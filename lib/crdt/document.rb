require "mutex_m"
class CRDT::Document < CRDT::Hash # INCEPTION!
  include Mutex_m

  # def initialize(distributor)
  #   self.distributor = distributor
  #   self["objects"] = beget(nil, CRDT::Hash)
  #   self["names"] = beget(nil, CRDT::Hash)
  #   @clock = 0
  # end

  # def beget(key, type, *args)
  #   atom = distributor.beget(type, *args)
  #   @clock += 1
  #   self[key] = CRDT::Vector.new(atom, @clock)
  #   atom
  # end
end
