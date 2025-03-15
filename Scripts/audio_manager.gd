extends Node

enum Sound {Click}
@onready var click_sound : AudioStream = preload("res://Assets/Audio/click.wav")
@onready var swish_sound : AudioStream = preload("res://Assets/Audio/double-swish.mp3")
@onready var tick_sound : AudioStream = preload("res://Assets/Audio/tick.wav")

var audio_player: AudioStreamPlayer

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
func play_clip(clip: AudioStream, pitch_range):
	audio_player.pitch_scale = (1.0 - pitch_range * 0.5) + randf() * pitch_range
	audio_player.stream = clip
	audio_player.play()
	
func play_click():
	play_clip(click_sound, 0.4)
	
func play_swish():
	play_clip(swish_sound, 0.4)
	
func play_tick():
	play_clip(tick_sound, 0.4)
