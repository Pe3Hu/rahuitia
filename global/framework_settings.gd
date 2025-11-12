extends Node



const STARTING_CREDIT: int = 3
const TURN_ACTION: int = 3
const STARTING_CARD: int = 3

var TEMPORARY_LEVEL: int = 1
var PERMANENT_LEVEL: int = 1
const PEDESTAL_CARD: int = 3


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

#region core enum
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

enum CoreType {
	TACTIC = 1,
	ALLY = 2
}

const card_to_string = {
	CoreType.TACTIC: "tactic",
	CoreType.ALLY: "ally",
}

enum SideState {
	FRIENDLY,
	HOSTILE
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
	ARSENAL = 9,
	SACRIFICE = 10,
	FORGE = 11,
}

enum ConditionValue {
	DEFAULT = 0,
	ANY = 1,
	A = 2,
	B = 3,
	C = 4
}
#endregion

#region effect enum
enum TokenType {
	DEFAULT = 0,
	LEVEL = 7,
	DAMAGE = 1,
	CREDIT = 2,
	ACTION = 3,
	ARMOR = 4,
	HEALTH = 5,
	SACRIFICE = 10,
	SALE = 11,
	KILL = 12,
	AMBUSH = 13,
	
	DANGER = 100,
	OFFENSIVE = 101,
	DEFENSIVE = 102
}

const effect_to_token = {
	EffectType.CREDIT: TokenType.CREDIT
}

const token_to_string = {
	TokenType.LEVEL: "level",
	TokenType.DAMAGE: "damage",
	TokenType.CREDIT: "credit",
	TokenType.ACTION: "action",
	TokenType.ARMOR: "armor",
	TokenType.HEALTH: "health",
	TokenType.SACRIFICE: "sacrifice",
	
	TokenType.DANGER: "danger",
	TokenType.OFFENSIVE: "offensive",
	TokenType.DEFENSIVE: "defensive",
}

enum EffectType {
	DAMAGE = 1,
	CREDIT = 2,
	ACTION = 3,
	ARMOR = 4,
	HEAL = 5,
	REFRESH = 6,
	TRAIN = 7,
	AOE = 8,
	TRASH = 9,
	SACRIFICE = 10,
	SALE = 11,
	KILL = 12,
	AMBUSH = 13,
}

enum EffectValue {
	DEFAULT = 0,
	ONDECK = 1,
	ANY = 2,
	UNITE = 3,
	FOCUS = 5,
	SACRIFICE = 10,
	MODIFICATION = 7,
}
#endregion

#region threat
var DANGER_MARKER = 0

const TURN_THREAT_MIN: int = 3
const TURN_THREAT_MAX: int = 3

enum PlanetType{
	DEFAULT,
	CERES,
	VIRENOS,
	MITHRAS,
	TRIUMVIRATE,
	HARBRINGER,
}

const planet_to_string = {
	PlanetType.DEFAULT: "",
	PlanetType.CERES: "cares",
	PlanetType.VIRENOS: "virenos",
	PlanetType.MITHRAS: "mithras",
}

enum ThreatType{
	HUMAN,
	BEAST,
	VIREN,
	VEHICLE
}

const threat_to_string = {
	ThreatType.HUMAN: "human",
	ThreatType.BEAST: "beast",
	ThreatType.VIREN: "viren",
	ThreatType.VEHICLE: "vehicle",
}

enum KeywordType{
	FAST,
	RAGE,
	TAUNT,
	CRAZED,
	TERROR
}

const keyword_to_string = {
	KeywordType.FAST: "fast",
	KeywordType.RAGE: "rage",
	KeywordType.TAUNT: "taunt",
	KeywordType.CRAZED: "crazed",
	KeywordType.TERROR: "terror",
}

enum DangerType {
	DEFAULT = 0,
	DAMAGE = 1,
	ARMOR = 4,
}

const danger_to_string = {
	DangerType.DAMAGE: "damage",
	DangerType.ARMOR: "armor",
}
#endregion

enum CursorState {
	IDLE,
	SELECT,
	HOLD
}
