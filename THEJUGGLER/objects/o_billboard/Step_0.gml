if !activated {
	if collision_circle(x, y, 80, o_player, false, false) {
		activated = true;
		alpha_timer.start();
	}
} else {
	image_alpha = alpha_timer.get_percent_done();
}