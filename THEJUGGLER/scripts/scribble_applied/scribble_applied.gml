function scribble_init(){
	default_font_name = "fnt_large_test";
	scribble_font_set_default(default_font_name);
	
	scribble_typists_add_event("speaker", function(element, param_array, character_index) {
		set_speaker(param_array[0]);
	});
	
	scribble_typists_add_event("shakehand", function(element, param_array, character_index) {
		with (o_watch_hand) {
			shake_intensity_factor = parse_number(param_array[0]);
		}
	});
	
	scribble_typists_add_event("shakehand_moment", function(element, param_array, character_index) {
		o_watch_hand.start_shake(new Vector2(parse_number(param_array[0]), parse_number(param_array[1])), parse_number(param_array[2]));
	});
	
	scribble_typists_add_event("set_juggler_emotion", function(element, param_array, character_index) {
		set_juggler_emotion(param_array[0]);
	});
	
	scribble_add_macro("num", function(value) {
		var value_string = string(value);
		var final_string = "";
		var num_digits = string_length(value_string);
		for (var i = 1; i <= num_digits; i++) {
			final_string = sfmt("%[spr_seven_digit_numbers,%]", final_string, string_char_at(value_string, i));
		}
		
		return final_string;
	});
	
	scribble_add_macro("tm", function() {
		return "[spr_tm]";
	});
	
	scribble_add_macro("mystery", function() {
		var hues = array_map(global.c_magic_colors, function(color, i) {
			return color_get_hue(color);
		});
		
		return sfmt("[wave][wobble][fnt_witch][cycle,%,%,%,%]", hues[0], hues[1], hues[2], hues[3]);
	});
	
	scribble_add_macro("/mystery", function() {
		return "[/wave][/wobble][/cycle]";
	});
	
	scribble_add_macro("player_score", function() {
		return string(o_manager.current_score);
	});
	
	scribble_add_macro("play_time", function() {
		return string(current_time/1000);
	});
}

function seven_digit(digit, scale=0.075) {
	return sfmt("[scaleStack,%][num,%][scaleStack,%]", scale, digit, 1/scale);
}