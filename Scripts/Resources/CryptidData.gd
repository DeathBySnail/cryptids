class_name CryptidData extends Resource

@export var Name: String
@export var Description: String
@export var History: String
@export var WebLink: String
@export var Tex: Texture2D
@export var Bogus : bool
@export var BefriendScore: int = 15

@export_group("encounter stats")
@export var Coo: int
@export var Joke: int
@export var Bribe: int
@export var Ignore: int
@export var EncounterHints: Array[String]
@export var EncounterSuccessMessages : Array[String]
@export var EncounterFailMessages : Array[String]

@export_group("investigate stats")
@export var Track: int
@export var Gossip: int
@export var Study: int
@export var Spy: int


# stats keyed by CryptidStat
func get_stat(stat: CryptidConsts.Stat) -> int:
	match stat:
		CryptidConsts.Stat.Coo:
			return Coo;
		CryptidConsts.Stat.Joke:
			return Joke;
		CryptidConsts.Stat.Bribe:
			return Bribe;
		CryptidConsts.Stat.Ignore:
			return Ignore;
		CryptidConsts.Stat.Track:
			return Track;
		CryptidConsts.Stat.Gossip:
			return Gossip;
		CryptidConsts.Stat.Study:
			return Study;
		CryptidConsts.Stat.Spy:
			return Spy;
	return 0;

func encounter_success_message() -> String:
	return EncounterSuccessMessages.pick_random();
	
func encounter_fail_message() -> String:
	return EncounterFailMessages.pick_random();
