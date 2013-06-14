class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content
      t.integer :feed_item_id
      t.integer :user_id

      t.timestamps
    end

    add_index :posts, :feed_item_id, unique: true

  end
end
