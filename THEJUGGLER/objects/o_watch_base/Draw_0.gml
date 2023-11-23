

with (o_button_parent) {
	if button_value > 10 {
		draw_self();
	}
}

gpu_set_tex_filter(true);
draw_self();
gpu_set_tex_filter(false);