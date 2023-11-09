// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function cutscene_set_object_sprite(target_object, sprite){
	with(target_object) {
		set_sprite(sprite);
	}

	cutscene_end_action();
}

function cutscene_set_object_battle_idle(target_object, sprite) {
	with(target_object) {
		sprite_battle_idle = sprite;
		set_sprite(sprite);
	}

	cutscene_end_action();
}