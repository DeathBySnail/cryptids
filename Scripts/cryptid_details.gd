class_name CryptidDetails extends GameScene

@onready var CryptidTexture : TextureRect = $ScreenPanel/Cryptid
@onready var Header : Label = $ScreenPanel/Header
@onready var Subheader : Label = $ScreenPanel/Subheader
@onready var Contents: RichTextLabel = $ScreenPanel/Content
@onready var WebLink: RichTextLabel = $ScreenPanel/WebLink
@onready var Back: Button = $ScreenPanel/Back

func _ready() -> void:
	Back.pressed.connect(func(): go_to_scene.emit(SceneManager.Scene.Selection))
	WebLink.meta_clicked.connect(_on_RichTextLabel_meta_clicked)

func init(cryptid: CryptidData):
	CryptidTexture.texture = cryptid.Tex
	Header.text = cryptid.Name
	Subheader.text = cryptid.Description
	Contents.text = cryptid.History
	
	WebLink.visible = !cryptid.WebLink.is_empty()
	WebLink.text = cryptid.WebLink
	
	Back.grab_focus()

func _on_RichTextLabel_meta_clicked(meta: Variant) -> void:
	var err := OS.shell_open(str(meta))
	if err == OK:
		print("Opened link '%s' successfully!" % str(meta))
	else:
		print("Failed opening the link '%s'!" % str(meta))
