# weibo_search
Very simple weibo.com posts search script.

## Introduction
* grab `10*100` 'latest' post about setting keyword & store related info into database for further analysis.

## Usage
1. git clone & cd
2. `bundle install`
3. run `ruby init_database.rb` if database not exsisted
4. run `ruby weibo_search.rb`
5. use `crontab` to run this script periodically
  * `*/42 * * * * ruby /path_to_script/weibo_search.rb`
## Notes
* Better not try to use multithreading, or sina will ban your ip
