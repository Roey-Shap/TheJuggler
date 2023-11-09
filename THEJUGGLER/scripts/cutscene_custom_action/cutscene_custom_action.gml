// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_custom_action(custom_function){
	if (custom_function != undefined and custom_function != -1) {
		custom_function();
	}
	
	cutscene_end_action();
}