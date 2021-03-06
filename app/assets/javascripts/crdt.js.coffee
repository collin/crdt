# WIRE FORMAT
# OKAY WE'RE GOING OVER THE WIRE!
window.CRDT =
  detect: (list, fn) ->
    for item in list
      return item if fn(item)

  equals: (list, other) ->
    return false unless list.length is other.length

    for item, index in list
      return false unless item.equals( other[index] )

  sort: (list) -> list.sort (item, other) -> item.compareTo(other)

  include: (list, item) ->
    for other in list
      return true if item.equals(other)

  max:  (list) -> Math.max.apply(null, list)
  
  last: (list) -> list[ list.length - 1]

  any: (list) -> list.length > 0

  flatten: (array, output=[]) ->
    output = []
    for item in array
      if item.constructor is Array
        Array::push.apply output, CRDT.flatten(item)
      else
        output.push(item)
    output
