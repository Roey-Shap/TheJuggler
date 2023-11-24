//var t = 0.075;
//draw_scale.x = lerp(draw_scale.y, 1, t);
//draw_scale.y = lerp(draw_scale.y, 1, t);

hit_flash_timer.tick();

if !hit_flash_timer.is_done() {
	hit_flash_interval_timer.tick();
	if hit_flash_interval_timer.is_done() {
		hit_flash_interval_timer.start();
		if fog_color == -1 {
			fog_color = global.c_hurt;
		} else {
			fog_color = -1;
		}
	}
}