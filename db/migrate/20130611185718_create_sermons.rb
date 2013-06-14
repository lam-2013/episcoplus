class CreateSermons < ActiveRecord::Migration
  def change
    create_table :sermons do |t|
      t.string :title
      t.string :subtitle
      t.integer :user_id
      t.string :content
      t.datetime :day
      t.string :type_of_liturgy
      t.string :audio
      t.string :video

      t.timestamps
    end
  end
end
