# Advertises FFOpenVN to people on twitter tweeting about visual novels and whatnot
require_relative 'tbot'
require_relative 'config/configReader'
@current_path = File.dirname(__FILE__)
@config_hash = configReader(@current_path + '/config/stats')
@@search_limit = @config_hash['search_limit']
@@tag = @config_hash['tag']
@@start_point = @config_hash['start_point']
require 'uri'

def parse_wordlist(n)
  l = []
  f = File.open(n, 'r')
  f.each do |word|
    l << word
  end  
  f.close
  #puts l
  return l
end


def run_bot(client, list_of_words)
  url = "http://api.twitter.com/1/statuses/public_timeline.json"
  url = make_query_url(list_of_words)
  rawdata = Net::HTTP.get(url)
  data = JSON.parse( rawdata )
  replies = generate_replies( data )
  tweet_spam( client, replies )
end

def make_query_url( list_of_words )
	query = "http://search.twitter.com/search.json?q="
	list_of_words.each do |word|
		query += word + "OR"
	end
	query += "&result_type=recent&&rpp=#{@@search_limit}"
	query += "&since_id=" + get_latest_id()
	return URI.escape( query )
end # make_query_url

def get_latest_id()
	f = File.open(@current_path + "/word_records/_latest", 'r')
	id = ""
	f.each do |line|
		id = line
	end # end f.each
	f.close
	return id
end # get_latest_id

def write_latest_id(id)
	f = File.open( @current_path + "/word_records/_latest", "w" )
	f.puts( id )
	f.close
end

def generate_replies( data )
	results = ['results']
	replies = []
	write_latest_id( results[0]['from_user_id_str'] ) unless results.empty?
	results.each do |status|
		if status['text'][0..1] == "RT"
			next
		else
			origin = status['from_user']
			text = status['text']
			puts origin + " says: " + text
			replies << "@" + origin + " there's an online VN making platform that's coming out at http://ffopenvn.com" 
		end # if status
	end # end results.each
	return replies
end # generate_replies

def tweet_spam( client, replies )
	replies.each do |reply|
		begin
			client.status :post, reply
		rescue => e
			if e.to_s.include?( "403" )
				puts "Twitter has rate-limited me."
				# We got rate-limited by twitter
			end
			puts e	
			puts "Reply not tweeted: " + reply
		end # begin-rescue
	end #replies.each
end # end tweet_spam

f = File.open(@current_path + "/word_records/_latest", 'w')
f.write(" ")
f.close

list_of_words = parse_wordlist(@current_path + "/keywords.txt")
client = My_client.new.bot
run_bot(client, list_of_words)
