
function parse_number(str) {
	var newS = "";
	var len = string_length(str);
	var neg = false;
	for (var i=1; i <= len; i++) {
	     var c = string_char_at(str, i);
	     newS += string_digits(c);
	     if (c == ".") newS += ".";
		 if (c == "-") neg = true;
	}
	newS = real(newS);
	return(neg? -newS : newS);
}


// from Juju Adam's pixel perfect camera tutorial
/// @description  sfmt(format, ...values)
/// @param format
/// @param  ...values
function sfmt(f) {
	// sfmt("%/% hp", 1, 2) -> "1/2 hp"
	gml_pragma("global", @'
		global.sfmt_buf = buffer_create(1024, buffer_grow, 1);
		global.sfmt_map = ds_map_create();
		global.sfmt_warn = ds_map_create();
	');
	var w = global.sfmt_map[?f], i, n;
	if (w == undefined) {
	    w[0] = "";
	    global.sfmt_map[?f] = w;
	    i = string_pos("%", f);
	    n = 0;
	    while (i) {
	        w[n++] = string_copy(f, 1, i - 1);
	        f = string_delete(f, 1, i);
	        i = string_pos("%", f);
	    }
	    w[n++] = f;
	} else n = array_length(w);
	//
	var b = global.sfmt_buf;
	buffer_seek(b, buffer_seek_start, 0);
	buffer_write(b, buffer_text, w[0]);
	var m = argument_count;
	for (i = 1; i < n; i++) {
	    if (i < m) {
	        f = string(argument[i]);
	        if (f != "") buffer_write(b, buffer_text, f);
	    }
	    f = w[i];
	    if (f != "") buffer_write(b, buffer_text, f);
	}
	buffer_write(b, buffer_u8, 0);
	buffer_seek(b, buffer_seek_start, 0);
	return buffer_read(b, buffer_string);


}
