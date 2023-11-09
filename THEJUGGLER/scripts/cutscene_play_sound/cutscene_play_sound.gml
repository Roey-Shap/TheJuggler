// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_play_sound(sound, priority, loop){
	audio_play_sound(sound, priority, loop);
	cutscene_end_action();
}