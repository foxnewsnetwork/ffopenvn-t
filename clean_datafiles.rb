puts "Cleaning Start!"
words.each do |word|
  f = File.open("#{word}.txt", "w")
  f.write("")
  f.close
end
puts "Cleaning finished"
