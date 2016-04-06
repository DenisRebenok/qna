class AddQuestionIdToAttachment < ActiveRecord::Migration
  def change
    add_column :attachnents, :question_id, :integer
    add_index :attachnents, :question_id
  end
end
