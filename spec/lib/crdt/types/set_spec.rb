require 'spec_helper'
describe CRDT::Set do
  include AtomSpecHelper

  subject { CRDT::Set.new }

  it("is an atom") { CRDT::Set.should < CRDT::Atom }

  commute("adds atoms",
    -> { subject.add CRDT::Vector.new atom, 1 }) do
    subject.atoms.should include atom
  end

  commute("removes atoms",
    -> { subject.add CRDT::Vector.new atom, 1 },
    -> { subject.remove CRDT::Vector.new atom, 2 }) do    
    subject.atoms.should_not include atom    
  end

  commute("gives a tied clock to the added atom",
    -> { subject.add CRDT::Vector.new atom, 1 },
    -> { subject.remove CRDT::Vector.new atom, 1 }) do    
    subject.atoms.should include atom
  end

  commute("is enumerable",
    -> { subject.add CRDT::Vector.new atom1, 1 },
    -> { subject.add CRDT::Vector.new atom2, 1 },
    -> { subject.remove CRDT::Vector.new atom1, 2 }) do    
    subject.atoms.should == [atom2]
  end
end