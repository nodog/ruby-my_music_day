#!/usr/bin/env ruby

repertoire = ['Take the A Train',
              'Blue Monk',
              'Summertime',
              'So What',
              'Blue Skies',
              'All of Me',
              'Freddie Freeloader',
              'All Blues',
              'Blue Bossa',
              'Footprints',
              'Chameleon']

repertoire = repertoire.shuffle

puts
puts '---------------------------'
for i in 0..(repertoire.size - 1)
  puts repertoire[i]
end
puts '---------------------------'
puts
