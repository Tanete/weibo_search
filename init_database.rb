require "sequel"

# connect to an in-memory database
DB = Sequel.sqlite('weibo.db')

# create an items table
DB.create_table :mblog do
  primary_key :id
  String :mid, :unique=>true
  DateTime :created_at
  String :text
  String :source
end

# create a dataset from the items table
mblog = DB[:mblog]

# populate the table
mblog.insert(:mid => 'abc', :text => "hello1")

# print out the number of records
puts "mblog count: #{mblog.count}"
