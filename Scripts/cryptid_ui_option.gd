class_name CryptidUIOption extends Node

@export var Cryptid: CryptidData
@onready var Tex : TextureRect = $TextureRect
@onready var Butt: Button = $Button
@onready var KnowledgeSlider: Slider = $Button/KnowledgeSlider

signal cryptid_selected(cryptid: CryptidData)
func _ready() -> void:
	Tex.texture = Cryptid.Tex
	Butt.text = Cryptid.Name
	Butt.tooltip_text = Cryptid.Description

func init() -> void:
	KnowledgeSlider.value = CryptidManager.get_progression(Cryptid).investigation_score

func _on_button_pressed() -> void:
	cryptid_selected.emit(Cryptid)
