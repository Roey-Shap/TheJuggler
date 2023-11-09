///@description scr_cutscene_textbox

// this function is run by the cutscene object, which should take its "parent" information from the *interact object* that created it
// then, that interact object can be referenced by the textbox in its use of [destroy] and other Events
function cutscene_textbox(text_array) {
	
	make_textbox(text_array);
/*
	if !instance_exists(o_textbox_cutscene){
		var box = instance_create_layer(x, y, "Textboxes", o_textbox_cutscene);

		//var len = array_length_1d(argument0);
		box.text_array = argument0;
	}
	/*
	with(box){
		text_array = argument2;
	}

	/*
	text_array = [
		["Enzo", spr_..., "hi"],
		[],
		[],
	]

	//Check for number of arguments, and then make a textbox with that number of slots
	//Make an array containing the picture to display, the title, and the text

/* end scr_cutscene_textbox */
}

function make_textbox(text_array) {
	if !instance_exists(obj_cutscene_textbox_scribble) {
		var textbox = instance_create_layer(x, y, LAYER_META, obj_cutscene_textbox_scribble);
		textbox.textbox_conversation = text_array;
		textbox.parent = parent;
		//var sound_info = o_manager.sound_info;
		//textbox.typist.sound_per_char(sound_info.sounds, 
		//							  sound_info.pitchMin, 
		//							  sound_info.pitchMax, 
		//							  sound_info.exceptionCharacters, 
		//							  sound_info.sound_gain);
		return textbox;
	}

	return instance_nearest(x, y, obj_cutscene_textbox_scribble);
}


function cs_text (arr) {
	cutscene_textbox(arr);
}