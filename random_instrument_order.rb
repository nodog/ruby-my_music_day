#!/usr/bin/env ruby

require 'date'
require_relative 'regular_seed_lib'

BIG_INTEGER = 99999999

seed = regular_seed(ARGV[0])

prng = Random.new(seed)

instruments = ['  :45 - voice']

if prng.rand() < 0.5
  instruments.push('  :30 - bass')
else
  instruments.push('  :30 - guitar')
end

if prng.rand() < 0.5
  instruments.push('  :30 - piano - xscription and paperstuff')
else
  instruments.push('  :30 - piano - repertoire')
end

instruments = instruments.shuffle(random: prng)

drums_placement = prng.rand(instruments.size - 1) + 1
instruments.insert(drums_placement, '  :45 - drums')

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
