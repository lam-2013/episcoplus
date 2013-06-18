class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :follower_id
      t.string :followed_id

      t.timestamps
    end
    add_index :relationships, [:follower_id, :followed_id], :unique => :true
  end
end
