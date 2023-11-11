
function draw_from_list(list, on_surface=false, draw_shadow=false){
	var len = ds_list_size(list);
	for (var i = 0; i < len; i++) {
		var cur = list[| i];
		cur.draw(o_manager.virtual_camera_corner, on_surface, draw_shadow);
	}
}

function fx_perform_step() {
	
	//foreach_list (global.lights_list, function(inst) {
	//	inst.step();
	//	//if !instance_exists(inst.parent) {
	//	//	db_show(inst.parent_name);
	//	//}
	//});

	if ds_exists(global.TextFX_list_all, ds_type_list) {
		for (var i = 0; i < ds_list_size(global.TextFX_list_all); i++) {
			var cur = global.TextFX_list_all[| i];
			// if one died this frame then move i backwards one to account for that			
			i -= cur.step();
		}
	}

	if ds_exists(global.sprite_FX_list_all, ds_type_list) {
		for (var i = 0; i < ds_list_size(global.sprite_FX_list_all); i++) {
			var cur = global.sprite_FX_list_all[| i];
			// if one died this frame then move i backwards one to account for that
			if is_instanceof(cur, FadeFX) {
				cur.update_alpha();
			}
			i -= cur.step();
		}
	}
	}

function FX_init(){
	//enum effects {
	//	circle,
	//	LAST
	//}
	
	global.sprite_FX_lists = [
		"sprite_FX_list_over", 
		"sprite_FX_list_under", 
		"sprite_FX_list_all",
		"sprite_FX_list_GUI_over"
	];
	
	var len = array_length(global.sprite_FX_lists);
	for (var i = 0; i < len; i++) {
		if !variable_global_exists(global.sprite_FX_lists[i]) {
			variable_global_set(global.sprite_FX_lists[i], ds_list_create());
		}
	}
	
	
	TextFX_init();
	//Lights_init();
}



function TextFX_init(){
	//enum effects {
	//	circle,
	//	LAST
	//}
	
	global.TextFX_lists = [
		"TextFX_list_over", 
		"TextFX_list_under", 
		"TextFX_list_all",
		"TextFX_list_GUI_over"
	];
	var len = array_length(global.TextFX_lists);
	for (var i = 0; i < len; i++) {
		if !variable_global_exists(global.TextFX_lists[i]) {
			variable_global_set(global.TextFX_lists[i], ds_list_create());
		}
	}
}

function Lights_init() {
	global.lights_list = ds_list_create();
}

function Lights_clean_up() {
	//if ds_exists(global.lights_list, ds_type_list) {
	//	ds_list_destroy(global.lights_list);
	//}
}

function reset_FX_lists(recreate=true) {
	var len = array_length(global.sprite_FX_lists);
	for (var i = 0; i < len; i++) {
		var glob = variable_global_get(global.sprite_FX_lists[i]);
		
		if ds_exists(glob, ds_type_list) {
			ds_list_destroy(glob);
		}
		
		if recreate {
			variable_global_set(global.sprite_FX_lists[i], ds_list_create());
		}
	}
	
	reset_text_FX_lists(recreate);
}




function reset_text_FX_lists(recreate=true) {
	var len = array_length(global.TextFX_lists);
	for (var i = 0; i < len; i++) {
		var glob = variable_global_get(global.TextFX_lists[i]);
		if ds_exists(glob, ds_type_list) {
			ds_list_destroy(glob);
		}
		
		if recreate {
			variable_global_set(global.TextFX_lists[i], ds_list_create());
		}
	}
}

function make_damage_fx(instance, damage_dealt) {
	var mess = new BattleMessage(-damage_dealt, "", battle_message_type.hp);
	instance.battle_message_queue.add_message(mess);
	var cam_pos = get_inst_pos_camera(instance);
	
	var life_random = random_range(0.5, 0.9);
	var hspd_random = choose(-1, 1) * random_range(0.65, 1);
	var vspd_random = random_range(-1.5, -0.8);
	
	var FX = new TextEffect(cam_pos.x, cam_pos.y - TILE_SIZE * V_SQUASH / 2, "[spr_icon_health_small]", life_random);
	FX.set_velocity(hspd_random, vspd_random).set_gravity(0, 0.011);
	
	//return FX;
}


function make_energy_fx(instance, energy_gained) {
	var mess = new BattleMessage(energy_gained, "", battle_message_type.energy);
	instance.battle_message_queue.add_message(mess);
	var cam_pos = get_battle_pos_camera(instance.battle_x, instance.battle_y);
	var FX = new TextEffect(cam_pos.x, cam_pos.y - TILE_SIZE * V_SQUASH / 2, "[spr_icon_energy_medium]", 0.9);
	FX.set_velocity(random_range(-0.4, 0.4), random_range(-0.9, -0.4)).set_gravity(0, 0.003);
	FX.set_color(c_lime);
	
	//return FX;
}


function make_health_gain_fx(instance, hp_gained) {
	var mess = new BattleMessage(hp_gained, "", battle_message_type.hp);
	instance.battle_message_queue.add_message(mess);
	var cam_pos;
	if o_manager.in_battle() {
		cam_pos	= get_battle_pos_camera(instance.battle_x, instance.battle_y);
		cam_pos.y -= TILE_SIZE * V_SQUASH / 2;
	} else {
		cam_pos = get_overworld_coords(instance);
	}
	var FX = new TextEffect(cam_pos.x, cam_pos.y, "[spr_icon_health_small]", 0.9);
	FX.set_velocity(random_range(-0.4, 0.4), random_range(-0.9, -0.4)).set_gravity(0, 0.003);
	FX.set_color(c_lime);
		
	//	return FX;
	//}
}

function make_broke_fx(instance, owner) {
	var mess = new BattleMessage(-1, sfmt("[%,0] broke", sprite_get_name(instance.sprite_index)), battle_message_type.item_death);
	owner.battle_message_queue.add_message(mess);
	//var cam_pos;
	//if o_manager.in_battle() {
	//	cam_pos	= get_battle_pos_camera(owner.battle_x, owner.battle_y);
	//	cam_pos.y -= TILE_SIZE * V_SQUASH / 2;
		
	//} else {
	//	cam_pos = get_overworld_coords(owner);
	//	var FX = new TextEffect(cam_pos.x, cam_pos.y, sfmt("[%] broke", sprite_get_name(instance.sprite_index)), 1.5);
	//	FX.set_velocity(random_range(-0.4, 0.4), random_range(-0.9, -0.4)).set_gravity(0, 0.003);
	//	FX.set_color(c_white);
	
	//	return FX;
	//}

}

function make_insufficient_space_for_unequipped_item_fx() {
	var camera_space_pos;
	if o_manager.in_battle() {
		camera_space_pos = get_battle_pos_camera(PLAYER.battle_x, PLAYER.battle_y);
	} else {
		camera_space_pos = get_overworld_coords(PLAYER);
	}
	
	var fx = make_general_text_fx(camera_space_pos, "Not enough space [scale,0.5][spr_inventory_space_icon][scale,1] to hold unequipped item.", 0, -0.1, 2);
	fx.color = c_white;
	fx.color2 = c_black;
	o_manager.do_bag_shake();
}



function make_general_text_fx(cam_pos, text, hspd, vspd, life) {
	var life_random = random_range(0.5, 0.9);
	var hspd_random = random_range(-0.4, 0.4);
	var vspd_random = random_range(-0.7, 0);
	
	var FX = new TextEffect(cam_pos.x, cam_pos.y - TILE_SIZE * V_SQUASH / 2, text, life_random);
	FX.set_velocity(hspd_random, vspd_random).set_gravity(0, 0.011);
	
	return FX;
}


function fx_setup_screen_layer(fx) {
	fx.draw_on_surface = o_manager.get_level_data().level_type == eLevelType.sidescrolling;
}




