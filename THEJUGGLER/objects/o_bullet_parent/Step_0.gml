
manage_collision();

var sin_val = sin(current_time/400) + sin(current_time/300);
var scale = map(-2, 2, sin_val, 0.7, 1.3);
var scale2 = map(-2, 2, sin_val, 1.3, 0.7);
draw_scale.x = scale;
draw_scale.y = scale2;

x += hspd;
y += vspd;