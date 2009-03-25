class EncryptedChunk < ActiveRecord::Base
  belongs_to :encryptable, :polymorphic => true
end
