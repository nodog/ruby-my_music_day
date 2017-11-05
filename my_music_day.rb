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

puts '-----------------'
puts "#{practice_hash["title"]}"
puts "based on seed #{seed}"
if date_of
  puts "for the date of #{date_of}"
end
puts '-----------------'
puts 'session 1 - 15 min'
puts "a key - #{practice_hash["keys"].sample(random: prng)}"
puts "a scale - #{practice_hash["scales"].sample(random: prng)}"
scale_practice_method = practice_hash["scale practice method"].sample(random: prng)
if scale_practice_method == practice_hash["scale practice method"][2]
  scale_practice_method += " #{Random.rand(practice_hash["hanon exercise max"]) + 1}"
end
puts "a scale practice method - #{scale_practice_method}"
puts "3 octave all inversion arpeggios of root chord -  #{practice_hash["chords"].shuffle(random:prng).join('  ')}"
puts "  arpeggio style - #{practice_hash["arp_styles"].sample(random: prng)}"
puts "  arpeggio start - #{practice_hash["arp_start"].sample(random: prng)}"
puts "  connection style - #{practice_hash["connection_styles"].sample(random: prng)}"

songs = practice_hash["songs"].shuffle(random:prng)
record_choice = prng.rand(8)
for i_song in 0..1
  key_order = ["day key", "common key"].shuffle(random:prng).join(', then ')
  puts '-----------------'
  puts "session #{i_song + 2} - 15 min"
  puts "song 1 - #{songs[i_song]}"
  puts "  key order is #{key_order}"
  puts "  focus on #{practice_hash['chord_styles'].sample(random: prng)} style chords"
  if record_choice == i_song
    puts '  RECORD AND LISTEN TO THIS!'
  end
  puts '  mid-song break to apreggiate all chords all inversions 3 octaves'
end

n_periods = practice_hash["n_periods"]
period_time = practice_hash["total_time"]/n_periods
for i_session in 1..n_periods do
  puts '-----------------'
  puts "session #{i_session + 3} - #{period_time} min"
  puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  activity = practice_hash["activities"].sample(random: prng)
  puts "activity = \n  #{activity["activity"]}"
  goal_numbers = activity["goals"]
  puts "  goals to keep in mind:"
  for i_goal in 0..goal_numbers.size - 1 do
    puts "    - #{practice_hash["goals"][goal_numbers[i_goal].to_s]}"
  end
end

puts '-----------------'

puts 'AFK activities'
practice_hash['afk_activities'].each do |activity|
  puts "  - #{activity}"
end

puts '-----------------'
