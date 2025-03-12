class_name Investigate extends CanvasLayer

@onready var cryptid_outline : Sprite2D = %CryptidOutline

func set_cryptid(cryptid: CryptidData):
	cryptid_outline.texture = cryptid.Tex
