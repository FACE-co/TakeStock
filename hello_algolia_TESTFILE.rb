require 'algolia'
require 'pry-byebug'
require 'json'


# # Connect and authenticate with your Algolia app
# client = Algolia::Search::Client.create('K0X97I2FU8', '8a7a37583a0a64ec1bad468b42e92342')

# # Create a new index and add a record
# index = client.init_index('test_index')
# record = { 'objectID': 1, 'name': 'test_record'}
# index.save_object(record).wait()

# # Search the index and print the results
# results = index.search('tes')
# puts results[:hits][0]


def fetch_data_from_database
  Stock.all
end

# # Connect and authenticate with your Algolia app
## client = Algolia::Search::Client.create(PARAM 1, PARAM 2)
## PARAM 1 = Algolia Application ID
## PARAM 2 = Algolia Admin ID (In ENV file)
client = Algolia::Search::Client.create('K0X97I2FU8', '8a7a37583a0a64ec1bad468b42e92342')

# # Create a new index and add a record
## Define your index for search(Can be found under index (Next to Application in Headers))
index = client.init_index("TakeStock")

## Save your records => This must be a JSON format - Generates an Object ID if one does not already exist)
index.save_objects(records, { autoGenerateObjectIDIfNotExist: true })


# # Search the index and print the results
query = form.input.value
results = index.search(query)
puts results[:hits][0]


# TEST RECORDS
# records = [
#   {
#     name: "APPLE INC",
#     ticker: "AAPL",
#     cik: "320193",
#     cusip: "037833100",
#     exchange: "NASDAQ",
#     isDelisted: false,
#     category: "Domestic Common Stock",
#     sector: "Technology",
#     industry: "Consumer Electronics",
#     sic: "3571",
#     sicSector: "Manufacturing",
#     sicIndustry: "Electronic Computers",
#     famaSector: "",
#     famaIndustry: "Computers",
#     currency: "USD",
#     location: "California; U.S.A",
#     api_id: "a43c3ffca9b4a0be9cee4fa1120832a2"
#   },
#   {
#     name: "TESLA INC",
#     ticker: "TSLA",
#     cik: "1318605",
#     cusip: "88160R101",
#     exchange: "NASDAQ",
#     isDelisted: false,
#     category: "Domestic Common Stock",
#     sector: "Consumer Cyclical",
#     industry: "Auto Manufacturers",
#     sic: "3711",
#     sicSector: "Manufacturing",
#     sicIndustry: "Motor Vehicles & Passenger Car Bodies",
#     famaSector: "",
#     famaIndustry: "Automobiles and Trucks",
#     currency: "USD",
#     location: "California; U.S.A",
#     api_id: "eaeafc4ffc04a49da153adebf1f6960a"
#   }
# ]
