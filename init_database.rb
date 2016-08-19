require "sequel"
# connect to databse
DB = Sequel.sqlite('weibo.db')

# create an items table
DB.create_table :mblog do
  primary_key :id
  String :mid, :unique=>true
  DateTime :created_timestamp
  String :content, :text => true
  String :source
  String :user_id
  String :user_name
  String :user_gender
  Integer :user_status_count
  Integer :user_fansNum
end

# create a dataset from the items table
mblog = DB[:mblog]

# populate the table
mblog.insert(:mid => '1010110', :content => "hello1")

# print out the number of records
puts "mblog count: #{mblog.count}"
