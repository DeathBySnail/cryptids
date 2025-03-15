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
			option.init(cryptid == option.Cryptid)

func _on_selection(cryptid: CryptidData) -> void:
	CryptidManager.set_current_cryptid(cryptid);
	if CryptidManager.get_progression(cryptid).befriended_count > 0:
		go_to_scene.emit(SceneManager.Scene.Details)
	else:
		go_to_scene.emit(SceneManager.Scene.Investigate)


func _on_social_link_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
