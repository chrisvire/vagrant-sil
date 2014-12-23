#!/usr/bin/env ruby
# 'vagrant box list' display a list of the currently downloaded vagrant boxes
# This list is ordered by box name and then by version. I don't have multiple
# providers, so I don't know how those are handled.  I am assuming they are
# group together as well.
# Example:
# chrisvire/precise32  (virtualbox, 0.4.0)
# chrisvire/precise32  (virtualbox, 0.5.0)
# chrisvire/precise64  (virtualbox, 0.4.0)
# chrisvire/precise64  (virtualbox, 0.5.0)
# chrisvire/saucy32    (virtualbox, 0.1.0)
# chrisvire/saucy32    (virtualbox, 0.2.0)
# chrisvire/saucy64    (virtualbox, 0.1.0)
# chrisvire/saucy64    (virtualbox, 0.2.0)
# chrisvire/trusty32   (virtualbox, 0.2.0)
# chrisvire/trusty32   (virtualbox, 0.3.0)
# chrisvire/trusty64   (virtualbox, 0.3.0)
# chrisvire/trusty64   (virtualbox, 0.4.0)
# chrisvire/wasta64-12 (virtualbox, 0.1.0)
# chrisvire/wasta64-12 (virtualbox, 0.3.0)
# chrisvire/wasta64-14 (virtualbox, 0.1.0)
# chrisvire/wasta64-14 (virtualbox, 0.2.0)
#
# The algorithm for the script is to push all the entries on a list (so that they
# are processed in reverse order).  If a duplicate of box name and provider are
# found, then remove it.

pipe = IO.popen("vagrant box list")
re =  /(\S+)\s+\((\w+), ([0-9.]+)/
boxes = []
while (line = pipe.gets)
  m = line.match(re)
  boxes.unshift([ m[1], m[2], m[3] ])
end

last_box = nil
last_provider = nil
boxes.each do  |box|
  if box[0] == last_box && box[1] == last_provider
    system "vagrant box remove #{box[0]} --provider #{box[1]} --box-version #{box[2]}"
  end
  last_box = box[0]
  last_provider = box[1]
end
