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

def host_serv(list)
  list.split("\n").each do |all|
    ip = all.split(":").first
    port = all.split(":").last
    File.foreach("/etc/services") do |line|
      if line.include?(port)
        res = line.strip.split
        puts("#{ip} #{res[0]} #{res[1]}\n")
        break
      end
    end
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

#need to add os support
def check_os_version
  case RUBY_PLATFORM
  when /linux/
    puts "Running on Linux"
  when /darwin/
    puts "Running on macOS"
  when /mingw|mswin/
    puts "Running on Windows"
  else
    puts "Unknown OS: #{RUBY_PLATFORM}"
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

  opts.on("-r", "--resolv", "resolves hostnames") do
    options[:resolv] = true
  end

  opts.on("-s", "--serv", "resolves services") do
    options[:serv] = true
  end
end

begin
  parser.parse!
rescue OptionParser::InvalidOption => e
  puts e.message
  puts parser
  exit 1
end

check_os_version

if options[:verbose]
  cmd1 = %x[netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq]
  host_port(cmd1)
elsif options[:resolv]
  cmdr = %x[netstat -tan|grep tcp|awk '{print $5}'|grep -v "*"|cut -d":" -f1|sort|uniq] 
  host_resolv(cmdr)
elsif options[:serv]
  cmds = %x[netstat -tan|grep tcp|awk '{print $5}'|grep -v "*"|uniq]
  host_serv(cmds)
else
  cmd = %x[netstat -tan| grep tcp|awk '{print $5}'|grep -v "*"|uniq]
  hosts(cmd)
end

