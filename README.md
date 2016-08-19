# weibo_search
Very simple weibo.com posts search script.
## Introduction
* grab `10*100` 'latest' post about setting keyword & store related info into database for further analysis.
## Usage
1. git clone
2. bundle install
3. run `ruby init_database.rb`
4. run `ruby weibo_search.rb`
## Notes
* Better not try to use multithreading, or sina will ban your ip
