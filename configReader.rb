#!/usr/bin/env ruby

def configReader(file)
  f = File.open(file, 'r')
  result = {}
  f.each do |l|

    # Skip comments
    if l[0] == 'x'
      next
    end

    if l.include?(':')
      tmp = l.strip.split(':')
      result << {tmp[0], tmp[1]}
    end
  end
  puts result
  return result
end

configReader('keys')


