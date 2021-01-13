# encoding: utf-8
require 'net/http'
require 'launchy'

def check(req, http)
  loop do
    response = http.request(req).code
    if response != '404'
      return response
    end
    sleep 2.5
  end
end

def checkloop(req, http)
  loop do
    code = check(req, http)
    p code
    if code == '200'
      p '更新じゃあ！'
      break
    end
  end
end

def mainloop(domain, ncode, title, index, http)
  loop do
    req = Net::HTTP::Head.new("/#{ncode}/#{index}")
    req['Connection'] = 'Keep-Alive'
    checkloop(req, http)
    Launchy.open "https://#{domain}/#{ncode}/#{index}"
    indexi = index.to_i
    indexi += 1
    index = indexi.to_s
    File.write("index",index)
    sleep 1
  end
end

def main
  p 'starting……'
  domain = File.read("domain").chomp
  ncode = File.read("ncode").chomp
  title = File.read("title").chomp
  index = File.read("index").chomp
  puts "-------------------\ndomain = #{domain}\nncode =  #{ncode}\nindex =  #{index}\n-------------------"
  http = Net::HTTP.new(domain,80)
  http.start
  p 'started'
  mainloop(domain, ncode, title, index, http)
end

main
