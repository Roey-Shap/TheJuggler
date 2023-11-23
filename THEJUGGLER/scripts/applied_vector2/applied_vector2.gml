

function bbox_center(inst) {
	return new Vector2((inst.bbox_left + inst.bbox_right) / 2,
	                 (inst.bbox_top + inst.bbox_bottom) / 2);
}

function get_pos(instance) {
	return new Vector2(instance.x, instance.y);
}


function draw_to(vec1, vec2) {
	draw_line(vec1.x, vec1.y, vec2.x, vec2.y);
}

function draw_vertex_v2(vec) {
	draw_vertex(vec.x, vec.y);
}

function draw_rect_vec(upper_left, bottom_right, outline) {
	draw_rectangle(upper_left.x, upper_left.y, bottom_right.x, bottom_right.y, outline);
}

function draw_healthbar_vec(up_left, down_right, percent, backcol, mincol, maxcol, dir, showback, showborder) {
	draw_healthbar(up_left.x, up_left.y, down_right.x, down_right.y, percent * 100, backcol, mincol, maxcol, dir, showback, showborder);
}