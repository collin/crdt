require 'spec_helper'

describe CRDT::Hash do
  include AtomSpecHelper

  subject { CRDT::Hash.new }

  it("is an atom") { CRDT::Array.should < CRDT::Atom }

  CONVERGANCE_COUNT = 10

  def self.converges(test, keys, atoms, *operations)
    CONVERGANCE_COUNT.times do |iteration|
      it "#{test} ( converges iter-#{iteration}/#{CONVERGANCE_COUNT} )" do
        subject1 = described_class.new
        subject2 = described_class.new

        subject1.observe(subject2)
        subject2.observe(subject1)

        EM.run do
          instance_exec(&atoms).each_with_index do |atom, index|
            operation = operations.shuffle.first
            subject = [subject1, subject2].shuffle.first
            key = keys.shuffle.first
            operation[subject, key, atom, index]
          end


          EM.stop_when_done          
        end

        # puts "SUBJECT 1"
        # Hirb::Console.table subject1.send :atoms
        # subject1.table
        # puts "SUBJECT 2"
        # Hirb::Console.table subject2.send :atoms
        # subject2.table

        subject1.should == subject2
      end      
    end
  end

  it "does not respond to add and remove" do
    subject.should_not respond_to(:add)
    subject.should_not respond_to(:remove)
  end

  it "inserts/reads items" do
    subject["key"] = CRDT::Vector.new atom, 0
    subject["key"].atom.value.should == atom
  end

  it "deletes items" do
    subject["key"] = CRDT::Vector.new atom1, 0
    subject.delete "key"
    subject["key"].should == nil
  end

  it "lets inserts win" do
    subject["key"] = CRDT::Vector.new atom1, 0
    subject.delete "key", 0
    subject["key"].atom.value.should == atom1
  end

  it "overwrites member values" do
    subject["key"] = CRDT::Vector.new atom, 0
    subject["key"] = CRDT::Vector.new atom1, 1
    subject["key"].atom.value.should == atom1
  end

  converges("crazy hash ops", %w(key1 key2 key3 key4), 
    -> {
      [atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom,
       atom, atom1, atom2, atom1, atom, atom1, atom]
    },
    Proc.new {|hash, key, atom, index| hash[key] = CRDT::Vector.new(atom, index) },
    Proc.new {|hash, key, atom, index| hash.delete(key, index) }
  )

end