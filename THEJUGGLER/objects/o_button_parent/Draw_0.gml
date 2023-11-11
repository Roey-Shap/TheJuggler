if pressed {
	image_blend = c_ltgray;
	scale_factor = 0.9;
} else {
	image_blend = c_white;
	scale_factor = lerp(scale_factor, 1, 0.4);
}
