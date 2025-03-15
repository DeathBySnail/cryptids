class_name WheelUI extends CanvasLayer

signal attempt_made(current_score: int);
signal attempts_over(score: int);

@onready var wheel:Wheel = %Wheel
@onready var selected_option_text: RichTextLabel = %SelectedOptionText
@onready var attempt_count_label: RichTextLabel = %AttemptCountLabel
@onready var free_roate_count_label: RichTextLabel = %FreeRotateCount
@onready var RoundReaction: PopupText = %RoundReaction

@export var WheelOptions: WheelOptionDictionary
@export var ScoreForGoodRound : int = 4
@export var ScoreForBadRound : int = -1

@onready var UpImage : TextureRect = $Wheel/UpImage
@onready var RightImage : TextureRect  = $Wheel/RightImage
@onready var DownImage  : TextureRect = $Wheel/DownImage
@onready var LeftImage  : TextureRect = $Wheel/LeftImage

@onready var TotalValueText : RichTextLabel = $Wheel/Debug/TotalValue
@onready var BaseScoreValueText : RichTextLabel = $Wheel/Debug/BaseScore
@onready var BaseMultiplierValueText : RichTextLabel = $Wheel/Debug/BaseMultiplier

var CurrentScore : int = 0
var RoundScore : int = 0
var wheel_values: Array[int] = [-2,-1,1,2];
var attempt_count: int = 3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wheel.new_dir_selected.connect(update_wheel_selection);
	wheel.new_dir_chosen.connect(update_wheel_value);
	wheel.puzzle_finished.connect(selections_finished);
	wheel.rotation_started.connect(wheel_rotated);

func configure_wheel_from_options(options:WheelOptionDictionary, attempts: int, rotates: int) -> void:
	WheelOptions = options;
	configure_wheel_option(Wheel.Directions.Up, UpImage, 0)
	configure_wheel_option(Wheel.Directions.Right, RightImage, 1)
	configure_wheel_option(Wheel.Directions.Down, DownImage, 2)
	configure_wheel_option(Wheel.Directions.Left, LeftImage, 3)
	
	wheel.set_base_numbers(wheel_values);
	attempt_count = attempts;
	attempt_count_label.text = str(attempt_count)
	free_roate_count_label.text = str(rotates)
	CurrentScore = 0;
	RoundScore = 0;
	wheel.reset(true);
	wheel.free_rotates = rotates
	set_visible(true)
	set_process(true)
	update_wheel_selection()

func configure_wheel_option(direction: Wheel.Directions, icon: TextureRect, index: int) -> void:
	var data: WheelOptionData = WheelOptions.Options.get(direction);
	icon.texture = data.Tex;
	var stat: CryptidConsts.Stat = data.Stat;
	if CryptidManager.CurrentCryptid != null:
		var statValue = CryptidManager.CurrentCryptid.get_stat(stat);
		wheel_values[index] = statValue;
	
	
func update_wheel_selection() -> void:
	var selection: WheelOptionData = WheelOptions.Options.get(wheel.current_direction)
	selected_option_text.text = selection.Name
	BaseScoreValueText.text = str(wheel.get_current_wheel_value().base_value)
	BaseMultiplierValueText.text = str(wheel.get_current_wheel_value().slice_value)
	
func update_wheel_value(current_value: Wheel.WheelPayload) -> void:
	var score = CryptidManager.mutate_score(current_value.total_value)
	RoundScore += score
	print("score %d round %d mutated %s segment sum %d base %d slice %d" % [CurrentScore,RoundScore, score, current_value.total_value, current_value.base_value, current_value.slice_value])
	TotalValueText.text = str(CurrentScore);
	
	var RoundScoreText: String = "[shake][color=#e43b44]POOR"
	if score >= ScoreForGoodRound:
		RoundScoreText = "[wave][color=#63c74d]NICE!"
	elif score > ScoreForBadRound:
		RoundScoreText = "[shake rate=10][color=#c0cbdc]MEH"
	RoundReaction.show_text(RoundScoreText)
	
func selections_finished() -> void:
	attempt_count = attempt_count - 1;
	attempt_count_label.text = str(attempt_count)
	
	CurrentScore += RoundScore
	RoundScore = 0
	
	if attempt_count > 0:
		wheel.reset(false);
		attempt_made.emit(CurrentScore)
	else:
		print("attempts over with score %d" % [CurrentScore])
		attempts_over.emit(CurrentScore)

func wheel_rotated() -> void:
	free_roate_count_label.text = str(wheel.free_rotates)
