class_name Investigate extends GameScene

@onready var cryptid_outline : Sprite2D = %CryptidOutline
@onready var knowledge_slider: Range = %InvestigateScoreSlider
@onready var back_button: Button = $BackButton
@onready var score_popup: PopupText = %InvestigateScorePopup

func _ready() -> void:
	back_button.pressed.connect(func(): go_to_scene.emit(SceneManager.Scene.Selection))
	score_popup.visible = false
	
func init(cryptid: CryptidData):
	cryptid_outline.texture = cryptid.Tex
	knowledge_slider.value = CryptidManager.get_investigation_score()

func score_update(score: int, finished: bool) -> void:
	if finished:
		# give some progress no matter what
		var new_score = max(1, score)
		CryptidManager.add_investigation_score(new_score)

		## show knowledge gain popup, then go to the encounter
		score_popup.show_text("[wave][color=#63c74d]+" + str(new_score))
		score_popup.current_tween.finished.connect(func(): go_to_scene.emit(SceneManager.Scene.Encounter))
		
		var slider_tween = create_tween();
		slider_tween.set_trans(Tween.TRANS_EXPO)
		slider_tween.tween_property(knowledge_slider,"value", CryptidManager.get_investigation_score(), 2.4)
		slider_tween.finished.connect(func(): slider_tween.kill())

		if score <= 0:
			CryptidManager.set_current_cryptid(CryptidManager.BogusCryptid)
