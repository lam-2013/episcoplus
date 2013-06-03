class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    # add a remember token column for users
    add_column :users, :remember_token, :string
    # create the related index
    add_index :users, :remember_token
  end
end
