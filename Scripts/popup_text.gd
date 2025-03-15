class_name PopupText extends RichTextLabel

@export var seconds_to_full_display: float = 0.5
@export var seconds_to_vanish: float = 0.5
@export var default_text: String = "Nice!"

var start_position: Vector2 = Vector2.ZERO

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
	
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "visible_ratio", 1.0,seconds_to_full_display)
	tween.tween_property(self, "position", start_position + Vector2.UP * 200,seconds_to_vanish).set_trans(Tween.TRANS_ELASTIC)
