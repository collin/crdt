module "Between"

assertBetween = (low, high, depth) ->
  generated = Between.generate(low, high)

  ok low < generated < high

  return if depth is 0
  
  if Math.round(Math.random() * 2) is 0 
    assertBetween(low, generated, depth - 1,)
  else
    assertBetween(generated, high, depth - 1)

test "generates strings between strings", ->
  assertBetween "!", "~", 200

test "generates random string", ->
  ok Between.rand(4).length is 4