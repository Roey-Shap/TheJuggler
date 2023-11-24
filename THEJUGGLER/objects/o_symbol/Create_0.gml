event_inherited();

symbol_struct = -1;
image_speed = 0;
scale = 1;
symbol_manager_index = -1;

death_col_1 = c_lime;
death_col_2 = global.c_lcd_shade;

///@param {Struct.Symbol} symbol
function set_symbol(symbol) {
	symbol_struct = symbol;
	sprite_index = symbol.sprite;
	if symbol_struct.type == symbol_type.number {
		image_index = symbol_struct.literal_value;
		sprite_index = spr_seven_digit_numbers;
		scale = o_manager.symbol_draw_scale;
		image_xscale = scale;
		image_yscale = scale;
	} else if symbol_struct.type == symbol_type.charged {
		is_stone = true;
		image_speed = 1;
	}
}

function draw() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

function destroy_alt_anim_setup() {
	death_col_1 = merge_color(c_white, c_red, 0.2);
	death_col_2 = merge_color(c_white, c_red, 0.7);
}