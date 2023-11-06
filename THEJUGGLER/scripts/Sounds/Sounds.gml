function play_pitch_range(sound, min_pitch, max_pitch) {
	var snd = audio_play_sound(sound, SND_PRIORITY_FX, false);
	var ran_pitch = random_range(min_pitch, max_pitch);
	audio_sound_pitch(snd, ran_pitch);
	return snd;
}

function play_random_sound(sounds, min_pitch=1, max_pitch=1) {
	var snd_index = array_pick_random(sounds);
	return play_pitch_range(snd_index, min_pitch, max_pitch);
}