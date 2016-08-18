# encoding: utf-8
require 'date'
# # change 今天 20:46 to 08-18 20:46
# # change 3分钟前 to
# str_1 = '今天 20:46'
# str_2 = '19分钟前'
# str_3 = '08-18 23:11'
# puts str_1
# puts str_2
class TimeIssue
  @tnow = Time.now.localtime("+08:00")
  # standardize time
  def self.standardize(str)
    if str.include?('今天')
      return str.sub '今天', @tnow.to_date.to_s
    elsif str.include?('分钟前')
      mins = str.match(/\d+/).to_s.to_i # minutes
      tmp = minus_min(@tnow, mins).to_s
      return tmp.sub(/\:\d+\s\+0800/,'')
    else
      return @tnow.to_date.year.to_s + " #{str}"
    end
  end

  def self.minus_min(time, mins)
    time = time - (mins * 60)
  end
end
#
# puts TimeIssue.standardize(str_1)
# puts TimeIssue.standardize(str_2)
# puts TimeIssue.standardize(str_3)
# puts Time.now.localtime("+08:00").to_date.year
