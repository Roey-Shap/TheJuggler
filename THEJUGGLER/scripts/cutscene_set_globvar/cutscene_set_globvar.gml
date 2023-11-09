// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_set_globvar(index, value){
	if is_string(index) {
		variable_global_set(index, value);
	} else {
		global.dummy_vars[index] = value;
	}
	
	cutscene_end_action();
}