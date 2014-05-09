Epic Geo
========
[![Build Status](https://travis-ci.org/jenningsanderson/epic-geo.svg?branch=master)](https://travis-ci.org/jenningsanderson/epic-geo)
[![Gem Version](https://badge.fury.io/rb/epic-geo.svg)](http://badge.fury.io/rb/epic-geo)

####Background
A gem for interfacing with both twitter and OSM data for Project EPIC and University of Colorado Boulder.

####Dependencies
Most of the functionality within this gem requires access to project EPIC's NoSQL Mongo database.  This will require being on campus or the VPN.

**Gem Dependencies**
 - ```rgeo``` - A decently maintained geospatial gem for Ruby.  Allows for easy geospatial calculations such as area and length.

 - ```georuby``` - Another geospatial library for Ruby which offers support for reading and writing shapefiles.

###Installation
Pull from Github for latest version of gem
  1. Put the following line in your Gemfile: ```gem 'epic-geo' ,github: 'jenningsanderson/epic-geo'```
  2. Run ```bundle install```

Other:
```gem install epic-geo```
