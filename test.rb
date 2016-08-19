# encoding: utf-8
require 'httparty'

class Partay
  include HTTParty
  search_word = "简书"
  escape_s_word = URI::escape(search_word)
  page = 20
  base_uri "http://m.weibo.cn/page/pageJson?containerid=&containerid=100103type%3D2%26q%3D#{escape_s_word}&type=wb&queryVal=#{escape_s_word}A6&luicode=10000011&lfid=100103type%3D1%26q%3D&title=#{escape_s_word}&v_p=11&ext=&fid=100103type%3D2%26q%3D#{escape_s_word}&uicode=10000011&next_cursor=&page=#{page}"
  http_proxy '120.52.73.96', 8080
end

x = 0
loop do
  puts x
  puts j_res = Partay.get('/')
  # j_res = JSON.parse(HTTP.get(search_url))
  x += 1
end
