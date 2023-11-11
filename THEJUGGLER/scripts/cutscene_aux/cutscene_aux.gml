function cutscene_playing(){
	return instance_exists(o_cutscene) or instance_exists(obj_cutscene_textbox_scribble);
}