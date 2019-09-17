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

instruments = ['voice']

if seed.even?()
  instruments.push('guitar')
else
  instruments.push('bass')
end

instruments = instruments.shuffle(random: prng)

drums_placement = prng.rand(instruments.size - 1) + 1
instruments.insert(drums_placement, 'drums')

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

instruments.insert(piano_skills_placement, 'piano - skills')
instruments.insert(piano_songs_placement, 'piano - new songs')

puts
puts '---------------------------'
for i in 0..(instruments.size - 1)
  puts instruments[i]
end
puts '---------------------------'
puts
