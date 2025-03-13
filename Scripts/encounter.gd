extends CanvasLayer

@onready var CryptidSprite: Sprite2D = %CryptidSprite

func set_cryptid(cryptid: CryptidData):
	CryptidSprite.texture = cryptid.Tex
