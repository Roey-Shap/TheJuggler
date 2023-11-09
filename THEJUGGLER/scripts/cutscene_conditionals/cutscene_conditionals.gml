///@description scr_cutscene_wait

function cutscene_check_for_input(input_names, results) {
	o_manager.input_wait_input_names = input_names;
	o_manager.input_wait_results = results;
	o_manager.input_wait_do_check = true;
	cutscene_end_action();
}

function cutscene_continue_when(criterion, response=-1) {
	if criterion() {
		if response != -1 {
			response();
		}
		
		cutscene_end_action();
	}
}