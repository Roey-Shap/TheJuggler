
///@description returns a new array which is the concatenation of two input arrays
function concat_arrays(arr1, arr2) {
	var len1 = array_length(arr1);
	var len2 = array_length(arr2);
	var result = array_create(len1 + len2);
	array_copy(result, 0, arr1, 0, array_length(arr1));
	array_copy(result, len1, arr2, 0, array_length(arr2));
	
	return result;
}

function copy_array(arr) {
	return concat_arrays(arr, []);
}

function isIn(item, array) {
	return array_find(array, item) != -1; 
}

function findStructWithValue(variable_name, value, array) {
	var len = array_length(array);
	for (var i = 0; i < len; i++) {
		if variable_struct_get(array[i], variable_name) == value {
			return array[i];
		}
	}
	
	return -1;
}

function array_is_subset(subarray, array) {
	return array_equals_unordered(array_intersection(subarray, array), subarray);
	//var subarray_size = array_length(subarray);
	//var superarray_size = array_length(array);
	//var superarray_copy = concat_arrays([], array);
	//for (var i = 0; i < subarray_size; i++) {
	//	var index_in_superarray = array_find(superarray_copy, subarray[i]);
	//	if index_in_superarray == -1 {
	//		return false;
	//	} else {
	//		array_delete(superarray_copy, index_in_superarray, 1);
	//	}
	//}
	
	//return 
}

function array_find(array, item) {
	var len = array_length(array);
	for (var i = 0; i < len; i++) {
		if array[i] == item return i;
	}
	return -1;
}

function array_remove(array, item) {
	var index = array_find(array, item);
	if index != -1 {
		array = array_delete(array, index, 1);
	}
	return array;
}

function array_contains_ancestor_of(obj_ind, array) {
	var len = array_length(array);
	for (var i = 0; i < len; i++) {
		if object_is_ancestor_ext(obj_ind, array[i]) {
			return true;
		}
	}
	return false;
}

function with_each(objs, func) {
	var num_objs = array_length(objs);
	for (var i = 0; i < num_objs; i++) {
		with (objs[i]) {
			func();
		}
	}
}

//function array_intersection(arr1, arr2) {
//	var len1 = array_length(arr1);
//	var len2 = array_length(arr2);
//	var intersection = [];
//	if len1 > len2 {
//		var t = arr1;
//		arr1 = arr2;
//		arr2 = t;
//	}
	
//	for (var i = 0; i < min(len1, len2); i++) {
//		if isIn(arr1[i], arr2) {
//			array_push(intersection, arr1[i]);
//		}
//	}
	
//	return intersection;
//}

//function array_filter(arr, f) {
//	var len = array_length(arr);
//	var filtered = array_create(len);
//	var num_passed = 0;
//	for (var i = 0; i < len; i++) {
//		if f(arr[i]) {
//			filtered[num_passed] = arr[i];
//			num_passed++;
//		}
//	}
	
//	array_resize(filtered, num_passed);
//	return filtered;
//}

//function foreach(array, f) {
//	var l = array_length(array);
//	for (var i = 0; i < l; i++) {
//		f(array[i], i);
//	}
//}

//function foreach_list(list, f) {
//	var l = ds_list_size(list);
//	for (var i = 0; i < l; i++) {
//		f(list[| i], i);
//	}
//}

//function foreach_struct(struct, f) {
//	var var_names = variable_struct_get_names(struct);
//	foreach (var_names, function(name) {
//		f(variable_struct_get(struct, name));
//	});
//}

//function array_map(arr, f) {
//	var l = array_length(arr);
//	var new_arr = array_create(l);
//	for (var i = 0; i < l; i++) {
//		new_arr[i] = f(arr[i]);
//	}
	
//	return new_arr;
//}

//function array_equals(arr1, arr2) {
//	var l1 = array_length(arr1);
//	var l2 = array_length(arr2);
//	if l1 != l2 {
//		return false;
//	}
	
//	for (var i = 0; i < l1; i++) {
//		if arr1[i] != arr2[i] {
//			return false;
//		}
//	}
	
//	return true;
//}

function array_equals_unordered(a1, a2) {
	var len_int = array_length(array_intersection(a1, a2))
	var len1 = array_length(a1);
	var len2 = array_length(a2);
	return len_int == len1 and len1 == len2;
}

///@description return a single element of the array, chosen at random
function array_pick_random(array, remove_from_array=false) {
	var length = array_length(array);
	if length == 0 {
		return undefined;
	}
	
	var index = irandom(length-1);
	var val = array[index];
	if remove_from_array {
		array_delete(array, index, 1);
	}
	
	return val;
}

function array_pad(array, item, amount) {
	repeat(amount){
		array_push(array, item);
	}
	return array;
}


function counts_to_probs(array) {
	var len = array_length(array);
	var clone = concat_arrays(array, []);
	var sum = 0;
	for (var i = 0; i < len; i++) {
		sum += array[i];
		clone[i] = sum;
	}
	
	for (var i = 0; i < len; i++) {
		clone[i] /= sum;
	}
	
	return clone;
}

///@description picks an index at random, using the counts as weights
function array_pick_monte_carlo(probs_array) {
	var len = array_length(probs_array);
	var random_roll = irandom(1);
	for (var i = 0; i < len; i++) {
		if random_roll <= probs_array[i] {
			return i;
		}
	}
	
	db_show("array_pick_monte_carlo: You should never get here: " + string(probs_array));
}

function array_fill_range(n1, n2) {
	var size = n2 - n1 + 1;
	var arr = array_create(size);
	for (var i = 0; i < size; i++) {
		arr[i] = n1 + i;
	}
	
	return arr;
}