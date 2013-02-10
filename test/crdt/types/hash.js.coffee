module "CRDT.Hash"
atom = new CRDT.Atom "atom1"
atom2 = new CRDT.Atom "atom2"


test "is an atom", ->
  ok CRDT.Hash.__super__ instanceof CRDT.Atom

test "does not respond to add and remove", ->
  ok not(CRDT.Hash::add)
  ok not(CRDT.Hash::remove)

subject = new CRDT.Hash
test "inserts/reads items", ->
  subject.set "key", new CRDT.Vector(atom, 0)
  deepEqual subject.get("key").atom.value(), atom

subject = new CRDT.Hash
test "deletes items", ->
  subject.set "key", new CRDT.Vector(atom, 0)
  subject.delete "key"
  ok not(subject.get("key"))

subject = new CRDT.Hash
test "inserts win", ->
  subject.set "key", new CRDT.Vector(atom, 0)
  subject.delete "key", 0
  deepEqual subject.get("key").atom.value(), atom

subject = new CRDT.Hash
test "overwrites member values", ->
  subject.set "key", new CRDT.Vector(atom, 0)
  subject.set "key", new CRDT.Vector(atom2, 1)
  deepEqual subject.get("key").atom.value(), atom2

# TODO: test convergeance