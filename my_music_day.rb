#!/usr/bin/env ruby

# I want to be able to pick out sections that will be useful in each practice.
# I want to be able to weight different options.
# This definitely should be on a website.

require 'json'
require_relative 'regular_seed_lib'

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

def generate_instrument(practice_hash, prng)
  #"voice", "keys", "drums", "fretted", "learning"
  instrument_type = practice_hash['instrument_types'].shuffle(random:prng)[0]
  return practice_hash["#{instrument_type}_instruments"].shuffle(random:prng)[0]
end

def should_i_sing(prng)
  if (prng.rand(1.0) > 0.5)
    return " - SING"
  else
    return ""
  end
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

seed = regular_seed(ARGV[0])

prng = Random.new(seed)
sing_day = should_i_sing(prng)

#puts '-----------------'
print "#{practice_hash["title"]}"
#if date_of
#  print " for the date of #{date_of}"
#end
puts " based on seed #{seed}"
#puts 'Practice chords, walk bass (1-5-1) w/chords, melody, melody w/chords, soloing, soloing, solo w/chords, and soloing (2-5-1 ARPS).'
puts "all random notes for improv - #{practice_hash["all_notes"].shuffle(random: prng).join('  ')}"
puts "1..8 in random order - #{[1,2,3,4,5,6,7,8].shuffle(random: prng)}"
puts "instrument - #{generate_instrument(practice_hash, prng)}"

#puts "\n-----------------"
puts "\n"
#puts sing_day
print "  key - #{practice_hash['all_notes'].sample(random: prng)}"
print "   metronome - #{generate_tempo(prng)}"
puts "   style - #{practice_hash["metronome_styles"].sample(random: prng)}"
print "  chord components - #{practice_hash["arp_components"].sample(random: prng)}"
print ", #{practice_hash["inversion_start"].sample(random: prng)}"
puts ", #{practice_hash["arp_start"].sample(random: prng)} start"
puts "  a scale - #{practice_hash["scales"].sample(random: prng)}"
generate_scales_practice(practice_hash, prng, sing_day)
puts ''
puts '  weightlifting, 5 min 1 scale, random chords'
puts "  scales - major, dorian, harmonic minor, mixolydian, natural minor, minor blues"
puts '  I IV I V I (triads in major), i iv i V i (triads in harmonic minor)'
#puts '  warmup voice - buzzing octave sirens in my range.'
#puts '  If structure is giving trouble: 5X chorus chords only, visualize music, improvise structurally.'
# puts '  warmup voice - point-sing-play major scales in my range.'
# puts '  warmup voice - point-sing-play random notes above in my range.'
# puts '  voice exercise - point-sing-play up & down major w/alternating root w & w/o piano.'
# puts '  voice exercise - sing-play - up & down chromatic w/piano.'
# puts '  voice exercise - tonicize (I-IV-I-V-I triads) - sight sing exercises.'
# puts '  voice exercise - vocal improv - point-scat-play LH bass note, RH point-sing-play piano.'
# puts '  voice exercise - play a backing track, vocal improv + piano doubling'
#puts "  connection style - #{practice_hash["connection_styles"][2]} with clean firm touch"


def generate_arpeggios_practice(practice_hash, prng, sing_day)
  print "  chord order"
  puts " -  #{practice_hash["chord_types"].shuffle(random:prng).join('  ')}"
  print "  arpeggio style" + sing_day
  puts " - #{practice_hash["arp_styles"].sample(random: prng)}"
  print "  chord style"
  puts " - #{practice_hash["chord_styles"].sample(random: prng)}"
end

# GOALS
goals = practice_hash["goals"].shuffle(random:prng)
# if no focus_goals, do nothing, if 1, put it in first 2, otherwise, focus_goals take over
focus_goals = practice_hash["focus_goals"]
if focus_goals.length == 1
  goals.insert(prng.rand(2), focus_goals[0])
elsif focus_goals.length > 1
  goals = focus_goals.shuffle(random:prng)
end

record_choice = prng.rand(8)
n_goals = practice_hash['n_goals']
for i_goal in 0..(n_goals - 1)
  #puts "\n-----------------"
  puts "\n"
  goal = goals[i_goal]
  puts "--- session #{i_goal + 1} - #{practice_hash['goal_time']/n_goals} min --- #{goal['name']}"
  puts "  #{goal['primary_technique']}"
  # add back??  "over #{practice_hash["backing_sources"].sample(random: prng)}"
  shuffled_solo_techniques = practice_hash['solo_techniques'].shuffle(random: prng)
  puts "  extra - #{goal['extra_techniques'].sample(random: prng)}"
  puts "  solo technique 1 - #{shuffled_solo_techniques[0]}"
  puts "  solo technique 2 - #{shuffled_solo_techniques[1]}"

  if record_choice == i_goal
    puts '  RECORD AND LISTEN TO THIS!'
  end
end

n_exercises = practice_hash["n_exercises"]
exercise_time = practice_hash["exercise_time"]/n_exercises
print "\n--- session 3 - #{exercise_time} min"
puts " - arpeggio practice"
generate_arpeggios_practice(practice_hash, prng, sing_day)

def generate_progression_rhythm_practice(practice_hash, prng)
  puts "  chord style: #{practice_hash["chord_styles"].sample(random: prng)}"
  puts "  chord progression: #{practice_hash["chord_progressions"].sample(random: prng)}"
  puts "  comping rhythm 1 -   |:  #{generate_comp_rhythm(prng)} :|"
  puts "  comping rhythm 2 -   |:  #{generate_comp_rhythm(prng)} :|"
end

print "\n--- session 4 - #{exercise_time} min"
puts " - chord progression practice"
generate_progression_rhythm_practice(practice_hash, prng)

# EXERCISES
n_exercises = practice_hash["n_exercises"]
exercise_time = practice_hash["exercise_time"]/n_exercises
shuffled_activities = practice_hash["activities"].shuffle(random: prng)
for i_session in 1..n_exercises do
  print "\n--- session #{i_session + n_goals + 2} - #{exercise_time} min"
#   puts "instrument = #{practice_hash["instruments"].sample(random: prng)}"
  activity = shuffled_activities[i_session - 1]
  puts " - #{activity}"

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
