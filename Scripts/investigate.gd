class_name Investigate extends GameScene

@onready var cryptid_outline : Sprite2D = %CryptidOutline
@onready var knowledge_slider: Slider = $InvestigateScoreSlider
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.pressed.connect(func(): go_to_scene.emit(SceneManager.Scene.Selection))
func init(cryptid: CryptidData):
	cryptid_outline.texture = cryptid.Tex
	knowledge_slider.value = CryptidManager.get_investigation_score()

func score_update(score: int, finished: bool) -> void:
	if finished:
		# give some progress no matter what
		CryptidManager.add_investigation_score(max(1, score))

		if score <= 0:
			CryptidManager.set_current_cryptid(CryptidManager.BogusCryptid)

		go_to_scene.emit(SceneManager.Scene.Encounter);
