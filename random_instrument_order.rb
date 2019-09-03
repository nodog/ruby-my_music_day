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

instruments = ['voice',
               'guitar',
               'bass']

instruments = instruments.shuffle(random: prng)

drums_placement = prng.rand(instruments.size - 1) + 1
instruments.insert(drums_placement, 'drums')

piano_placement = prng.rand(2)*(-1) - 1
instruments.insert(piano_placement, 'piano - new songs')

puts
puts '---------------------------'
for i in 0..(instruments.size - 1)
  puts instruments[i]
end
puts '---------------------------'
puts
