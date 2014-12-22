class AddTitleAndPointToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :title, :string
    add_column :microposts, :point, :integer
  end
end
