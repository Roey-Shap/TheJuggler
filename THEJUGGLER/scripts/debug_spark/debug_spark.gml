function debug_spark(_x, _y, color=c_lime){
	effect_create_above(ef_ring, _x, _y, 10, color);
}

function debug_spark_at_cell(pos) {
	var cam_pos = get_battle_pos_camera(pos.x , pos.y);
	debug_spark(cam_pos.x, cam_pos.y);
}