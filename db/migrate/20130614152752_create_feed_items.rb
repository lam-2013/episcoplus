class CreateFeedItems < ActiveRecord::Migration
  def change

    create_table :feed_items do |t|
      t.integer :user_id
      t.references :doc, :polymorphic => true

      t.timestamps
    end

    add_index :feed_items, [:user_id, :updated_at]

  end

end
