
var endOfLine = (typist.get_state() != 1) or (typist.get_paused());
image_speed = endOfLine;

image_alpha = 0;//(cur_portrait == -1 and global.debug);

var proceed_dialogue = INPUT_ACC or INPUT_BACK or continue_text_auto or (DEBUG and mouse_check_button(mb_right));

//if typist.get_state() >= 1 {
//	var cs = instance_nearest(x, y, o_cutscene);
//	var speaker_map = cs.speaker_object_map;
//	foreach_struct(speaker_map, function(inst) {
//		handle_speaking_stop(inst);
//	});
//} else {
	
//}

if proceed_dialogue {
	if typist.get_paused() {
		typist.unpause();
	} else if typist.get_state() >= 1 {
		textbox_skip = false;
        continue_text_auto = false;
		
        if (textbox_element.get_page() < textbox_element.get_page_count() - 1) {
            textbox_element.page(textbox_element.get_page() + 1);
			
			// reset the reaction functions with each page
			//yes_func = -1;
			//no_func = -1;
        }
        else //if the textbox is at the end of the line, move to the next one
        {
            // Increment our conversation index for the next piece of text
            textbox_conversation_index += 1;
        }
	} else {
        textbox_skip = true;
		typist.skip();
		//db_show("!");
    }
}

//typist.in(textbox_skip? 9999 : typewriter_speed, typewriter_smoothness);

if textbox_conversation_index >= array_length(textbox_conversation) {
	//end conversation
	instance_destroy(id);
}

typewriter_state_prev = typist.get_state();

