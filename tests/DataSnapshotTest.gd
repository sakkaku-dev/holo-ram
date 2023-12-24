extends UnitTest

func test_random_card():
	var data = DataSnapshot.new([
		[0, 1],
		[2, 3]
	])

	var cards: Array[Vector2] = []
	cards.append(data.random_card(cards))
	cards.append(data.random_card(cards))
	cards.append(data.random_card(cards))
	cards.append(data.random_card(cards))

	assert_contains_exact(cards, [
		Vector2(0, 0),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(1, 1)
	])

func test_random_free():
	var data = DataSnapshot.new([
		[null, 1],
		[null, null]
	])

	var free = []

	for _i in range(50):
		free.append(data.random_free())
	
	assert_does_not_have(free, Vector2(1, 0))

func test_set_get_has_card():
	var data = DataSnapshot.new([
		[1, null],
		[null, null]
	])

	assert_true(data.has_data(Vector2(0, 0)))
	assert_false(data.has_data(Vector2(1, 0)))

	data.set_card(Vector2(1, 0), 2)

	assert_true(data.has_data(Vector2(1, 0)))
	assert_eq(data.get_card(Vector2(0, 0)), 1)
	assert_eq(data.get_card(Vector2(1, 0)), 2)
	assert_null(data.get_card(Vector2(1, 1)))

func test_card_count():
	var data = DataSnapshot.new([
		[1, null],
		[null, 2]
	])

	assert_eq(data.get_card_count(), 2)

func test_clone():
	var data = DataSnapshot.new([
		[null, null],
		[null, null]
	])

	var cloned = data.clone()
	cloned.set_card(Vector2(0, 0), 1)

	assert_eq(data.data, [
		[null, null],
		[null, null]
	])

func test_get_neighbors():
	var data = DataSnapshot.new([
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	])

	assert_contains_exact(data.get_neighbors(Vector2(1, 1)), [
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(2, 1),
		Vector2(1, 2),
	])

	assert_contains_exact(data.get_neighbors(Vector2(0, 0)), [
		Vector2(0, 1),
		Vector2(1, 0),
	])

	assert_contains_exact(data.get_neighbors(Vector2(2, 1)), [
		Vector2(2, 0),
		Vector2(1, 1),
		Vector2(2, 2),
	])

	assert_contains_exact(data.get_neighbors(Vector2(1, 0), true), [
		Vector2(0, 0),
		Vector2(2, 0),
		Vector2(1, 1),
		Vector2(2, 1),
		Vector2(0, 1),
	])

func test_get_closest_card_coord():
	var data = DataSnapshot.new([
		[0, 0, 0],
		[0, null, 0],
		[0, 0, 0]
	])
	
	assert_eq(data.get_closest_card_coord(Vector2(0, 0), Vector2.DOWN), Vector2(0, 0))
	assert_eq(data.get_closest_card_coord(Vector2(1, 0), Vector2.RIGHT), Vector2(1, 0))
	
	assert_eq(data.get_closest_card_coord(Vector2(1, 1), Vector2.DOWN), Vector2(1, 2))
	assert_eq(data.get_closest_card_coord(Vector2(1, 1), Vector2.LEFT), Vector2(0, 1))
