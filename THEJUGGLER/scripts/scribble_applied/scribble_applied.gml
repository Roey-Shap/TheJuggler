function scribble_init(){
	default_font_name = "fnt_large_test";
	scribble_font_set_default(default_font_name);
	scribble_add_macro("num", function(value) {
		var value_string = string(value);
		var final_string = "";
		var num_digits = string_length(value_string);
		for (var i = 1; i <= num_digits; i++) {
			final_string = sfmt("%[spr_seven_digit_numbers,%]", final_string, string_char_at(value_string, i));
		}
		
		return final_string;
	})
}

function seven_digit(digit, scale=0.075) {
	return sfmt("[scale,%][num,%][scale,1]", scale, digit);
}