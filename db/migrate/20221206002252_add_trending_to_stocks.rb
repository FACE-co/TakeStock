class AddTrendingToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :trending, :integer
  end
end
