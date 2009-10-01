#!/usr/bin/ruby

# also shows User as legacy schema with non rails defaults

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => "mysql",
  :database => "auth",
  :socket => "/var/run/mysqld/mysqld.sock",
  :username => "root",
  :password => "root"
                                        })

class User < ActiveRecord::Base
  # needed because not users
  set_table_name "user"
  # needed because not id
  set_primary_key "userId"
end

User.find(:all).each { |u| puts u.firstName }

user = User.find("1")
puts "The userName of user 1 is: " + user.firstName
