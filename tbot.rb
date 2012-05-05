#!/usr/bin/env ruby

require 'rubygems'
gem 'twitter4r'
require 'twitter'
require 'twitter/console'
require_relative 'config/configReader'
 # Spell Police's Access
class My_client

  @@t = Twitter::Client
  
  @@current_path = File.dirname(__FILE__)
  def initialize
    @keydir = '/home/bitnami/'
    config_hash = configReader(@@current_path + '/config/keys2.txt')
    key = config_hash['key']
    secret = config_hash['secret']
    token = config_hash['token']
    token_secret = config_hash['token_secret']

    @@t.configure do |conf|
      # App configuration
      conf.application_name = 'FFOpenVN'
      conf.application_version = '1.0'
      conf.application_url = 'http://crunchymall.com'

   #  App OAuth token key/secret pair
      conf.oauth_consumer_token = key
      conf.oauth_consumer_secret = secret
    end

    @@key = key
    @@secret = secret
    @@token = token
    @@token_secret = token_secret
    @@cfg = @@t.config
    @@foo = @@t.new(:oauth_access => { :key => token, :secret => token_secret})
  end
  def foo
    @@foo
  end
# we reuse the cfg variable we set earlier since it contains our app configuration
#k = cfg.oauth_consumer_token
#s = cfg.oauth_consumer_secret
#u = "#{(cfg.protocol == :ssl ? :https : cfg.protocol).to_s}://#{cfg.host}:#{cfg.port}"

#oc = OAuth::Consumer.new(k ,s, :site=> u)

#rt = oc.get_request_token
#auth_url = rt.authorize_url
#puts auth_url
#at = rt.get_access_token(:oauth_verifier=>'7136138')

#user_key = at.token
#user_secret = at.secret
 
    #return client = Twitter::Client.new(:oauth_access => { :key => access_token, :secret => access_secret })
   def bot
    @@t.new(:oauth_access => { :key => @@token, :secret => @@token_secret})
  end
  def bot_test
    @@t.new
  end
end

#client = My_client.new(consumer_key, consumer_secret, access_token, access_secret)
#puts client.bot
#puts client.foo
#puts client.bot_test

#puts client.foo.status :post, 'test, me what'
#puts client.timeline_for :me

#fr = client.my :friends

#puts fr
 
