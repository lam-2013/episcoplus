class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    # index to help us retrieve all the posts associated with a given user in reverse order
    add_index :posts, [:user_id, :created_at]
  end
end
