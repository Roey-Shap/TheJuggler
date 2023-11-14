fog_color = -1;
draw_scale = new Vector2(1, 1);

draw_custom = function(offset_pos=new Vector2(0, 0), draw_shadow=false) {
	//gpu_set_fog(true, global.c_lcd_shade, 0, 1);
	//if fog_color != -1 {
	//	gpu_set_fog(true, fog_color, 0, 1);
	//}
	if draw_shadow {
		var off = object_is_ancestor_ext(object_index, o_symbol)? LCD_SHADE_OFFSET.multiply(o_manager.symbol_draw_scale) : LCD_SHADE_OFFSET;
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + off.x, y + offset_pos.y + off.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, global.c_lcd_shade, global.lcd_alpha_large * image_alpha);
	} else {
	//gpu_set_fog(false, c_white, 0, 1);
		//if fog_color != -1 {
		//	gpu_set_fog(true, fog_color, 0, 1);
		//}
		
		draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale * draw_scale.x, image_yscale * draw_scale.y, image_angle, image_blend, image_alpha);
	}
	//gpu_set_fog(false, c_white, 0, 1);

}