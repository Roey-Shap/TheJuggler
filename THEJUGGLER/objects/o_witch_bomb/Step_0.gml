
vspd = min(vspd + grav, vspd_max);

x += hspd;
y += vspd;

image_angle += 2;

manage_collision();

if !warning_timer.have_started and abs(y_limit - y) <= CAM_H * 1 {
	warning_timer.start();
}

if on_period(0.2) {
	var fx = new FadeFX(x, y, sprite_index, -1, 0, get_frames(0.1));
	fx_setup_screen_layer(fx);
	fx.image_blend = c_black;
}

if !warning_timer.is_done() and warning_timer.have_started and warnings_left > 0 {
	if round(warning_timer.get_count_seconds() * 100) % 25 == 0 {
		warnings_left -= 1;
		var snd = play_pitch_range(snd_watch_beep_3, 0.25, 0.25);
		var snd2 = play_pitch_range(snd_watch_beep_3, 0.4, 0.4);
		audio_sound_gain(snd, 0.5, 0);
		audio_sound_gain(snd, 0.5, 0);
		var fx = new FadeFX(x, y_limit, spr_fx_bomb_warning, 1, 0, sprite_get_duration(spr_fx_bomb_warning));
		fx_setup_screen_layer(fx);
		//fx.alpha_factor = 0.8;
		//fx.growth_limit = new Vector2(10, 10);
		//fx.growth_scale = new Vector2(1.005, 1.005);
	}
}

warning_timer.tick();