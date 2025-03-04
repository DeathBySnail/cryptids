extends Label

@export var time_until_start_displaying: float = 1.0;
@export var time_until_fully_displayed: float = 1.0;
@export var time_fully_displayed: float = 1.0;

var current_display_time: float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	current_display_time += delta;
	
	if current_display_time <= time_until_start_displaying:
		visible_ratio = 0.0;
	else:
		var post_display_lifetime = current_display_time - time_until_start_displaying;
		var lifetime = time_fully_displayed + time_until_fully_displayed + time_until_start_displaying;
		if post_display_lifetime > lifetime:
			current_display_time = 0.0;
		var norm_time = clampf(post_display_lifetime / time_until_fully_displayed, 0.0, 1.0);
		visible_ratio = norm_time;
