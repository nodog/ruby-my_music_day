#!/usr/bin/env ruby

# big ideas!
# I want to move this to be an all encompassing practice program.
# Until then, here's what I'm thinking
# Mon - AM piano  PM bass  (note: kids music time on Mondays)
# Tue - AM piano  PM piano
# Wed - AM piano  PM guitar
# Thu - AM piano  PM bass
# Fri - AM piano  PM piano
# Sat - AM piano  PM guitar
# Sun - AM piano  PM music making

# I want to be able to pick out sections that will be useful in each practice.
# I want to be able to weight different options.
# This definitely should be on a website.

require 'json'
require 'date'

BIG_INTEGER = 99999999

practice_file = File.read('music_practice.json')
practice_hash = JSON.parse(practice_file)

def generate_comp_rhythm(prng)
  comp_rhythm = ['- ', '. ', '- ', '. ', '- ', '. ', '- ', '. ']
  # There must be at least one off-beat hit.
  comp_rhythm[1 + 2 * prng.rand(4)] = 'O '
  prng.rand(4).times do
    comp_rhythm[prng.rand(8)] =  'O '
  end
  comp_rhythm.join()
end

def generate_tempo(prng)
  prng.rand(80) + 80
end

def should_i_sing(prng)
  if (prng.rand(1.0) > 0.5)
    return " - SING "
  else
    return ""
  end
end

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
sing_day = should_i_sing(prng)

#puts '-----------------'
print "#{practice_hash["title"]}"
if date_of
  print " for the date of #{date_of}"
end
puts " based on seed #{seed}"
puts "4 notes for improv - #{practice_hash["all_notes"].shuffle(random: prng)[0..3].join('  ')}"
#puts "\n-----------------"
puts "\n"
print 'session 1 - 21 min'
puts sing_day
print "  key - #{practice_hash['all_notes'].sample(random: prng)}"
print "   metronome - #{generate_tempo(prng)}"
puts "   style - #{practice_hash["metronome_styles"].sample(random: prng)}"
print "  chord components - #{practice_hash["arp_components"].sample(random: prng)}"
print ", #{practice_hash["inversion_start"].sample(random: prng)}"
puts ", #{practice_hash["arp_start"].sample(random: prng)} start"
puts "  a scale - #{practice_hash["scales"].sample(random: prng)}"
puts "  connection style - #{practice_hash["connection_styles"][2]} with clean firm touch"

puts "\n--- session 1a - 5 min --- scale practice"
scale_practice_method = practice_hash["scale practice method"].sample(random: prng)
if scale_practice_method == practice_hash["scale practice method"][2]
  scale_practice_method += " #{prng.rand(practice_hash["hanon exercise max"]) + 1}"
end
print "  a scale practice method"
print " - #{scale_practice_method}"
print sing_day
if (prng.rand(1.0) > 0.5)
  print " with SWING"
end
print "\n"

puts "\n--- session 1b - 5 min --- 2 octave arpeggio practice"
print "  chord order"
puts " -  #{practice_hash["chords"].shuffle(random:prng).join('  ')}"
print "  arpeggio style" + sing_day
puts " - #{practice_hash["arp_styles"].sample(random: prng)}"

puts "\n--- session 1c - 10 min --- progression practice"
puts "  chord style: #{practice_hash["chord_styles"].sample(random: prng)}"
puts "  chord progression: #{practice_hash["chord_progressions"].sample(random: prng)}"
puts "  comping rhythm 1 -   |:  #{generate_comp_rhythm(prng)} :|"
puts "  comping rhythm 2 -   |:  #{generate_comp_rhythm(prng)} :|"

puts "\n--- session 1d - 1 min --- chords in key"
puts "  Find viable chords in current key."

focus_songs = practice_hash["focus_songs"]
if focus_songs.length == 1
  songs = practice_hash["songs"].shuffle(random:prng)
  songs.insert(prng.rand(2), focus_songs[0])
else
  songs = focus_songs.shuffle(random:prng)
end
record_choice = prng.rand(8)
for i_song in 0..(practice_hash['n_periods'] - 1)
  #puts "\n-----------------"
  puts "\n"
  song = songs[i_song]
  puts "session #{i_song + 2} - #{practice_hash['session_time']} min --- #{song['name']}"
  puts "  #{song['primary_technique']} over #{practice_hash["backing_sources"].sample(random: prng)}"
  shuffled_solo_techniques = practice_hash['solo_techniques'].shuffle(random: prng)
  puts "  if time - #{song['extra_techniques'].sample(random: prng)}"
  puts "  solo technique 1 - #{shuffled_solo_techniques[0]}"
  puts "  solo technique 2 - #{shuffled_solo_techniques[1]}"

  if record_choice == i_song
    puts '  RECORD AND LISTEN TO THIS!'
  end
end

puts "\n--- session 4a - 1 min --- rushing/dragging practice"
puts "  On key practice on beat, then dragging one note to metronome, rhythm, or music."

puts "\n--- session 4b - 1 min --- So What quartal voicing"
puts "  In multiple octaves, find root minor key quartal voicings and plane."

# n_periods = practice_hash["n_periods"]
# period_time = practice_hash["total_time"]/n_periods
# for i_session in 1..n_periods do
#   puts '-----------------'
#   puts "session #{i_session + 3} - #{period_time} min"
#   puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
#   #activity = practice_hash["activities"].sample(random: prng)
#   # temporarily choose sight readig always
#   activity = practice_hash["activities"][7]
#   puts "activity = \n  #{activity["activity"]}"
#   goal_numbers = activity["goals"]
#   puts "  goals to keep in mind:"
#   for i_goal in 0..goal_numbers.size - 1 do
#     puts "    - #{practice_hash["goals"][goal_numbers[i_goal].to_s]}"
#   end
# end

# puts '-----------------'

# puts 'AFK activities'
# practice_hash['afk_activities'].shuffle(random: prng).each do |activity|
#  puts "  - #{activity}"
# end

# puts '-----------------'
