function cutscene_playing(){
	return instance_exists(o_cutscene) or instance_exists(obj_cutscene_textbox_scribble);
}

function set_speaker(speaker_name) {
	var num_speakers = array_length(o_manager.speaker_data);
	var index = -1;
	for (var i = 0; i < num_speakers; i++) {
		var speaker = o_manager.speaker_data[i];
		if speaker.name == speaker_name {
			index = i;
			break;
		}
	}
	
	if index == -1 {
		return;
	}
	
	o_cutscene.speaker_current = o_manager.speaker_data[index];
}

function cs_set_speaker(name) {
	set_speaker(name);
	cutscene_end_action();
}

function cs_create_fx(pos, sprite, over_or_under) {
	var fx = new SpriteFX(pos.x, pos.y, sprite, over_or_under);
	fx_setup_screen_layer(fx);
	cutscene_end_action();
	return fx;
}

function cs_create_fx_scaling(pos, sprite, over_or_under, growth_rates, stopping_scales, initial_scales=new Vector2(1, 1)) {
	var fx = cs_create_fx(pos, sprite, over_or_under);
	fx.hold_sprite_time = get_frames(60);	// hold for at most a minute
	fx.growth_scale = growth_rates.copy()
	fx.growth_limit = stopping_scales.copy();
	fx.image_xscale = initial_scales.x;
	fx.image_yscale = initial_scales.y;
	return fx;
}


function cs_create_fx_scaling_with(inst, sprite, over_or_under, growth_rates, stopping_scales, initial_scales=new Vector2(1, 1)) {
	var pos = get_pos(inst);
	var fx = cs_create_fx_scaling(pos, sprite, over_or_under, growth_rates, stopping_scales, initial_scales);
}

function cs_fade(fade_type, time) {
	o_manager.fade = fade_type;
	o_manager.fade_timer.set_and_start(time);
	cutscene_end_action();
}