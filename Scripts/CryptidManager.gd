extends Node

var CurrentCryptid: CryptidData

@onready var BogusCryptid: CryptidData = preload("res://Assets/CryptidData/Gus.tres")

const MAX_INVESTIGATE_SCORE : int = 25

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
	get_current_progression().investigation_score = min(get_current_progression().investigation_score + score, MAX_INVESTIGATE_SCORE)

func get_investigation_score() -> int:
	return get_current_progression().investigation_score
	
func get_allowed_encounter_attempts() -> int:
	var investigate_score: int = get_current_progression().investigation_score;
	return maxi(1, investigate_score / 10)
	
func get_hints(cryptid: CryptidData) -> Array[String]:
	var hints: Array[String];
	# 1 hint every 5 knowledge above 5, up to however many we have
	var max_hint_count = min(max(0, (get_progression(cryptid).investigation_score - 5) / 5), cryptid.EncounterHints.size())
	
	# bogies require no knowledge
	if cryptid.Bogus:
		max_hint_count = cryptid.EncounterHints.size()
	for i in range(0, max_hint_count):
		hints.push_back(cryptid.EncounterHints[i])
	return hints
	
