class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.datetime :time_imported
      t.boolean :success
      t.text :messages, :array => true, :default => []
    end

    change_table :videos do |t|
      t.references :import
    end
  end
end
