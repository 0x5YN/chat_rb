#!/usr/bin/ruby

require "socket"
require "io/console"

@h = IO.console.winsize[0]

class Client
    def initialize(server)
        @server = server
        @req = nil
        @res = nil
        listen
        send
        print("Enter Nickname: ")
        @req.join
        print("\033[2J\033[6:3H")
        @res.join
    end


    def send
        @req = Thread.new do
            loop {
                
                msg = $stdin.gets.chomp
                if msg == "/exit"
                    @server.puts(msg)
                    exit
                elsif msg == "/clear"
                    clear
                else
                    @server.puts(msg)
                end
            }
        end
    end

    def listen
        @res = Thread.new do
            loop {
                msg = @server.gets.chomp
                puts "#{msg}"
            }
        end
    end

    def clear
        system("clear")
    end    

end

def clear
    system("clear")
end

def get_info
    clear
    print("Server at: ")
    @ip = gets.chomp
    print "Port Number: "
    @port = gets.chomp.to_i
    clear
end

get_info

server = TCPSocket.open(@ip , @port)
Client.new(server)
