event_inherited();

hp = 3;

platforming_active = false;

movespd = 3.65;
hspd = 0;
vspd = 0;
fric = 0.35;
grav = 0.35;
jump_force = 7.7;
jump_force_bounce_pad = jump_force * 1.4;

grounded = false;
grounded_last = false;
player_jump = false;
jumped_this_frame = false;

fast_falling = false;
fast_fall_speed = 10;
fast_falling_hspd_factor = 0.4;

invulnerability_timer = new Timer(get_frames(1.5));

last_checkpoint_pos = get_pos(id);

key_left = ord("A");
key_right = ord("D");
key_up = ord("W");
key_down = ord("S");

draw_scale = new Vector2(1, 1);
sprite_scale_normalize_lerp_factor = 0.2;

coyote_time_timer = new Timer(8);
buffer_jump_timer = new Timer(8);

function grounded_check() {
	var touching_screen_bottom = false; //instance_exists(o_screen) and y >= o_screen.bbox_bottom and o_manager.get_level_data().level_type == eLevelType.platforming;
	grounded = place_meeting(x, y+1, o_collision) or touching_screen_bottom;
}

manage_collision = function() {
	
	var obj = o_collision;
	
	if place_meeting(x + hspd, y, obj) {
		var hdir = sign(hspd);
		while !place_meeting(x + hdir, y, obj) {
			x += hdir;
		}
		
		hspd = 0;
		//debug_spark(x, y);
	}
	
	var vcol = instance_place(x, y + vspd, obj)
	if vcol != noone {
		var is_bounce_pad = object_is_ancestor(vcol.object_index, o_bounce_pad_parent)
		
		var vdir = sign(vspd);
		while !place_meeting(x, y + vdir, obj) {
			y += vdir;
		}
		
		if is_bounce_pad and fast_falling {
			vspd = -jump_force_bounce_pad;
		} else {		
			vspd = 0;
		}
		//debug_spark(x, y, c_red);
		player_jump = false;
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
}

function manage_bullets() {
	if o_manager.game_is_frozen() {
		return;
	}
	
	var bullet = instance_place(x, y, o_bullet_parent);
	if bullet != noone {
		hp -= 1;
		instance_destroy(bullet);
		invulnerability_timer.start();
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
		dust.alpha = 0.75;
		dust.image_yscale = 0.5;
	}
}

function initiate_fast_fall() {
	fast_falling = true;
	vspd = max(vspd, fast_fall_speed);
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
		last_checkpoint_pos = bbox_center(cp);
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
	
	if hspd != 0 {
		draw_scale.x = sign(hspd);
	}
	
	draw_scale.x = lerp(draw_scale.x, sign(draw_scale.x), sprite_scale_normalize_lerp_factor);
	draw_scale.y = lerp(draw_scale.y, 1, sprite_scale_normalize_lerp_factor);
}
