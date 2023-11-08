
//manage_collision();

var sin_val = sin(current_time/400) + sin(current_time/300);
var scale = map(-2, 2, sin_val, 0.9, 1.1);
image_xscale = scale;
image_yscale = scale;

x += hspd;
y += vspd;