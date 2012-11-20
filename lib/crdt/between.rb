module CRDT::Between
  CHARS = '!0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~'.freeze
  CHARRAY = CHARS.split(//).freeze
  HIGH = CHARRAY.last
  LOW = CHARRAY.first

  def self.string(left, right)
    _string = ""
    index = 0
    loop do
      _left = CHARRAY.index(left[index]) || 0
      _right = CHARRAY.index(right[index]) || CHARS.length - 1

      index += 1

      char = CHARS[
        if _left + 1 < _right
          ((_left + _right) / 2).round
        else
          _left
        end
      ]

      _string += char

      if left < _string && _string < right && char != LOW
        return _string
      end
    end
  end

  def self.rand(length)
    CHARRAY.shuffle[0, length] * ""
  end
end

  # SOME EXAMPLE STRINGS, IN ORDER
 
  # 0
  # 00001
  # 0001
  # 001
  # 001001
  # 00101
  # 0011
  # 0011001
  # 001100101
  # 00110011
  # 001101
  # 00111
  # 01  

  # if you never make a string that ends in the lowest char,
  # then it is always possible to make a string between two strings.
  # this is like how decimals never end in 0. 

  # example:

  # between('A', 'AB') 

  # ... 'AA' will sort between 'A' and 'AB' but then it is impossible
  # to make a string inbetween 'A' and 'AA'.
  # instead, return 'AAB', then there will be space.