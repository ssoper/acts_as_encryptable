class ActsAsEncryptableMigrationGenerator < Rails::Generator::NamedBase 
  def manifest
    record do |m| 
      m.migration_template 'migration:migration.rb', 'db/migrate', {
        :assigns => migration_local_assigns,
        :migration_file_name => "add_encryption_field_to_#{model_name}"
      }
    end
  end
  
  private
  
  def model_name
    return ARGV.first
  end
  
  def migration_local_assigns
    returning(assigns = {}) do
      assigns[:migration_action] = "add"
      assigns[:class_name] = "add_encryption_field_to_#{model_name}"
      assigns[:table_name] = model_name
      assigns[:attributes] = [Rails::Generator::GeneratedAttribute.new("encrypted", "text")]
    end
  end
end
