class_name SceneManager extends Control

enum Scene {None, Investigate, Encounter}

@export var SceneWheelOptions: Dictionary[Scene, WheelOptionDictionary]

@onready var InvestigateScene : CanvasLayer = $Investigate
@onready var EncounterScene : CanvasLayer = $Encounter
@onready var WheelPanel : WheelUI = $UI
@onready var CryptidPanel : CryptidSelection = $CryptidSelection

var SceneMap: Dictionary[Scene, CanvasLayer]
var CurrentScene: Scene = Scene.None

func _ready() -> void:
	SceneMap[Scene.Investigate] = $Investigate
	SceneMap[Scene.Encounter] = $Encounter
	WheelPanel.set_visible(false)
	WheelPanel.set_process(false)
	
	for scene in SceneMap:
		SceneMap[scene].set_process(false)
		SceneMap[scene].set_visible(false)

func activate_scene(scene: Scene) -> void:
	if CurrentScene != Scene.None:
		SceneMap[CurrentScene].set_process(false)
		SceneMap[CurrentScene].set_visible(false)
	
	CurrentScene = scene;
	
	if SceneWheelOptions.has(CurrentScene):
		WheelPanel.configure_wheel_from_options(SceneWheelOptions[CurrentScene])
	
	SceneMap[CurrentScene].set_process(true)
	SceneMap[CurrentScene].set_visible(true)
	
	WheelPanel.set_visible(true)
	WheelPanel.set_process(true)


func _on_cryptid_selection_option_selected(cryptid: CryptidData) -> void:
	CryptidManager.SetCurrentCryptid(cryptid);
	InvestigateScene.set_cryptid(cryptid);
	CryptidPanel.set_visible(false);
	activate_scene(Scene.Investigate)


func _on_ui_attempts_over(score: int) -> void:
	if CurrentScene == Scene.Investigate:
		activate_scene(Scene.Encounter);
	else:
		activate_scene(Scene.Investigate);
