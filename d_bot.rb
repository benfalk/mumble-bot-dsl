#!/usr/bin/env ruby

require './bot'

Bot.with_command 'setvol' do |val|
  `mpc volume #{val}`
end

Bot.start!
