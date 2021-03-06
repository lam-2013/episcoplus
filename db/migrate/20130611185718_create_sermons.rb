class CreateSermons < ActiveRecord::Migration
  def change
    create_table :sermons do |t|
      t.string :title, :null => false
      t.string :subtitle
      t.string :content, :null => false
      t.string :user_id
      t.datetime :day
      t.string :type_of_liturgy
      t.string :multimedia
      t.string :multimedia_url
      t.string :feed_item_id

      t.timestamps
    end

  end
end
