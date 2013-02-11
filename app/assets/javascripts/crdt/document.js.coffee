{flatten} = CRDT

isObject  = (object) -> object is Object(object)
isString  = (object) -> toString.call(object) is "[object String]"
isNumber  = (object) -> toString.call(object) is "[object Number]"
isBoolean = (object) -> toString.call(object) is "[object Boolean]"
isArray   = (object) -> toString.call(object) is "[object Array]"
class CRDT.Document extends CRDT.Hash
  constructor: (@id, @distributor, @clock=0) ->
    super

  at: (path...) ->
    new CRDT.SubDoc this, path

  begetClock: -> 
    new CRDT.Vector undefined, @clock++

class CRDT.SubDoc  
  constructor: (@document, @path=[]) ->

  at: (path...) ->
    new CRDT.SubDoc @document, @path.concat(CRDT.flatten path)

  get: ->
    @document.readPath(@path)

  set: (value, callback) ->
    [key, path...] = @path.slice(0).reverse()
    atom = @getAtom( path.reverse() )
    clock = @document.begetClock()
    vector = @begetVector(value, clock)
    atom.set(key, vector)

  insert: (index, value, callback) ->

  del: (index, length, callback) ->

  remove: (callback) ->
    [containerPath..., index] = @path
    container = @getAtom(containerPath)
    clock = @document.begetClock()
    if container instanceof CRDT.Array
      container.slice(index, 1, clock.clock)

  push: (value, callback) ->
    atom = @getAtom( @path )
    clock = @document.begetClock()
    vector = @begetVector(value, clock)
    atom.push(vector)

  getAtom: (path) -> @document.getAtom(path)

  begetVector: (value, clock) ->
    clock.child if isString(value) || isNumber(value) || isBoolean(value) || (value is null) || (value is undefined)
      new CRDT.Atom value
    else if isArray value
      atom = new CRDT.Array
      for item in value
        atom.push @begetVector(item, clock)
      atom
    else if isObject value
      atom = new CRDT.Hash
      console.log "WHAT", atom
      for key, _value of value
        atom.set key, @begetVector(_value, clock)
      atom