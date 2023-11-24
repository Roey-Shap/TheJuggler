function SymbolManager() constructor {
	active_symbols = [];
	queued_charge_symbols = 0;
	
	static get_num_symbols = function() {
		return array_length(active_symbols);
	}
	
	static generate_symbol_from_level_data = function(level_data) {
		var chosen_symbol_value = array_pick_random(level_data.allowed_symbols);
		if o_manager.get_level_data().charging_level and queued_charge_symbols > 0 {
			chosen_symbol_value = symbol_type.charged;
			queued_charge_symbols -= 1;
		}
		
		var symbol = generate_symbol(chosen_symbol_value);
		return symbol;
	}
	
	static generate_symbol = function(value) {
		var symbol_struct = new Symbol(value);
		var symbol = instance_create_layer(0, 0, LAYER_WATCH_DISPLAY, o_symbol);
		symbol.set_symbol(symbol_struct);
		return symbol;
	}
	
	static add_symbol = function(symbol) {
		var sw = symbol.sprite_width;
		var sh = symbol.sprite_height;
		var num_symbols = get_num_symbols();
		for (var i = 0; i < num_symbols; i++) {
			var inst = active_symbols[i];
			inst.x -= sw;
		}
		
		var inst_screen = instance_nearest(0, 0, o_screen);
		var screen_up_left = new Vector2(inst_screen.bbox_left, inst_screen.bbox_top);
		var screen_dimensions = new Vector2(inst_screen.sprite_width, inst_screen.sprite_height);
		var screen_down_right = screen_up_left.add(screen_dimensions);
		if o_player.platforming_active {
			screen_down_right = get_pos(inst_anchor_screen_bottom_right);
		}
		
		symbol.x = screen_down_right.x - sw;
		symbol.y = screen_down_right.y - sh;
		
		array_push(active_symbols, symbol);
		update_symbols_of_relation();
	}
	
	static pop_symbol = function(index=0) {
		var symbol = active_symbols[index];
		array_delete(active_symbols, index, 1);
		update_symbols_of_relation();
		return symbol;
	}
	
	static queue_charged_symbol = function() {
		queued_charge_symbols += 1;
	}
	
	static update_symbols_of_relation = function() {
		array_foreach(active_symbols, function(inst, index) {
			with (inst) {
				symbol_manager_index = index;
			}
		});
	}
	
	static get_concat_symbols_string = function() {
		var concat_symbols_string = "";
		var num_symbs = get_num_symbols();
		for (var i = 0; i < num_symbs; i++) {
			concat_symbols_string += active_symbols[i].to_string();
		}
		
		return concat_symbols_string;
	}
	
	static draw_symbols = function() {
		array_foreach(active_symbols, function(inst) {
			inst.draw_custom(new Vector2(0, 0), true);
		});
		
		array_foreach(active_symbols, function(inst) {
			inst.draw_custom(new Vector2(0, 0), false);
		});
	}
	
	static kill_first_symbol_of_value = function(value, id_mode=false) {
		var value_index = -1;
		var removed_symbol = -1;
		var num_symbs = get_num_symbols();
		for (var i = 0; i < num_symbs; i++) {
			var symbol = active_symbols[i];
			if id_mode {
				if symbol == value {
					value_index = i;
					break;
				}
			} else if symbol.symbol_struct.literal_value == value and !symbol.is_stone {
				value_index = i;
				break;
			}
		}
		
		if value_index != -1 {
			if !o_manager.used_event(events.killed_symbol) {
				o_manager.use_event(events.killed_symbol);
				o_manager.cs_see_score_rise.play();
			}
			
			removed_symbol = pop_symbol(value_index);
			var symbol_struct = removed_symbol.symbol_struct;
			var symbol_width = removed_symbol.sprite_width;
			for (var i = value_index-1; i >= 0; i--) {
				active_symbols[i].x += symbol_width;
			}
			
			var level = o_manager.get_level_data();
			if level.killed_symbols_become_bullets {
				var spawn_pos = bbox_center(removed_symbol).iadd(new Vector2(0, removed_symbol.sprite_height/2));
				//o_manager.spawn_bullet_towards_player(spawn_pos);
				var bombs = o_manager.drop_bombs(1);				
			} else if level.charging_level {
				o_manager.add_charge();
			}

			removed_symbol.destroy_alt_anim_setup();
			instance_destroy(removed_symbol);
			return symbol_struct;
		}
		
		return noone;
	}
	
	static kill_closest_symbol_of_value = function(value, list) {
		var len = ds_list_size(list);
		for (var i = 0; i < len; i++) {
			var inst = list[| i];
			if inst.symbol_struct.literal_value == value and !inst.is_stone {
				instance_destroy(inst);
				return inst;
				break;
			}
		}
		
		return noone;
	}
		
	static clear_symbols = function() {
		array_foreach(active_symbols, function(inst) {
			inst.destroy_alt_anim_setup();
			instance_destroy(inst);
		});
		
		active_symbols = [];
	}
}