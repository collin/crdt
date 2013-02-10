# Simple dictionary type class. Allows for arbirtary object keys.
# (like ruby)
class CRDT.Map
  HASH_KEY = "crdt:4827" # Property unlikely to conflict

  constructor: ->
    @id = 0
    @map = {}
    @keyMap = {}

  get: (key) ->
    @map[key[HASH_KEY]]

  set: (key, value) ->
    hashKey = key[HASH_KEY] ||= @id++
    @keyMap[hashKey] ||= key
    @map[hashKey] = value

  forEach: (iterator) ->
    iterator(@keyMap[hashKey], value) for hashKey, value of @map
