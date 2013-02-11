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



# test "at", ->
#   doc = new CRDT.Document

module "CRDT.SubDoc", ->
test "opens a subdoc", ->
  doc = new CRDT.Document
  sub = doc.at("path").at(22)
  deepEqual sub.path, ["path", 22]


