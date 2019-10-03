#!/usr/bin/env ruby

require 'date'
require_relative 'regular_seed_lib'

BIG_INTEGER = 99999999

seed = regular_seed(ARGV[0])

prng = Random.new(seed)

technique_exerice_flows = ['meditative in order',
                           'jump around to favorites',
                           'crescendo/decrescendo']

technique_exerice_flows = technique_exerice_flows.shuffle(random: prng)

puts
puts '---------------------------'
puts technique_exerice_flows.sample(random: prng)
puts '---------------------------'
puts
