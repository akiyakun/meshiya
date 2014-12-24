class AddShopNameToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :shop_name, :string
  end
end
