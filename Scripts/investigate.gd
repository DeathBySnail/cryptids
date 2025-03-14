class_name Investigate extends GameScene

@onready var cryptid_outline : Sprite2D = %CryptidOutline

func set_cryptid(cryptid: CryptidData):
	cryptid_outline.texture = cryptid.Tex

func score_update(score: int, finished: bool) -> void:
	if finished:
		go_to_scene.emit(SceneManager.Scene.Encounter);
