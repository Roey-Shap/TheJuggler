scribble_element = -1;
text = "DEFAULT!";

function set_text(str) {
	text = str;
}

function set_text_witch(str) {
	set_text(sfmt("[c_lime][shake]", str));
}

function draw() {	
	scribble_element.draw(x, y);
}

draw_custom = function(pos) {
	scribble_element.draw(x + pos.x, y + pos.y);
}