extends Node



const ENEMY_LIMIT: int = 3
const STARTING_CREDIT: int = 3
const TURN_ACTION: int = 3


#region pile enum
enum PileType {
	DRAW = 0,
	HAND = 1,
	PLAY = 2,
	DISCARD = 3,
}

enum PileDirection {
	UP = 0,
	LEFT = 1,
	RIGHT = 2,
	DOWN = 3
}
#endregion

#region card enum
enum CoreType {
	DEFAULT = 0,
	LEVEL = 7,
	DAMAGE = 1,
	CREDIT = 2,
	ACTION = 3,
	ARMOR = 4,
	HEALTH = 5,
	SACRIFICE = 6
}

const core_to_string = {
	CoreType.LEVEL: "level",
	CoreType.DAMAGE: "damage",
	CoreType.CREDIT: "credit",
	CoreType.ACTION: "action",
	CoreType.ARMOR: "armor",
	CoreType.HEALTH: "health",
	CoreType.SACRIFICE: "sacrifice",
	
}

enum FactionType {
	DEFAULT = 0,
	COUNCIL = 1,
	VIREN = 2,
	SILVER = 3,
	JUNKER = 4,
}

const faction_to_string = {
	FactionType.DEFAULT: "",
	FactionType.COUNCIL: "council",
	FactionType.VIREN: "viren",
	FactionType.SILVER: "silver",
	FactionType.JUNKER: "junker",
}

enum CardType {
	TACTIC = 1,
	ALLY = 2
}

const card_to_string = {
	CardType.TACTIC: "tactic",
	CardType.ALLY: "ally",
}
#endregion

#region condition enum
enum ConditionType {
	DEFAULT = 0,
	LEVEL = 1,
	CONSPIRE = 2,
	UNITE = 3,
	WOUNDED = 4,
	FOCUS = 5,
	BARGAIN = 6,
	MODIFICATION = 7,
	BACKSTAB = 8,
}

enum ConditionValue {
	DEFAULT = 0,
	X = 1,
	A = 2,
	B = 3,
	C = 4
}
#endregion

#region effect enum
enum EffectType {
	DAMAGE = 1,
	CREDIT = 2,
	ACTION = 3,
	ARMOR = 4,
	HEAL = 5,
	SACRIFICE = 6,
	TRAIN = 7,
	AOE = 8
}

enum EffectValue {
	DEFAULT = 0,
	FOCUS = 1
}
#endregion

enum CursorState {
	IDLE,
	SELECT,
	HOLD
}
