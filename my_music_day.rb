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
  #prng.rand(prng.rand(80)) + 80
  prng.rand(80) + 80
end

def should_i_sing(prng)
  if (prng.rand(1.0) > 0.5)
    return " - SING"
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
puts sing_day
print "  key - #{practice_hash['all_notes'].sample(random: prng)}"
print "   metronome - #{generate_tempo(prng)}"
puts "   style - #{practice_hash["metronome_styles"].sample(random: prng)}"
print "  chord components - #{practice_hash["arp_components"].sample(random: prng)}"
print ", #{practice_hash["inversion_start"].sample(random: prng)}"
puts ", #{practice_hash["arp_start"].sample(random: prng)} start"
puts "  a scale - #{practice_hash["scales"].sample(random: prng)}"
puts "  connection style - #{practice_hash["connection_styles"][2]} with clean firm touch"

# SONGS
songs = practice_hash["songs"].shuffle(random:prng)
# if no focus_songs, do nothing, if 1, put it in first 2, otherwise, focus_songs take over
focus_songs = practice_hash["focus_songs"]
if focus_songs.length == 1
  songs.insert(prng.rand(2), focus_songs[0])
elsif focus_songs.length > 1
  songs = focus_songs.shuffle(random:prng)
end

record_choice = prng.rand(8)
n_songs = practice_hash['n_songs']
for i_song in 0..(n_songs - 1)
  #puts "\n-----------------"
  puts "\n"
  song = songs[i_song]
  puts "--- session #{i_song + 1} - #{practice_hash['song_time']/n_songs} min --- #{song['name']}"
  puts "  #{song['primary_technique']} over #{practice_hash["backing_sources"].sample(random: prng)}"
  shuffled_solo_techniques = practice_hash['solo_techniques'].shuffle(random: prng)
  puts "  if time - #{song['extra_techniques'].sample(random: prng)}"
  puts "  solo technique 1 - #{shuffled_solo_techniques[0]}"
  puts "  solo technique 2 - #{shuffled_solo_techniques[1]}"

  if record_choice == i_song
    puts '  RECORD AND LISTEN TO THIS!'
  end
end

# EXERCISES
def generate_progression_rhythm_practice(practice_hash, prng)
  puts "  chord style: #{practice_hash["chord_styles"].sample(random: prng)}"
  puts "  chord progression: #{practice_hash["chord_progressions"].sample(random: prng)}"
  puts "  comping rhythm 1 -   |:  #{generate_comp_rhythm(prng)} :|"
  puts "  comping rhythm 2 -   |:  #{generate_comp_rhythm(prng)} :|"
end

def generate_scales_practice(practice_hash, prng, sing_day)
  print "  a scale practice method"
  scale_practice_method = practice_hash["scale practice methods"].sample(random: prng)
  if scale_practice_method == "Hanon"
    scale_practice_method += " #{prng.rand(practice_hash["hanon exercise max"]) + 1}"
  else
    scale_practice_method += " using #{practice_hash["scale practice intervals"].sample(random: prng)}"
  end
  print " - #{scale_practice_method}"
  print sing_day
  if (prng.rand(1.0) > 0.5)
    print " with SWING"
  end
  print "\n"
end

def generate_arpeggios_practice(practice_hash, prng, sing_day)
  print "  chord order"
  puts " -  #{practice_hash["chords"].shuffle(random:prng).join('  ')}"
  print "  arpeggio style" + sing_day
  puts " - #{practice_hash["arp_styles"].sample(random: prng)}"
  print "  chord style"
  puts " - #{practice_hash["chord_styles"].sample(random: prng)}"
end

n_exercises = practice_hash["n_exercises"]
exercise_time = practice_hash["exercise_time"]/n_exercises
shuffled_activities = practice_hash["activities"].shuffle(random: prng)
for i_session in 1..n_exercises do
  print "\n--- session #{i_session + n_songs} - #{exercise_time} min"
#   puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  activity = shuffled_activities[i_session - 1]
  puts " - #{activity}"

  case activity
  when "progression rhythm practice"
    generate_progression_rhythm_practice(practice_hash, prng)
  when   "scales"
    generate_scales_practice(practice_hash, prng, sing_day)
  when "arpeggios"
    generate_arpeggios_practice(practice_hash, prng, sing_day)
  end

#   goal_numbers = activity["goals"]
#   puts "  goals to keep in mind:"
#   for i_goal in 0..goal_numbers.size - 1 do
#     puts "    - #{practice_hash["goals"][goal_numbers[i_goal].to_s]}"
#   end
end

# puts '-----------------'

# puts 'AFK activities'
# practice_hash['afk_activities'].shuffle(random: prng).each do |activity|
#  puts "  - #{activity}"
# end

# puts '-----------------'
