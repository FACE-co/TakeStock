class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :ticker
      t.string :cik
      t.string :cusip
      t.string :exchange
      t.boolean :isDelisted
      t.string :category
      t.string :sector
      t.string :industry
      t.string :sic
      t.string :sicSector
      t.string :sicIndustry
      t.string :currency
      t.string :location
      t.string :api_id

      t.timestamps
    end
  end
end
