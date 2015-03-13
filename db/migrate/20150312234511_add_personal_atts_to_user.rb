class AddPersonalAttsToUser < ActiveRecord::Migration
  def up
    add_column :users, :name, :string
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :bio, :text
  end
  def down
    remove_column :users, :name, :string
    remove_column :users, :city, :string
    remove_column :users, :country, :string
    remove_column :users, :bio, :text
  end
end
