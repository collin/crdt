module "CRDT.Document"
test "opens a subdoc", ->
  doc = new CRDT.Document
  sub = doc.at "path"
  deepEqual sub.path, ["path"]

module "CRDT.SubDoc", ->
test "opens a subdoc", ->
  doc = new CRDT.Document
  sub = doc.at("path").at(22)
  deepEqual sub.path, ["path", 22]
