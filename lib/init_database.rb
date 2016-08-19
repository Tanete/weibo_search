# encoding: utf-8
require "sequel"
require_relative 'pinyin_translate.rb'
file_path = File.expand_path("..", File.dirname(__FILE__))

# connect to databse
DB = Sequel.sqlite("#{file_path}/db/weibo.db")

# create an items table
def create_table(table_name)
  # translate into pinyin, then to symbol
  table = trans_pinyin(table_name).to_sym
  DB.create_table table do
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
  return table
end

# works?
table = create_table("简书")
puts table
dataset = DB[table]

dataset.insert(:mid => '1010110', :content => "hello1")
puts "mblog count: #{dataset.count}"

create_table("豆瓣")
