class AddQToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :q, :integer, default: 13
  end
end
