freaking_out = false;

offset_draw = vector_zero();
shake_intensity = new Vector2(5, 5);
shake_intensity_factor = 0;

temp_offset_draw = vector_zero();
temp_shake_intensity = new Vector2(0, 0);
temp_shake_timer = new Timer(1, false, function() {
	with (o_watch_hand) {
		temp_offset_draw = new Vector2(0, 0);
	}
});

temp_shake_timer.start();

///@param {Struct.Vector2} intensity
///@param Int frames
function start_shake(intensity, frames) {
	if !temp_shake_timer.is_done() {
		// add a factor of the new shake
		temp_shake_intensity = temp_shake_intensity.mult_add(intensity, 0.5);
	} else {		
		temp_shake_intensity = intensity.copy();
	}
	
	temp_shake_timer.set_and_start(max(temp_shake_timer.current_count, frames));
}

angle_offset = 0;
angle_offset_max = 0.5;

layer_id_colorize = layer_get_id("Colorize_Hand");
layer_fx_colorize = layer_get_fx(layer_id_colorize);
layer_colorize_params = fx_get_parameters(layer_fx_colorize);

layer_id_distort = layer_get_id("Distort_Hand");
layer_fx_distort = layer_get_fx(layer_id_distort);
layer_distort_params = fx_get_parameters(layer_fx_distort);