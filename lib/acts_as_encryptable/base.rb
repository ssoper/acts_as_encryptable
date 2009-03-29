module ActsAsEncryptable
  module Base
    WARNING_MSG = "\n  \e[0m\e[1;36m[\e[37mActsAsEncryptable\e[36m] \e[1;31mUsing the provided sample keys in production mode is highly discouraged. Generate your own RSA keys using the provided crypto libraries.\e[0m\n\n"
    MAX_CHUNK_SIZE = 115
    ENCRYPTED_CHUNK_SIZE = 175
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_encryptable(*args)
        self.class_eval do
          before_save :encrypt!
          
          sample_key_public = File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key.pub')
          sample_key_private = File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key')

          options = {
            :public_key => sample_key_public,
            :private_key => sample_key_private,
            :column => :encrypted
          }
          options.merge!(args.pop) if args.last.is_a? Hash

          if (sample_key_public == options[:public_key]) and 
             (ENV['RAILS_ENV'] && ENV['RAILS_ENV'] == 'production')
            RAILS_DEFAULT_LOGGER.warn WARNING_MSG
          end

          args = args.first if args.first.is_a? Array

          write_inheritable_attribute(:encrypted_fields, args.uniq)
          class_inheritable_reader :encrypted_fields

          write_inheritable_attribute(:public_key, ActsAsEncryptable::Crypto::Key.from_file(options[:public_key]))
          class_inheritable_reader :public_key

          write_inheritable_attribute(:private_key, ActsAsEncryptable::Crypto::Key.from_file(options[:private_key]))
          class_inheritable_reader :private_key

          write_inheritable_attribute(:encrypted_column, options[:column])
          class_inheritable_reader :encrypted_column

          include ActsAsEncryptable::Base::InstanceMethods
          extend ActsAsEncryptable::Base::SingletonMethods
        end
      end
    end

    module SingletonMethods
      def chunkize(str, chunk_size)
        (0..((str.length/chunk_size.to_f).ceil - 1)).each do |x|
          start, stop = x * chunk_size, (x + 1) * chunk_size
          yield str[start,stop]
        end
      end
    end

    module InstanceMethods
      def encrypt!
        yaml_data = self.class.encrypted_fields.inject({}) do |result, field|
          result.merge!(field => instance_variable_get("@#{field}".to_sym))
        end.to_yaml

        chunks = ''
        self.class.chunkize(yaml_data, MAX_CHUNK_SIZE) do |chunk|
          chunks << self.class.public_key.encrypt(chunk)
        end

        self.send("#{self.class.encrypted_column}=", chunks)
      end

      def decrypt!
        encrypted_data = self.send("#{self.class.encrypted_column}")

        chunks = ''
        self.class.chunkize(encrypted_data, ENCRYPTED_CHUNK_SIZE) do |chunk|
          chunks << self.class.private_key.decrypt(chunk)
        end

        YAML::load(chunks).each do |k, v|
          instance_variable_set("@#{k}".to_sym, v)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsEncryptable::Base)
