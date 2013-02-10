{flatten} = CRDT
class CRDT.Document extends CRDT.Hash
  constructor: (@id, @distributor) ->

  at: (path...) ->
    new CRDT.SubDoc this, path

class CRDT.SubDoc  
  constructor: (@document, @path=[]) ->

  at: (path...) ->
    new CRDT.SubDoc @document, @path.concat(CRDT.flatten path)
