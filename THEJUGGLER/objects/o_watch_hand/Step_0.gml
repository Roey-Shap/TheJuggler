offset_draw = shake_intensity.multiply(choose(1, -1) * shake_intensity_factor);
angle_offset = shake_intensity_factor * random_range(-angle_offset_max, angle_offset_max);

temp_offset_draw = temp_shake_intensity.multiply(choose(1, -1)).lerp_to(vector_zero(), temp_shake_timer.get_percent_done());


if layer_exists(layer_id_colorize) {
	/*
	g_Intensity (Real)
g_TintCol (Array)
_filter_colourise
	*/
	
	layer_colorize_params.g_Intensity = lerp(layer_colorize_params.g_Intensity, shake_intensity_factor, 0.01);

	// Apply updated parameters struct to the FX struct
	fx_set_parameters(layer_fx_colorize, layer_colorize_params);
}

if layer_exists(layer_id_distort) {
	layer_distort_params.g_DistortAmount = lerp(layer_distort_params.g_DistortAmount, 512 * shake_intensity_factor / 2, 0.01);
	layer_distort_params.g_DistortScale = map(-1.3, 1.3, sin(current_time/200) + 0.3 * sin(current_time/60), 32 * shake_intensity_factor, 0.01);
	fx_set_parameters(layer_fx_distort, layer_distort_params);
}

temp_shake_timer.tick();