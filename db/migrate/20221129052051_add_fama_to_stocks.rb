class AddFamaToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :famaSector, :string
    add_column :stocks, :famaIndustry, :string
  end
end
