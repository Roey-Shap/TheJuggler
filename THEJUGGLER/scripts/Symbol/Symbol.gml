enum symbol_type {
	number,
	shape,
	color,
	
	LAST
}

enum symbol_shape {
	square,
	triangle,
	diamond,
	row,
	column
}

enum symbol_color {
	red,
	blue,
	yellow,
	purple,
	orange,
	green,
	brown
}

function Symbol(_symbol_value, _symbol_type) constructor {
	value = _symbol_value;
	type = _symbol_type;
	
	static to_string = function() {
		switch (type) {
			case symbol_type.number:
				return string(value);
				break;
				
			case symbol_type.shape:
				return "shape";
				break;
				
			case symbol_type.color:
				return "color";
				break;
		}
	}
}