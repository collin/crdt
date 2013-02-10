{include} = CRDT

module "CRDT.Set"
test "is an Atom", ->
  ok CRDT.Set.__super__.constructor is CRDT.Atom

commute = (name, operations..., _test) ->
  all = permutations(operations)
  for permutation, index in all
    do (permutation, index) ->
      test "#{name} ( permutation #{index + 1}/#{all.length} )", ->
        operation() for operation in permutation
        _test()

atom = new CRDT.Atom "atom1"
atom2 = new CRDT.Atom "atom2"

subject = new CRDT.Set
commute "adding atoms",
  (-> subject.add new CRDT.Vector atom, 1)
  (-> ok CRDT.include( subject.atoms(), atom), "subject atoms include atom1")

subject = new CRDT.Set
commute "removes atoms",
  (-> subject.add new CRDT.Vector(atom, 1))
  (-> subject.remove new CRDT.Vector(atom, 2))
  (-> ok not(CRDT.include(subject.atoms(), atom)), "atom removal commutes")

subject = new CRDT.Set
commute "ties go to addition",
  (-> subject.add new CRDT.Vector(atom, 1))
  (-> subject.remove new CRDT.Vector(atom, 1))
  (-> ok CRDT.include( subject.atoms(), atom), "subject atoms include atom1")

subject = new CRDT.Set
commute "atoms are enumerable",
  (-> subject.add new CRDT.Vector(atom, 1))
  (-> subject.add new CRDT.Vector(atom2, 1))
  (-> subject.remove new CRDT.Vector(atom, 2))
  (-> deepEqual subject.atoms(), [atom2], "correct atoms are in set")

