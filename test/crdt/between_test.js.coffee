module "Between"

assertBetween = -> (low, high, depth)
  generated = Between.generate(low, high)

  ok low < b < high

  return if depth is 0
  
  if Math.round(Math.random() * 2) is 0 
    assertBetween(low, generated, depth - 1, between)
  else
    assertBetween(generated, high, depth - 1, between)
    
test "generates strings between strings", ->
  assert_between "!", "~", 200
