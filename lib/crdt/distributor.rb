class CRDT::Distributor
  attr_accessor :document

  def initialize(document)
    @document
  end

  def beget(type, *args)
    atom = type.new(*args)
    atom.add_observer(self, :distribute)
    atom
  end

  def distribute
    
  end
end