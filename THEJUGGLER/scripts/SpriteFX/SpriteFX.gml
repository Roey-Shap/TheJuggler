
enum draw_effects {
	circle,
	LAST,
}


function SpriteFX(_x, _y, _sprite_index, over_or_under) constructor {
	list = global.sprite_FX_list_over;
	switch(over_or_under) {
		case -1:
			list = global.sprite_FX_list_under;
			break;
		case 1:
			list = global.sprite_FX_list_over;
			break;
		case 10:
			list = global.sprite_FX_list_GUI_over;
			break;
	}
	
	ds_list_add(list, self);
	ds_list_add(global.sprite_FX_list_all, self);
	
	x = _x;
	y = _y;
	
	sprite_index = _sprite_index;
	image_index = 0;
	max_index = sprite_get_number(sprite_index) - 0.5;
	
	image_speed = 1;
	width = 1;		// get actual width and height below in switch statement !!!!!
	height = 1;		// for actual dimensions multiply by x/yscale
	
	// I like using frames per second in the sprite editor, so sprite_spd is in FPS
	sprite_spd = sprite_get_speed(sprite_index);
	sprite_duration = sprite_get_duration(sprite_index);
	
	image_xscale = 1;
	image_yscale = 1;
	image_angle = 0;
	image_blend = c_white;
	image_alpha = 1;
	
	growth_scale = new Vector2(1, 1);
	growth_limit = new Vector2(0, 0);
	epsilon = 0.005;
	
	alpha_multiplier = 1;
	alpha_limit = 0;
	alpha_fade_with_time = false;
	
	hspd = 0;
	vspd = 0;
	
	fric = 1;
	grav = 0;
	
	hspd_targ = 0;
	vspd_targ = 0;
	fog_col = -1;
	
	loop = false;
	end_of_loop = false;
	hold_sprite_time = 0;
	draw_on_surface = false;
	
	cutscene_effect = false;
	
	draw_func = -1;
	switch (sprite_index) {
		case draw_effects.circle:
			draw_func = function() {
				draw_set_alpha(image_alpha);
				draw_set_color(image_blend);
				draw_circle(round(x), round(y), width, false);
			}
		break;
		
		default:
			width = sprite_get_width(sprite_index);
			height = sprite_get_height(sprite_index);		// for actual dimensions multiply by x/yscale
			
			draw_func = function(offset=new Vector2(0, 0), draw_shadow=false) {
				if fog_col != -1 {
					gpu_set_fog(true, fog_col, -1, 1);
					draw_set_alpha(image_alpha);
				}
				if !draw_on_surface {
					offset = new Vector2(0, 0);
				}
				
				if draw_shadow {
					draw_sprite_ext(sprite_index, image_index, x + offset.x + LCD_SHADE_OFFSET.x, y + offset.y + LCD_SHADE_OFFSET.y, image_xscale, image_yscale,
									image_angle, global.c_lcd_shade, global.lcd_alpha * image_alpha);
				} else {
				
					//add_debug_text(image_index);
					draw_sprite_ext(sprite_index, image_index, x + offset.x, y + offset.y, image_xscale, image_yscale,
									image_angle, image_blend, image_alpha);
				}
				
				if fog_col != -1 {
					draw_set_alpha(1);
					gpu_set_fog(false, c_white, -1, 1);
				}
			}			
		break;
	}
	
	static step = function() {
		if cutscene_effect and !cutscene_playing() {
			end_of_loop = true;
		}
		
		if (end_of_loop) {
			if (hold_sprite_time <= 0) {
				// remove this from the global list of effects structs
				ds_list_delete(list, ds_list_find_index(list, self));
				ds_list_delete(global.sprite_FX_list_all, ds_list_find_index(global.sprite_FX_list_all, self));
				
				// return that this just died, don't go through the rest of the image_index calcuations
				return 1;
			}
		}
		
		
		// move image_index forward
		image_index += (image_speed * sprite_spd * DELTATIME) / game_get_speed(gamespeed_fps);
		
		// check for reaching the end of an animation cycle
		if (image_index >= max_index) {
			if (loop) {
				image_index = 0;
			} else {
				image_speed = 0;
				end_of_loop = true;
				hold_sprite_time -= DELTATIME;
			}
		} else {
			if (image_index < 0) {
				if (loop) {
					image_index = max_index-1;
				} else {
					image_speed = 0;
					end_of_loop = true;
					hold_sprite_time -= DELTATIME;
				}
			}
		}
		
		image_xscale *= growth_scale.x;
		image_yscale *= growth_scale.y;
		
		if abs(image_xscale - growth_limit.x) <= epsilon or abs(image_yscale - growth_limit.y) <= epsilon {
			end_of_loop = true;
		}
		
		image_alpha *= alpha_multiplier;
		
		if abs(image_alpha - alpha_limit) <= epsilon {
			end_of_loop = true;
		}
		
		if alpha_fade_with_time {
			image_alpha = clamp(1 - (image_index / (max_index + 1)), 0, 1);
		}
		
		hspd *= fric;
		vspd += grav;
		
		x += hspd;
		y += vspd;
		
		// it's still alive and going - no death
		return 0;
	}
	static draw = function(offset=new Vector2(0, 0), should_be_drawn_on_surface=false, draw_shadow=false) {
		if draw_on_surface and should_be_drawn_on_surface {
			return;
		}
		
		if draw_func != -1 {
			draw_func(offset, draw_shadow);
		}
	}
}

function FadeFX(_x, _y, _sprite_index, _over_or_under, _image_index, _time) : SpriteFX(_x, _y, _sprite_index, _over_or_under) constructor {
	hold_sprite_time = _time;
	total_life_time = max(1, _time);
	alpha_factor = 1;
	image_index = _image_index;
	//max_index = _image_index;
	
	static update_alpha = function() {
		image_alpha = clamp(alpha_factor * (hold_sprite_time / total_life_time), 0, 1);
	}
}

function CurveFollower(_x, _y, _sprites, _over_or_under, curve) constructor {
	
}