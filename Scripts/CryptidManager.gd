extends Node

var CurrentCryptid: CryptidData

@onready var BogusCryptid: CryptidData = preload("res://Assets/CryptidData/Gus.tres")

func SetCurrentCryptid(cryptid: CryptidData):
	CurrentCryptid = cryptid;
