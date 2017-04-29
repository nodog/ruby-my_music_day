#!/usr/bin/env ruby

require 'json'
require 'date'

practice_file = File.read('music_practice.json')
practice_hash = JSON.parse(practice_file)

if ARGV[0]
  seed = ARGV[0].to_i
else
  seed = Date.today.year() * 1000 + Date.today.yday()
end

prng = Random.new(seed)

puts "-----------------"
puts "#{practice_hash["title"]}"
puts "based on seed #{seed}"
puts "a key - #{practice_hash["keys"].sample(random: prng)}"
puts "a scale - #{practice_hash["scales"].sample(random: prng)}"

n_periods = practice_hash["n_periods"]
for i_session in 1..n_periods do
  puts "-----------------"
  puts "session #{i_session} - #{60/n_periods} minutes"
  puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  puts "activity = \n  #{practice_hash["activities"].sample(random: prng)}"
end

puts "-----------------"
