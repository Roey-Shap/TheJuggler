event_inherited();

hp_second_wave = 5;
hp_max = 3;
hp = hp_max;

platforming_active = false;
special_sprite = -1;

movespd = 3.65;
hspd = 0;
vspd = 0;
fric = 0.35;
grav = 0.35;
jump_force = 7.7;
jump_force_bounce_pad = jump_force * 1.4;
jump_force_break_symbol_freeze = jump_force * 0.75;

bob_enabled = false;

grounded = false;
grounded_last = false;
player_jump = false;
jumped_this_frame = false;

fast_falling = false;
fast_fall_speed = 10;
fast_falling_hspd_factor = 0.4;

vspd_max = fast_fall_speed * 1.5;

shake_offset = vector_zero();
shake_intensity = vector_zero();
shake_timer = new Timer(1, false, function() {
	shake_offset = vector_zero();
});


///@param {Struct.Vector2} intensity
///@param Int frames
function start_shake(intensity, frames) {
	if !shake_timer.is_done() {
		// add a factor of the new shake
		shake_intensity = shake_intensity.mult_add(intensity, 0.5);
	} else {		
		shake_intensity = intensity.copy();
	}
	
	shake_timer.set_and_start(max(shake_timer.current_count, frames));
}

invuln_default_time = get_frames(2.5);
invulnerability_timer = new Timer(invuln_default_time, false, function() {
	with (o_player) {
		image_alpha = 1;
		image_blend = c_white;
	}
});

invulnerability_flash_timer = new Timer(get_frames(0.45));

last_checkpoint_pos = get_pos(id);

key_left = ord("A");
key_right = ord("D");
key_up = ord("W");
key_down = ord("S");

draw_scale = new Vector2(1, 1);
sprite_scale_normalize_lerp_factor = 0.2;
run_dust_timer = new Timer(get_frames(0.375));
draw_hp_as_text = true;
been_take_from_GUI = false;

coyote_time_timer = new Timer(8);
buffer_jump_timer = new Timer(8);

function grounded_check() {
	var touching_screen_bottom = false; //instance_exists(o_screen) and y >= o_screen.bbox_bottom and o_manager.get_level_data().level_type == eLevelType.platforming;
	grounded = place_meeting(x, y+1, o_collision) or touching_screen_bottom;
}

manage_collision = function() {
	
	var obj = o_collision;
	
	var hcol = instance_place(x + hspd, y, obj);
	if hcol != noone {
		var is_spiky = object_is_ancestor(hcol.object_index, o_spike_parent);
		
		if is_spiky {
			take_hit();
		}
		
		var hdir = sign(hspd);
		while !place_meeting(x + hdir, y, obj) {
			x += hdir;
		}
		
		hspd = 0;
		//debug_spark(x, y);
	}
	
	var vcol = instance_place(x, y + vspd, obj)
	if vcol != noone {
		var is_symbol = vcol.symbol_struct != -1;
		var is_bounce_pad = object_is_ancestor_ext(vcol.object_index, o_bounce_pad_parent) or (is_symbol and vcol.symbol_struct.type == symbol_type.shape and isIn(vcol.symbol_struct.value, [symbol_type.row, symbol_type.column, symbol_type.square]));
		var is_spiky = false; //object_is_ancestor_ext(vcol.object_index, o_spike_parent) or (is_symbol and isIn(vcol.symbol_struct.value, [symbol_type.triangle, symbol_type.diamond]));
		var is_frozen = vcol.is_stone;
		var inside_collision = place_meeting(x, y, vcol);
		
		if is_spiky and !is_frozen and !inside_collision {
			take_hit();
		}
		
		
		var vdir = sign(vspd);
		while !place_meeting(x, y + vdir, obj) {
			y += vdir;
		}
		
		if is_frozen {
			if fast_falling {
				vspd = -jump_force_break_symbol_freeze;
				vcol.break_freeze();
			} else {
				vspd = 0;
			}
		} else {
			if is_bounce_pad and fast_falling {
				vspd = -jump_force_bounce_pad;
				//vcol.draw_scale.x = 1.3;
				//vcol.draw_scale.y = 0.5;
			} else {		
				vspd = 0;
			}
		}
		//debug_spark(x, y, c_red);
		player_jump = false;
	}
	
	if place_meeting(x, y, o_killzone) {
		hp = 1;
		invulnerability_timer.current_count = 0;
		take_hit();
	}
	//if o_manager.playing_normal_platforming_level() {
	//	var screen = instance_nearest(0, 0, o_screen);
	//	if x + hspd > screen.bbox_right {
	//		x = screen.bbox_right;
	//		hspd = 0;
	//	}
		
	//	if x + hspd < screen.bbox_left {
	//		x = screen.bbox_left;
	//		hspd = 0;
	//	}
		
	//	if y + vspd < screen.bbox_top {
	//		y = screen.bbox_top;
	//		vspd = 0;
	//	}
		
	//	if y + vspd > screen.bbox_bottom {
	//		y = screen.bbox_bottom;
	//		if fast_falling {
	//			vspd = -jump_force_bounce_pad;
	//		} else {
	//			vspd = 0;
	//		}
	//	}
	//}	
	
	var cols = ds_list_create();
	var num_cols = collision_rectangle_list(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, o_collision, false, false, cols, false);
	for (var i = 0; i < num_cols; i++) {
		var inst = cols[| i];
		var is_symbol = inst.symbol_struct != -1;
		var is_spike = !inst.is_stone and object_is_ancestor_ext(inst.object_index, o_spike_parent);
		if is_symbol {
			is_spike = is_spike or isIn(inst.symbol_struct.value,[symbol_type.triangle, symbol_type.diamond]);
		}
		
		if is_spike {
			take_hit();
			inst.start_hit_flash();
			break;
		}
	}
	
	ds_list_destroy(cols);
	
	var inside_symbol = instance_place(x, y, o_symbol);
	if inside_symbol != noone {
		var height = bbox_bottom - bbox_top;
		//var offset_from_sprite_bottom = height - sprite_get_yoffset(mask_index);
		y = inside_symbol.bbox_top - sprite_get_yoffset(mask_index) - 1;
	}
}

function take_hit() {
	if !invulnerability_timer.is_done() {
		return;
	}
	
	hp -= 1;
	start_shake(new Vector2(4, 4), get_frames(0.6));
	o_manager.start_shake(new Vector2(10, 10), get_frames(0.65));
	invulnerability_timer.set_and_start(invuln_default_time);
	if hp <= 0 {
		o_manager.handle_game_over();
	}
}

function heal(amount) {
	hp = min(hp + amount, hp_max);
}

function give_invuln(frames) {
	invulnerability_timer.set_and_start(max(invulnerability_timer.current_count, frames));
}

function manage_bullets() {
	if o_manager.game_is_frozen() or !invulnerability_timer.is_done() {
		return;
	}
	
	var bullet = instance_place(x, y, o_bullet_parent);
	if bullet != noone {
		take_hit();
		instance_destroy(bullet);
	}
}

function perform_jump() {
	vspd = -jump_force;
	player_jump = true;
	jumped_this_frame = true;
	coyote_time_timer.current_count = 0;
	buffer_jump_timer.current_count = 0;
	draw_scale.x = sign(draw_scale.x) * 0.6;
	draw_scale.y = 1.35;
}

function perform_landing() {
	draw_scale.x = sign(draw_scale.x) * 1.4;
	draw_scale.y = 0.5;
	
	var dust = new SpriteFX(x, y + 10, spr_fx_player_land_dust, 1);
	fx_setup_screen_layer(dust);
	if fast_falling {
		play_pitch_range(snd_tap_1, 0.8, 0.9);
		repeat(irandom_range(4, 6)) {
			var offset_x = choose(-1, 1) * irandom_range(8, 20);
			var offset_y = irandom_range(-10, 2);
			var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3);
			var fx = new SpriteFX(x + offset_x, y + offset_y, spr, 1);
			fx.image_angle = irandom(359);
			fx.image_speed = random_range(0.8, 1);
			fx_setup_screen_layer(fx);
		}
	} else {
		play_pitch_range(snd_tap_1, 0.9, 1.05);
		
		dust.alpha = 0.1;
		dust.image_yscale = 0.25;
		
		repeat(irandom_range(2, 3)) {
			var offset_x = choose(-1, 1) * irandom_range(8, 20);
			var offset_y = irandom_range(-10, 2);
			var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3);
			var fx = new SpriteFX(x + offset_x, y + offset_y, spr, 1);
			fx.image_angle = irandom(359);
			fx.image_speed = random_range(0.8, 1);
			fx.image_xscale = random_range(0.5, 0.8);
			fx.image_yscale = random_range(0.5, 0.8);
			fx_setup_screen_layer(fx);
		}
	}
	
}

function initiate_fast_fall() {
	fast_falling = true;
	vspd = max(vspd, fast_fall_speed);
	
	play_pitch_range(snd_fast_fall, 0.9, 1.05);
	
	repeat(irandom_range(4, 6)) {
		var side = choose(-1, 1);
		var offset_x = side * irandom_range(15, 25);
		var offset_y = irandom_range(-40, -30);
		var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3, spr_fx_sparkle_1);
		var fx = new SpriteFX(x + offset_x, y + offset_y, spr, 1);
		fx.image_angle = irandom(359);
		fx.image_speed = random_range(0.8, 1);
		fx.hspd = side * random_range(0, 2);
		fx.vspd = -random_range(0.1, 3);
		fx.image_blend = merge_color(c_white, c_lime, random_range(0.1, 0.9));
		fx_setup_screen_layer(fx);
	}
}

function manage_checkpoint_collisions() {
	var cp = instance_place(x, y, o_checkpoint);
	if cp != noone {
		var p = last_checkpoint_pos;
		last_checkpoint_pos = bbox_center(cp);
		//if !last_checkpoint_pos.equals(p) {
		//	print(last_checkpoint_pos);
		//}
	}
}

function manage_cutscene_triggers() {
	var trigger = instance_place(x, y, o_cutscene_trigger);
	if trigger != noone {
		trigger.scene.play();
		instance_destroy(trigger);
	}
}

function manage_sprite() {
	if grounded {
		if abs(hspd) > 0.15 == 0 {
			set_sprite(spr_player_idle);
		} else {
			set_sprite(spr_player_run);
		}
	} else {
		if vspd < 0 {
			set_sprite(spr_player_rise);
		} else {
			set_sprite(spr_player_fall);
		}
	}
	
	if special_sprite != -1 {
		set_sprite(special_sprite);
	}
	
	if bob_enabled {
		set_sprite(spr_player_fall);
		
		if hit_roll(0.07) {
			var particle_noise = 2;
			var ran_x = x + irandom_range(-particle_noise, particle_noise);
			var ran_y = y + irandom_range(-particle_noise, particle_noise);
			var ran_spr = choose(spr_fx_sparkle_1, spr_fx_dust_1, spr_fx_dust_3);
			var fx = new SpriteFX(ran_x, ran_y, ran_spr, 1);
			fx_setup_screen_layer(fx);
			var s = random_range(0.75, 0.95);
			fx.hspd = random_range(-0.3, 0.3);
			fx.vspd = random_range(-0.3, 0.3);
			fx.fric = 0.999;
			fx.image_xscale = s;
			fx.image_yscale = s;
			fx.image_angle = irandom_range(-10, 10);
			fx.image_blend = merge_color(c_white, c_lime, random(1));
		}
	}
	
	if hspd != 0 {
		draw_scale.x = sign(hspd);
	}
	
	draw_scale.x = lerp(draw_scale.x, sign(draw_scale.x), sprite_scale_normalize_lerp_factor);
	draw_scale.y = lerp(draw_scale.y, 1, sprite_scale_normalize_lerp_factor);
}

draw_custom_prev = draw_custom;

draw_custom = function(offset_pos, draw_shadow=false) {
	//if !platforming_active {
	//	return;
	//}
	if !been_take_from_GUI {
		return;
	}
	
	draw_custom_prev(offset_pos.add(shake_offset), draw_shadow);
	
	if image_blend != c_white {
		gpu_set_fog(true, image_blend, 0, 1);
		if !draw_shadow {
			draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + shake_offset.x, y + offset_pos.y + shake_offset.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
		}
		
		gpu_set_fog(false, c_white, 0, 1);
	}
	
	o_manager.draw_circles(x + offset_pos.x + 6, y + offset_pos.y - 60, 8, hp);
}
