class ActsAsEncryptableMigration < ActiveRecord::Migration
  def self.up
    create_table :encrypted_chunks do |t|
      t.column :data, :string
      t.references :encryptable, :polymorphic => true
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :encrypted_chunks
  end
end
