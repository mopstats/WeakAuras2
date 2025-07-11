local AddonName, TemplatePrivate = ...
---@class WeakAuras
local WeakAuras = WeakAuras
if not WeakAuras.IsMists() then return end
local L = WeakAuras.L
local GetSpellInfo, tinsert, GetSpellDescription, C_Timer, Spell
    = GetSpellInfo, tinsert, GetSpellDescription, C_Timer, Spell

-- The templates tables are created on demand
local templates =
  {
    class = { },
    race = {
      Human = {},
      NightElf = {},
      Dwarf = {},
      Gnome = {},
      Draenei = {},
      Orc = {},
      Scourge = {},
      Tauren = {},
      Troll = {},
      BloodElf = {},
      Pandaren = {},
    },
    general = {
      title = L["General"],
      icon = 136116,
      args = {}
    },
  }

local manaIcon = "Interface\\Icons\\spell_frost_manarecharge.blp"
local rageIcon = "Interface\\Icons\\ability_racial_bloodrage.blp"
local comboPointsIcon = "Interface\\Icons\\ability_backstab"

local powerTypes =
  {
    [0] = { name = POWER_TYPE_MANA, icon = manaIcon },
    [1] = { name = POWER_TYPE_RED_POWER, icon = rageIcon},
    [2] = { name = POWER_TYPE_FOCUS, icon = "Interface\\Icons\\ability_hunter_focusfire"},
    [3] = { name = POWER_TYPE_ENERGY, icon = "Interface\\Icons\\spell_shadow_shadowworddominate"},
    [4] = { name = COMBO_POINTS, icon = comboPointsIcon},
    [12] = {name = CHI_POWER, icon = "Interface\\Icons\\ability_monk_healthsphere"},
  }

-- Collected by WeakAurasTemplateCollector:
--------------------------------------------------------------------------------

-- DONE
templates.class.WARRIOR = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 469, type = "buff", unit = "player" }, -- Commanding Shout
        { spell = 871, type = "buff", unit = "player" }, -- Shield Wall
        { spell = 1719, type = "buff", unit = "player" }, -- Recklessness
        { spell = 6673, type = "buff", unit = "player" }, -- Battle Shout
        { spell = 12292, type = "buff", unit = "player", talent = 17 }, -- Bloodbath
        { spell = 12328, type = "buff", unit = "player" }, -- Sweeping Strikes
        { spell = 12880, type = "buff", unit = "player" }, -- Enrage
        { spell = 12968, type = "buff", unit = "player" }, -- Flurry
        { spell = 18499, type = "buff", unit = "player" }, -- Berserker Rage
        { spell = 20572, type = "buff", unit = "player" }, -- Blood Fury
        { spell = 23920, type = "buff", unit = "player" }, -- Spell Reflection
        { spell = 46916, type = "buff", unit = "player" }, -- Bloodsurge
        { spell = 50227, type = "buff", unit = "player" }, -- Sword and Board
        { spell = 52437, type = "buff", unit = "player" }, -- Sudden Death
        { spell = 55694, type = "buff", unit = "player", talent = 4 }, -- Enraged Regeneration
        { spell = 60503, type = "buff", unit = "player" }, -- Taste for Blood
        { spell = 97463, type = "buff", unit = "player" }, -- Rallying Cry
        { spell = 107574, type = "buff", unit = "player", talent = 16 }, -- Avatar
        { spell = 112048, type = "buff", unit = "player" }, -- Shield Barrier
        { spell = 114028, type = "buff", unit = "player", talent = 13 }, -- Mass Spell Reflection
        { spell = 118038, type = "buff", unit = "player" }, -- Die by the Sword
        { spell = 122510, type = "buff", unit = "player" }, -- Ultimatum
        { spell = 125565, type = "buff", unit = "player" }, -- Demoralizing Shout
        { spell = 126513, type = "buff", unit = "player" }, -- Poised to Strike
        { spell = 131116, type = "buff", unit = "player" }, -- Raging Blow!
        { spell = 131526, type = "buff", unit = "player" }, -- Cyclonic Inspiration
        { spell = 132404, type = "buff", unit = "player" }, -- Shield Block
        { spell = 139958, type = "buff", unit = "player" }, -- Sudden Execute
        { spell = 147833, type = "buff", unit = "target" }, -- Intervene
      },
      icon = 132333
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 355, type = "debuff", unit = "target" }, -- Taunt
        { spell = 1160, type = "debuff", unit = "target" }, -- Demoralizing Shout
        { spell = 1715, type = "debuff", unit = "target" }, -- Hamstring
        { spell = 5246, type = "debuff", unit = "target" }, -- Intimidating Shout
        { spell = 7922, type = "debuff", unit = "target" }, -- Charge Stun
        { spell = 12323, type = "debuff", unit = "target", talent = 8 }, -- Piercing Howl
        { spell = 64382, type = "debuff", unit = "target" }, -- Shattering Throw
        { spell = 81326, type = "debuff", unit = "target" }, -- Physical Vulnerability
        { spell = 86346, type = "debuff", unit = "target" }, -- Colossus Smash
        { spell = 105771, type = "debuff", unit = "target", talent = 3 }, -- Warbringer
        { spell = 107566, type = "debuff", unit = "target", talent = 7 }, -- Staggering Shout
        { spell = 113344, type = "debuff", unit = "target", talent = 17 }, -- Bloodbath
        { spell = 113746, type = "debuff", unit = "target" }, -- Weakened Armor
        { spell = 115767, type = "debuff", unit = "target" }, -- Deep Wounds
        { spell = 115798, type = "debuff", unit = "target" }, -- Weakened Blows
        { spell = 115804, type = "debuff", unit = "target" }, -- Mortal Wounds
        { spell = 132168, type = "debuff", unit = "target", talent = 11 }, -- Shockwave
        { spell = 132169, type = "debuff", unit = "target", talent = 18 }, -- Storm Bolt
      },
      icon = 132366
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 71, type = "ability" }, -- Defensive Stance
        { spell = 78, type = "ability", overlayGlow = true, requiresTarget = true }, -- Heroic Strike
        { spell = 100, type = "ability", requiresTarget = true, usable = true }, -- Charge
        { spell = 355, type = "ability", debuff = true, requiresTarget = true }, -- Taunt
        { spell = 469, type = "ability", buff = true }, -- Commanding Shout
        { spell = 676, type = "ability", requiresTarget = true }, -- Disarm
        { spell = 845, type = "ability", overlayGlow = true, requiresTarget = true }, -- Cleave
        { spell = 871, type = "ability", buff = true }, -- Shield Wall
        { spell = 1160, type = "ability", debuff = true }, -- Demoralizing Shout
        { spell = 1464, type = "ability", requiresTarget = true }, -- Slam
        { spell = 1715, type = "ability", debuff = true, requiresTarget = true }, -- Hamstring
        { spell = 1719, type = "ability", buff = true }, -- Recklessness
        { spell = 2457, type = "ability" }, -- Battle Stance
        { spell = 2458, type = "ability" }, -- Berserker Stance
        { spell = 2565, type = "ability", charges = true, usable = true }, -- Shield Block
        { spell = 3411, type = "ability", requiresTarget = true }, -- Intervene
        { spell = 5246, type = "ability", debuff = true, requiresTarget = true }, -- Intimidating Shout
        { spell = 5308, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Execute
        { spell = 6343, type = "ability" }, -- Thunder Clap
        { spell = 6552, type = "ability", requiresTarget = true }, -- Pummel
        { spell = 6572, type = "ability", requiresTarget = true }, -- Revenge
        { spell = 6673, type = "ability", buff = true }, -- Battle Shout
        { spell = 7384, type = "ability", charges = true, requiresTarget = true, usable = true }, -- Overpower
        { spell = 7386, type = "ability", requiresTarget = true }, -- Sunder Armor
        { spell = 12292, type = "ability", buff = true, talent = 17 }, -- Bloodbath
        { spell = 12294, type = "ability", requiresTarget = true }, -- Mortal Strike
        { spell = 12328, type = "ability", buff = true }, -- Sweeping Strikes
        { spell = 18499, type = "ability", buff = true }, -- Berserker Rage
        { spell = 20243, type = "ability", requiresTarget = true, usable = true }, -- Devastate
        { spell = 20572, type = "ability", buff = true }, -- Blood Fury
        { spell = 23881, type = "ability", requiresTarget = true }, -- Bloodthirst
        { spell = 23920, type = "ability", buff = true }, -- Spell Reflection
        { spell = 23922, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Shield Slam
        { spell = 34428, type = "ability", requiresTarget = true, usable = true }, -- Victory Rush
        { spell = 46924, type = "ability", talent = 10 }, -- Bladestorm
        { spell = 46968, type = "ability", talent = 11 }, -- Shockwave
        { spell = 55694, type = "ability", buff = true, talent = 4 }, -- Enraged Regeneration
        { spell = 57755, type = "ability", requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", debuff = true, requiresTarget = true }, -- Shattering Throw
        { spell = 85288, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Raging Blow
        { spell = 86346, type = "ability", debuff = true, overlayGlow = true, requiresTarget = true }, -- Colossus Smash
        { spell = 97462, type = "ability" }, -- Rallying Cry
        { spell = 100130, type = "ability", charges = true, overlayGlow = true, requiresTarget = true, usable = true }, -- Wild Strike
        { spell = 102060, type = "ability", talent = 9 }, -- Disrupting Shout
        { spell = 103840, type = "ability", requiresTarget = true, talent = 6 }, -- Impending Victory
        { spell = 107566, type = "ability", debuff = true, talent = 7 }, -- Staggering Shout
        { spell = 107570, type = "ability", requiresTarget = true, talent = 18 }, -- Storm Bolt
        { spell = 107574, type = "ability", buff = true, talent = 16 }, -- Avatar
        { spell = 112048, type = "ability", buff = true, usable = true }, -- Shield Barrier
        { spell = 114028, type = "ability", buff = true, talent = 13 }, -- Mass Spell Reflection
        { spell = 118000, type = "ability", talent = 12 }, -- Dragon Roar
        { spell = 118038, type = "ability", buff = true }, -- Die by the Sword
        { spell = 122475, type = "ability", requiresTarget = true }, -- Throw
        { spell = 1250619, type = "ability", charges = true, requiresTarget = true }, -- Charge
      },
      icon = 132355
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = rageIcon,
    }
  }
}

templates.class.PALADIN = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 135964
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 135952
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 135972
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.HUNTER = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 3045, type = "buff", unit = "player" }, -- Rapid Fire
        { spell = 5118, type = "buff", unit = "player" }, -- Aspect of the Cheetah
        { spell = 5384, type = "buff", unit = "player" }, -- Feign Death
        { spell = 13159, type = "buff", unit = "player" }, -- Aspect of the Pack
        { spell = 13165, type = "buff", unit = "player" }, -- Aspect of the Hawk
        { spell = 19263, type = "buff", unit = "player" }, -- Deterrence
        { spell = 19506, type = "buff", unit = "player" }, -- Trueshot Aura
        { spell = 19615, type = "buff", unit = "player" }, -- Frenzy
        { spell = 34471, type = "buff", unit = "player" }, -- The Beast Within
        { spell = 34720, type = "buff", unit = "player", talent = 12 }, -- Thrill of the Hunt
        { spell = 45444, type = "buff", unit = "player" }, -- Bonfire's Blessing
        { spell = 51755, type = "buff", unit = "player" }, -- Camouflage
        { spell = 53257, type = "buff", unit = "player" }, -- Cobra Strikes
        { spell = 54216, type = "buff", unit = "player" }, -- Master's Call
        { spell = 54227, type = "buff", unit = "player" }, -- Rapid Recuperation
        { spell = 56453, type = "buff", unit = "player" }, -- Lock and Load
        { spell = 77769, type = "buff", unit = "player" }, -- Trap Launcher
        { spell = 82692, type = "buff", unit = "player" }, -- Focus Fire
        { spell = 82726, type = "buff", unit = "player", talent = 10 }, -- Fervor
        { spell = 109260, type = "buff", unit = "player", talent = 8 }, -- Aspect of the Iron Hawk
        { spell = 118694, type = "buff", unit = "player", talent = 9 }, -- Spirit Bond
        { spell = 118922, type = "buff", unit = "player", talent = 1 }, -- Posthaste
        { spell = 126483, type = "buff", unit = "player" }, -- Windswept Pages
        { spell = 136, type = "buff", unit = "target" }, -- Mend Pet
        { spell = 136, type = "buff", unit = "pet" }, -- Mend Pet
        { spell = 19574, type = "buff", unit = "pet" }, -- Bestial Wrath
        { spell = 61684, type = "buff", unit = "pet" }, -- Dash
        { spell = 62305, type = "buff", unit = "pet" }, -- Master's Call
        { spell = 82728, type = "buff", unit = "pet", talent = 10 }, -- Fervor
        { spell = 118455, type = "buff", unit = "pet" }, -- Beast Cleave
      },
      icon = 132242
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 1130, type = "debuff", unit = "target" }, -- Hunter's Mark
        { spell = 2649, type = "debuff", unit = "target" }, -- Growl
        { spell = 3674, type = "debuff", unit = "target" }, -- Black Arrow
        { spell = 4167, type = "debuff", unit = "target" }, -- Web
        { spell = 5116, type = "debuff", unit = "target" }, -- Concussive Shot
        { spell = 19386, type = "debuff", unit = "target", talent = 5 }, -- Wyvern Sting
        { spell = 19503, type = "debuff", unit = "target" }, -- Scatter Shot
        { spell = 20736, type = "debuff", unit = "target" }, -- Distracting Shot
        { spell = 24394, type = "debuff", unit = "target", talent = 6 }, -- Intimidation
        { spell = 34490, type = "debuff", unit = "target" }, -- Silencing Shot
        { spell = 35101, type = "debuff", unit = "target" }, -- Concussive Barrage
        { spell = 53301, type = "debuff", unit = "target" }, -- Explosive Shot
        { spell = 82654, type = "debuff", unit = "target" }, -- Widow Venom
        { spell = 117405, type = "debuff", unit = "target", talent = 4 }, -- Binding Shot
        { spell = 118253, type = "debuff", unit = "target" }, -- Serpent Sting
        { spell = 120699, type = "debuff", unit = "target", talent = 15 }, -- Lynx Rush
        { spell = 120761, type = "debuff", unit = "target", talent = 16 }, -- Glaive Toss
        { spell = 131894, type = "debuff", unit = "target", talent = 13 }, -- A Murder of Crows
      },
      icon = 135860
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 75, type = "ability", requiresTarget = true, usable = true }, -- Auto Shot
        { spell = 781, type = "ability" }, -- Disengage
        { spell = 1543, type = "ability" }, -- Flare
        { spell = 1978, type = "ability", requiresTarget = true, usable = true }, -- Serpent Sting
        { spell = 2643, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Multi-Shot
        { spell = 2649, type = "ability", debuff = true }, -- Growl
        { spell = 3044, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Arcane Shot
        { spell = 3045, type = "ability", buff = true }, -- Rapid Fire
        { spell = 3674, type = "ability", debuff = true }, -- Black Arrow
        { spell = 4167, type = "ability", debuff = true }, -- Web
        { spell = 5116, type = "ability", debuff = true, requiresTarget = true, usable = true }, -- Concussive Shot
        { spell = 5118, type = "ability", buff = true }, -- Aspect of the Cheetah
        { spell = 5384, type = "ability", buff = true }, -- Feign Death
        { spell = 6991, type = "ability", requiresTarget = true, usable = true }, -- Feed Pet
        { spell = 13159, type = "ability", buff = true }, -- Aspect of the Pack
        { spell = 13165, type = "ability", buff = true }, -- Aspect of the Hawk
        { spell = 17253, type = "ability" }, -- Bite
        { spell = 19263, type = "ability", charges = true, buff = true }, -- Deterrence
        { spell = 19386, type = "ability", debuff = true, talent = 5 }, -- Wyvern Sting
        { spell = 19503, type = "ability", debuff = true, requiresTarget = true, usable = true }, -- Scatter Shot
        { spell = 19574, type = "ability", buff = true, unit = 'pet' }, -- Bestial Wrath
        { spell = 19577, type = "ability", talent = 6 }, -- Intimidation
        { spell = 19801, type = "ability", requiresTarget = true, usable = true }, -- Tranquilizing Shot
        { spell = 20736, type = "ability", debuff = true, requiresTarget = true, usable = true }, -- Distracting Shot
        { spell = 34026, type = "ability" }, -- Kill Command
        { spell = 34490, type = "ability", debuff = true }, -- Silencing Shot
        { spell = 51753, type = "ability" }, -- Camouflage
        { spell = 53209, type = "ability" }, -- Chimera Shot
        { spell = 53271, type = "ability" }, -- Master's Call
        { spell = 53301, type = "ability", debuff = true, overlayGlow = true }, -- Explosive Shot
        { spell = 53351, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Kill Shot
        { spell = 61684, type = "ability", buff = true, unit = 'pet' }, -- Dash
        { spell = 77767, type = "ability", requiresTarget = true, usable = true }, -- Cobra Shot
        { spell = 77769, type = "ability", buff = true }, -- Trap Launcher
        { spell = 82654, type = "ability", debuff = true, requiresTarget = true, usable = true }, -- Widow Venom
        { spell = 82692, type = "ability", charges = true, buff = true, overlayGlow = true, usable = true }, -- Focus Fire
        { spell = 82726, type = "ability", buff = true, talent = 10 }, -- Fervor
        { spell = 109248, type = "ability", usable = true, talent = 4 }, -- Binding Shot
        { spell = 109259, type = "ability", talent = 17 }, -- Powershot
        { spell = 109260, type = "ability", buff = true, talent = 8 }, -- Aspect of the Iron Hawk
        { spell = 109304, type = "ability", talent = 7 }, -- Exhilaration
        { spell = 117050, type = "ability", requiresTarget = true, usable = true, talent = 16 }, -- Glaive Toss
        { spell = 120360, type = "ability", usable = true, talent = 18 }, -- Barrage
        { spell = 120679, type = "ability", talent = 11 }, -- Dire Beast
        { spell = 120697, type = "ability", talent = 15 }, -- Lynx Rush
        { spell = 121818, type = "ability", requiresTarget = true }, -- Stampede
        { spell = 131894, type = "ability", debuff = true, requiresTarget = true, talent = 13 }, -- A Murder of Crows
        { spell = 147362, type = "ability", requiresTarget = true, usable = true }, -- Counter Shot
        { spell = 148467, type = "ability", charges = true, buff = true }, -- Deterrence
      },
      icon = 135130
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.ROGUE = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 132290
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 132302
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 132350
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = comboPointsIcon,
    },
  }
}

templates.class.PRIEST = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 135940
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 136207
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 136224
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.SHAMAN = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 135863
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 135813
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 135963
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = 135990,
    },
  }
}

templates.class.MAGE = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 136096
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 135848
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 136075
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = manaIcon,
    },
  }
}

templates.class.WARLOCK = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 136210
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 136139
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 135808
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\inv_misc_gem_amethyst_02",
    },
  }
}

templates.class.DRUID = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 136097
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 132114
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 132134
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources and Shapeshift Form"],
      args = {
      },
      icon = manaIcon,
    },
  },
}

templates.class.DEATHKNIGHT = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 237517
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 237514
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 136120
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\PlayerFrame\\UI-PlayerFrame-Deathknight-SingleRune",
    },
  }
}

templates.class.MONK = {
  [1] = {
    [1] = {
      title = L["Buffs"],
      args = {

      },
      icon = 237517
    },
    [2] = {
      title = L["Debuffs"],
      args = {

      },
      icon = 237514
    },
    [3] = {
      title = L["Cooldowns"],
      args = {

      },
      icon = 136120
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {
      title = L["Resources"],
      args = {
      },
      icon = "Interface\\Icons\\monk_stance_drunkenox",
    },
  }
}

-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\inv_potion_54",
  type = "health"
});
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = 136209,
  type = "cast"
});
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_alwaystrue = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_HasPet = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\ability_defend.blp",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Pet Behavior"),
    event = "Pet Behavior",
    use_behavior = true,
    behavior = "assist"}}}
});

tinsert(templates.general.args, {
  spell = 2825, type = "buff", unit = "player",
  forceOwnOnly = true,
  ownOnly = nil,
  overideTitle = L["Bloodlust/Heroism"],
  spellIds = {2825, 32182}}
);

-- Meta template for Power triggers
local function createSimplePowerTemplate(powertype)
  local power = {
    title = powerTypes[powertype].name,
    icon = powerTypes[powertype].icon,
    type = "power",
    powertype = powertype,
  }
  return power;
end

-------------------------------
-- Hardcoded trigger templates
-------------------------------

-- Warrior
tinsert(templates.class.WARRIOR[1][8].args, {
  title = L["Stance"],
  icon = 132349,
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
    event = "Stance/Form/Aura"}}}
})
for j, id in ipairs({2457, 71, 2458}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    tinsert(templates.class.WARRIOR[1][8].args, {
      title = title,
      icon = icon,
      triggers = {
        [1] = {
          trigger = {
            type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
            event = "Stance/Form/Aura",
            use_form = true,
            form = { single = j }
          }
        }
      }
    });
  end
end

tinsert(templates.class.WARRIOR[1][8].args, createSimplePowerTemplate(1));
tinsert(templates.class.PALADIN[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.HUNTER[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(3));
tinsert(templates.class.ROGUE[1][8].args, createSimplePowerTemplate(4));
tinsert(templates.class.PRIEST[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.SHAMAN[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.MAGE[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.WARLOCK[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(1));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(3));
tinsert(templates.class.DRUID[1][8].args, createSimplePowerTemplate(4));

tinsert(templates.class.MONK[1][8].args, createSimplePowerTemplate(0));
tinsert(templates.class.MONK[1][8].args, createSimplePowerTemplate(3));
tinsert(templates.class.MONK[1][8].args, createSimplePowerTemplate(12));

-- Shapeshift Form
tinsert(templates.class.DRUID[1][8].args, {
  title = L["Shapeshift Form"],
  icon = 132276,
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
    event = "Stance/Form/Aura"}}}
});
for j, id in ipairs({5487, 768, 783, 114282, 1394966}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    tinsert(templates.class.DRUID[1][8].args, {
      title = title,
      icon = icon,
      triggers = {
        [1] = {
          trigger = {
            type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
            event = "Stance/Form/Aura",
            use_form = true,
            form = { single = j }
          }
        }
      }
    });
  end
end


------------------------------
-- Hardcoded race templates
-------------------------------

-- Will of Survive
tinsert(templates.race.Human, { spell = 59752, type = "ability" });
-- Stoneform
tinsert(templates.race.Dwarf, { spell = 20594, type = "ability", buff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.Dwarf, { spell = 20594, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Shadow Meld
tinsert(templates.race.NightElf, { spell = 58984, type = "ability", buff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.NightElf, { spell = 58984, type = "buff", titleSuffix = L["buff"]});
-- Escape Artist
tinsert(templates.race.Gnome, { spell = 20589, type = "ability" });

-- Blood Fury
tinsert(templates.race.Orc, { spell = 20572, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Orc, { spell = 20572, type = "buff", unit = "player", titleSuffix = L["buff"]});
--Cannibalize
tinsert(templates.race.Scourge, { spell = 20577, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 20578, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Will of the Forsaken
tinsert(templates.race.Scourge, { spell = 7744, type = "ability", buff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 7744, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- War Stomp
tinsert(templates.race.Tauren, { spell = 20549, type = "ability", debuff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.Tauren, { spell = 20549, type = "debuff", titleSuffix = L["debuff"]});
--Beserking
tinsert(templates.race.Troll, { spell = 26297, type = "ability", buff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.Troll, { spell = 26297, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Arcane Torrent
tinsert(templates.race.BloodElf, { spell = 28730, type = "ability", debuff = true, titleSuffix = L["cooldown"]});
-- Gift of the Naaru
tinsert(templates.race.Draenei, { spell = 28880, type = "ability", buff = true, titleSuffix = L["cooldown"]});
tinsert(templates.race.Draenei, { spell = 28880, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Quaking Palm
tinsert(templates.race.Pandaren, { spell = 107079, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Pandaren, { spell = 107079, type = "buff", titleSuffix = L["buff"]});
------------------------------
-- Helper code for options
-------------------------------

-- Enrich items from spell, set title
local function handleItem(item)
  local waitingForItemInfo = false;
  if (item.spell) then
    local name, icon, _;
    if (item.type == "item") then
      name, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Item"] .. " " .. tostring(item.spell);
        waitingForItemInfo = true;
      end
    else
      name, _, icon = GetSpellInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Spell"] .. " " .. tostring(item.spell);
      end
    end
    if (icon and not item.icon) then
      item.icon = icon;
    end

    item.title = item.overideTitle or name or "";
    if (item.titleSuffix) then
      item.title = item.title .. " " .. item.titleSuffix;
    end
    if (item.titlePrefix) then
      item.title = item.titlePrefix .. item.title;
    end
    if (item.titleItemPrefix) then
      local prefix = C_Item.GetItemInfo(item.titleItemPrefix);
      if (prefix) then
        item.title = prefix .. "-" .. item.title;
      else
        waitingForItemInfo = true;
      end
    end
    if (item.type ~= "item") then
      local spell = Spell:CreateFromSpellID(item.spell);
      if (not spell:IsSpellEmpty()) then
        spell:ContinueOnSpellLoad(function()
          item.description = GetSpellDescription(spell:GetSpellID());
        end);
      end
      item.description = GetSpellDescription(item.spell);
    end
  end
  if (item.talent) then
    item.load = item.load or {};
    if type(item.talent) == "table" then
      item.load.talent = { multi = {} };
      for _,v in pairs(item.talent) do
        item.load.talent.multi[v] = true;
      end
      item.load.use_talent = false;
    else
      item.load.talent = {
        single = item.talent,
        multi = {};
      };
      item.load.use_talent = true;
    end
  end
  if (item.pvptalent) then
    item.load = item.load or {};
    item.load.use_pvptalent = true;
    item.load.pvptalent = {
      single = item.pvptalent,
      multi = {};
    }
  end
  if (item.covenant) then
    item.load = item.load or {}
    item.load.use_covenant = true
    item.load.covenant = {
      single = item.covenant,
      multi = {}
    }
  end
  if (item.bonusItemId) then
    item.load = item.load or {}
    item.load.use_item_bonusid_equipped = true
    item.load.item_bonusid_equipped = tostring(item.bonusItemId)
  end
  -- form field is lazy handled by a usable condition
  if item.form then
    item.usable = true
  end
  return waitingForItemInfo;
end

local function addLoadCondition(item, loadCondition)
  -- No need to deep copy here, templates are read-only
  item.load = item.load or {};
  for k, v in pairs(loadCondition) do
    item.load[k] = v;
  end
end

local delayedEnrichDatabase = false;
local itemInfoReceived = CreateFrame("Frame")

local enrichTries = 0;
local function enrichDatabase()
  if (enrichTries > 3) then
    return;
  end
  enrichTries = enrichTries + 1;

  local waitingForItemInfo = false;
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        local loadCondition = {
          use_class = true, class = { single = className, multi = {} },
        };
        for itemIndex, item in pairs(section.args or {}) do
          local handle = handleItem(item)
          if(handle) then
            waitingForItemInfo = true;
          end
          addLoadCondition(item, loadCondition);
        end
      end
    end
  end

  for raceName, race in pairs(templates.race) do
    local loadCondition = {
      use_race = true, race = { single = raceName, multi = {} }
    };
    for _, item in pairs(race) do
      local handle = handleItem(item)
      if handle then
        waitingForItemInfo = true;
      end
      if handle ~= nil then
        addLoadCondition(item, loadCondition);
      end
    end
  end

  for _, item in pairs(templates.general.args) do
    if (handleItem(item)) then
      waitingForItemInfo = true;
    end
  end

  if (waitingForItemInfo) then
    itemInfoReceived:RegisterEvent("GET_ITEM_INFO_RECEIVED");
  else
    itemInfoReceived:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
  end
end


enrichDatabase();

itemInfoReceived:SetScript("OnEvent", function()
  if (not delayedEnrichDatabase) then
    delayedEnrichDatabase = true;
    C_Timer.After(2, function()
      enrichDatabase();
      delayedEnrichDatabase = false;
    end)
  end
end);


TemplatePrivate.triggerTemplates = templates
