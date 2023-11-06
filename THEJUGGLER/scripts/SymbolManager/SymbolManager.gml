function SymbolManager() constructor {
	active_symbols = [];
	
	static get_num_symbols = function() {
		return array_length(active_symbols);
	}
	
	static generate_symbol_from_level_data = function(level_data) {
		var chosen_symbol_value = array_pick_random(level_data.allowed_symbols);
		var symbol = new Symbol(chosen_symbol_value);
		return symbol;
	}
	
	static add_symbol = function(symbol) {
		array_push(active_symbols, symbol);
	}
	
	static pop_symbol = function(index=0) {
		var symbol = active_symbols[index];
		array_delete(active_symbols, index, 1);
		return symbol;
	}
	
	static get_concat_symbols_string = function() {
		var concat_symbols_string = "";
		var num_symbs = get_num_symbols();
		for (var i = 0; i < num_symbs; i++) {
			concat_symbols_string += active_symbols[i].to_string();
		}
		
		return concat_symbols_string;
	}
	
	static kill_first_symbol_of_value = function(value) {
		var value_index = -1;
		var removed_symbol = -1;
		var num_symbs = get_num_symbols();
		for (var i = 0; i < num_symbs; i++) {
			if active_symbols[i].literal_value == value {
				value_index = i;
				break;
			}
		}
		
		if value_index != -1 {
			removed_symbol = pop_symbol(value_index);
		}
		
		return removed_symbol;
	}
		
	static clear_symbols = function() {
		active_symbols = [];
	}
}