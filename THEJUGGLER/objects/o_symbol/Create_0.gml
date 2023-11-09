event_inherited();

symbol_struct = -1;
image_speed = 0;
scale = 0.1;
image_xscale = scale;
image_yscale = scale;

function set_symbol(symbol) {
	symbol_struct = symbol;
	sprite_index = symbol.sprite;
	if symbol_struct.type == symbol_type.number {
		image_index = symbol_struct.literal_value;
		sprite_index = spr_seven_digit_numbers;
	}
}

function draw() {
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}