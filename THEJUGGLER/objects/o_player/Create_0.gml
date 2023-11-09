hp = 3;

platforming_active = false;

movespd = 3.65;
hspd = 0;
vspd = 0;
fric = 0.3;
grav = 0.4;
jump_force = 7;
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

function grounded_check() {
	var touching_screen_bottom = instance_exists(o_screen) and y >= o_screen.bbox_bottom;
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
		
		player_jump = false;
	}
	
	if o_manager.playing_normal_platforming_level() {
		var screen = instance_nearest(0, 0, o_screen);
		if x + hspd > screen.bbox_right {
			x = screen.bbox_right;
			hspd = 0;
		}
		
		if x + hspd < screen.bbox_left {
			x = screen.bbox_left;
			hspd = 0;
		}
		
		if y + vspd < screen.bbox_top {
			y = screen.bbox_top;
			vspd = 0;
		}
		
		if y + vspd > screen.bbox_bottom {
			y = screen.bbox_bottom;
			if fast_falling {
				vspd = -jump_force_bounce_pad;
			} else {
				vspd = 0;
			}
		}
	}
}

function manage_bullets() {
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
}
	
function manage_checkpoint_collisions() {
	var cp = instance_place(x, y, o_checkpoint);
	if cp != noone {
		last_checkpoint_pos = bbox_center(cp);
	}
}

draw_custom = function(offset_pos) {
	if o_manager.get_level_data().level_type != eLevelType.normal {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
}