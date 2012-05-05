#!/usr/bin/env ruby


require_relative 'tbot'

list_of_words = [
["abreviate", "abbreviate"],
["equiptment", "equipment"],
]

def run_bot(client, list_of_words)

  url = "http://api.twitter.com/1/statuses/public_timeline.json"
  uri = URI(url)
  j = Net::HTTP.get(uri)

  r = JSON.parse(j)
  get_english(r, client, list_of_words)  
end

def get_english(json_file, client, list_of_words)

  list = []
  json_file.each do |status|
    if status['user']['lang'] == 'en'
      puts status['text']
      match_word_status(list_of_words, [status['text'], status['user']['screen_name']], client)
    end
  end
  return list
end

# takes a group of time line
def parse_timeline

end

# match string
def match_word_status(list_of_words, status, client)
  list_of_words.each do |word|
    if status[0].include?(word[0])
      post_correction(status[1], word[1], client)
    end
  end
end
def match_word(list_of_words, statuses, client)
  statuses.each do |status|
    list_of_words.each do |word|
      if status[0].include?(word[0])
        post_correction(status[1], word[1], client)
      end
     end
  end
end

def post_correction(user, word, client)
  #client.status :post, "@#{user} I think you meant #{word}."
  puts "@#{user} I think you meant #{word}."
end

client = my_client
run_bot(client, list_of_words)
