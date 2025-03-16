class_name CryptidUIOption extends Node

@export var Cryptid: CryptidData
@onready var Tex : TextureRect = $TextureRect
@onready var Butt: Button = $Button
@onready var KnowledgeSlider: ProgressBar = $KnowledgeSlider
@onready var BefriendedIcon: Node = $BefriendedIcon

signal cryptid_selected(cryptid: CryptidData)
func _ready() -> void:
	Tex.texture = Cryptid.Tex
	Butt.text = Cryptid.Name
	Butt.tooltip_text = Cryptid.Description

func init(focus: bool) -> void:
	var progress = CryptidManager.get_progression(Cryptid)
	KnowledgeSlider.value = progress.investigation_score
	var befriended : bool = progress.befriended_count > 0
	
	KnowledgeSlider.visible = !befriended
	BefriendedIcon.visible = befriended
	
	var tint = 1.0;
	if befriended:
		tint = 0.0
	Tex.set_instance_shader_parameter("tint_power", tint)
	#Tex.material.set_shader_parameter("tint_power", tint)
	
	if focus:
		Butt.grab_focus()

func _on_button_pressed() -> void:
	cryptid_selected.emit(Cryptid)
	AudioManager.play_click()


func _on_button_mouse_entered() -> void:
	AudioManager.play_tick()


func _on_button_focus_entered() -> void:
	AudioManager.play_tick()
