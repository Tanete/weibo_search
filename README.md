# weibo_search
Very simple weibo.com posts search script.
## Introduction
* grab `10*100` 'latest' post about setting keyword & store related info into database for further analysis.
## Usage
1. git clone
2. bundle install
3. run `sqlite weibo.db`
4. run `ruby init_database.rb`
5. run `ruby weibo_search.rb`
