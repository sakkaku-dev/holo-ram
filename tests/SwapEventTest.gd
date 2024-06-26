extends GutTest

func test_swap():
	var data = DataSnapshot.new([
		[0, 1],
		[0, 0],
	])
	var ev = SwapEvent.new(Vector2(1, 0), Vector2(0, 1))
	ev.do(data)
	assert_eq_deep(data.data, [
		[0, 0],
		[1, 0],
	])

func test_undo_swap():
	var data = DataSnapshot.new([
		[0, 1],
		[0, 2]
	])

	var ev = SwapEvent.new(Vector2(1, 0), Vector2(1, 1))
	ev.do(data)
	assert_eq_deep(data.data, [
		[0, 2],
		[0, 1],
	])

	ev.undo(data)
	assert_eq_deep(data.data, [
		[0, 1],
		[0, 2],
	])

func test_affected():
	var ev = SwapEvent.new(Vector2(1, 0), Vector2(0, 1))

	var actual = ev.get_affected()
	assert_eq(actual.size(), 2)
	assert_has(actual, Vector2(1, 0))
	assert_has(actual, Vector2(0, 1))
