Gem::Specification.new do |s|
  s.name = "acts_as_encryptable"
  s.version = "1.0.2"
  s.date = "2009-03-26"
  s.author = "Sean Soper"
  s.email = "sean.soper@gmail.com"
  s.summary = "Encrypt and decrypt your data using asymmetric keys"
  s.description = "Allow your models to encrypt an arbitrary amount of data using asymmetric keys"
  s.homepage = "http://github.com/ssoper/acts_as_encryptable"
  s.require_path = "lib"
  s.files = %w{ acts_as_encryptable.gemspec
                lib/acts_as_encryptable.rb
                lib/acts_as_encryptable/base.rb
                lib/acts_as_encryptable/crypto.rb
                generators/acts_as_encryptable_migration/acts_as_encryptable_migration_generator.rb
                sample_keys/rsa_key.pub
                sample_keys/rsa_key
                MIT-LICENSE
                Rakefile
                README.rdoc
                TODO
                Changelog }
  s.has_rdoc = true
  s.extra_rdoc_files = %w{ MIT-LICENSE
                           README.rdoc }
  s.rdoc_options = ["--line-numbers",
                    "--inline-source",
                    "--title",
                    "acts_as_encryptable",
                    "--main",
                    "README.rdoc"]
  s.rubygems_version = "1.3.1"
  s.add_dependency "capistrano", ">= 2.5.0"
end