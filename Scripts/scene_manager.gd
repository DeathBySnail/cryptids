class_name SceneManager extends Control

enum Scene {None, Selection, Investigate, Encounter}

@export var SceneWheelOptions: Dictionary[Scene, WheelOptionDictionary]
@export var SceneTweenType: Tween.TransitionType = Tween.TransitionType.TRANS_EXPO;
@export var SceneTweenSpeed: float = 1.2
@onready var InvestigateScene : GameScene = $Investigate
@onready var EncounterScene : GameScene = $Encounter
@onready var WheelPanel : WheelUI = $UI
@onready var CryptidPanel : CryptidSelection = $CryptidSelection
@onready var Camera: Camera2D = $Camera2D;

var SceneMap: Dictionary[Scene, GameScene]
var SceneTweenPositions: Dictionary[Scene, Vector2]
var CurrentScene: Scene = Scene.None

func _ready() -> void:
	SceneMap[Scene.Investigate] = $Investigate
	SceneTweenPositions[Scene.Investigate] = Vector2.LEFT * 2000.0;
	SceneMap[Scene.Encounter] = $Encounter
	SceneTweenPositions[Scene.Encounter] = Vector2.RIGHT * 2000.0;
	SceneMap[Scene.Selection] = $CryptidSelection
	SceneTweenPositions[Scene.Selection] = Vector2.DOWN * 2000.0;
	WheelPanel.set_visible(false)
	WheelPanel.set_process(false)
	
	for scene in SceneMap:
		SceneMap[scene].set_process(false)
		SceneMap[scene].set_visible(false)
		SceneMap[scene].go_to_scene.connect(activate_scene)
		
	CryptidPanel.set_visible(false);
	activate_scene(Scene.Selection)

func activate_scene(scene: Scene) -> void:
	
	var OldScene = CurrentScene;
	CurrentScene = scene;
	
	if SceneMap.has(OldScene):
		var old_tween:Tween = get_tree().create_tween().bind_node(SceneMap[OldScene])

		old_tween.set_trans(SceneTweenType)
		var old_target_pos : Vector2 = SceneTweenPositions[OldScene]
		old_tween.tween_property(SceneMap[OldScene], "offset",old_target_pos,SceneTweenSpeed)
		old_tween.finished.connect(func(): 
			SceneMap[OldScene].set_process(false);
			SceneMap[OldScene].set_visible(false););
	
	if SceneWheelOptions.has(CurrentScene):
		var attempts = 3;
		if CurrentScene == Scene.Encounter:
			attempts = CryptidManager.get_allowed_encounter_attempts()
		WheelPanel.configure_wheel_from_options(SceneWheelOptions[CurrentScene], attempts)
	else:
		WheelPanel.set_visible(false)
		WheelPanel.set_process(false)
		
	SceneMap[CurrentScene].init(CryptidManager.CurrentCryptid)
		
	var tween:Tween = get_tree().create_tween().bind_node(SceneMap[CurrentScene])
	tween.set_trans(SceneTweenType) 
	SceneMap[CurrentScene].offset = SceneTweenPositions[CurrentScene]
	var target_pos : Vector2 = Vector2.ZERO;
	tween.tween_property(SceneMap[CurrentScene], "offset",target_pos,SceneTweenSpeed)
		
	if Camera != null:
		# bump the camera a bit whilst transitioning
		var camera_tween:Tween = get_tree().create_tween().bind_node(Camera)
		camera_tween.set_trans(SceneTweenType)
		
		var dir = SceneTweenPositions[CurrentScene].normalized();
		var camera_target_pos: Vector2 = -dir * 200;
		camera_tween.tween_property(Camera, "position",camera_target_pos,SceneTweenSpeed * 0.5)
		camera_tween.tween_property(Camera, "position",Vector2.ZERO,SceneTweenSpeed * 0.5)
	
	SceneMap[CurrentScene].set_process(true)
	SceneMap[CurrentScene].set_visible(true)

func _on_ui_attempts_over(score: int) -> void:
	if CurrentScene != Scene.None:
		SceneMap[CurrentScene].score_update(score, true)


func _on_ui_attempt_made(current_score: int) -> void:
	# pass to the current scene that a score update has occurred
	if CurrentScene != Scene.None:
		SceneMap[CurrentScene].score_update(current_score, false)
