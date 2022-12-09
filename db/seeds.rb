# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
Stock.destroy_all

User.create!(email: "elliott@faceco.com", password: "123456")
# AAPL
Stock.create!({
  name: "APPLE INC",
  ticker: "AAPL",
  cik: "320193",
  cusip: "037833100",
  exchange: "NASDAQ",
  isDelisted: false,
  category: "Domestic Common Stock",
  sector: "Technology",
  industry: "Consumer Electronics",
  sic: "3571",
  sicSector: "Manufacturing",
  sicIndustry: "Electronic Computers",
  famaSector: "",
  famaIndustry: "Computers",
  currency: "USD",
  location: "California; U.S.A",
  api_id: "a43c3ffca9b4a0be9cee4fa1120832a2"
})
# TSLA
Stock.create!({
  name: "TESLA INC",
  ticker: "TSLA",
  cik: "1318605",
  cusip: "88160R101",
  exchange: "NASDAQ",
  isDelisted: false,
  category: "Domestic Common Stock",
  sector: "Consumer Cyclical",
  industry: "Auto Manufacturers",
  sic: "3711",
  sicSector: "Manufacturing",
  sicIndustry: "Motor Vehicles & Passenger Car Bodies",
  famaSector: "",
  famaIndustry: "Automobiles and Trucks",
  currency: "USD",
  location: "California; U.S.A",
  api_id: "eaeafc4ffc04a49da153adebf1f6960a"
})
# JPM
Stock.create!({
  name: "JPMORGAN CHASE & CO",
  ticker: "JPM",
  cik: "19617",
  cusip: "46625H100 16161A108",
  exchange: "NYSE",
  isDelisted: false,
  category: "Domestic Common Stock Primary Class",
  sector: "Financial Services",
  industry: "Banks - Diversified",
  sic: "6021",
  sicSector: "Finance Insurance And Real Estate",
  sicIndustry: "National Commercial Banks",
  famaSector: "",
  famaIndustry: "Banking",
  currency: "USD",
  location: "New York; U.S.A",
  api_id: "9b2b5dd6bb56471237e8d985863c5a5d"
})
# SPY
Stock.create!({
  name: "SPDR® S&P 500",
  ticker: "SPY",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Index",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# VOO
Stock.create!({
  name: "Vanguard S&P 500 ETF",
  ticker: "VOO",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Index",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# MSFT
Stock.create!({
  name: "MICROSOFT CORP",
  ticker: "MSFT",
  cik: "789019",
  cusip: "594918104",
  exchange: "NASDAQ",
  isDelisted: false,
  category: "Domestic Common Stock",
  sector: "Technology",
  industry: "Software - Infrastructure",
  sic: "7372",
  sicSector: "Services",
  sicIndustry: "Services-Prepackaged Software",
  famaSector: "",
  famaIndustry: "Business Services",
  currency: "USD",
  location: "Washington; U.S.A",
  api_id: "0f08a6a6742dc4148badfef6977406cf"
})
# GS
Stock.create!({
  name: "Goldman Sachs Group Inc",
  ticker: "GS",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Financial Services",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# Procter
Stock.create!({
  name: "Procter & Gamble Company",
  ticker: "PG",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Consumer",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# NVDA
Stock.create!({
  name: "NVIDIA Corporation",
  ticker: "NVDA",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Technology",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# GOOGL
Stock.create!({
  name: "Alphabet Inc Class A",
  ticker: "GOOGL",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Technology",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# NKE
Stock.create!({
  name: "Nike Inc",
  ticker: "NKE",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Consumer",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})


# MCHI
Stock.create!({
  name: "iShares MSCI China ETF",
  ticker: "MCHI",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Index",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})
# JNJ
Stock.create!({
  name: "Johnson & Johnson",
  ticker: "JNJ",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Healthcare",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})


# IEUR
Stock.create!({
  name: "iShares Core MSCI Europe ETF",
  ticker: "IEUR",
  cik: "",
  cusip: "",
  exchange: "",
  isDelisted: false,
  category: "",
  sector: "Index",
  industry: "",
  sic: "",
  sicSector: "",
  sicIndustry: "",
  famaSector: "",
  famaIndustry: "",
  currency: "",
  location: "",
  api_id: ""
})

Portfolio.create!(name: "My Tech Stocks", user_id: 1)
Portfolio.create!(name: "Indices and ETFs", user_id: 1)

PortfolioStock.create!(portfolio_id: 1, stock_id: 1)
PortfolioStock.create!(portfolio_id: 1, stock_id: 2)
PortfolioStock.create!(portfolio_id: 1, stock_id: 6)

PortfolioStock.create!(portfolio_id: 2, stock_id: 4)
PortfolioStock.create!(portfolio_id: 2, stock_id: 5)
PortfolioStock.create!(portfolio_id: 2, stock_id: 12)
PortfolioStock.create!(portfolio_id: 2, stock_id: 14)
