#!/usr/bin/env ruby

# this file creates a new bot and mine the search api for mispelled words
# and picks responses based on that
# 
require_relative 'tbot'
require_relative 'config/configReader'
#require_relative 'tbot'
#require File.join(File.dirname(__FILE__), 'utils' )
@current_path = File.dirname(__FILE__)
@config_hash = configReader(@current_path + '/config/stats')
@@search_limit = @config_hash['search_limit']
@@tag = @config_hash['tag']
@@start_point = @config_hash['start_point']

def parse_wordlist(n)
  l = []
  f = File.open(n, 'r')
  f.each do |wordpair|
    if wordpair[0] != '#'
      wordpair = wordpair.strip.split(', ')
      l << wordpair
    end
  end  
  f.close
  #puts l
  return l
end


def run_bot(client, list_of_words)
  url = "http://api.twitter.com/1/statuses/public_timeline.json"
  urls = make_urls(list_of_words)
  urls.each do |tmp|
    url_half = tmp[0]
    word = tmp[2]
    misspelled_word = tmp[1]
    url = url_half + "&since_id=#{retrieve_id(misspelled_word)}"
    uri = URI(url)
    j = Net::HTTP.get(uri)
    r = JSON.parse(j)
    get_english(r, client, word, misspelled_word)  
  end
end

def make_urls(list_of_words)
  r = []
  list_of_words.each do |pair|
    r << ["http://search.twitter.com/search.json?q=#{pair[0]}&result_type=recent&&rpp=#{@@search_limit}", pair[0], pair[-1]]
  end
  return r
end

def save_id(num, word)
  f = File.open(@current_path+"/word_records/#{word}.txt",'w')
  f.write(num.to_i + 1)
  f.close
end

def retrieve_id(word)
  f= File.open(@current_path+"/word_records/#{word}.txt", 'r')
  s =  f.read
  f.close
  return s
end

def mark_end_point(json_file, start_point, filename)
  if not json_file[0].nil?
    if start_point == 'newest'
      save_id(json_file[0]['id'], filename)
    else
      save_id(json_file[-1]['id'], filename)
    end
  end
end

# go through each status
def get_english(json_file, client, word, misspelled_word)
  list = []
  json_file = json_file['results']
  json_file.each do |status|
    if status['text'][0..1] == "RT"
      next
    elsif status['text'].include?(" #{misspelled_word} ")
        puts status['text']
        post_correction(status['from_user'] ,word, client)
    end
  end
  mark_end_point(json_file, @start_point, misspelled_word)
  return list
end

def post_correction(user, word, client)
   begin    
     client.status :post, "@#{user} I think you meant #{word}. #{@@tag}"
   rescue => e 
     if e.to_s.include?("403")
       puts e
       #Process.exit
     else
       puts e
     end
   end
#   puts "@#{user} I think you meant #{word}."
#  client.status :post, "Food!"
end

f = File.open(@current_path + "/word_records/_lastran", 'w')
f.write(" ")
f.close

list_of_words = parse_wordlist(@current_path + "/wordlist.txt")
client = My_client.new.bot
run_bot(client, list_of_words)
