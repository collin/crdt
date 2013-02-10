module "CRDT.Array"

CONVERGANCE_COUNT = 10

# converges = (test, atoms, operations...) ->
#   for iteration in [0..CONVERGANCE_COUNT]
#     test "#{test} ( converges iter-#{iteration + 1}/#{CONVERGANCE_COUNT}", ->
#       subject1 = CRDT.Array.new
#       subject2 = CRDT.Array.new

#       subject1.observe subject2
#       subject2.observe subject1


atom = new CRDT.Atom "atom1"
atom2 = new CRDT.Atom "atom2"
atom3 = new CRDT.Atom "atom3"

test "is an Atom", ->
  ok CRDT.Array.__super__ instanceof CRDT.Atom

test "does not respond to add/remove", ->
  ok not(CRDT.Array::add)
  ok not(CRDT.Array::remove)

subject = new CRDT.Array
test "pushes atoms", ->
  subject.push new CRDT.Vector atom, 1
  subject.push new CRDT.Vector atom2, 2
  subject.push new CRDT.Vector atom3, 3
  deepEqual subject.atoms(), [atom, atom2, atom3]

subject = new CRDT.Array
test "members show up if added and removed", ->
  subject.push new CRDT.Vector(atom, 0)
  subject.pop()
  subject.push new CRDT.Vector(atom, 2)
  deepEqual subject.atoms(), [atom]

# TODO: test convergence
