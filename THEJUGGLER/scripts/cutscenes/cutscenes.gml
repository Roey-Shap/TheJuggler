function cutscenes_init() {
	speaker_data = [
		(new Speaker("Player", new Vector2(0.7, 0.8), fnt_player))
			.set_textbox_direction(new Vector2(3, 2)),
		(new Speaker("Thought", new Vector2(0.7, 0.8), fnt_player))
			.set_textbox_sprite(spr_textbox_neutral_nineslice)
			.set_textbox_direction(new Vector2(3, 2)),
		(new Speaker("Other", new Vector2(0.7, 0.3), fnt_other))
			.set_textbox_direction(new Vector2(3, -2)),
		(new Speaker("None", new Vector2(0.5, 0.5), fnt_other))
			.set_textbox_sprite(spr_textbox_neutral_nineslice)
			.set_textbox_direction(new Vector2(3, 2)),
		(new Speaker("Witch", new Vector2(0.75, 0.2), fnt_witch))
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
		]],
		//[cutscene_custom_action, function() {
		//	with (o_manager) {
		//		obscure_screen_alpha_target = 1;
		//	}
		//}],
		//[cs_text, [
		//	"1",
		//]],
		//[cutscene_custom_action, function() {
		//	with (o_manager) {
		//		obscure_screen_alpha_target = 0.5;
		//	}
		//}],
		//[cs_text, [
		//	"2",
		//]],
		//[cutscene_custom_action, function() {
		//	with (o_manager) {
		//		obscure_screen_alpha_target = 0;
		//	}
		//}],
		//[cs_text, [
		//	"3",
		//]],
	], false);
	
	cs_deac = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0;
			}
		}], 
	], false);
	
	cs_see_score_rise = new CutsceneData([
		[cs_set_speaker, "Player"],
		[cs_text, [
			"Oh! Guess that's my score there on the left...",
		]]
	], false);
	
	cs_get_watch_from_seller = new CutsceneData([
		[cs_fade, fade_type.indefinite, 1],
		[cutscene_play_sound, snd_bell_ring, SND_PRIORITY_FX, false],
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
	
	cs_try_again_reluctant = new CutsceneData([
		[cs_set_speaker, "Thought"],
		[cs_text, [
			"([slant]I... need to try again.)",
		]]
	], true);
	
	cs_try_again_glitch = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 1;
			}
		}],
		[cs_wait, get_frames(1)],
		[cs_set_speaker, "Thought"],
		[cs_text, [
			"([slant]I... can't give up!)",
		]],
		[cs_wait, get_frames(0.5)],
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0;
			}
		}],
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
		[cutscene_custom_action, function() {
			with (o_manager) {
				audio_sound_gain(background_music, 0.2, 10 * 1000);
				obscure_screen_alpha_target = 0.5;
			}
		}],
		[cs_text, [
			"[speed,0.8]IN THAT MOMENT, YOU REALIZE.",
			"[speed,0.8]WHEREVER YOU GO, YOU LOOK ELSEWHERE.",
			"[speed,0.8]AT DINNER, AT YOUR PHONE.\nIN CLASS, AT THE SKY.",
			"[speed,0.8]AND IN YOUR MEETINGS... YOU DREAM.",
			"[speed,0.8]YOU MULTITASK. NEVER STAYING IN ONE PLACE. ALWAYS JUGGLING MANY THINGS.",
			"[speed,0.8]YES. YOU KNEW IT ALL ALONG. THIS IS WHO YOU ARE.",
			"[speed,0.8]YOU ARE      [delay,1000]THE JUGGLER[set_juggler_emotion,reset]",
		]],
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0;
			}
		}],
	], true);
	
	cs_weirded_out_by_shapes = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				create_symbol();
			}
			
			use_event(events.start_playing_combo_noises);
		}],
		[cs_set_speaker, "Player"],
		[cs_text, [
			"[slant](Wait... huh?)"
		]],
		[cs_wait, get_frames(2)],
		[cs_text, [
			"[slant](Isn't this thing an LCD display?)",
			"[slant](How can something with numerical digits render shapes...)",
			"[slant](Did I get ripped off??? Ugh.)",
			"[slant](... guess I'll finish this game.)"
		]],
	], true);
	
	cs_butterfly_and_player = new CutsceneData([
		[cs_wait, get_frames(2)],
		[cutscene_custom_action, function() {
			var anchor = inst_anchor_butterfly;
			instance_create_layer(anchor.x, anchor.y, LAYER_WATCH_DISPLAY, o_butterfly);
		}],
		[cs_wait, get_frames(3)],
		[cs_set_speaker, "Thought"],
		[cs_text, [
			"[slant](!?)",
			"[slant](No, no. I'm seeing things now. This thing can't display color.)",
			"[slant](Either that or this is the most elaborate prank of all time...)",
			"[slant](I've gotta go find that old shopkeep. This is way more important than this stupid meeting.)",
		]],
		//[cs_set_mouse_towards, inst_button_mode],
		// do clicking things
		[cs_wait, get_frames(0.5)],
		[cs_wait, get_frames(0.05)],
		[cs_text, [
			"[slant][shakehand_moment,5,5,35](!?)",
			"[slant](... why won't my hand move?)",
		]],
		[cutscene_custom_action, function() {
			with (o_manager) {
				set_music_track(snd_music_something_is_not_right);
			}
		}],	
		[cs_text, [
			"[slant][shakehand,0.75]([scale,2]!??![scale,1])",
			"[slant](And I can't get up? I can't look up! I can't speak!)",
			"[slant](HELP! SOMEBODY HELP!!)",
		]],
		[cs_wait, get_frames(0.5)],
		[cutscene_custom_action, function() {
			with (o_player) {
				draw_hp_as_text = false;
				hp_max = hp_second_wave;
				hp = hp_max;
				//been_take_from_GUI = true;
			}
			
			with (o_manager) {
				repeat(16) {
					var offset_x = choose(-1, 1) * irandom_range(4, 12);
					var offset_y = irandom_range(-10, 2);
					var spr = choose(spr_fx_dust_1, spr_fx_dust_2, spr_fx_dust_3);
					var fx = new SpriteFX(title_position.x + offset_x, title_position.y + offset_y, spr, 1);
					fx.image_angle = irandom(359);
					var dir = fx.image_angle;
					var spd = random_range(0.25, 2.5);
					fx.alpha_fade_with_time = true;
					fx.image_speed = random_range(0.8, 1);
					fx.hspd = lengthdir_x(spd, dir);
					fx.vspd = lengthdir_y(spd, dir);
					fx.image_blend = array_pick_random(concat_arrays([c_white], global.c_magic_colors));
				}
			}
		}],
		[cs_text, [
			"[slant][set_juggler_emotion,scared](Why do I suddenly feel so small...)",
			"[slant][set_juggler_emotion,dismiss][shakehand,0.15](It's a dream. It's a dream!)",
			"[slant][set_juggler_emotion,scared](Oh, god... Please be a dream...)"
		]],
		[cutscene_custom_action, function() {
			set_juggler_emotion("knees");
		}],
		[cutscene_custom_action, function() {
			with (o_manager) {
				eyes_may_open = true;
			}
		}],
	], true);
	
	//cs_platforming_failure_1 = new CutsceneData([
	//	[cs_text, [
	//		"Well... that was weird. Guess I'll just-",
	//		"Why can't I turn it off?",
	//	]]
	//], false);
	
	cs_set_creepy_music = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				set_music_track(snd_music_spooky_1);
				
				background_music = audio_play_sound(snd_music_spooky_2, SND_PRIORITY_MUSIC, true, 0);
				if !watch_platforming_growth_perform_transition {
					watch_platforming_growth_perform_transition = true;
					watch_growth_transition_timer.start();
				}
			}
		}],	
	], false);
	
	cs_set_creepy_music_mid = new CutsceneData([
				[cutscene_custom_action, function() {
			with (o_manager) {
				audio_sound_gain(background_music, 0.4, 10 * 1000);
			}
		}],
	], false);
	
	cs_set_creepy_music_06 = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				audio_sound_gain(background_music, 0.6, 6 * 1000);
			}
		}],
		[cs_text, [
			"([slant][speaker,Thought]Maybe this isn't a dream. But still... I'm alive, aren't I?)",
			"([slant][set_juggler_emotion,dismiss]No... I'm definitely going to die, aren't I.)",
			"([slant][set_juggler_emotion,excited]Maybe this is actually a quest!! And there's some secret this watch holds...!)",
			"([slant][set_juggler_emotion,excited]Yeah! I'm the hero of this quest! I'm literally inside a video game, right?)",
			"([slant][set_juggler_emotion,reset]Alright, let's get to the bottom of this!)",
		]]
	], true);
	
	cs_set_creepy_music_08 = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				audio_sound_gain(background_music, 0.8, 5 * 1000);
			}
		}],
		[cs_text, [
			"([slant][speaker,Thought]... maybe I'm, like, a natural juggler now.)",
			"([slant]Huh. Always wanted to juggle. Neat.)",
		]]
	], false);
	
	cs_end_of_platforming_intro_level = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0.25;
			}
		}],
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"So you've made it... To the center of this curse!!",
		]],
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0.5;
			}
		}],
		[cs_wait, get_frames(0.25)],
		[cutscene_custom_action, function() {
			o_manager.start_next_level();
			//if get_level_data().level_type == eLevelType.platforming {
			//	o_manager.place_player_for_normal_gameplay();
			//	//player.x = o_screen.bbox_left + (o_screen.sprite_width/2);
			//	//player.y = o_screen.bbox_top + (o_screen.sprite_height * 0.1);
			//	//create_player_platform();
			//}
		}],
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0;
			}
		}],
	], false);
	
	cs_witch_intro = new CutsceneData([
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
			"You're stuck here with me, [mystery]The Witch[/mystery], and-!",
			"([speaker,Player][slant]Hey, so, uh, I guess you're what's cursed this watch. But can I ask a question?)",
			"[speaker,Witch][scale,1.5]Ahem!!![/scale][delay,100]I was [delay,250][scale,1.3]monologuing[/scale]. Rude.",
			"([speaker,Player][slant]Where am I? What do you want from me?)",
			"[speaker,Witch]That's for -heh- me to know! Let's see how you deal with these symbols! [wave]Kekekeh!!",
		]],
		[cutscene_play_sound, snd_witch_laugh_1, SND_PRIORITY_FX + 1, false],
		[cs_wait, get_frames(1.5)],
		//[cs_create_fx_scaling_with, o_witch, spr_fx_witch_explosion, 1, new Vector2(1.05, 1.05), new Vector2(10, 10)],
		//[cs_text, [
		//	"Be careful when you clear them! They're quite... [c_red]explosive[/c]!! [wave]Kekeke!!"
		//]]
	], true);
	
	cs_witch_explains_exploding_symbols = new CutsceneData([
		[cutscene_custom_action, function() {
			with (o_witch) {
				defaulting_to_neutral = true;
			}
		}],
		[cs_wait, get_frames(1)],
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"So you're resilient, eh!?",
			"[speaker,Player][set_juggler_emotion,excited]Heh. Yeah.",
			"[speaker,Witch]Your soul, stuck in this [speed,0.4]little Juggler form[speed,1]...",
			"There was another, long ago, but I like you MUCH better.",
			"Now in this NEXT level... when you clear symbols, they'll [c_red]expl-",
			"[set_juggler_emotion,reset]([speaker,Player][slant]Hi!! Question. I'm not the first one in here?)",
			"([slant]I'm not, like, destined to defeat you?",
			"[speaker,Witch]What? No, honey, get in line. I've been in, like, six watches already.",
			"([speaker,Player][slant]Huh.)",
			"[speaker,Witch]*shrug*",
			"([speaker,Player][slant]Well, this watch is MINE! Beat it!)",
			"[speaker,Witch]Is that so? Where was I... Oh, yes. Exploding symbols?",
			"Let them detonate and [c_red]bombs fall[/c]. [c_green]Clear them[/c] and [c_green]less[/c] fall. Capiche?",
			"[speaker,Player]Clearing symbols means less bombs. Sure.",
		]],
		[cutscene_custom_action, function() {
			audio_stop_all();
		}],
		[cs_text, [
			"Whatever it is... you're going DOWN, lady!",
			"[speaker,Witch]I'd like to see you try, Juggler man!",
		]],
		[cutscene_play_sound, snd_witch_laugh_1, SND_PRIORITY_FX + 1, false],
		[cs_wait, get_frames(1.5)],
		[cs_create_fx_scaling_with, o_witch, spr_fx_witch_explosion, 1, new Vector2(1.05, 1.05), new Vector2(10, 10)],
		[cutscene_custom_action, function() {
			with (o_manager) {
				obscure_screen_alpha_target = 0;
				set_music_track(snd_music_witch_fight_epic);
				audio_sound_gain(background_music, 0, 0.5 * 1000);

			}
		}],
	], true);
	
	cs_witch_3_intro = new CutsceneData([
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"[shake]Ouuughhh!![/shake] Now you've done it!",
			"You've passed the explosive spell and your soul is still writhing!",
			"My symbols! Why are you siding with [slant]him[/slant]?",
			"FINE! See if I care! You can all grant the Juggler strength...",
			"Let's see if they can clear you quickly enough to survive!",
		]],
	], true);
	
	cs_witch_final_level_intro = new CutsceneData([
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"This won't do, this won't do.... [delay,200][shake] AMP IT ALL UP TO [c_emph][scale,2]11[scale,1][/c]!!",
			"[mystery]Let's end this, here and now!",
		]],
		[cutscene_custom_action, function() {
			with (o_player) {
				hp_max = hp_second_wave;
				hp = hp_max;
			}
		}],
	], true);
	
	cs_witch_defeat = new CutsceneData([
		[cs_wait, get_frames(2)],
		[cutscene_custom_action, function() {
			audio_stop_all();
			with (o_witch) {
				start_shaking();
			}
		}],
		[cs_set_speaker, "Witch"],
		[cs_text, [
			"[shake]NO.... NO!!!!",
			"[shake]I HAVE BEEN... DEFEATED!",
			"[speaker,Player]Woot!!",
			"[speaker,Witch][shake]AND - [delay,200] COUGH [delay,200]- YOU WILL NOW RETURN TO YOUR LIFE...",
			"[speaker,Player].. yeah - oh, wait, aww.",
			"[speaker,Witch][shake]At... least... this... half-baked... game... is over...",
			"[speaker,Witch][shake]*bleh*",
		]],
		[cs_fade, fade_type.indefinite, 1],
		[cs_set_speaker, "None"],
		[cs_text, [
			"And so, the game had been won.",
			"The strange curse had been lifted. Or something.",
			"And the developer can go back to doing other things.",
			"Maybe he'll actually come back to polish this game like he wanted.",
			"Who knows.",
			"Now scram. Narrating's hard work.",
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

function set_juggler_emotion(name) {
	var spr = spr_player_frozen;
	var spr_map = {
		"scared" : spr_player_scared,
		"dismiss" : spr_player_dismissive,
		"neutral" : spr_player_frozen,
		"knees" : spr_player_knees,
		"excited" : spr_player_excited,
		"reset": -1,
	}
	
	spr = variable_struct_get(spr_map, name);
	o_player.special_sprite = spr;
}