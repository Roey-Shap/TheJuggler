function cutscenes_init() {
	speaker_data = [
		(new Speaker("Player", new Vector2(0.7, 0.8), fnt_player))
			.set_textbox_direction(new Vector2(3, 2)),
		(new Speaker("Other", new Vector2(0.7, 0.3), fnt_other))
			.set_textbox_direction(new Vector2(3, -2)),
		(new Speaker("None", new Vector2(0.5, 0.5), fnt_other))
			.set_textbox_sprite(spr_textbox_neutral_nineslice)
			.set_textbox_direction(new Vector2(3, 2)),
		(new Speaker("Witch", new Vector2(0.65, 0.2), fnt_witch))
			.set_textbox_angle(-90)
			.set_textbox_direction(new Vector2(2, 3)),
	];
	
	//cs_game_start = new CutsceneData([
	//	[cutscene_custom_action, function() {
	//		with (o_manager) {
	//			state_game = st_game_state.playing;
	//			start_next_level();
	//		}
	//	}],
	//], false);
	
	cs_start_game = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"There we go! [c_emph]Match the numbers[/c], he said...",
		]]
	], false);
	
	cs_get_watch_from_seller = new CutsceneData([
		[cs_fade, fade_type.indefinite, 1],
		[cutscene_play_sound, snd_bell_ring, SND_PRIORITY_FX, false],
		[cs_set_speaker, "None"],
		[cs_text, [
			"[mystery]Spooookkky.... This is the end for you....",
		]],
		[cs_set_speaker, "Other"],
		[cs_text, [
			"... oh, hello, yes! .... one second!",
		]],
		[cs_wait, get_frames(0.5)],
		[cs_text, [
			"[speaker,Other]Hello there! What can I do ya for?",
			"[speaker,Player]I was actually thinking of getting a watch.",
			"Not anything too modern, obviously. Wouldn't have come here if I were.",
			"[speaker,Other]I see... A man of culture! Come in, come in! I've got just the thing!",
		]],
		[cs_wait, get_frames(0.75)],
		[cs_text, [
			"[speaker,None]Some time later...",
		]],
		[cs_fade, fade_type.from_black, get_frames(1)],
		[cs_text, [
			"[speaker,Other]Welcome to your new Tasionic! It has a variety of features!",
			"Its face buttons allow you to calculate various things, and, of course, it lets you tell the time.",
			"But I'll let you in on a little secret - it's got [c_emph]a game[/c] for those especially boring meetings.",
			"You can't hide your amusement under that businessman suit and tie! Here...",
			"Just press that [c_emph]button on the left[/c] there and you'll have a little something to keep your mind offa' spreadsheets.",
			"... anyway. How you spend your meetings ain't none of my business.",
			"[speaker,Player]How's it work? The game, I mean.",
			"[speaker,Other]Oh, it's just a [c_emph]number matching game[/c]. But you'll figure it out.",
			"Have a good day, sir.",
		]],
		[cs_fade, fade_type.indefinite, get_frames(1)],
		[cs_wait, get_frames(1)],
		[cs_set_speaker, "None"],
		[cs_text, [
			"[speaker,None](Later, at the meeting.)"			
		]],
		[cs_fade, fade_type.from_black, get_frames(0.5)],
		[cs_set_speaker, "Player"],
		[cs_text, [
			"[speaker,Player][slant](Don't look at the clock. Don't. [delay,200]Look. [delay,200]At. [delay,200]The- ugh god DAMN.)",
			"([slant]Six minutes???)",
			"([slant]Do they [/slant]want[slant] these meetings to go on forever?)",
			"([slant]!!\n I have the watch! Genius!)",
			"([slant][wave]Heh heh.[/wave] Well, Andrew, it pays to be prepared.)",
			"([slant]I knew those survival classes would pay off! I shall survive this meeting!!",
			"([slant]Let's see. How does this thing work again? Button on the left, he said...)",
		]],
		[cutscene_custom_action, function() {
			with (o_manager) {
				state_watch = eWatchState.time;
			}
		}],
	], true);
	
	cs_numbers_fast_start = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"([slant]Alright, not too bad...)",
		]]
	], true);
	
	cs_numbers_getting_harder = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"[slant](Getting a little harder...)",
		]]
	], false);
	
	cs_try_again = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"([slant]Again!)",
		]]
	], true);
	
	cs_player_becomes_juggler = new CutsceneData([
		[cs_text, [
			"[mystery]Aahhhh, yes.",
			"[mystery]You've been here a while, haven't you?",
			"[mystery]At the start, it was measly fascination. But now...",
			"[mystery]Heh heh. Now, you're MINE.",
			"[mystery]You thought you'd just get out of your meetings with no consequences? BAH!",
			"[mystery]Cool Watches[tm] aren't something to be taken lightly, FOOL.",
			"[mystery]Everybody knows... the spiffier the watch, the more likely it is to be cursed!!",
			"[mystery]And this watch...",
			"[mystery]Ha.. ha.. This watch has some SERIOUS SPIFF.",
			"[mystery]THERE'S NO ESCAPE!! FWEEEE HEHEHEHEHE!",
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
	
	cs_set_creepy_music = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				set_music_track(snd_music_spooky_1);
				
				background_music = audio_play_sound(snd_music_spooky_2, SND_PRIORITY_MUSIC, true, 0);
			}
		}],	
	], false);
	
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
	
	cs_witch_explains_exploding_symbols = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_witch) {
				defaulting_to_neutral = true;
			}
		}],
		[cs_wait, get_frames(1)],
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"Ho ho! You'll never break free, don't you see?",
			"This curse was placed by me, and another spell shall be:",
			"These symbols are enchanted, and... I ran out of rhymes.",
			"Anyway!! [delay,100]Let's see how you deal with these symbols!",
		]],
		[cutscene_play_sound, snd_witch_laugh_1, SND_PRIORITY_FX + 1, false],
		[cs_wait, get_frames(1.5)],
		[cs_create_fx_scaling_with, o_witch, spr_fx_witch_explosion, 1, new Vector2(1.05, 1.05), new Vector2(10, 10)],
		[cs_text, [
			"Be careful when you clear them! They're quite... [c_red]explosive[/c]!! [wave]Kekeke!!"
		]]
	], true);
	
	cs_witch_final_level_intro = new CutsceneData([
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"[shake]Ouuughhh!![/shake] Now you've done it!",
			"You've passed the explosive spell and your soul is still writhing!",
			"This won't do, this won't do.... [delay,200][shake] AMP IT ALL UP TO 11!!",
		]],
	], true);
}

function CutsceneData(_scene, _freeze_game) constructor {
	scene = _scene;
	freeze_game = _freeze_game;
	times_played = 0;
	
	static play = function(parent=noone) {
		if scene == -1 {
			return;
		}
		
		times_played += 1;
		create_cutscene(scene, parent, freeze_game);
	}
	
	static been_played = function() {
		return times_played > 0;
	}
}

function Speaker(_name, _textbox_position, _font) constructor {
	name = _name;
	textbox_position = _textbox_position;
	font = font_get_name(_font);
	textbox_sprite = spr_textbox_nineslice;
	update_function = -1;
	textbox_direction = new Vector2(1, 1);
	textbox_angle = 0;
	
	static set_update_function = function(f) {
		update_function = f;
		return self;
	}
	
	static set_textbox_direction = function(vec) {
		textbox_direction = vec;
		return self;
	}
	
	static set_textbox_angle = function(angle) {
		textbox_angle = angle;
		return self;
	}
	
	static set_textbox_sprite = function(spr) {
		textbox_sprite = spr;
		return self;
	}
	
	static step = function() {
		if update_function != -1 {
			update_function();
		}
	}
}