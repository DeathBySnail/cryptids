class_name WheelUI extends CanvasLayer

signal attempts_over(score: int);

@onready var wheel:Wheel = %Wheel
@onready var selected_option_text: RichTextLabel = %SelectedOptionText
@onready var attempt_count_label: RichTextLabel = %AttemptCountLabel

@export var WheelOptions: WheelOptionDictionary

@onready var UpImage : TextureRect = $Wheel/UpImage
@onready var RightImage : TextureRect  = $Wheel/RightImage
@onready var DownImage  : TextureRect = $Wheel/DownImage
@onready var LeftImage  : TextureRect = $Wheel/LeftImage

@onready var TotalValueText : RichTextLabel = $Wheel/Debug/TotalValue

var CurrentScore : int = 0
var wheel_values: Array[int] = [-2,-1,1,2];
var attempt_count: int = 3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configure_wheel_from_options(WheelOptions)
	wheel.new_dir_selected.connect(update_wheel_selection);
	wheel.new_dir_chosen.connect(update_wheel_value);
	wheel.puzzle_finished.connect(selections_finished);
	update_wheel_selection()

func configure_wheel_from_options(options:WheelOptionDictionary) -> void:
	WheelOptions = options;
	configure_wheel_option(Wheel.Directions.Up, UpImage, 0)
	configure_wheel_option(Wheel.Directions.Right, RightImage, 1)
	configure_wheel_option(Wheel.Directions.Down, DownImage, 2)
	configure_wheel_option(Wheel.Directions.Left, LeftImage, 3)
	
	wheel.set_base_numbers(wheel_values);
	attempt_count = 3;
	attempt_count_label.text = str(attempt_count)
	CurrentScore = 0;
	wheel.reset();

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
	
func update_wheel_value(current_value: Wheel.WheelPayload) -> void:
	CurrentScore += current_value.total_value
	print("score %d segment sum %d base %d slice %d" % [CurrentScore, current_value.total_value, current_value.base_value, current_value.slice_value])
	TotalValueText.text = str(CurrentScore);
	
func selections_finished() -> void:
	attempt_count = attempt_count - 1;
	attempt_count_label.text = str(attempt_count)
	if attempt_count > 0:
		wheel.reset();
	else:
		print("attempts over with score %d" % [CurrentScore])
		attempts_over.emit(CurrentScore)
