class_name PopupText extends RichTextLabel

@export var seconds_to_full_display: float = 0.5
@export var seconds_at_full_display: float = 0.0
@export var seconds_to_vanish: float = 0.5
@export var default_text: String = "Nice!"
@export var end_rel_position: Vector2 = Vector2.UP * 200

var start_position: Vector2 = Vector2.ZERO
var current_tween: Tween = null

func _ready() -> void:
	visible = false
	start_position = position
	#show_default_text()
	
func show_default_text() -> void:
	show_text(default_text)
	
func show_text(display_text: String):
	visible_ratio = 0.0
	visible = true
	text = display_text
	position = start_position
	
	if current_tween != null:
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_LINEAR)
	current_tween.tween_property(self, "visible_ratio", 1.0,seconds_to_full_display)
	if seconds_at_full_display > 0.0:
		current_tween.tween_interval(seconds_at_full_display)
	current_tween.tween_property(self, "position", start_position + end_rel_position,seconds_to_vanish).set_trans(Tween.TRANS_ELASTIC)
