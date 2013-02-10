window.Between = {}
Between.chars = '!0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~'
Between.low = chars[0]
Between.high = chars[-2]

Between.generate = (left, right) ->
  string = ''
  index = 0

  loop
    _left = chars.indexOf left[index]
    _right = chars.indexOf right[index]

    _a = 0 if _a is -1
    _b = chars.length - 1 if _b is -1