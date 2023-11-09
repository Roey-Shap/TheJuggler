///@description scr_cutscene_wait

function cutscene_simulate_input(frames, hinput, vinput) {

	timer += 1;
	global.cutscene_hinput = hinput;
	global.cutscene_vinput = vinput;

	if timer >= frames {
		global.cutscene_hinput = 0;
		global.cutscene_vinput = 0;
		timer = 0;
		cutscene_end_action();
	}
}
