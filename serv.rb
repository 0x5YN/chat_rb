#!/usr/bin/ruby

require "socket"


$ip = ""
$port = 0

class Server
    def initialize(ip , port)
        @server = TCPServer.open(ip , port)
        @connections = Hash.new
        @clients = Hash.new
        @connections[:server] = @server
        @connections[:clients] = @clients
        run
    end
    
    def run 
        puts("\033[92;1mServer Connected and Listen on #{$ip}:#{$port}\n\033[0m")
        puts("Logs:")
        loop {
            Thread.start(@server.accept) do |client|
                nick_name = client.gets.chomp.to_sym
                @connections[:clients].each do |other_name , other_client|
                    if nick_name == other_name || client == other_client
                        client.puts "Username already exist!"
                        Thread.kill self
                        exit
                    else
                        other_client.puts "\033[32m-> #{nick_name} joined!\033[0m"
                    end
                end
                puts "#{nick_name} : #{client} joined at #{Time.now}"
                @connections[:clients][nick_name] = client
                client.puts "Connection Established!"
                listen_user_message(nick_name , client)
            end
        }.join
    end

    def listen_user_message(username , client)
        loop {
            msg = client.gets.chomp
            @connections[:clients].each do |other_name , other_client|
                unless other_name == username
                    if msg == "/exit"
                        other_client.puts "\033[31m<- #{username} exit!\033[0m"
                        begin
                            puts "#{username} : #{client} exit at #{Time.now}"
                        end
                    else
                        other_client.puts "#{username}: #{msg}"
                    end
                end
            end
        }
    end
end

def clear
    system("clear")
end

def beg
    clear
    print("Server at: ")
    $ip = gets.chomp
    if $ip == ""
        $ip = "127.0.0.1"
    end
    print("Port Number: ")
    $port = gets.chomp.to_i
    clear
end

beg
server = Server.new($ip , $port)
