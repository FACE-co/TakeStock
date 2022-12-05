# hello_algolia.rb
require 'algolia'

# Connect and authenticate with your Algolia app
client = Algolia::Search::Client.create('K0X97I2FU8', '533f53ba9884d8ce16c8aec2f1bb2e11')

# Create a new index and add a record
index = client.init_index('test_index')
record = { 'objectID': 1, 'name': 'test_record'}
index.save_object(record).wait()

# Search the index and print the results
results = index.search('test_record')
puts results[:hits][0]
