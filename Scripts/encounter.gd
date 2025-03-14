extends GameScene

@onready var CryptidSprite: Sprite2D = %CryptidSprite

@export var RevealTransitionType : Tween.TransitionType = Tween.TransitionType.TRANS_ELASTIC
@export var RevealScaleMultiplier: float = 2.0;
@export var ScaleTweenSpeed: float = 0.8;

var InitialScale : Vector2 = Vector2.ONE;
func _ready() -> void:
	InitialScale = CryptidSprite.scale;
	CryptidSprite.material.set_shader_parameter("tint_power", 1.0)
	
func set_cryptid(cryptid: CryptidData):
	CryptidSprite.texture = cryptid.Tex
	CryptidSprite.material.set_shader_parameter("tint_power", 1.0)
	CryptidSprite.scale = InitialScale;

func score_update(score: int, finished: bool) -> void:
	if finished:
		CryptidSprite.material.set_shader_parameter("tint_power", 0.0)
		var tween:Tween = create_tween();
		tween.set_trans(RevealTransitionType);
		var target_pos: Vector2 = Vector2.RIGHT * 200;
		tween.tween_property(CryptidSprite, "scale",InitialScale * RevealScaleMultiplier,ScaleTweenSpeed);
		tween.tween_interval(2.0);
		tween.finished.connect(func(): go_to_scene.emit(SceneManager.Scene.Investigate))
