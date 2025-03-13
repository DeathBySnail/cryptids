class_name SceneManager extends Control

enum Scene {None, Investigate, Encounter}

@export var SceneWheelOptions: Dictionary[Scene, WheelOptionDictionary]
@export var SceneTweenType: Tween.TransitionType = Tween.TransitionType.TRANS_EXPO;
@export var SceneTweenSpeed: float = 1.2
@onready var InvestigateScene : CanvasLayer = $Investigate
@onready var EncounterScene : CanvasLayer = $Encounter
@onready var WheelPanel : WheelUI = $UI
@onready var CryptidPanel : CryptidSelection = $CryptidSelection
@onready var Camera: Camera2D = $Camera2D;

var SceneMap: Dictionary[Scene, CanvasLayer]
var SceneTweenPositions: Dictionary[Scene, Vector2]
var CurrentScene: Scene = Scene.None

func _ready() -> void:
	SceneMap[Scene.Investigate] = $Investigate
	SceneTweenPositions[Scene.Investigate] = Vector2.LEFT * 2000.0;
	SceneMap[Scene.Encounter] = $Encounter
	SceneTweenPositions[Scene.Encounter] = Vector2.RIGHT * 2000.0;
	WheelPanel.set_visible(false)
	WheelPanel.set_process(false)
	
	for scene in SceneMap:
		SceneMap[scene].set_process(false)
		SceneMap[scene].set_visible(false)
		
	CryptidPanel.set_visible(true);

func activate_scene(scene: Scene) -> void:
	
	var OldScene = CurrentScene;
	CurrentScene = scene;
	
	if SceneWheelOptions.has(OldScene):
		var tween:Tween = get_tree().create_tween().bind_node(SceneMap[OldScene])

		tween.set_trans(SceneTweenType)
		var target_pos : Vector2 = SceneTweenPositions[OldScene]
		tween.tween_property(SceneMap[OldScene], "offset",target_pos,SceneTweenSpeed)
		tween.finished.connect(func(): 
			SceneMap[OldScene].set_process(false);
			SceneMap[OldScene].set_visible(false););
	
	if SceneWheelOptions.has(CurrentScene):
		WheelPanel.configure_wheel_from_options(SceneWheelOptions[CurrentScene])
		
		var tween:Tween = get_tree().create_tween().bind_node(SceneMap[CurrentScene])
		tween.set_trans(SceneTweenType) 
		SceneMap[CurrentScene].offset = SceneTweenPositions[CurrentScene]
		var target_pos : Vector2 = Vector2.ZERO;
		tween.tween_property(SceneMap[CurrentScene], "offset",target_pos,SceneTweenSpeed)
		
	if Camera != null:
		# bump the camera a bit whilst transitioning
		var tween:Tween = get_tree().create_tween().bind_node(Camera)
		tween.set_trans(SceneTweenType)
		var target_pos: Vector2 = Vector2.RIGHT * 200;
		tween.tween_property(Camera, "position",target_pos,SceneTweenSpeed * 0.5)
		tween.tween_property(Camera, "position",Vector2.ZERO,SceneTweenSpeed * 0.5)
	
	SceneMap[CurrentScene].set_process(true)
	SceneMap[CurrentScene].set_visible(true)
	
	WheelPanel.set_visible(true)
	WheelPanel.set_process(true)


func _on_cryptid_selection_option_selected(cryptid: CryptidData) -> void:
	CryptidManager.SetCurrentCryptid(cryptid);
	InvestigateScene.set_cryptid(cryptid);
	EncounterScene.set_cryptid(cryptid);
	CryptidPanel.set_visible(false);
	activate_scene(Scene.Investigate)


func _on_ui_attempts_over(score: int) -> void:
	if CurrentScene == Scene.Investigate:
		activate_scene(Scene.Encounter);
	else:
		activate_scene(Scene.Investigate);


func _on_ui_attempt_made(current_score: int) -> void:
	# pass to the current scene that a score update has occurred
	pass
