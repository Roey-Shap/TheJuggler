
// linearly maps from one range to another
function map(oldmin, oldmax, value, newmin, newmax) {
  return ((value-oldmin) / (oldmax-oldmin) * (newmax-newmin) + newmin);
}

// from https://www.reddit.com/r/gamemaker/comments/6s2wni/arithmetic_wrap/
// Returns the value wrapped to the range [min, max] (min and max can be swapped).
// Calls floor() on reals, but GML's modulo is doing something weird and original_wrap just hangs indefinitely on some values anyways so oh well.
function wrap(_value, _min_, _max_) {
	var value = floor(_value);
	var _min = floor(min(_min_, _max_));
	var _max = floor(max(_min_, _max_));
	var range = _max - _min + 1; // + 1 is because max bound is inclusive

	return (((value - _min) % range) + range) % range + _min;
}

// unconditional one from https://stackoverflow.com/questions/5385024/mod-in-java-produces-negative-numbers
// found it in a second - could've figured it out though :/
function neg_mod(value, mod_value) {
	return (((value % mod_value) + mod_value) % mod_value)
}


function round_to(value, snap_value) {
	return round(value / snap_value) * snap_value;
}

function floor_to(value, snap_value) {
	return floor(value / snap_value) * snap_value;
}

function ceil_to(value, snap_value) {
	return ceil(value / snap_value) * snap_value;
}

