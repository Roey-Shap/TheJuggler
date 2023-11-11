function scribble_init(){
	default_font_name = "fnt_large_test";
	scribble_font_set_default(default_font_name);
	scribble_add_macro("num", function(index) {
		return sfmt("[spr_seven_digit_numbers,%]", index);
	})
}

function seven_digit(digit, scale=0.075) {
	return sfmt("[scale,%][num,%][scale,1]", scale, digit);
}