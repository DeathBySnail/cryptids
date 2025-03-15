class_name CryptidSelection extends GameScene


@onready var OptionsPanel: Control = %Options
@onready var FocusControl: Control = %Options/CryptidUIOption/Button
func _ready() -> void:
	for option : Node in OptionsPanel.get_children():
		if option is CryptidUIOption:
			option.connect("cryptid_selected",_on_selection)
		pass
		
func init(cryptid: CryptidData):
	FocusControl.grab_focus()
	for option : Node in OptionsPanel.get_children():
		if option is CryptidUIOption:
			option.init()

func _on_selection(cryptid: CryptidData) -> void:
	CryptidManager.set_current_cryptid(cryptid);
	go_to_scene.emit(SceneManager.Scene.Investigate)
