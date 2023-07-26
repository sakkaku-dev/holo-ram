extends GutTest

func test_match():
	var data = DataSnapshot.new([
		[null, 1],
		[null, 1]
	])
	var ev = MatchEvent.new(Vector2(1, 0), Vector2(1, 1))
	watch_signals(ev)

	ev.do(data)

	assert_signal_emitted_with_parameters(ev, 'matched', [1])
	assert_eq_deep(data.data, [
		[null, null],
		[null, null],
	])

func test_not_match():
	var data = DataSnapshot.new([
		[null, 1],
		[null, 2]
	])
	var ev = MatchEvent.new(Vector2(1, 0), Vector2(1, 1))
	watch_signals(ev)

	ev.do(data)

	assert_signal_not_emitted(ev, 'matched')
	assert_eq_deep(data.data, [
		[null, 1],
		[null, 2],
	])

func test_affected():
	var ev = MatchEvent.new(Vector2(1, 0), Vector2(1, 1))

	var actual = ev.get_affected()
	assert_eq(actual.size(), 2)
	assert_has(actual, Vector2(1, 0))
	assert_has(actual, Vector2(1, 1))