#!/usr/bin/ruby -w

require 'xmlrpc/client'

server = XMLRPC::Client.new("localhost", "/", 2000)

ret = server.call("getAddress")
puts "for getAddress we received #{ret}"

ret = server.call("getSomethingElse")
puts "for getSomethingElse we received #{ret}"
