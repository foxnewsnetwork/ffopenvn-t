#!/bin/ruby

# run this to create the file based word record databases

@word_recordsPath = '~/twitter_spelling_bot/word_records/'

@wordlistPath = "../wordlist.txt"
def make_file(word)
  if not FileTest.exists?("#{word}.txt")
    f = File.new("#{word}.txt", 'w')
    f.close
  end
end


if FileTest.exists?(@wordlistPath)
  f = File.open(@wordlistPath, "r")
  f.each do |wordpair|
    if wordpair[0] != "#"
      wordpair = wordpair.strip.split(", ")
      make_file(wordpair[0])
    end
  end
  f.close 
else 
  puts "a wordlist.txt does not exist"
end

