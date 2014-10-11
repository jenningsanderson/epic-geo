#
# Spec Helper
#
# Helper file for rspec tests
#

require 'pp'
require 'rgeo'

require_relative '../lib/epic_geo'

FACTORY = RGeo::Geographic.simple_mercator_factory