enum symbol_type {
	number,
	shape,
	color,
	
	zero,
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	nine,
	
	square,
	triangle,
	diamond,
	row,
	column,
	
	white,
	red,
	blue,
	yellow,
	purple,
	orange,
	green,
	brown,
	
	partially_formed,
	
	LAST
}

#region
//enum symbol_shape {
//	square,
//	triangle,
//	diamond,
//	row,
//	column
//}

//enum symbol_color {
//	red,
//	blue,
//	yellow,
//	purple,
//	orange,
//	green,
//	brown
//}
#endregion

function Symbol(_symbol_value) constructor {
	value = _symbol_value;
	literal_value = value;
	type = symbol_type.LAST;
	sprite = get_symbol_sprite_from_value(value);
	sprite_name = sfmt("[%]", sprite_get_name(sprite));
	if value >= symbol_type.zero and value <= symbol_type.nine {
		type = symbol_type.number;
		literal_value = value - symbol_type.zero;
		sprite_name = seven_digit(literal_value);
	} else if value >= symbol_type.square and value <= symbol_type.column {
		type = symbol_type.shape;
	} else if value >= symbol_type.white and value <= symbol_type.brown {
		type = symbol_type.color;
	}
	
	static to_string = function() {
		return sprite_name;
	}
}

function get_symbol_sprite_from_value(_sprite_value) {
	switch (_sprite_value) {
		case symbol_type.zero:		return spr_symbol_zero;
		case symbol_type.one:		return spr_symbol_one;
		case symbol_type.two:		return spr_symbol_two;
		case symbol_type.three:		return spr_symbol_three;
		case symbol_type.four:		return spr_symbol_four;
		case symbol_type.five:		return spr_symbol_five;
		case symbol_type.six:		return spr_symbol_six;
		case symbol_type.seven:		return spr_symbol_seven;
		case symbol_type.eight:		return spr_symbol_eight;
		case symbol_type.nine:		return spr_symbol_nine;
		
		case symbol_type.square:	return spr_symbol_square;
		case symbol_type.triangle:	return spr_symbol_triangle;
		case symbol_type.diamond:	return spr_symbol_diamond;
		case symbol_type.row:		return spr_symbol_row;
		case symbol_type.column:	return spr_symbol_column;
		
		//case symbol_type.white:
		//case symbol_type.red:
		//case symbol_type.blue:
		//case symbol_type.yellow:
		//case symbol_type.purple:
		//case symbol_type.orange:
		//case symbol_type.green:
		//case symbol_type.brown:
	}
}

