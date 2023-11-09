///@description script_execute_alt
///@arg ind
///@arg [arg1,arg2,...]
function cutscene_destroy_instance(obj) {
	if is_string(obj) {
		obj = cs_get_speaker_helper(obj);
	}
	
	instance_destroy(obj);
	cutscene_end_action();
}
