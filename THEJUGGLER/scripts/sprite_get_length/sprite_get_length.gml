
///@description Returns the duration in frames of the sprite's playback.
///For example, 4 images at 15 fps is 4 * (60/15) frames
function sprite_get_duration(spr){
	return get_frames(sprite_get_number(spr) / sprite_get_speed(spr));
}

// images / (images/second) = seconds