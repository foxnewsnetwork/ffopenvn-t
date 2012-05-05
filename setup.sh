#!/bin/bash
mkdir ~/twitter_spelling_bot
echo 'Making twitter_spelling_bot folder...'

cp -r * ~/twitter_spelling_bot/.
echo 'Copying the contents...'
ruby ~/twitter_spelling_bot/word_records/make_word_record.rb
echo 'Making word_record database...'
crontab -i ~/twitter_spelling_bot/cronfile
echo 'Installing cron file...'

echo 'Installation complete!'

echo 'Make sure youve changed the wordlist.txt and setupped the database files!'
