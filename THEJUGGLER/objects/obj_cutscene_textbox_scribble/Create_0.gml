


//var UIunit = BASE_W / 240;

//scribble_font_add_from_sprite("spr_sprite_font", _mapstring, 0, 3);

textbox_conversation = ["Default"];

textbox_width				= 400;
textbox_height				= 100;
cur_portrait				= -1;
textbox_title				= undefined;
textbox_conversation_index	= 0;
textbox_skip				= false;
textbox_element				= undefined;
typewriter_speed			= 1;
typewriter_smoothness		= 0;

typewriter_state_prev		= 0;
parent						= noone;
freeze_battle = true;
yes_func = -1;
no_func = -1;

continue_text_auto = false;			// automatically continue the text
sound_array = [snd_watch_beep_1];

typist = scribble_typist();
typist.in(textbox_skip? 9999 : typewriter_speed, typewriter_smoothness)

text_dims_max = new Vector2(0.3 * CAM_W, 0.3 * CAM_H);
textbox_margins = text_dims_max.multiply(0.1);
//.sound_per_char(sound_array, 0.7, 1.3, " ", 1.5);

//typist.character_delay_add(".", 70);

scribble_anim_shake(1, 0.25);
scribble_anim_wave(1.5, 0.4, 0.25);

function perform_yes_no_func() {
	if yes_func != -1 {
		if INPUT_ACC {
			yes_func();
		}
	} 
	
	if no_func != -1 and INPUT_BACK and !INPUT_ACC {
		no_func();
	}
}

draw = function() {
	
	var speaker = o_cutscene.speaker_current;
	if speaker == -1 {
		set_speaker("None");
		speaker = o_cutscene.speaker_current;
	}

	
	textbox_element = scribble(textbox_conversation[textbox_conversation_index])
	.starting_format(speaker.font, 1)
	.wrap(text_dims_max.x - textbox_margins.x * 2, text_dims_max.y - textbox_margins.y * 2)
	.align(fa_center, fa_middle)

	var textbox_pos = speaker.textbox_position.copy();

	//.starting_format("fnt_textbox", c_white)
	//.typewriter_sound_per_char([noone, noone, noone, s_option_4], 10, 0.8, 1.2)

	textbox_pos.x *= CAM_W;
	textbox_pos.y *= CAM_H; 
	
	var textbox_bbox = textbox_element.get_bbox(textbox_pos.x, textbox_pos.y);
		
	var xscale = 3 * speaker.textbox_direction.x;
	var yscale = 2 * speaker.textbox_direction.y;
	var spr = speaker.textbox_sprite;
	
	var sprite_w = (sprite_get_bbox_right(spr) - sprite_get_bbox_left(spr)) * xscale;
	var sprite_h = (sprite_get_bbox_bottom(spr) - sprite_get_bbox_top(spr)) * yscale;
	
	draw_sprite_ext(speaker.textbox_sprite, 0, 
					textbox_pos.x, textbox_pos.y, 
					xscale, yscale, 
					speaker.textbox_angle, c_white, 1);

	textbox_element.draw(textbox_pos.x, textbox_pos.y, typist);

	if typist.get_state() >= 1 or typist.get_paused() {
		var continue_sprite_name = sprite_get_name(spr_mouse_left_click_icon);
		draw_sprite_fade(1, asset_get_index(continue_sprite_name), 0, 
				textbox_pos.x + abs(sprite_w/2), textbox_pos.y + abs(sprite_h/2), 
				1, 1, 
				0, c_white, 0, 1);
	}
	
	//var guiW = display_get_gui_width();
	//var guiH = display_get_gui_height();

	//var textbox_w = guiW * 8/16;
	//var textbox_h = guiH * 2/10;


	//var midX = guiW/2;
	//var midY = textbox_h * 5/8;


	//var margin = textbox_w/24;
	//var radius = 16;
	//var borderWidth = 4;

	//draw_set_color(c_white);
	//draw_set_alpha(1);
	//draw_roundrect_ext(midX - textbox_w/2, 
	//				   midY - textbox_h/2, 
	//				   midX + textbox_w/2, 
	//				   midY + textbox_h/2, 
	//				   radius, radius, false);

	//draw_set_color(c_black);
	//draw_roundrect_ext(midX - textbox_w/2 + borderWidth, 
	//				   midY - textbox_h/2 + borderWidth, 
	//				   midX + textbox_w/2 - borderWidth, 
	//				   midY + textbox_h/2 - borderWidth, 
	//				   radius, radius, false);


	//draw_set_halign(fa_center);
	//draw_set_valign(fa_center);

	////Main text
	//var textSectionW = (textbox_w) * 11/16;
	//var textSectionH = (textbox_h);
	//if cur_portrait == -1 textSectionW = textbox_w;
	////var maxTextWidth = textSectionW - 2*margin;
	////var fontSep = string_height("AAA");
	////var curTextHeight = string_height_ext(cur_text, fontSep, maxTextWidth);

	//var textX = midX + textbox_w/2 - textSectionW/2;
	//var textY = midY + ((textbox_title != undefined)? -textbox_h/6 : 0);

	//Note that we're setting "textbox_element" here 


	//Title
	//draw_set_font(fnt_title);
	//draw_set_color(cur_title_col);
	//draw_text_ext(textX, textY-textbox_h/2+margin, cur_title, string_height("AAA"), 500);

	//if (textbox_title != undefined) {
	//	var titleY = midY - textbox_h/2 + (margin*0.75);
	//    var _element = scribble(textbox_title)
	//	.align(fa_center, fa_middle)
	//	.starting_format("fnt_regular", c_white)
	//    var _name_box = _element.get_bbox(textX, titleY, 10, 10, 10, 10);
    
	////    draw_set_colour($936969);
	//  //  draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
	//   // draw_set_colour(c_white);
    
	//    _element.draw(textX, titleY);
	//}

	////Portrait
	//var portraitSectionWidth = textbox_w * 5/16;
	//var portraitX = midX - textbox_w/2 + portraitSectionWidth/2;
	//var portraitY = midY;

	//if (sprite_exists(cur_portrait)) {
	//	var portraitW = sprite_get_width(cur_portrait);
	//	var portraitH = sprite_get_height(cur_portrait);
	
	//	draw_set_color(merge_color(c_white, $936969, 0.6));
	//	draw_roundrect_ext(portraitX - portraitW/2, portraitY - portraitH/2, portraitX + portraitW/2, portraitY + portraitH/2, radius, radius, false);
	
	////	shader_set() non-black outliner here?
	//	draw_sprite_ext(cur_portrait, image_index, portraitX, portraitY, 1, 1, 0, c_white, 1);
	//}


	/*var vw = display_get_gui_width();
	var vh = display_get_gui_height();

	var _x = vw/2;
	var _y = vh/2;

	//Draw textbox
	draw_set_colour($936969);
	draw_rectangle(_x, _y, _x + textbox_width + 20, _y + textbox_height + 20, false);
	draw_set_colour(c_white);

	//Draw main text body
	//Note that we're setting "textbox_element" here
	textbox_element = scribble(textbox_conversation[textbox_conversation_index])
	.wrap(textbox_width, textbox_height)
	.typewriter_in(textbox_skip? 9999 : 1, 0)
	.draw(_x + 10, _y + 10);

	//Draw portrait
	draw_set_colour($936969);
	draw_rectangle(_x + textbox_width + 30, _y, _x + textbox_width + textbox_height + 50, _y + textbox_height + 20, false);
	draw_set_colour(c_white);

	if (sprite_exists(textbox_portrait))
	{
	    draw_sprite(textbox_portrait, 0, _x + textbox_width + 40, _y + 10);
	}

	//Draw a little icon once the text has finished displaying, or if text display is paused
	if ((textbox_element.get_typewriter_state() >= 1) || textbox_element.get_typewriter_paused())
	{
	    draw_sprite(spr_white_coin, 0, _x + textbox_width + 20, _y + textbox_height + 20);
	}

	if (textbox_name != undefined)
	{
	    //Draw name tag
	    var _element = scribble(textbox_name).align(fa_right, fa_bottom);
	    var _name_box = _element.get_bbox(_x + textbox_width + 10, _y - 20, 10, 10, 10, 10);
    
	    draw_set_colour($936969);
	    draw_rectangle(_name_box.left, _name_box.top, _name_box.right, _name_box.bottom, false);
	    draw_set_colour(c_white);
    
	    _element.draw(_x + textbox_width + 10, _y - 20);
	}
	*/
}