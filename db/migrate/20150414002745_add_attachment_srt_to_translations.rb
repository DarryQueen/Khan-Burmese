class AddAttachmentSrtToTranslations < ActiveRecord::Migration
  def change
    change_table :translations do |t|
      t.attachment :srt
    end
  end
end
