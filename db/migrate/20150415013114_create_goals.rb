class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :descriptor
      t.integer :value
    end
  end
end
