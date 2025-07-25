#!/usr/bin/env ruby
# Script to list  #
# connected hosts #
###################
require 'resolv'
require 'optparse'
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

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: showhosts [options]"

  opts.on("-h","--help", "prints this help message") do
    puts opts
    exit
  end

  opts.on("-a", "--all", "prints ip and port numnber") do
    options[:verbose] = true
  end

  opts.on("-r", "--names", "resolves hostnames") do
    options[:names] = true
  end
end

begin
  parser.parse!
rescue OptionParser::InvalidOption => e
  puts e.message
  puts parser
  exit 1
end

if options[:verbose]
  cmd1 = %x[netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq]
  host_port(cmd1)
elsif options[:name]
  cmdr = %x[netstat -tan|grep tcp|awk '{print $5}'|grep -v "*"|uniq] 
  host_resolv(cmdr)
else
  cmd = %x[netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq]
  hosts(cmd)
end

