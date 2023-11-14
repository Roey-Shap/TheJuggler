event_inherited();

hspd = 0;
vspd = 0;

grav = 0.3;
vspd_max = 12;

y_limit = 0;

warning_timer = new Timer(get_frames(1.5));
warnings_left = 3;

manage_collision = function() {
	var touched_something = false;
	var player = instance_place(x, y, o_player);
	if player != noone {
		player.take_hit();
		touched_something = true;
	}
	
	var col = instance_place(x, y, o_collision);
	if col != noone {
		touched_something = true;
	}
	
	if touched_something {
		instance_destroy(id);
	}
}

draw_custom = function(offset_pos, draw_shadow=false) {	
	if draw_shadow {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + LCD_SHADE_OFFSET.x, y + offset_pos.y + LCD_SHADE_OFFSET.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
	} else {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
	}
}