// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_text_scenes(conversations_array){
	// for each conversation, make a corresponding single-command scene that contains that conversation
	// put them all in a scene array and return it
	var conversations = array_length(conversations_array);
	
	var scenes = [];	// options layer
	for (var c = 0; c < conversations; c++) {
		array_push(scenes,	
					[		// single scene layer 
						[cutscene_textbox, conversations_array[c]]	// single command layer
					]		// end scene
			      );
	}
	
	return (scenes);
}