class AddCompositeIndexesToAttachments < ActiveRecord::Migration
  def change
    add_index :attachments, [:attachable_id, :attachable_type]
  end
end
