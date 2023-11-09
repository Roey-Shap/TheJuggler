///@description scr_cutscene_wait

function cs_wait(frames) {

	timer += 1;

	if timer >= frames {
		timer = 0;
		cutscene_end_action();
	}
}
