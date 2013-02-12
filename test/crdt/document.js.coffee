module "CRDT.Document"
test "opens a subdoc", ->
  doc = new CRDT.Document
  sub = doc.at "path"
  deepEqual sub.path, ["path"]

test "set text value", ->
  doc = new CRDT.Document
  doc.at('key').set "KEY"
  deepEqual doc.at('key').get(), "KEY"

test "set numeric value", ->
  doc = new CRDT.Document
  doc.at('key').set 44
  deepEqual doc.at('key').get(), 44

test "set bolean value", ->
  doc = new CRDT.Document
  doc.at('key').set true
  deepEqual doc.at('key').get(), true

test "set null value", ->
  doc = new CRDT.Document
  doc.at('key').set null
  deepEqual doc.at('key').get(), null

test "set undefined value", ->
  doc = new CRDT.Document
  doc.at('key').set undefined
  deepEqual doc.at('key').get(), undefined

test "overwrite value", ->
  doc = new CRDT.Document
  doc.at('key').set "kitty"
  deepEqual doc.at('key').get(), "kitty"
  doc.at('key').set "doggy"
  deepEqual doc.at('key').get(), "doggy"

test "set an array value", ->
  doc = new CRDT.Document
  doc.at('list').set []
  deepEqual doc.at('list').get(), []

test "set an array value with data inside", ->
  doc = new CRDT.Document
  doc.at('list').set ["item"]
  deepEqual doc.at('list').get(), ["item"]

test "set an array with an array inside", ->
  doc = new CRDT.Document
  doc.at('list').set ["item", ["inception?"]]
  deepEqual doc.at('list').get(), ["item", ["inception?"]]

test "get at an array index", ->
  doc = new CRDT.Document
  doc.at('list').set [0, 1, 2, 3, 4]
  deepEqual doc.at('list', 3).get(), 3

test "push onto an array", ->
  doc = new CRDT.Document
  doc.at('list').set []
  doc.at('list').push 33
  deepEqual doc.at('list').get(), [33]

test "remove from array", ->
  doc = new CRDT.Document
  doc.at('list').set [0, 1, 2, 3, 4]
  doc.at('list', 3).remove()
  deepEqual doc.at('list').get(), [0, 1, 2, 4]

test "set a Hash value", ->
  doc = new CRDT.Document
  doc.at('o').set {}
  deepEqual doc.at('o').get(), {}

complex =
  key: "value"
  list: ["some", ["lists"]]
  crazy: [
    "a crazy set of"
    ["values", {with: ["so much", [{going:"on"}]]}]
  ]
test "set a complex hash value", ->
  doc = new CRDT.Document
  doc.at('o').set complex
  deepEqual doc.at('o').get(), complex

test "read a complex hash value", ->
  doc = new CRDT.Document
  doc.at('o').set complex
  subdoc = doc.at('o', 'crazy', 1, 1, 'with', 1, 0)
  deepEqual subdoc.get(), {going:"on"}
  deepEqual doc.at('o', 'crazy', 1, 1).get(), {with: ["so much", [{going:"on"}]]}

# test "at", ->
#   doc = new CRDT.Document

module "CRDT.SubDoc", ->
test "opens a subdoc", ->
  doc = new CRDT.Document
  sub = doc.at("path").at(22)
  deepEqual sub.path, ["path", 22]


