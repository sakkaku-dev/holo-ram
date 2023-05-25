extends GutTest

var spin_params = [
	[
		Vector2(1, 1), [
			[0, 1, 0],
			[0, 0, 0],
			[0, 2, 0],
		], [
			[0, 0, 0],
			[1, 0, 2],
			[0, 0, 0],
		]
	],
	[
		Vector2(1, 1), [
			[0, 1, 0],
			[0, 0, 2],
			[0, 0, 0],
		], [
			[0, 2, 0],
			[1, 0, 0],
			[0, 0, 0],
		]
	],
	[
		Vector2(1, 1), [
			[0, 1, 0],
			[4, 0, 2],
			[0, 3, 0],
		], [
			[0, 2, 0],
			[1, 0, 3],
			[0, 4, 0],
		]
	],
	[
		Vector2(1, 0), [
			[1, 0, 2],
			[0, 0, 0],
		], [
			[2, 0, 0],
			[0, 1, 0],
		]
	]
]

func test_spin(params=use_parameters(spin_params)):
	var origin: Vector2 = params[0]
	var d: Array = params[1]
	var expected_data: Array = params[2]
	
	var data = DataSnapshot.new(d)
	var spin = SpinEvent.new(origin)
	spin.do(data)
	assert_eq_deep(data.data, expected_data)
