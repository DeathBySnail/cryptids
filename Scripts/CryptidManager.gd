extends Node

var CurrentCryptid: CryptidData

@onready var BogusCryptid: CryptidData = preload("res://Assets/CryptidData/Gus.tres")

class CryptidProgress:
	var investigation_score: int = 0
	var hints_unlocked: Array[String]

var Progression: Dictionary[String, CryptidProgress]

func set_current_cryptid(cryptid: CryptidData):
	CurrentCryptid = cryptid;

func get_progression(cryptid: CryptidData) -> CryptidProgress:
	if !Progression.has(cryptid.Name):
		Progression[cryptid.Name] = CryptidProgress.new()
	return Progression[cryptid.Name]
	
func get_current_progression() -> CryptidProgress:
	return get_progression(CurrentCryptid)

func add_investigation_score(score: int):
	get_current_progression().investigation_score += score
	
func get_allowed_encounter_attempts() -> int:
	var investigate_score: int = get_current_progression().investigation_score;
	return maxi(1, investigate_score / 10)
