function cutscenes_init(){
	cs_player_becomes_juggler = new CutsceneData([
		[cs_text, [
			"Aahhhh, yes.",
			"You’ve been here a while, haven’t you?",
			"At the start, it was measly fascination. But now…",
			"Heh heh. Now, you’re MINE.",
			"You thought you’d just get out of your meetings with no consequences? BAH!",
			"Cool Watches™ aren’t something to be taken lightly, FOOL.",
			"Everybody knows… the spiffier the watch, the more likely it is to be cursed!!",
			"And this watch…",
			"Ha.. ha.. This watch has some SERIOUS SPIFF.",
			"THERE’S NO ESCAPE!! FWEEEE HEHEHEHEHE!",
		]],
		[cs_wait, get_frames(1)],
		[cs_text, [
			"[speed,0.8]IN THAT MOMENT, YOU REALIZE.",
			"[speed,0.8]WHEREVER YOU GO, YOU LOOK ELSEWHERE.",
			"[speed,0.8]AT DINNER, AT YOUR PHONE.\nIN CLASS, AT THE SKY.",
			"[speed,0.8]AND IN YOUR MEETINGS... YOU DREAM.",
			"[speed,0.8]THIS IS WHO YOU ARE. YOU MULTITASK. NEVER STAYING IN ONE PLACE.",
			"[speed,0.8]YES. YOU KNEW IT ALL ALONG.",
			"[speed,0.8]YOU ARE      [delay,1000]THE JUGGLER",
		]]
	], true);
	
	cs_end_of_platforming_intro_level = new CutsceneData([
		[cs_text, [
			"END OF LEVEL!!!",
		]],
		[cutscene_custom_action, function() {
			o_manager.start_next_level();
			if get_level_data().level_type == eLevelType.platforming {
				var player = instance_nearest(x, y, o_player);
				player.x = o_screen.bbox_left + (o_screen.sprite_width/2);
				player.y = o_screen.bbox_top + (o_screen.sprite_height * 0.1);
				create_player_platform();
			}
		}]
	], false);
}

function CutsceneData(_scene, _freeze_game) constructor {
	scene = _scene;
	freeze_game = _freeze_game;
	
	static play = function(parent=noone) {
		if scene == -1 {
			return;
		}
		
		create_cutscene(scene, parent, freeze_game);
	}
}