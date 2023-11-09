
hspd = 0;
vspd = 0;

manage_collision = function() {
	var screen = instance_nearest(0, 0, o_screen);
	if screen != noone {
		var w = screen.bbox_right - bbox_left;
		var margin = w * 0.1;
		var exited_frame = false;
		if x > screen.bbox_right + margin {
			exited_frame = true;
		}
		
		if x < screen.bbox_left - margin {
			exited_frame = true;
		}
		
		if y < screen.bbox_top - margin {
			exited_frame = true;
		}
		
		if y > screen.bbox_bottom + margin {
			exited_frame = true;
		}	
	
		if exited_frame {
			instance_destroy(id);
		}
	}
}