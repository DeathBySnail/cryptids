@tool class_name Wheel extends Control
## Hello and welcome to the Persuasion Wheel Game Jam AKA WHEELJAM! This code
## is free to use and distribute for the purposes of WHEELJAM and any games
## you choose to make with it outside of wheeljam as well. Please provide 
## attribution if you use it outside the jam. I'd love to see what you make 
## with it!

## you can also make your own wheel if you'd like, this one is not required,
## but I did try to make it as easy to use as possible so people can plug in their
## own art and sounds and just kinda run with it. This code has been adapted from
## Colin McInerney's Unity implementation of the wheel.

## Have fun, tag me on bsky (@shanescott.itch.io) if you use the wheel bc again, 
##I'd LOVE to see what you make, and good luck!

## Love, Shane Scott & Colin McInerney.

enum Directions {Up = 0, Right = 90, Down = 180, Left = 270};

#region Signals
signal new_dir_selected() ## emitted when a new direction is selected.
signal new_dir_chosen(payload:WheelPayload) ## emitted when a direction is chosen
signal rotation_started ## emitted when the gimbal begins to be rotated.
signal rotation_finished ## emitted when the gimbal is finished rotating.
signal puzzle_finished ## emitted when the puzzle is complete.
#endregion

#region Export Variables
@export_category("Wheel Cosmetics")
@export_group("Size & Scale")
@export var wheel_size:Vector2 = Vector2(300,300): ## a vector2 that specifies the wheel's custom minimum size.
	set(value):
		wheel_size = value
		if Engine.is_editor_hint(): self.custom_minimum_size = wheel_size
@export_range(0,5,0.1) var wheel_scale:float = 1: ## specifies the wheel's scale.
	set(value):
		wheel_scale = value
		self.scale.x = wheel_scale
		self.scale.y = wheel_scale
@export_group("Animations")
## controls the animation of the rotation of the wheel.
enum TweenType { 
	TRANS_LINEAR, ## linear animation.
	TRANS_SINE, ## sine animation.
	TRANS_QUINT, ## quint animation.
	TRANS_QUART, ## quart animation.
	TRANS_QUAD, ## quad animation.
	TRANS_EXPO, ## expo animation.
	TRANS_ELASTIC, ## elastic animation.
	TRANS_CUBIC, ## cubic animation.
	TRANS_CIRC, ## circ animation.
	TRANS_BOUNCE, ## bounce animation.
	TRANS_BACK, ## back animation.
	TRANS_SPRING ## spring animation.
	}
@export var tween_type:TweenType = TweenType.TRANS_CIRC ## holds the value of the animation type enum.
@export_range(0,2,0.05) var anim_time= 0.3 ## controls how long the rotation animation will play for.

@export_group("Textures")
@export var slice_textures:Array[Texture2D] = [
	preload("uid://d26cocb7f5biu"),
	preload("uid://b26d46otswkev"),
	preload("uid://b62c2x3fpqy2g"),
	preload("uid://cibvjji04v87m")
]: ## an array of slice textures. order is [slice1,slice2,slice3,slice4] (smallest to largest)
	set(value):
		slice_textures = value
		if Engine.is_editor_hint():
			_update_slices_ui(value)
@export var underlay_texture:Texture2D = preload("uid://dq2c0cj6havec"):
	set(value):
		underlay_texture = value
		if Engine.is_editor_hint():
			_update_node_ui(get_node_or_null("slice_gimbal/underlay"),underlay_texture)
@export var overlay_texture:Texture2D = preload("uid://cqsjo7cxeno47"):
	set(value):
		overlay_texture = value
		if Engine.is_editor_hint():
			_update_node_ui(get_node_or_null("wheel/overlay"),overlay_texture)
@export var selector_texture:Texture2D = preload("uid://bj1ti43o3pgnc"):
	set(value):
		selector_texture = value
		if Engine.is_editor_hint():
			_update_node_ui(get_node_or_null("selector"),selector_texture)
#endregion

#region Onready Variables
@onready var slices:Array[Control] = [%slice1,%slice2,%slice3,%slice4] ## our triangles of varying sizes.
@onready var covers:Array[Control] = [%cover_up,%cover_down,%cover_left,%cover_right] ## our covers to indicate that the selection has already been chosen.
@onready var selector:Control = %selector ## a reference to our selector node.
@onready var slice_gimbal:Control = %slice_gimbal ## a reference to our slice gimbal.
#endregion

#region Internal Variables
var base_numbers:Array[int] = [-2,-1,1,2] ## base score values for the slices
var slice_values:Array[int] = [1,2,3,4] ## slice value multiplier
var current_value_mappings:Array[int] = [Directions.Up,Directions.Right,Directions.Down,Directions.Left] ## assigns values to directions; format is as follows: [UP,RIGHT,DOWN,LEFT]
enum WheelState {AWAITING_SELECTION,ROTATING,NO_INPUT} ## enum dictating current state of wheel.
var _state:WheelState = WheelState.NO_INPUT ## variable containing current state of wheel.
var num_selections:int = 0 ## how many selections have been chosen
var _current_value:WheelPayload ## a WheelPayload object containing the wheel's value
var current_direction:int = 0 ## where the selector currently is.
const DIRECTIONS:Array[int] = [Directions.Up,Directions.Right,Directions.Down,Directions.Left] ## rotation value (in degrees) for the wheel directions. [UP,RIGHT,DOWN,LEFT]
var target_selections:int = 4 ## how many selections are allowed; default is 4.
var free_rotates: int = 0 ## how many times we can freely spin the wheel per game
#endregion

func angle_to_direction(angle: int) -> int:
	match angle:
		Directions.Up:
			return 0
		Directions.Right:
			return 1
		Directions.Down:
			return 2
		Directions.Left:
			return 3
	return 0
	
#region Built-In Functions
#called when the scene is loaded into the tree
func _ready()->void:
	reset(true) # all the setup is contained in reset
	rotation_finished.connect(end_check) # check if puzzle is completed when rotation is done
	# wait for an actual ready call to begin the minigame
	_state = WheelState.NO_INPUT


# handles input for our minigame
func _unhandled_input(_event: InputEvent) -> void:
	if _state != WheelState.AWAITING_SELECTION: return

	if Input.is_action_just_pressed("ui_accept"): # ui_accept is spacebar
		process_confirm_input(current_direction)
	
	# if up, down, left or right is pressed, process that direction input
	if Input.is_action_just_pressed("ui_up"): 
		current_direction=Directions.Up
		process_direction_input(current_direction)
	if Input.is_action_just_pressed("ui_down"):
		current_direction=Directions.Down
		process_direction_input(current_direction)
	if Input.is_action_just_pressed("ui_left"):
		current_direction=Directions.Left
		process_direction_input(current_direction)
	if Input.is_action_just_pressed("ui_right"):
		current_direction=Directions.Right
		process_direction_input(current_direction)
		
func _gui_input(event: InputEvent) -> void:
	if is_processing_unhandled_input():
		if event is InputEventMouseMotion:
			mouse_selection(event.position)
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
				process_confirm_input(current_direction)
#endregion

func mouse_selection(mouse_pos: Vector2):
	var mouse_pos_relative : Vector2 = (mouse_pos - (slice_gimbal.position + slice_gimbal.pivot_offset)).normalized()
	
	var doty = mouse_pos_relative.dot(Vector2.UP)
	var dotx = mouse_pos_relative.dot(Vector2.RIGHT)
	
	var new_direction : int = selector.rotation_degrees
	if absf(doty) > absf(dotx):
		if doty > 0.0:
			new_direction = Directions.Up
		else:
			new_direction = Directions.Down
	else:
		if dotx < 0.0:
			new_direction = Directions.Left
		else:
			new_direction = Directions.Right

	if new_direction != selector.rotation_degrees:
		current_direction = new_direction
		process_direction_input(new_direction)

#region Custom Functions
## processes the input direction and moves the selector to that direction.
func process_direction_input(direction:int)->void:
	# if _state != WheelState.AWAITING_SELECTION: return
	selector.rotation_degrees = direction #move our selector to the direction
	_current_value = get_current_wheel_value() #set the current wheel value to our slice and base values
	new_dir_selected.emit() # emit signal that we have moved the selector

## confirms that the current selection has been chosen
func process_confirm_input(direction:int)->void:
	if _state != WheelState.AWAITING_SELECTION: return
		
	for x:Control in %covers.get_children():  # show the covers, increase the num selections, emit the signal, rotate
		if int(round(x.rotation_degrees)) == direction: 
			if x.visible: return 
			
			x.visible = true
			num_selections += 1
			new_dir_chosen.emit(_current_value)
			rotate_slices()

func attempt_rotate_slices() -> bool:
	if free_rotates > 0:
		free_rotates -= 1
		rotate_slices()
		return true
	return false
	
## rotates the slice gimbal +90 degrees
func rotate_slices()->void:
	if _state != WheelState.AWAITING_SELECTION: return
	
	_state = WheelState.ROTATING 
	current_value_mappings = _rotate_array(current_value_mappings) # +90 to each of our current value mappings
	_current_value = get_current_wheel_value() # make sure the wheel value is updated
	rotation_started.emit() 
	var tween:Tween = create_tween() # create our tween object we will use for the animation
	tween.set_trans(int(tween_type)) # sets our transition type to our enum
	tween.tween_property(%slice_gimbal, "rotation_degrees",%slice_gimbal.rotation_degrees+90,anim_time) # rotate gimbal
	tween.finished.connect(func(): rotation_finished.emit()) # emit rotation finished when done anim

## this function resets the minigame.
func reset(new_game: bool)->void:
	randomize() # ensures that godot will randomize the shuffle of the mappings
	#selector.rotation_degrees = 0 # remove this if you don't want the selector to reset up every time
	slice_gimbal.rotation_degrees = 0 
	num_selections = 0 
	for x:Control in covers: x.visible = false # hides the covers

	if new_game:
		current_value_mappings.shuffle() # chooses a random order for our value mappings
	for x:int in DIRECTIONS.size(): # assigns the slice value to the direction of the corresponding slice
		for j:int in current_value_mappings.size():
			slices[j].rotation_degrees = current_value_mappings[j]  # sets the slice rotations to our value mappings
			if DIRECTIONS[x] == current_value_mappings[j]:
				slice_values[x] = x+1

	_current_value = get_current_wheel_value() 
	_state = WheelState.AWAITING_SELECTION 

## checks if the minigame is finished
func end_check()->void:
	if num_selections == target_selections:
		_state = WheelState.NO_INPUT
		puzzle_finished.emit()
	else:
		_state = WheelState.AWAITING_SELECTION

## returns the wheel value
func get_current_wheel_value()->WheelPayload:
	var wp:WheelPayload = WheelPayload.new()
	wp.base_value = base_numbers[angle_to_direction(current_direction)]
	for x:int in current_value_mappings.size():
		if current_direction == current_value_mappings[x]:
			wp.slice_value = slice_values[x]

	wp.total_value = wp.base_value * wp.slice_value
	return wp

# set the base values for the wheel
func set_base_numbers(numbers: Array[int]):
	assert(numbers.size() == 4);
	base_numbers = numbers;
	
	_current_value = get_current_wheel_value() #set the current wheel value to our slice and base values
#endregion

#region helper functions
## +90 degrees to each value mapping for rotation; also adjusts base values so they stay the same
func _rotate_array(arr:Array)->Array:
	var a:Array = arr
	for x:int in a.size():
		a[x] += 90 # add 90 degrees to each value mapping
		if int(a[x]) == 360: a[x] = 0  # wrap values back to 0
	return a

# this is all UI stuff. 
func _update_slices_ui(new_textures:Array[Texture2D])->void: 
	for x:int in slices.size(): # this assumes you will have the same amount of covers as slices. idk why you wouldn't.
		#update our slices with the new texture
		slices[x].texture = new_textures[x]
		slices[x].pivot_offset = Vector2(new_textures[x].get_size().x/2,new_textures[x].get_size().y/2)
		slices[x].position = Vector2.ZERO
		slices[x].set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		slices[x].size = new_textures[x].get_size()
		# set our covers to the biggest slice at a modulate and update
		covers[x].texture = new_textures[3]
		covers[x].modulate = Color("000000a8")
		covers[x].pivot_offset = Vector2(Vector2(new_textures[3].get_size().x/2,new_textures[3].get_size().y/2))
		covers[x].position = Vector2.ZERO
		covers[x].set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		covers[x].size = new_textures[3].get_size()
func _update_node_ui(node:Control,new_texture:Texture2D)->void:
	if node==null: return
	
	node.texture = new_texture
	node.pivot_offset = Vector2(new_texture.get_size().x/2,new_texture.get_size().y/2)
	node.position = Vector2.ZERO
	node.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	node.size = new_texture.get_size()
#endregion

#region WheelPayload Class
## allows us to create wheel payload objects and assign values to the wheel.
class WheelPayload:
	var base_value:int
	var slice_value:int
	var total_value:int
#endregion
