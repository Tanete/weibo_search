require 'ruby-pinyin'

def trans_pinyin(hans)
  pinyin =  PinYin.of_string(hans)
  str = ""
  pinyin.each do |single|
    str += single
  end
  return str
end
