function draw_sprite_fade(period_in_seconds, sprite, image_ind, _x, _y, xscale, yscale, rotation, blend, min_alpha, max_alpha)
{
	var modified_time = sin(2 * pi * current_time / (1000 * period_in_seconds));
	var alpha = map(-1, 1, modified_time, min_alpha, max_alpha);
	draw_sprite_ext(sprite, image_ind, _x, _y, xscale, yscale, rotation, blend, alpha);
}
