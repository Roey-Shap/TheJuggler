function cs_text_yes_no(text, yes_func, no_func) {
	var box = make_textbox(text);
	box.yes_func = yes_func;
	box.no_func = no_func;
}

function cs_text_yes_no_auto(text, yes_func, no_func, accept_text="Yes", reject_text="No") {
	if !made_textbox {
		made_textbox = true;
		var t = concat_arrays(text, []);
		t[array_length(t)-1] += sfmt("\n[button_sprite,accept]%    [button_sprite,back]%", accept_text, reject_text);
		cs_text_yes_no(t, yes_func, no_func);
	}
}

function cs_text_yes_no_from_var(globvar_name, yes_func, no_func) {
	cs_text_yes_no(variable_global_get(globvar_name), yes_func, no_func);
}