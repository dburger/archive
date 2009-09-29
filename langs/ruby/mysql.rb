#!/usr/bin/ruby

# using a  mysql connection directly in Ruby:

require 'mysql'

dbh = Mysql.real_connect("localhost", "root", "root", "auth");
rs = dbh.query("SELECT userName, password FROM user");
rs.each do |row|
  puts row[0]
end
