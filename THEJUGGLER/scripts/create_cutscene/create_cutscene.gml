///@description scr_create_cutscene
///@arg scene_info
function create_cutscene(_scene_info, _parent=noone, _freeze_battle=false) {
	
	//var do_push = false;
	//if (array_length(o_manager.queued_cutscenes) > 0 or cutscene_playing()) {
	//	db_show([cutscene_playing(), array_length(o_manager.queued_cutscenes)])
	//	do_push = true;
	//}
	//debug_spark(CAMERA.x, CAMERA.y);
	if instance_exists(o_cutscene) {
		var is_cs = instance_exists(o_cutscene);
		if (is_cs) {
			with (o_manager) {
				var cs = instance_nearest(x, y, o_cutscene);
			}
		}
		
		append_cutscene(_scene_info, _parent, _freeze_battle, false);
		return;
		///              doesn't continue from here!
	}
	

	
	var inst = instance_create_layer(0, 0, LAYER_META, o_cutscene);
	inst.parent = _parent;
	inst.freeze_battle = _freeze_battle;
	inst.scene_info = _scene_info;
	
	//if _parent != noone and variable_instance_exists(_parent, "speaker_sounds"){
	//	 var sounds = variable_instance_get(_parent, "speaker_sounds");
	//	 o_manager.sound_info.sounds = sounds;
	//}
	
	with(inst){
		event_perform(ev_other, ev_user0);
	}
	
	//if !do_push {
		
	//} else {
	//	array_push(o_manager.queued_cutscenes, inst);
	//}
	return inst;
}
