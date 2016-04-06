class CreateAttachnents < ActiveRecord::Migration
  def change
    create_table :attachnents do |t|
      t.string :file

      t.timestamps null: false
    end
  end
end
