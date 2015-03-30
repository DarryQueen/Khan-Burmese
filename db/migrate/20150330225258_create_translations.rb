class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.references :user
      t.references :video
      t.datetime :time_assigned
      t.datetime :time_last_updated
    end
  end
end
