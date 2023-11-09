function cutscene_camera_set_target(target_anchor_name) {
	camera_set_target_helper(target_anchor_name);

	cutscene_end_action();


}

function cutscene_camera_reset_target() {
	camera_set_target_helper(noone);

	cutscene_end_action();
}

function cutscene_camera_set_lerp_speed(spd) {
	o_camera.target_snap_speed_modifier = spd;
	cutscene_end_action();
}

function cutscene_camera_reset_lerp_speed() {
	o_camera.target_snap_speed_modifier = 1;
	cutscene_end_action();
}

function cutscene_camera_set_anchor_coords(xpercent, ypercent) {
	o_camera.target_camera_fraction_x = xpercent;
	o_camera.target_camera_fraction_y = ypercent;
	cutscene_end_action();
}

function cutscene_camera_reset_anchor_coords() {
	o_camera.target_camera_fraction_x = 0.5;
	o_camera.target_camera_fraction_y = 0.5;
	cutscene_end_action();
}

function cutscene_camera_set_shake(shake_x, shake_y, frames, looping) {
	camera_set_shake(shake_x, shake_y, frames, looping);
	cutscene_end_action();
}

function camera_set_shake(shake_x, shake_y, frames, looping) {
	o_camera.shake_x = shake_x;
	o_camera.shake_y = shake_y;
	o_camera.shake_timer.set_duration(frames);
	o_camera.shake_timer.looping = looping;
	o_camera.shake_timer.start();
}

function cutscene_camera_reset_shake() {
	camera_reset_shake();
	cutscene_end_action();
}

function camera_reset_shake() {
	o_camera.shake_x = 0;
	o_camera.shake_y = 0;
	o_camera.shake_timer.current_count = 0;
	o_camera.shake_timer.looping = false;	
}

//0 = fade in, 1 = fade out
function cutscene_camera_set_fade(in_or_out, frames, room_id) {
	o_camera.fade_type		= in_or_out;
	o_camera.fade_timer		= frames;//(_event_data[1] == -1 ? -1 : (string_digits(_event_data[1]) * o_camera.maxTime));
	o_camera.maxTime		= frames == -1? 45 : frames;	
	o_camera.target_room_id = room_id;
	
	cutscene_end_action();
}

function cutscene_camera_fade_and_hold(fade_frames, hold_frames, room_id){
	with (o_camera) {
		fade_type = fade.out;
		fade_timer = fade_frames;
		hold_fade_timer = fade_frames + hold_frames;
		target_room_id = room_id;
		
	}
	cutscene_end_action();
}

function cutscene_camera_hold_fade(frames) {
	with (o_camera) {
		hold_fade_timer = frames;
	}
	
	cutscene_end_action();
}

function camera_set_target_helper(target_anchor_name) {
	var target_anchor = noone;					// if none were found, the camera's cutscene target = noone
	
	// search for characters which might be pointed to first
	with (o_cellobj_character_parent) {
		if id == target_anchor_name {
			target_anchor = id;
			break;
		}
	}
	
	if target_anchor == noone {
		// and it returns to its lower-priority behaviors
		with(o_camera_anchor) {
			if anchor_name == target_anchor_name {
				target_anchor = id;
				break;
			}
		}
	}
	
	
	camera_set_target(target_anchor);
	
	return target_anchor;
}

function camera_set_target(obj) {
	with(CAMERA) {
		cutscene_target = obj;
	}
}