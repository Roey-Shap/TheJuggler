///@description scr_cutscene_wait

function cs_set_mouse_towards(inst) {

	var dist_to_inst = point_distance(mouse_x, mouse_y, inst.x, inst.y);
	var spd = 20;
	display_mouse_set(mouse_x + sign(inst.x - mouse_x) * spd, 
					  mouse_y + sign(inst.y - mouse_y) * spd);
	
	if dist_to_inst <= spd {
		cutscene_end_action();
	}
}
