scribble_element = -1;
text = "DEFAULT!";

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
	if draw_shadow {
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(global.c_lcd_shade);
		draw_set_alpha(global.lcd_alpha);
		draw_text_scribble(x + pos.x + LCD_SHADE_OFFSET.x, y + pos.y + LCD_SHADE_OFFSET.y, text);
		draw_set_color(c_white);
		draw_set_alpha(1);
	} else {
		scribble_element.draw(x + pos.x, y + pos.y);
	}
}