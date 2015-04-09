class AddStatusToTranslation < ActiveRecord::Migration
  def change
    add_column :translations, :status, :int, :default => 0
  end
end

