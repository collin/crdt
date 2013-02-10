{include} = CRDT

module "CRDT.Set"
test "is an Atom", ->
  equal CRDT.Set.__super__.constructor, CRDT.Atom

test "adding atoms", ->
  subject = new CRDT.Set
  atom = new CRDT.Atom "atom1"
  subject.add new CRDT.Vector atom, 1
  ok CRDT.include(subject.atoms(), atom), "subject atoms include atom1"

test "removes atoms", ->
  subject = new CRDT.Set
  atom = new CRDT.Atom "atom1"
  subject.add new CRDT.Vector(atom, 1)
  subject.remove new CRDT.Vector(atom, 2)
  ok not(CRDT.include(subject.atoms(), atom)), "atom removal commutes"

test "ties go to addition", ->
  subject = new CRDT.Set
  atom = new CRDT.Atom "atom1"
  subject.add new CRDT.Vector(atom, 1)
  subject.remove new CRDT.Vector(atom, 1)
  ok CRDT.include(subject.atoms(), atom), "subject atoms include atom1"

test "atoms are enumerable", ->
  subject = new CRDT.Set
  atom = new CRDT.Atom "atom1"
  atom2 = new CRDT.Atom "atom2"
  subject.add new CRDT.Vector(atom, 1)
  subject.add new CRDT.Vector(atom2, 1)
  subject.remove new CRDT.Vector(atom, 2)
  deepEqual subject.atoms(), [atom2], "correct atoms are in set"

