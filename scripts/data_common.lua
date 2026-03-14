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
	"Feature",
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
	"dkb",
	"nkb",
	"dbt",
	"nbt",
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
	"tox",
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
	"Vitals",
};

-- Injury Tolerance 
aInjuryToleranceData = {
	"None",
	"Unliving",
	"Homogeneous",
	"Diffuse",
};

-- Wounds
aWoundsData = {
    ["burn"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 1 },
        Eye = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 1 },
        Vitals = { ["None"] = 2, ["Unliving"] = 2, ["Homogeneous"] = 1 },
        Other = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 1 },
    },

    ["cor"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 1.5 },
        Face = { ["None"] = 1.5, ["Unliving"] = 1.5, ["Homogeneous"] = 1.5 },
        Neck = { ["None"] = 1.5, ["Unliving"] = 1.5, ["Homogeneous"] = 1.5 },
        Other = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 1 },
    },

    ["cr"] = {
        Neck = { ["None"] = 1.5, ["Unliving"] = 1.5, ["Homogeneous"] = 1.5 },
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 1 },
        Other = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 1 },
    },

    ["cut"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 1.5 },
        Neck = { ["None"] = 2, ["Unliving"] = 2, ["Homogeneous"] = 2 },
        Other = { ["None"] = 1.5, ["Unliving"] = 1.5, ["Homogeneous"] = 1.5 },
    },

    ["imp"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.5 },
        Eye = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.5 },
        Vitals = { ["None"] = 3, ["Unliving"] = 3, ["Homogeneous"] = 0.5 },
        Arm = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Leg = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Hand = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Foot = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Other = { ["None"] = 2, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
    },

    ["pi-"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.1 },
        Vitals = { ["None"] = 3, ["Unliving"] = 3, ["Homogeneous"] = 0.1 },
        Other = { ["None"] = 0.5, ["Unliving"] = 0.2, ["Homogeneous"] = 0.1 },
    },

    ["pi"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.2 },
        Eye = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.2 },
        Vitals = { ["None"] = 3, ["Unliving"] = 3, ["Homogeneous"] = 0.2 },
        Other = { ["None"] = 1, ["Unliving"] = (1 / 3), ["Homogeneous"] = 0.2 },
    },

    ["pi+"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = (1 / 3) },
        Vitals = { ["None"] = 3, ["Unliving"] = 3, ["Homogeneous"] = (1 / 3) },
        Arm = { ["None"] = 1, ["Unliving"] = 0.5, ["Homogeneous"] = (1 / 3) },
        Leg = { ["None"] = 1, ["Unliving"] = 0.5, ["Homogeneous"] = (1 / 3) },
        Hand = { ["None"] = 1, ["Unliving"] = 0.5, ["Homogeneous"] = (1 / 3) },
        Foot = { ["None"] = 1, ["Unliving"] = 0.5, ["Homogeneous"] = (1 / 3) },
        Other = { ["None"] = 1.5, ["Unliving"] = 0.5, ["Homogeneous"] = (1 / 3) },
    },

    ["pi++"] = {
        Skull = { ["None"] = 4, ["Unliving"] = 4, ["Homogeneous"] = 0.5 },
        Vitals = { ["None"] = 3, ["Unliving"] = 3, ["Homogeneous"] = 0.5 },
        Arm = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Leg = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Hand = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Foot = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
        Other = { ["None"] = 2, ["Unliving"] = 1, ["Homogeneous"] = 0.5 },
    },

    ["tox"] = {
        All = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 1 },
    },

    ["fat"] = {
        All = { ["None"] = 1, ["Unliving"] = 1, ["Homogeneous"] = 1 },
    },
}

-- Armor Divisors 
aArmorDivisorData = {
	"(1/5)",
	"(0.2)",
	"(1/2)",
	"(0.5)",
	"(1)",
	"(2)",
	"(3)",
	"(5)",
	"(10)",
	"(100)",
	"(inf)",
	"(inf.)",
	"(∞)",
};

-- Armor Hardened 
aHardenedData = {
	"None",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
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
	"All Out Attack",
	"All Out Defense",
	"Blinded",
	"Bound",
	"Committed",
	"Cover",
	"Cover (Very Light)",
	"Cover (Light)",
	"Cover (Medium)",
	"Cover (Heavy)",
	"Cover (Full)",
	"Crippled",
	"Crouched",
	"Disarmed",
	"Drunk",
	"Flying",
	"Grappled",
	"Kneeling",
	"Mounted",
	"On Fire",
	"Pinned",
	"Prone",
	"Reloading",
	"Seated",
	"Shock",
	"Sickened",
	"Spell",
	"Stunned",
	"Supine",
	"Surrendered",
	"Surprised",
	"Unconscious",
	"Unready",
};

-- Bonus/penalty effect types for token widgets
bonuscomps = {
};

-- Condition effect types for token widgets
condcomps = {
	["All Out Attack"] = "cond_GURPS4e_aoa",
	["All Out Defense"] = "cond_GURPS4e_aod",
	["Blinded"] = "cond_GURPS4e_blinded",
	["Bound"] = "cond_GURPS4e_bound",
	["Committed"] = "cond_GURPS4e_committed",
	["Cover"] = "cond_GURPS4e_cover",
	["Cover (Very Light)"] = "cond_GURPS4e_cover_vlight",
	["Cover (Light)"] = "cond_GURPS4e_cover_light",
	["Cover (Medium)"] = "cond_GURPS4e_cover_medium",
	["Cover (Heavy)"] = "cond_GURPS4e_cover_heavy",
	["Cover (Full)"] = "cond_GURPS4e_cover_full",
	["Crippled"] = "cond_GURPS4e_crippled",
	["Crouched"] = "cond_GURPS4e_posture_crouched",
	["Disarmed"] = "cond_GURPS4e_disarmed",
	["Drunk"] = "cond_GURPS4e_drunk",
	["Flying"] = "cond_GURPS4e_flying",
	["Grappled"] = "cond_GURPS4e_grappled",
	["Kneeling"] = "cond_GURPS4e_posture_kneeling",
	["Mounted"] = "cond_GURPS4e_mounted",
	["On Fire"] = "cond_GURPS4e_onfire",
	["Pinned"] = "cond_GURPS4e_pinned",
	["Prone"] = "cond_GURPS4e_posture_prone",
	["Reloading"] = "cond_GURPS4e_reloading",
	["Seated"] = "cond_GURPS4e_posture_seated",
	["Shock"] = "cond_GURPS4e_shock",
	["Sickened"] = "cond_GURPS4e_sickened",
	["Spell"] = "cond_GURPS4e_spell",
	["Stunned"] = "cond_GURPS4e_stunned",
	["Supine"] = "cond_GURPS4e_posture_supine",
	["Surrendered"] = "cond_GURPS4e_surrendered",
	["Surprised"] = "cond_GURPS4e_surprised",
	["Unconscious"] = "cond_GURPS4e_unconscious",
	["Unready"] = "cond_GURPS4e_unready",

	-- Custom conditions can be added here with the format:
	-- ["Condition Name"] = "cond_GURPS4e_custom",

	["Aim"] = "effect_GURPS4e_aim"
	--[""] = "effect_GURPS4e_generic"
};

-- Other visible effect types for token widgets
othercomps = {
};
