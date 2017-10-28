#!/usr/bin/env ruby

require 'json'
require 'date'

BIG_INTEGER = 99999999

practice_file = File.read('music_practice.json')
practice_hash = JSON.parse(practice_file)

if ARGV[0]
  if ARGV[0] == "random"
    seed = rand(BIG_INTEGER)
  elsif ARGV[0] == "tomorrow"
    tomorrow = Date.today + 1
    seed = tomorrow.year() * 1000 + tomorrow.yday()
    date_of = tomorrow.strftime("%F")
  else
    seed = ARGV[0].to_i
  end
else
  this_day = Date.today
  seed = this_day.year() * 1000 + this_day.yday()
  date_of = this_day.strftime("%F")
end

prng = Random.new(seed)

puts "-----------------"
puts "#{practice_hash["title"]}"
puts "based on seed #{seed}"
if date_of
  puts "for the date of #{date_of}"
end
puts "a key - #{practice_hash["keys"].sample(random: prng)}"
puts "a scale - #{practice_hash["scales"].sample(random: prng)}"
scale_practice_method = practice_hash["scale practice method"].sample(random: prng)
if scale_practice_method == practice_hash["scale practice method"][2]
  scale_practice_method += " #{Random.rand(practice_hash["hanon exercise max"]) + 1}"
end
puts "a scale practice method - #{scale_practice_method}"
puts "arpeggios of root chord -  #{practice_hash["chords"].shuffle(random:prng).join('  ')}"
n_periods = practice_hash["n_periods"]
period_time = practice_hash["total_time"]/n_periods
for i_session in 1..n_periods do
  puts "-----------------"
  puts "session #{i_session} - #{period_time} minutes"
  puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  activity = practice_hash["activities"].sample(random: prng)
  puts "activity = \n  #{activity["activity"]}"
  goal_numbers = activity["goals"]
  puts "  goals to keep in mind:"
  for i_goal in 0..goal_numbers.size - 1 do
    puts "    - #{practice_hash["goals"][goal_numbers[i_goal].to_s]}"
  end
end

puts "-----------------"
