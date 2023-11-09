function cs_text_inject (base_text, global_variable_name) {
	cs_text([
		sfmt(base_text, variable_global_get(global_variable_name))
	]);
}