-- Abilities drop down list data
aAbilityTypeData = {
	"Skill",
	"Spell",
	"Power",
	"Other",
};

aSkillTypeData = {
	"",
	"ST/Easy",
	"ST/Average",
	"ST/Hard",
	"ST/Very Hard",
	"DX/Easy",
	"DX/Average",
	"DX/Hard",
	"DX/Very Hard",
	"IQ/Easy",
	"IQ/Average",
	"IQ/Hard",
	"IQ/Very Hard",
	"HT/Easy",
	"HT/Average",
	"HT/Hard",
	"HT/Very Hard",
	"WILL/Easy",
	"WILL/Average",
	"WILL/Hard",
	"WILL/Very Hard",
	"PER/Easy",
	"PER/Average",
	"PER/Hard",
	"PER/Very Hard",
	"Tech/Average",
	"Tech/Hard",
};

aSkillTypeAbbrData = {
	"",
	"ST/E",
	"ST/A",
	"ST/H",
	"ST/VH",
	"DX/E",
	"DX/A",
	"DX/H",
	"DX/VH",
	"IQ/E",
	"IQ/A",
	"IQ/H",
	"IQ/VH",
	"HT/E",
	"HT/A",
	"HT/H",
	"HT/VH",
	"Will/E",
	"Will/A",
	"Will/H",
	"Will/VH",
	"Per/E",
	"Per/A",
	"Per/H",
	"Per/VH",
	"Tech/A",
	"Tech/H",
};

aSpellClassData = {
	"Regular",
	"Area",
	"Melee",
	"Missile",
	"Blocking",
	"Information",
	"Enchantment",
	"Special",
};

aSpellTypeData = {
	"IQ/Hard",
	"IQ/Very Hard",
};

aSpellTypeAbbrData = {
	"IQ/H",
	"IQ/VH",
};

aTraitTypeData = {
	"Advantage",
	"Perk",
	"Disadvantage",
	"Quirk",
};

-- Item drop down list data
aItemTypeData = {
	"",
	"Equipment",
	"Defense",
	"Melee Weapon",
	"Ranged Weapon",
	"Melee Weapon, Ranged Weapon",
	"Defense, Melee Weapon",
	"Defense, Ranged Weapon",
	"Defense, Melee Weapon, Ranged Weapon",
};

-- Vehicle drop down list data
aVehicleTypeData = {
	"",
	"Ground Vehicle",
	"Watercraft",
	"Aircraft",
	"Spacecraft",
};

-- Damage types
aDamageTypeData = {
	"aff",
	"burn",
	"cor",
	"cr",
	"cut",
	"dbk",
	"dbt",
	"ex",
	"exp",
	"fat",
	"frag",
	"imp",
	"inc",
	"pi-",
	"pi",
	"pi+",
	"pi++",
	"rad",
	"sur",
	"tox"
};

-- Hit Locations 
aHitLocationData = {
	"Eye",
	"Skull",
	"Face",
	"Arm",
	"Leg",
	"Torso",
	"Groin",
	"Hand",
	"Foot",
	"Neck",
	"Vitals"
};

-- Injury Tolerance 
aInjuryToleranceData = {
	"None",
	"Unliving",
	"Homogenous",
	"Diffuse"
};

-- Values for creature type comparison
creaturedefaulttype = "";
-- NOTE: Multi-word types must come before single word types
creaturetype = {
};

-- NOTE: Multi-word types must come before single word types
creaturesubtype = {
};

-- Values supported in effect conditionals
conditionaltags = {
};

-- Conditions supported in effect conditionals and for token widgets
-- (Also shown in Effects window)
conditions = {
	"Stunned",
	"Surprised",
	"Shock",
	"Surrendered",
	"Blinded",
	"Bound",
	"Unconscious",
	"Crouched",
	"Kneeling",
	"Seated",
	"Prone",
	"Supine",
	"Grappled",
	"Pinned",
	"Disarmed",
	"Crippled",
	"Cover",
	"Very Light Cover",
	"Light Cover",
	"Medium Cover",
	"Heavy Cover",
	"Full Cover",
	"AoA",
	"AoD",
	"Committed",
	"Unready",
	"Reloading"
	"Mounted",
	"Flying",
	"Drunk",
	"Sickened",
	"On Fire",
	"Spell"
};

-- Bonus/penalty effect types for token widgets
bonuscomps = {
};

-- Condition effect types for token widgets
condcomps = {
	["Stunned"] = "cond_GURPS4e_stunned",
	["Surprised"] = "cond_GURPS4e_surprised",
	["Shock"] = "cond_GURPS4e_shock",
	["Surrendered"] = "cond_GURPS4e_surrendered",
	["Blinded"] = "cond_GURPS4e_blinded",
	["Bound"] = "cond_GURPS4e_bound",
	["Unconscious"] = "cond_GURPS4e_unconscious"
	["Crouched"] = "cond_GURPS4e_posture_crouched",
	["Kneeling"] = "cond_GURPS4e_posture_kneeling",
	["Seated"] = "cond_GURPS4e_posture_seated",
	["Prone"] = "cond_GURPS4e_posture_prone",
	["Supine"] = "cond_GURPS4e_posture_supine",
	["Grappled"] = "cond_GURPS4e_grappled",
	["Pinned"] = "cond_GURPS4e_pinned",
	["Disarmed"] = "cond_GURPS4e_disarmed",
	["Crippled"] = "cond_GURPS4e_crippled",
	["Cover"] = "cond_GURPS4e_cover",
	["Very Light Cover"] = "cond_GURPS4e_cover_vlight",
	["Light Cover"] = "cond_GURPS4e_cover_light",
	["Medium Cover"] = "cond_GURPS4e_cover_medium",
	["Heavy Cover"] = "cond_GURPS4e_cover_heavy",
	["Full Cover"] = "cond_GURPS4e_cover_full",
	["Unready"] = "cond_GURPS4e_unready",
	["Reloading"] = "cond_GURPS4e_reloading",
	["AoA"] = "cond_GURPS4e_aoa",
	["AoD"] = "cond_GURPS4e_aod",
	["Committed"] = "cond_GURPS4e_committed",
	["Mounted"] = "cond_GURPS4e_mounted",
	["Flying"] = "cond_GURPS4e_flying",
	["Drunk"] = "cond_GURPS4e_drunk",
	["Sickened"] = "cond_GURPS4e_sickened",
	["On Fire"] = "cond_GURPS4e_onfire",
	["Spell"] = "cond_GURPS4e_spell",
};

-- Other visible effect types for token widgets
othercomps = {
};
