require 'spec_helper'

require 'method_profiler'
describe CRDT::Array do
  # before(:all) { @profiler = MethodProfiler.observe(described_class) }
  # after(:all) { 
  #   puts @profiler.report.sort_by(:total_time).order(:descending)
  #   puts @profiler.report.sort_by(:total_calls).order(:descending)
  # }

  include AtomSpecHelper

  CONVERGANCE_COUNT = 10

  def self.converges(test, atoms, *operations)
    CONVERGANCE_COUNT.times do |iteration|
      it "#{test} ( converges iter-#{iteration}/#{CONVERGANCE_COUNT} )" do
        subject1 = CRDT::Array.new
        subject2 = CRDT::Array.new

        subject1.observe(subject2)
        subject2.observe(subject1)

        EM.run do
          instance_exec(&atoms).each_with_index do |atom, index|
            operation = operations.shuffle.first
            subject = [subject1, subject2].shuffle.first
            method = subject.method(operation)

            # puts [operation, atom].inspect
            # puts operation.inspect
            case operation
            when :push, :unshift
              subject.send(operation, CRDT::Vector.new(atom, index))
            else
              subject.send(operation)
            end
          end

          # puts "SUBJECT 1"
          # subject1.table
          # puts "SUBJECT 2"
          # subject2.table

          EM.stop_when_done          
        end

        subject1.should == subject2
      end      
    end
  end
  
  subject { CRDT::Array.new }

  it("is an atom") { CRDT::Array.should < CRDT::Atom }

  it "does not respond to add and remove" do
    subject.should_not respond_to(:add)
    subject.should_not respond_to(:remove)
  end

  it "pushes atoms" do
    subject.push CRDT::Vector.new atom, 1
    subject.push CRDT::Vector.new atom1, 2
    subject.push CRDT::Vector.new atom2, 3
    subject.should == [atom, atom1, atom2]
  end

  converges("pushing atoms", ->{[atom, atom1, atom2, atom1, atom]}, :push)
  converges("pushing/popping atoms", ->{[atom, atom1, atom2, atom1, atom, atom1, atom]}, :push, :pop)
  converges("shift/unshift atoms", ->{[atom, atom1, atom2, atom1, atom, atom1, atom]}, :shift, :unshift)
  converges("crazy array ops", ->{
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
     atom, atom1, atom2, atom1, atom, atom1, atom,
     atom, atom1, atom2, atom1, atom, atom1, atom,
     atom, atom1, atom2, atom1, atom, atom1, atom,
     atom, atom1, atom2, atom1, atom, atom1, atom,
     atom, atom1, atom2, atom1, atom, atom1, atom]
  }, :push, :pop, :shift, :unshift)

  it "members show up if added and removed" do
    subject.push CRDT::Vector.new(atom, 0)
    subject.pop
    subject.push CRDT::Vector.new(atom, 2)
    subject.should == [atom]
  end
end

