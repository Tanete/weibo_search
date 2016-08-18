# encoding: utf-8
require 'httparty'
require "sequel"
require_relative 'time_issue'
class HTTPartyProxy
  include HTTParty
  # http_proxy '58.59.68.91', 9797
  # http_proxy  '183.196.9.132', 2226
  http_proxy '120.52.73.96', 8080
end

DB = Sequel.sqlite('weibo.db')
db = DB[:mblog]

def weibo_search(search_word, page_min, page_max, db)
  escape_s_word = URI::escape(search_word)

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
        mid = mblog['id']
        text = mblog['text']
        source = mblog['source']
        mblog = info["card_group"][0]['mblog']
        created_at = TimeIssue.standardize(mblog['created_at'])
        puts "#{page}-#{i}: #{created_at} #{source} #{text} #{mid}"
        save_data(db, mid, created_at, text, source)
      end
    end
  end
end

# threads = []
# threads << Thread.new { weibo_search("简书",1,20) }
# threads << Thread.new { weibo_search("简书",21,40) }
# threads << Thread.new { weibo_search("简书",41,60) }
# threads << Thread.new { weibo_search("简书",61,80) }
# threads << Thread.new { weibo_search("简书",81,100) }
# threads.each { |t| t.join }

def save_data(db, mid, created_at, text, source)
  # populate the table
  begin
    db.insert(:mid => mid, :created_at => created_at, :text => text, :source => source)
  rescue Sequel::UniqueConstraintViolation
    puts "Duplicate post, not added"
  end
end

weibo_search("简书",1,1, db)
# str_1 = '今天 20:46'
# str_2 = '19分钟前'
# str_3 = '08-18 23:11'
# puts str_1
# puts str_2
# puts str_3
# puts TimeIssue.standardize(str_1)
# puts TimeIssue.standardize(str_2)
# puts TimeIssue.standardize(str_3)
