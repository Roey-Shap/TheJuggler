// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_set_object_check_function(object, check_function, result_function){
	object.check_function = check_function;
	object.result_function = result_function;
	
	cutscene_end_action();
}