
manage_collision();

var sin_val = sin(current_time/200) + sin(current_time/100);
var scale = map(-2, 2, sin_val, 0.8, 1.2);
var scale2 = map(-2, 2, sin_val, 1.2, 0.8);
draw_scale.x = scale;
draw_scale.y = scale2;

x += hspd;
y += vspd;