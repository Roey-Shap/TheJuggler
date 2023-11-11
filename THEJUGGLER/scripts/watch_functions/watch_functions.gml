function store_init_watch_params() {
	xscale_base = image_xscale;
	yscale_base = image_yscale;
	x_init = x;
	y_init = y;
	watch_center_original_delta = get_pos(id).sub(get_pos(o_watch_base));
	
	scale_factor = 1;
}