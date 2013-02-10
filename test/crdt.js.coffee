module "CRDT"
test "flatten", ->
  deepEqual CRDT.flatten([1, [2, [3]]]), [1, 2, 3]
  deepEqual CRDT.flatten([[{}]]), [{}]