# encoding: utf-8
require 'httparty'
require "sequel"
require_relative 'pinyin_translate.rb'

class HTTPartyProxy
  include HTTParty
  # http_proxy '58.59.68.91', 9797
  # http_proxy  '183.196.9.132', 2226
  # http_proxy '120.52.73.96', 8080
end

DB = Sequel.sqlite('weibo.db')

def weibo_search(search_word, page_min, page_max)
  escape_s_word = URI::escape(search_word)
  table_name = trans_pinyin(search_word).to_sym
  (page_min..page_max).each do |page|
    puts page
    search_url = "http://m.weibo.cn/page/pageJson?containerid=&containerid=100103type%3D2%26q%3D#{escape_s_word}&type=wb&queryVal=#{escape_s_word}A6&luicode=10000011&lfid=100103type%3D1%26q%3D&title=#{escape_s_word}&v_p=11&ext=&fid=100103type%3D2%26q%3D#{escape_s_word}&uicode=10000011&next_cursor=&page=#{page}"
    j_res = HTTPartyProxy.get(search_url).parsed_response

    # retry for network issue
    if j_res["cards"].nil?
      puts "Fixing nil..."
      5.times do |x|
        puts "try #{x}..."
        sleep 2
        j_res = HTTPartyProxy.get(search_url).parsed_response
        if !j_res["cards"].nil?
          break
        end
      end
      if j_res["cards"].nil?
        next
      end
    end

    # each post
    (0..9).each do |i|
      info = j_res["cards"][i]
      if info != nil
        mblog             = info["card_group"][0]['mblog']
        mid               = mblog['id']
        created_timestamp = Time.at(mblog['created_timestamp']).localtime("+08:00")
        content              = mblog['text']
        source            = mblog['source']
        user              = mblog['user']
        user_id           = user['id']
        user_name         = user['screen_name']
        user_status_count = user['statuses_count']
        user_gender       = user['gender']
        user_fansNum      = user['fansNum']

        puts "#{page}-#{i}: #{created_timestamp} #{source} #{content} #{mid}"
        save_data(table_name, mid, created_timestamp, content, source, user_id, user_name,
                                    user_gender, user_status_count, user_fansNum)
      end
    end
  end
end

def save_data(table_name, mid, created_timestamp, content, source, user_id, user_name,
                                  user_gender, user_status_count, user_fansNum)

  db = DB[table_name]
  # populate the table
  begin
    db.insert(:mid => mid,
              :created_timestamp => created_timestamp,
              :content => content,
              :source => source,
              :user_id => user_id,
              :user_name => user_name,
              :user_gender => user_gender,
              :user_status_count => user_status_count,
              :user_fansNum => user_fansNum)
  rescue Sequel::UniqueConstraintViolation
    puts "Duplicate post, not added"
  end
end

weibo_search("简书", 1, 100)
weibo_search("豆瓣", 1, 100)