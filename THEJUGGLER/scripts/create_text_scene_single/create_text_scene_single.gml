// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function create_text_scene_single(text){
	return (create_text_scenes([[text]]));
}

function create_text_cutscene(text) {
	create_cutscene([
		[cs_text, text]
	]);
}