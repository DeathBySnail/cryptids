class_name CryptidSelection extends CanvasLayer

signal option_selected(cryptid: CryptidData);

@onready var OptionsPanel: Node = $Options
func _ready() -> void:
	for option : Node in OptionsPanel.get_children():
		if option is CryptidUIOption:
			option.connect("cryptid_selected",_on_selection)
		pass

func _on_selection(cryptid: CryptidData) -> void:
	option_selected.emit(cryptid)
