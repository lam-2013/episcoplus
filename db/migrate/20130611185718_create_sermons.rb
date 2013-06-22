class CreateSermons < ActiveRecord::Migration
  def change
    create_table :sermons do |t|
      t.string :title
      t.string :subtitle
      t.string :content
      t.string :user_id
      t.datetime :day
      t.string :type_of_liturgy
      t.string :audio
      t.string :video

      t.timestamps
    end

  end
end
