Gem::Specification.new do |s|
  s.name = "acts_as_encryptable"
  s.version = "1.0.0"
  s.date = "2009-03-25"
  s.author = "Sean Soper"
  s.email = "sean.soper@gmail.com"
  s.summary = "Encrypt and decrypt your important data"
  s.description = "Encrypt your data into chunks stored in the database and attached to your model via a polymorphic relationship"
  s.homepage = "http://github.com"
  s.require_path = "lib"
  s.files = %w{ acts_as_encryptable.gemspec
                lib/acts_as_encryptable.rb
                lib/acts_as_encryptable/base.rb
                lib/acts_as_encryptable/crypto.rb
                lib/acts_as_encryptable/encrypted_chunk.rb
                generators/acts_as_encryptable_migration/acts_as_encryptable_migration_generator.rb
                generators/acts_as_encryptable_migration/templates/migration.rb
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