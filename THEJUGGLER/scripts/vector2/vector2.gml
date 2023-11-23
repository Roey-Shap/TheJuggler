
function Vector2(_x, _y) constructor {
	x = _x
	y = _y

	
	static add = function(vec2) {
		return new Vector2(x + vec2.x, y + vec2.y)
	}
	
	static sub = function(vec2) {
		return new Vector2(x - vec2.x, y - vec2.y)
	}
	
	static mult_add = function(vec2, scalar) {
		return add(vec2.multiply(scalar));
	}
	
	static add_x = function(_x) {
		return new Vector2(x + _x, y);
	}
	
	static add_y = function(_y) {
		return new Vector2(x, y + _y);
	}
	
	static iadd = function(vec2) {
		x += vec2.x;
		y += vec2.y;
		return self;
	}
	
	static isub = function(vec2) {
		x -= vec2.x;
		y -= vec2.y;
		return self;
	}
	
	static ifloor = function() {
		x = floor(x);
		y = floor(y);
		return self;
	}
	
	static lerp_to = function(vec, t) {
		return new Vector2(lerp(x, vec.x, t), lerp(y, vec.y, t));
	}
	
	static equals = function(vec) {
		return x == vec.x and y == vec.y;
	}
	
	static add_constant = function(constant) {
		return new Vector2(x + constant, y + constant)
	}	
	
	///@description multiply by a scalar
	static multiply = function(scalar) {
		return new Vector2(x * scalar, y * scalar)
	}

	static get_mag = function() {
		return point_distance(0, 0, x, y);
	}
	
	static get_dir = function() {
		return diangle_360_normalize(point_direction(0, 0, x, y));
	}
	
	static normalize = function() {
		return multiply(1/get_mag())
	}
	
	static copy = function() {
		return new Vector2(x, y)
	}
}

function vector_zero() {
	return (new Vector2(0, 0));
}
