#!/usr/bin/env ruby
# Script to list  #
# connected hosts #
###################
require 'resolv'

def host_port(list)
  list.split("\n").each do |all|
    puts all
  end
end

def hosts(list)
  list.split("\n").each do |all|
    ip = all.split(":").first
      puts ip
  end
end

def host_resolv(list)
  list.split("\n").each do |all|
    ip = all.split(":").first
    begin
      hn = Resolv.getname(ip)
      puts "#{hn}"
    rescue Resolv::ResolvError => e
      puts "#{ip}"
    end
  end
end

val = ARGV[0]

case val
when "-a"
  cmd1 = `netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq`
  host_port(cmd1)
when "-h"
  puts "ShowHosts lists all the IP Addresses that are currently connected"
  puts " -a = show IP's and Ports"
  puts " -h  this help menu"
when "-r"
  cmdr = `netstat -tan|grep tcp|awk '{print $5}'|grep -v "*"|uniq`
  host_resolv(cmdr)
else
  cmd = `netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq`
  hosts(cmd)
end

