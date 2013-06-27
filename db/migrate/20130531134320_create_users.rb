class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string :name, :null => false
      t.string :surname, :null => false
      t.string :honorific
      t.string :email, :null => false
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
      t.string :remember_token
      t.string :password_digest, :null => false
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :users, :id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :remember_token

  end
end
