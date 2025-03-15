extends GameScene

@onready var CryptidSprite: Sprite2D = %CryptidSprite
@onready var HintTexts: Control = %Hints

@export var RevealTransitionType : Tween.TransitionType = Tween.TransitionType.TRANS_ELASTIC
@export var RevealScaleMultiplier: float = 2.0;
@export var ScaleTweenSpeed: float = 0.8;

var InitialScale : Vector2 = Vector2.ONE;
var InitialPos : Vector2 = Vector2.ZERO;
var TargetScore : int = 0;
func _ready() -> void:
	InitialScale = CryptidSprite.scale;
	InitialPos = CryptidSprite.position
	CryptidSprite.set_instance_shader_parameter("tint_power", 1.0)
	
func init(cryptid: CryptidData):
	CryptidSprite.texture = cryptid.Tex
	CryptidSprite.set_instance_shader_parameter("tint_power", 1.0)
	CryptidSprite.scale = InitialScale;
	CryptidSprite.position = InitialPos;
	TargetScore = cryptid.BefriendScore;
	
	var unlocked_hints : Array[String] = CryptidManager.get_hints(cryptid);
	var hint_counter : int = 0;
	for HintTextBox in HintTexts.get_children():
		if HintTextBox is RichTextLabel:
			if hint_counter < unlocked_hints.size():
				HintTextBox.text = unlocked_hints[hint_counter]	;
			else:
				HintTextBox.text = "[wave]???"
			hint_counter = hint_counter + 1
			
		pass

func score_update(score: int, finished: bool) -> void:
	if finished:
		if score >= TargetScore:
			CryptidSprite.set_instance_shader_parameter("tint_power", 0.0)
			var tween:Tween = create_tween();
			tween.set_trans(RevealTransitionType);
			tween.tween_property(CryptidSprite, "scale",InitialScale * RevealScaleMultiplier,ScaleTweenSpeed);
			tween.tween_interval(2.0);
			tween.finished.connect(func(): go_to_scene.emit(SceneManager.Scene.Selection))
			CryptidManager.befriend(CryptidManager.CurrentCryptid)
		else:
			var tween:Tween = create_tween();
			tween.set_trans(RevealTransitionType);
			tween.set_parallel(true)
			tween.tween_property(CryptidSprite, "scale",Vector2.ZERO,ScaleTweenSpeed);
			tween.tween_property(CryptidSprite, "position",Vector2.UP * 500.,ScaleTweenSpeed).as_relative();
			tween.chain().tween_interval(2.0);
			tween.finished.connect(func(): go_to_scene.emit(SceneManager.Scene.Investigate))
