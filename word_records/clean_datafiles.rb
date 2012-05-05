#!/usr/local/bin/ruby

puts "Cleaning Start!"

f = File.open("../wordlist.txt", "r")
f.each do |wordpair|
 if wordpair[0] != "#"
   wordpair = wordpair.strip.split(", ")
   k = File.open("#{wordpair[0]}.txt", "w")
   k.write("")
   k.close
  end
end
puts "Cleaning finished"
