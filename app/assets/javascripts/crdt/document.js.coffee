{flatten} = CRDT

isObject = (object) -> object is Object(object)
isString = (object) -> toString.call(object) is "[object String]"
isNumber = (object) -> toString.call(object) is "[object Number]"
isBoolean = (object) -> toString.call(object) is "[object Boolean]"
class CRDT.Document extends CRDT.Hash
  constructor: (@id, @distributor, @clock=0) ->
    super

  at: (path...) ->
    new CRDT.SubDoc this, path

  begetVector: (atom) -> 
    new CRDT.Vector atom, @clock++

class CRDT.SubDoc  
  constructor: (@document, @path=[]) ->

  at: (path...) ->
    new CRDT.SubDoc @document, @path.concat(CRDT.flatten path)

  get: ->
    @document.readPath(@path)

  set: (value, callback) ->
    [key, path...] = @path.slice(0).reverse()
    atom = @readPath( path.reverse()... )
    newAtom = @begetAtom(value)
    vector = @document.begetVector(newAtom)
    atom.set(key, vector)

  insert: (index, value, callback) ->

  del: (index, length, callback) ->

  remove: (callback) ->

  push: (value, callback) ->

  readPath: (path) -> @document.readPath(path)

  begetAtom: (value) ->
    if isString(value) || isNumber(value) || isBoolean(value) || (value is null) || (value is undefined)
      new CRDT.Atom value
