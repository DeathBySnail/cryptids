extends Camera2D

@export var speed: Vector2 = Vector2(1.0, 1.0);
@export var amplitude: Vector2 = Vector2(1.0, 1.0);
@export var cycle_offset: Vector2 = Vector2(1.0, 0.0);

var run_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_time += delta;
	
	var pos_x : float = sin((run_time + cycle_offset.x) * speed.x) * amplitude.x;
	var pos_y : float = sin((run_time + cycle_offset.y) * speed.y) * amplitude.y;
	var new_offset : Vector2 = Vector2(pos_x, pos_y);
	
	offset = new_offset;
