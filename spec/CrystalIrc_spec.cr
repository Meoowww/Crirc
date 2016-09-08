require "./spec_helper"

VERBOSE = ENV["VERBOSE"]? == "true" || false

require "./CrystalIrc/*"
require "./CrystalIrc/utils/*"
require "./CrystalIrc/protocol/*"
require "./CrystalIrc/server/*"
require "./CrystalIrc/client/*"
