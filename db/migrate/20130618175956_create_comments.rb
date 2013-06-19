class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :doc, :polymorphic => true
      t.integer :user_id, :null => false
      t.string :content, :null => false

      t.timestamps
    end

    add_index :comments, [:doc_id, :doc_type]
    add_index :comments, [:user_id]
  end
end
