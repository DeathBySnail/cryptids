class_name DialogueBox extends CanvasLayer

@export var DisplayTime = 4.0
@export var RevealSecondsPerCharacter = 0.02

@onready var TextBox: RichTextLabel = %Text

var current_tween: Tween = null

func _ready() -> void:
	DialogueManager.set_data(self)
	set_visible(false)

func show_text(text: String) -> void:
	TextBox.text = text
	TextBox.visible_characters = 0;
	set_visible(true)
	
	if current_tween != null:
		current_tween.kill()
	current_tween = create_tween();
	
	var tween_duration = RevealSecondsPerCharacter * text.length();
	current_tween.tween_property(TextBox, "visible_characters", text.length(), tween_duration)
	current_tween.tween_interval(DisplayTime)
	current_tween.finished.connect(tween_finished)

func tween_finished():
	set_visible(false)
