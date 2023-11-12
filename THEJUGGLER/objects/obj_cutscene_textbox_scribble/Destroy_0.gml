/// @description Update Cutscene

with(o_cutscene){	
	cutscene_end_action(); //If the textbox has finished, end this scene action
	speaker_current = -1;
}

perform_yes_no_func();