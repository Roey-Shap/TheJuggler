function cutscene_playing(){
	return instance_exists(o_cutscene) or instance_exists(obj_cutscene_textbox_scribble);
}

function set_speaker(speaker_name) {
	var num_speakers = array_length(o_manager.speaker_data);
	var index = -1;
	for (var i = 0; i < num_speakers; i++) {
		var speaker = o_manager.speaker_data[i];
		if speaker.name == speaker_name {
			index = i;
			break;
		}
	}
	
	if index == -1 {
		return;
	}
	
	o_cutscene.speaker_current = o_manager.speaker_data[index];
}

function cs_set_speaker(name) {
	set_speaker(name);
	cutscene_end_action();
}