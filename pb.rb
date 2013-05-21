#!/usr/bin/env ruby

require 'net/ftp'
require 'fileutils'
require 'httpclient'
require 'httpclient/include_client'
require 'trollop'

class Pb
    extend HTTPClient::IncludeClient

    include_http_client(:method_name => :pbhttp) do |client|
        # any init you want
        client.connect_timeout = 60
        client.send_timeout = 60
        client.receive_timeout = 60
        client.keep_alive_timeout = 360
    end

    LISTREG = /^(?<type>.{1})(?<mode>\S+)\s+(?<number>\d+)\s+(?<owner>\S+)\s+(?<group>\S+)\s+(?<size>\d+)\s+(?<mod_time>.{12})\s+(?<path>.+)$/
    def parse_entry(listline)
        listline.match(LISTREG)
    end

    def download_http(url, localpath)
        File.open(localpath, 'w') do |file|
            begin
                pbhttp.get_content(url, nil, 'Referer' => url.gsub('http://i', 'http://s') + '.html', 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36') do |chunk|
                    #puts "Downloaded chunk of size #{chunk.size}"
                    # print '.'
                    file.write(chunk)
                end
            rescue => e
                puts "Got Error from Server: #{e.message}"
            end
        end
        # puts ""
    end

    def download_entry(entry, path, downloadpath)
        if !File.exist?(downloadpath + '/' + entry['path']) or File.size(downloadpath + '/' + entry['path']) < entry['size'].to_i
            #file doesnt exist, download file
            uri = (@base_uri + path + entry['path']).gsub(' ', '%20') 
            uri = uri.gsub('.highres/', '') + '~original' if path.end_with?('.highres/', '.highres')
            puts "download = " + path + entry['path'] + " -> #{uri} -> " + downloadpath + '/' + entry['path']
            download_http(uri, downloadpath + '/' + entry['path']) rescue return false
        else
            puts "Exists = " + downloadpath + '/' + entry['path']
        end
        true
    end

    def downloaddir(ftp, path, downloadpath)
        puts "in #{path}"
        ftp.chdir(path)
        all = ftp.ls("-a")
        FileUtils.mkdir_p downloadpath

        all.each do |n|
            entry = parse_entry(n)
            if entry['path'] == '.highres'
                #download highres first
                ftp.ls('.highres').each do |e|
                    newe = parse_entry(e)
                    download_entry(newe, path + '.highres/', downloadpath)
                end
            elsif entry['path'].start_with?('.')
                #skip other . entries
                puts 'skipping ' + entry['path']
                next
            elsif entry['type'] == 'd'
                #is a directory, download it
                downloaddir(ftp, path + entry['path'] + '/', downloadpath + '/' + entry['path'])
                next
            elsif entry['path'].start_with?('th_')
                #skip thumbs
                next
            else
                download_entry(entry, path, downloadpath)
            end
            $stdout.flush
        end
    end

    def run(start)
        ftp = Net::FTP.open('ftp.photobucket.com', @username, @password)
        ftp.passive = true

        downloaddir(ftp, start, @dest)

        ftp.close
    end

    def initialize(username, password, base_uri, dest)
        @base_uri = base_uri
        @username = username
        @password = password
        @dest = dest
    end

end

opts = Trollop::options do
  version "PB Downloader 0.1"
  banner <<-EOS
Downloads all files from your photobucket account, preferring highres pictures

Usage:
EOS

  opt :username, "Photobucket username (not email address)", :type => String
  opt :password, "Photobucket password", :type => String
  opt :base_url, "Photobucket Base URL (view URL to one image, grab the URL up to and including your username, example: http://i323.photobucket.com/albums/s325/username", :type => String
  opt :start_path, "Photobucket folder path to start in", :default => '/'
  opt :destination, "Folder to put downloads in", :default => '.'
end
Trollop::die :username unless opts[:username]
Trollop::die :password unless opts[:password]
Trollop::die :base_url unless opts[:base_url]

base_url = opts[:base_url].chomp('/')
destination = opts[:destination].chomp('/')
start_path = ('/' + opts[:start_path] + '/').gsub('//', '/')

Pb.new(opts[:username], opts[:password], base_url, destination).run(start_path)
