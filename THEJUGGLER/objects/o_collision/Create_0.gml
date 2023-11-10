draw_custom = function(offset_pos=new Vector2(0, 0)) {
	//gpu_set_fog(true, global.c_lcd_shade, 0, 1);
	draw_sprite_ext(sprite_index, image_index, x + offset_pos.x + LCD_SHADE_OFFSET.x, y + offset_pos.y + LCD_SHADE_OFFSET.y, image_xscale, image_yscale, image_angle, global.c_lcd_shade, global.lcd_alpha);
	//gpu_set_fog(false, c_white, 0, 1);
	draw_sprite_ext(sprite_index, image_index, x + offset_pos.x, y + offset_pos.y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}