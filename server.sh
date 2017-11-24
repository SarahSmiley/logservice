#! /bin/bash
/etc/init.d/mysql start
mysql -u root -e 'create database logs;'
rake db:migrate
bundle exec unicorn -p 3000 -c ./config/unicorn.rb