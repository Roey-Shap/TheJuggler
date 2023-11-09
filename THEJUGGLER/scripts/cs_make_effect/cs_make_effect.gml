///@description scr_cutscene_textbox

// this function is run by the cutscene object, which should take its "parent" information from the *interact object* that created it
// then, that interact object can be referenced by the textbox in its use of [destroy] and other Events
function cs_make_effect(sprite, x_percent, y_percent) {
	var fx = new SpriteFX(CAMERA.x + (BASE_W * x_percent),
						   CAMERA.y + (BASE_H * y_percent),
						   sprite, 1);
	fx.loop = true;
	fx.cutscene_effect = true;
	
	cutscene_end_action();
}
