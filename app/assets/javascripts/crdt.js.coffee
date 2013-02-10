# WIRE FORMAT
# OKAY WE'RE GOING OVER THE WIRE!
@CRDT =
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
