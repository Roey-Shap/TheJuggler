scribble_element = -1;
text = "DEFAULT!";
activated = false;

alpha_timer = new Timer(get_frames(1));
image_alpha = 0;

function set_text(str) {
	text = str;
}

function set_text_witch(str) {
	set_text(sfmt("[c_lime][shake]", str));
}

function draw() {	
	scribble_element.draw(x, y);
}

draw_custom = function(pos, draw_shadow=false) {
	if !activated {
		return;
	}
	
	if draw_shadow {
		draw_set_font(fnt_other);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(global.c_lcd_shade * image_alpha);
		draw_set_alpha(global.lcd_alpha * 2);
		draw_text_scribble_ext(x + pos.x + LCD_SHADE_OFFSET.x, y + pos.y + LCD_SHADE_OFFSET.y, text, CAM_W * 0.2);
		draw_set_color(c_white);
		draw_set_alpha(1);
	} else {
		draw_set_font(fnt_other);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_alpha(image_alpha);
		draw_text_scribble_ext(x + pos.x, y + pos.y, text, CAM_W * 0.2);
		draw_set_alpha(1);
	}
}