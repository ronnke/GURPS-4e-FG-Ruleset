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
	"Unconscious",
	"Crouched",
	"Kneeling",
	"Seated",
	"Prone",
	"Supine",
	"Grappled",
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
	"Mounted",
	"Flying",
	"Sickened",
	"On Fire"
};

-- Condition effect types for token widgets
condcomps = {
	["AoA"] = "cond_GURPS4e_aoa",
	["AoD"] = "cond_GURPS4e_aod",
	["Committed"] = "cond_GURPS4e_committed",
	["Full Cover"] = "cond_GURPS4e_cover_full",
	["Heavy Cover"] = "cond_GURPS4e_cover_heavy",
	["Light Cover"] = "cond_GURPS4e_cover_light",
	["Very Light Cover"] = "cond_GURPS4e_cover_vlight",
	["Medium Cover"] = "cond_GURPS4e_cover_medium",
	["Cover"] = "cond_GURPS4e_cover",
	["Grappled"] = "cond_GURPS4e_grappled",
	["Disarmed"] = "cond_GURPS4e_disarmed",
	["Crippled"] = "cond_GURPS4e_crippled",
	["Mounted"] = "cond_GURPS4e_mounted",
	["Flying"] = "cond_GURPS4e_flying",
	["Crouched"] = "cond_GURPS4e_posture_crouched",
	["Kneeling"] = "cond_GURPS4e_posture_kneeling",
	["Seated"] = "cond_GURPS4e_posture_seated",
	["Prone"] = "cond_GURPS4e_posture_prone",
	["Supine"] = "cond_GURPS4e_posture_supine",
	["Stunned"] = "cond_GURPS4e_stunned",
	["Surprised"] = "cond_GURPS4e_surprised",
	["Surrendered"] = "cond_GURPS4e_surrendered",
	["Sickened"] = "cond_GURPS4e_sickened",
	["On Fire"] = "cond_GURPS4e_onfire",
	["Shock"] = "cond_GURPS4e_shock",
	["Unconscious"] = "cond_GURPS4e_unconscious"
};

-- Other visible effect types for token widgets
othercomps = {
	["STUNNED"] = "cond_GURPS4e_stunned",
};
