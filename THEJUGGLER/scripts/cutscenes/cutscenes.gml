function cutscenes_init() {
	speaker_data = [
		new Speaker("Player", new Vector2(0.7, 0.8), fnt_player),
		new Speaker("Other", new Vector2(0.7, 0.3), fnt_large_test),
		new Speaker("None", new Vector2(0.5, 0.5), fnt_large_test),
		(new Speaker("Witch", new Vector2(0.5, 0.2), fnt_witch))
			.set_update_function(function() {
				print("hi :)");
			}),
	];
	
	
	cs_get_watch_from_seller = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"[wave]Player test!",
			"Test 2 :3"
		]],
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"Mwahaha!!! This is the dastardly witch!!",
		]]
	], true);
	
	cs_numbers_fast_start = new CutsceneData([
		[cs_text, [
			"Alright, not too bad...",
		]]
	], true);
	
	cs_numbers_getting_harder = new CutsceneData([
		[cs_text, [
			"Getting a little harder...",
		]]
	], false);
	
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
			//if get_level_data().level_type == eLevelType.platforming {
			//	o_manager.place_player_for_normal_gameplay();
			//	//player.x = o_screen.bbox_left + (o_screen.sprite_width/2);
			//	//player.y = o_screen.bbox_top + (o_screen.sprite_height * 0.1);
			//	//create_player_platform();
			//}
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

function Speaker(_name, _textbox_position, _font) constructor {
	name = _name;
	textbox_position = _textbox_position;
	font = font_get_name(_font);
	update_function = -1;
	
	static set_update_function = function(f) {
		update_function = f;
		return self;
	}
	
	static step = function() {
		if update_function != -1 {
			update_function();
		}
	}
}