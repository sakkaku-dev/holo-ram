extends UnitTest

func test_swap_in_order():
	var data = DataSnapshot.new([
		[0, 1, 2],
		[3, 4, 5]
	])

	var ev = SwapInOrderEvent.new([Vector2(0, 0), Vector2(1, 1), Vector2(2, 0)])
	ev.do(data)

	assert_eq_deep(data.data, [
		[2, 1, 4],
		[3, 0, 5]
	])

	ev.undo(data)
	assert_eq_deep(data.data, [
		[0, 1, 2],
		[3, 4, 5]
	])