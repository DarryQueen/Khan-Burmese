class AddTimestampsToTranslations < ActiveRecord::Migration
  def up
    change_table :translations do |t|
      t.timestamps
    end
    remove_column :translations, :time_assigned
  end

  def down
    remove_column :translations, :created_at
    remove_column :translations, :updated_at
  end
end
