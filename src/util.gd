class_name Util

static func filename(path: String) -> String:
	var parts = path.split('/');
	return parts[parts.size() - 1]