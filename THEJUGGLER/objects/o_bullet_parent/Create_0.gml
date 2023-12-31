
hspd = 0;
vspd = 0;

draw_scale = new Vector2(1, 1);

draw_helper = function(_x, _y, angle, blend, alpha) {
	var spr = spr_bullet_colorable_base;
	var xscale = image_xscale * draw_scale.x;
	var yscale = image_yscale * draw_scale.y;
	var pc = new Vector2(_x, _y);
	var s = 7.5 * abs(xscale);
	var spd = (new Vector2(hspd, vspd)).multiply(s);
	var rspd = (new Vector2(vspd, -hspd)).multiply(s * 0.65);
	var stretchFactor = map(-1, 1, sin(spd.get_mag() * current_time/100), 1, 1.1);
	//var dir = point_direction(0, 0, hspd, vspd);
	//var len = point_distance(0, 0, hspd, vspd);
	var p1 = pc.mult_add(spd, 1 * stretchFactor);
	var p2 = pc.add(rspd);
	var p3 = pc.mult_add(spd, -1.5 * stretchFactor);
	var p4 = pc.sub(rspd);
	draw_sprite_pos(spr, image_index, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y, alpha);
	gpu_set_fog(true, blend, 0, 1);
	draw_sprite_pos(spr_bullet_colorable_top, image_index, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y, alpha);
	gpu_set_fog(false, c_white, 0, 1);
	//draw_sprite_ext_skew(spr_bullet_colorable_base, image_index, _x, _y, xscale, yscale, angle, alpha, );
	//draw_sprite_ext(spr_bullet_colorable_base, image_index, _x, _y, , image_yscale * draw_scale.y, angle, c_white, alpha);
	//draw_sprite_ext(spr_bullet_colorable_top, image_index, _x, _y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, angle, blend, alpha);
}

draw_custom = function(offset_pos, draw_shadow=false) {
	if draw_shadow {
		draw_helper(x + offset_pos.x + LCD_SHADE_OFFSET.x, y + offset_pos.y + LCD_SHADE_OFFSET.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
	} else {
		draw_helper(x + offset_pos.x, y + offset_pos.y, image_angle, image_blend, image_alpha);
	}
}

manage_collision = function() {
	//var collision = instance_place(x, y, o_collision);
	//if collision != noone {
	//	if !object_is_ancestor_ext(collision.object_index, o_symbol) and !object_is_ancestor_ext(collision.object_index, o_collision_thin) {
	//		instance_destroy(id);
	//	}
	//}
	var screen = instance_nearest(0, 0, o_screen);
	var bottom_right = get_pos(inst_anchor_screen_bottom_right);
	var top_left = bottom_right.sub(new Vector2(screen.sprite_width, screen.sprite_height));
	var w = screen.bbox_right - screen.bbox_left;
	var margin = w * 0.1;
	var exited_frame = false;
	if x > bottom_right.x + margin {
		exited_frame = true;
	}
		
	if x < top_left.x - margin {
		exited_frame = true;
	}
		
	if y < top_left.y - margin {
		exited_frame = true;
	}
		
	if y > bottom_right.y + margin {
		exited_frame = true;
	}	
	
	if exited_frame {
		instance_destroy(id);
	}
}