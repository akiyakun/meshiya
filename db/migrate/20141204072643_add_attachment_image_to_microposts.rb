class AddAttachmentImageToMicroposts < ActiveRecord::Migration
  def self.up
    change_table :microposts do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :microposts, :image
  end
end
