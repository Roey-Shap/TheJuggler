
function fire_bullet(position, spd, dir) {
	var bullet = instance_create_layer(position.x, position.y, LAYER_WATCH_DISPLAY, o_bullet_basic);
	bullet.hspd = lengthdir_x(spd, dir);
	bullet.vspd = lengthdir_y(spd, dir);
	
	return bullet;
}