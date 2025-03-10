extends CanvasLayer

@onready var wheel:Wheel = %Wheel
@onready var selected_option_text: RichTextLabel = %SelectedOptionText

@export var WheelOptions: WheelOptionDictionary
@export var Cryptid: CryptidData

@onready var UpImage : TextureRect = $Wheel/UpImage
@onready var RightImage : TextureRect  = $Wheel/RightImage
@onready var DownImage  : TextureRect = $Wheel/DownImage
@onready var LeftImage  : TextureRect = $Wheel/LeftImage

@onready var TotalValueText : RichTextLabel = $Wheel/Debug/TotalValue

var CurrentScore : int = 0
var wheel_values: Array[int] = [-2,-1,1,2];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configure_wheel_from_options()
	wheel.new_dir_selected.connect(update_wheel_selection);
	wheel.new_dir_chosen.connect(update_wheel_value);
	wheel.puzzle_finished.connect(selections_finished);
	update_wheel_selection()

func configure_wheel_from_options() -> void:
	configure_wheel_option(Wheel.Directions.Up, UpImage, 0)
	configure_wheel_option(Wheel.Directions.Right, RightImage, 1)
	configure_wheel_option(Wheel.Directions.Down, DownImage, 2)
	configure_wheel_option(Wheel.Directions.Left, LeftImage, 3)
	
	wheel.set_base_numbers(wheel_values);

func configure_wheel_option(direction: Wheel.Directions, icon: TextureRect, index: int) -> void:
	var data: WheelOptionData = WheelOptions.Options.get(direction);
	icon.texture = data.Tex;
	var stat: CryptidConsts.Stat = data.Stat;
	var statValue = Cryptid.get_stat(stat);
	wheel_values[index] = statValue;
	
	
func update_wheel_selection() -> void:
	var selection: WheelOptionData = WheelOptions.Options.get(wheel.current_direction)
	selected_option_text.text = selection.Name
	
func update_wheel_value(current_value: Wheel.WheelPayload) -> void:
	CurrentScore += current_value.total_value
	TotalValueText.text = str(CurrentScore);
	
func selections_finished() -> void:
	wheel.reset();
