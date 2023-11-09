/// @description Insert description here

have_started = false;

scene_info = -1;
command_index = -1;
parent = noone;
freeze_battle = false;

next_data = [];

timer = 0;
times_moved_char = 0;

x_dest = -1;
y_dest = -1;
mv_time = -1;

made_textbox = false;

speaker_object_map = {};
current_speaker = noone;

//array_push(o_manager.cutscene_objects_ordered, id);

function reset_flags() {
	made_textbox = false;
}