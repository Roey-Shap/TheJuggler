
// Inherit the parent event
event_inherited();


var symbol = o_manager.symbol_manager.generate_symbol(symbol_type.zero + image_index);
symbol.x = x;
symbol.y = y;
symbol.is_stone = is_stone;
instance_destroy(id);