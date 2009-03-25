module ActsAsEncryptable
  module Base
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def acts_as_encryptable(*args)
        self.class_eval do
          has_many :encrypted_chunks, :as => :encryptable
          before_save :encrypt!

          options = {
            :public_key => File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key.pub'),
            :private_key => File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key')
          }
          options.merge!(args.pop) if args.last.is_a? Hash

          write_inheritable_attribute(:encrypted_fields, args.uniq)
          class_inheritable_reader :encrypted_fields

          write_inheritable_attribute(:public_key, ActsAsEncryptable::Crypto::Key.from_file(options[:public_key]))
          class_inheritable_reader :public_key

          write_inheritable_attribute(:private_key, ActsAsEncryptable::Crypto::Key.from_file(options[:private_key]))
          class_inheritable_reader :private_key

          write_inheritable_attribute(:max_chunk_size, 115)
          class_inheritable_reader :max_chunk_size

          include ActsAsEncryptable::Base::InstanceMethods
        end
      end
    end

    module InstanceMethods
      def encrypt!
        yaml_data = self.class.encrypted_fields.inject({}) do |result, field|
          result.merge!(field => instance_variable_get("@#{field}".to_sym))
        end.to_yaml

        chunks = []
        (0..((yaml_data.length/self.class.max_chunk_size.to_f).ceil - 1)).each do |x|
          start, stop = x * self.class.max_chunk_size, (x + 1) * self.class.max_chunk_size
          start += 1 if start > 0
          chunks << self.class.public_key.encrypt(yaml_data[start..stop])
        end

        self.encrypted_chunks = chunks.collect do |chunk|
          EncryptedChunk.new(:data => chunk)
        end
      end

      def decrypt!
        yaml_data = self.encrypted_chunks.collect do |chunk|
          self.class.private_key.decrypt(chunk.data)
        end.join

        YAML::load(yaml_data).each do |k, v|
          instance_variable_set("@#{k}".to_sym, v)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsEncryptable::Base)