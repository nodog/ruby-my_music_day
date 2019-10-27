#!/usr/bin/env ruby

require 'date'
require_relative 'regular_seed_lib'

BIG_INTEGER = 99999999

seed = regular_seed(ARGV[0])

prng = Random.new(seed)

instruments = ['  :45 - voice']

selection = prng.rand()
if selection < 0.5
  instruments.push('  :30 - bass')
elsif selection < 0.75
  instruments.push('  :30 - guitar')
else
  instruments.push('  :30 - synth')
end

if prng.rand() < 0.5
  instruments.push('  :30 - piano - xscription (Freddie F) and paperstuff')
else
  instruments.push('  :30 - piano - repertoire')
end

instruments = instruments.shuffle(random: prng)

drums_technique_exerice_flows = ['meditative in order',
                                 'jump around to favorites',
                                 'crescendo/decrescendo']
drums_text = '  :45 - drums - ' + drums_technique_exerice_flows.sample(random: prng)
drums_placement = prng.rand(instruments.size - 1) + 1

instruments.insert(drums_placement, drums_text)

# piano skills anywhere
piano_skills_placement = prng.rand(instruments.size)
# piano songs afternoon
piano_songs_placement = prng.rand(2)*(-1) - 1

#if piano skills afternoon
if piano_skills_placement > 2
  # not the break
  piano_skills_placement += 1
  #and piano songs morning
  piano_songs_placement = prng.rand(3)
end

instruments.insert(piano_skills_placement, '  :30 - piano - skills')
instruments.insert(piano_songs_placement, '  :30 - piano - new songs')
instruments.insert(0, '  :15 - piano - warmups')

puts
puts '---------------------------'
for i in 0..(instruments.size - 1)
  puts instruments[i]
end
puts '---------------------------'
puts
