class_name CryptidData extends Resource

@export var Name: String
@export var Description: String
@export var Tex: Texture2D

@export_group("encounter stats")
@export var Coo: int
@export var Joke: int
@export var Bribe: int
@export var Ignore: int

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
