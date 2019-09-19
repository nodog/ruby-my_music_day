#!/usr/bin/env ruby

require 'date'

BIG_INTEGER = 99999999

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

instruments = ['45 - voice']

if prng.rand() < 0.5
  instruments.push('30 - bass')
else
  instruments.push('30 - guitar')
end

if prng.rand() < 0.5
  instruments.push('30 - piano - xscription')
else
  instruments.push('30 - piano - repertoire')
end

instruments = instruments.shuffle(random: prng)

drums_placement = prng.rand(instruments.size - 1) + 1
instruments.insert(drums_placement, '45 - drums')

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

instruments.insert(piano_skills_placement, '30 - piano - skills')
instruments.insert(piano_songs_placement, '30 - piano - new songs')
instruments.insert(0, '15 - piano - warmups')

puts
puts '---------------------------'
for i in 0..(instruments.size - 1)
  puts instruments[i]
end
puts '---------------------------'
puts
