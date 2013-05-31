class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string :name
      t.string :surname
      t.string :honorific
      t.string :email
      t.string :password_digest
      t.date :birth
      t.date :orderDay
      t.string :study
      t.string :role
      t.string :placeForRole
      t.string :diocese
      t.string :institute
      t.string :interests
      t.string :aboutMe
      t.boolean :confirmed

      t.timestamps
    end
  end
end
