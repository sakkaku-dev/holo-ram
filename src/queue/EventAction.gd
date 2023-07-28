class_name EventAction

enum {
	ACTION,
	USER
}

var type: int

func do(_data: DataSnapshot):
	pass

func undo(_data: DataSnapshot):
	pass

func get_affected() -> Array[Vector2]:
	return []
