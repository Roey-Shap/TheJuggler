var fx = new SpriteFX(x, y, spr_fx_bomb_explosion, 1);
fx_setup_screen_layer(fx);
fx.image_angle = irandom(359);
var s = random_range(0.95, 1.05);
fx.image_xscale = s;
fx.image_yscale = s;
fx.growth_scale.x = 1.005;