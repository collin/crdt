window.Between = {}
chars = '!0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~'
Between.chars = chars
Between.high = chars[chars.length - 1]
Between.low = chars[0]


Between.generate = (left, right) ->
  _string = ''
  index = 0

  loop
    _left = chars.indexOf( left[index] ) || 0
    _right = chars.indexOf( right[index] ) || chars.length - 1

    index++

    charIndex = if _left + 1 < _right
        Math.round((_left + _right) / 2)
      else
        _left

    char = chars[charIndex]
    _string += char

    if left < _string && _string < right && char != Between.low
      return _string

Between.rand = (length) ->
  string = ""
  while length > 0
    length--
    string += Between.chars[ Math.round(Math.random() * Between.chars.length) ]
  string