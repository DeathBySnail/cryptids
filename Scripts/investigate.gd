class_name Investigate extends GameScene

@onready var cryptid_outline : Sprite2D = %CryptidOutline

func init(cryptid: CryptidData):
	cryptid_outline.texture = cryptid.Tex

func score_update(score: int, finished: bool) -> void:
	if finished:
		if score <= 0:
			CryptidManager.set_current_cryptid(CryptidManager.BogusCryptid)
		else:
			CryptidManager.add_investigation_score(score)

		go_to_scene.emit(SceneManager.Scene.Encounter);
