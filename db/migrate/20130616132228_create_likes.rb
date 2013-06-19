class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :doc, :polymorphic => true
      t.integer :user_id

      t.timestamps
    end

    add_index :likes, [:user_id, :doc_id, :doc_type], :unique => :true
    add_index :likes, [:doc_id, :doc_type]
    add_index :likes, [:user_id]
  end
end
