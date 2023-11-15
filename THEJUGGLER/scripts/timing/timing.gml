function on_period(seconds){
	return (round(current_time / 1000) * 60) % round(seconds * 60) == 0;
}