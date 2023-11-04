

function sample_curve(curve_id, sample_value, new_min = 0, new_max = 1) {
	var channel = animcurve_get_channel(curve_id, 0);
	var curve_val = animcurve_channel_evaluate(channel, sample_value);
	
	return map(0, 1, curve_val, new_min, new_max);
}



function get_grid_dim(grid) {
	var w = ds_grid_width(grid);
	var h = ds_grid_height(grid);
	return [w, h];
}

function with_grid(grid, f) {
	var w = ds_grid_width(grid);
	var h = ds_grid_height(grid);
	
	for (var i = 0; i < w; i++) {
		for (var j = 0; j < h; j++) {
			f(grid[# i, j]);
		}
	}
}

function object_is_ancestor_ext(child_index, parent_index) {
	return child_index == parent_index or object_is_ancestor(child_index, parent_index);
}

function get_name(instance) {
	if instance == noone return "Noone";
	return object_get_name(instance.object_index);
}

function only_specified_cellobjs_exist(arr) {
	with (o_cellobj_character_parent) {
		if !isIn(object_index, arr) {
			return false;
		}
	}
	
	return true;
}