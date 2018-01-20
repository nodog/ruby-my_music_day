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
puts "4 notes for improv - #{practice_hash["all_notes"].shuffle(random: prng)[0..3].join('  ')}"
puts "3 octave all inversion arpeggios of root chord -  #{practice_hash["chords"].shuffle(random:prng).join('  ')}"
#puts "  arpeggio style - #{practice_hash["arp_styles"].sample(random: prng)}"
puts "  arpeggio start - #{practice_hash["arp_start"].sample(random: prng)}"
puts "  inversion start - #{practice_hash["inversion_start"].sample(random: prng)}"
puts "  connection style - #{practice_hash["connection_styles"].sample(random: prng)}"

songs = practice_hash["songs"].shuffle(random:prng)
exercises = [0,1].shuffle(random:prng)
record_choice = prng.rand(8)
for i_song in 0..1
  key_order = ["day key", "common key"].shuffle(random:prng).join(', then ')
  puts '-----------------'
  puts "session #{i_song + 2} - 15 min"
  song = songs[i_song]
  puts "song - #{song['name']}"
  #puts "  key order is #{key_order}"
  #puts "  focus on #{practice_hash['chord_styles'].sample(random: prng)} playing style"
  #puts "  using a #{practice_hash['rhythms'].sample(random: prng)} rhythm"
  puts "  special technique - #{song['special_techniques'].sample(random: prng)}"
  puts "  use the #{song['inversions'].sample(random: prng)} inversion, if appropriate."
  #puts "  focus on #{practice_hash['chord_styles'][0]} style chords"
  if record_choice == i_song
    puts '  RECORD AND LISTEN TO THIS!'
  end
  puts '  play through, focus on changes, play through'
  puts '  mid-song break to arpeggiate 2 chords all inversions 3 octaves'
  if i_song == exercises[0]
    puts '-----------------'
    puts 'Try exercise #2 - ii V I - circle - LH root + 7 or 3 + RH 1 chord tone'
  elsif i_song == exercises[1]
    puts '-----------------'
    puts 'Try exercise #1 - rhythm clapping'
  end
end

n_periods = practice_hash["n_periods"]
period_time = practice_hash["total_time"]/n_periods
for i_session in 1..n_periods do
  puts '-----------------'
  puts "session #{i_session + 3} - #{period_time} min"
  puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  #activity = practice_hash["activities"].sample(random: prng)
  # temporarily choose sight readig always
  activity = practice_hash["activities"][7]
  puts "activity = \n  #{activity["activity"]}"
  goal_numbers = activity["goals"]
  puts "  goals to keep in mind:"
  for i_goal in 0..goal_numbers.size - 1 do
    puts "    - #{practice_hash["goals"][goal_numbers[i_goal].to_s]}"
  end
end

puts '-----------------'

puts 'AFK activities'
practice_hash['afk_activities'].shuffle(random: prng).each do |activity|
  puts "  - #{activity}"
end

puts '-----------------'
