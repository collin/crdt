require 'spec_helper'

describe CRDT::Between do
  def assert_between(low, high, depth)
    generated = CRDT::Between.string(low, high)
    (generated > low).should be_true
    (generated < high).should be_true
    return if depth == 0
    if rand(2) == 1
      assert_between(low, generated, depth - 1)
    else
      assert_between(generated, high, depth - 1)
    end
  end

  it "goes between ! and ~" do
    assert_between "!", "~", 200
  end
end