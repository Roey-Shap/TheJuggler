
hspd = 0;
vspd = 0;

draw_scale = new Vector2(1, 1);

draw_custom = function(offset_pos, draw_shadow=false) {
	if draw_shadow {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + LCD_SHADE_OFFSET.x, y + offset_pos.y + LCD_SHADE_OFFSET.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large);
	} else {
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
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