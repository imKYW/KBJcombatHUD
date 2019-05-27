local _, ns = ...
local oUF = ns.oUF or oUF

-- sourced from FrameXML/Constants.lua
local SPELL_POWER_MANA = Enum.PowerType.Mana or 0
local SPELL_POWER_COMBO_POINTS = Enum.PowerType.ComboPoints or 4
local SPELL_POWER_SOUL_SHARDS = Enum.PowerType.SoulShards or 7
local SPELL_POWER_CHI = Enum.PowerType.Chi or 12
local SPELL_POWER_HOLY_POWER = Enum.PowerType.HolyPower or 9
local SPELL_POWER_ARCANE_CHARGES = Enum.PowerType.ArcaneCharges or 16

-- Tag Function -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-- Gradation Health Color
local healthColor = function(value)
    local r, g, b = 0, 0, 0

    if value > 0 then value = value / 100
    else
        value = 0
    end
    if value > 0.5 then
        r = (1 - value) * 2
        g = 1
    else
        r = 1
        g = value * 2
    end
    return r, g, b
end

-- Power Color (Recoloring for looks good)
oUF.colors.power['MANA'] = { 0.37, 0.6, 1 }
oUF.colors.power['RAGE'] = { 0.9,  0.3,  0.23 }
oUF.colors.power['RUNIC_POWER'] = { 0, 0.81, 1 }
oUF.colors.power['RUNES'] = { 0.5, 0.33, 0.66 }

local powerColor = function(unit)
    if not unit then return end
    local _, power, r, g, b = UnitPowerType(unit)
    local color = PowerBarColor[power]

    if color then
        r, g, b = color.r, color.g, color.b
    end
    return r, g, b
end

-- Hex to RGB
local hex = function(r, g, b)
    if not r then return '|cffFFFFFF' end
    if(type(r) == 'table') then
        if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
end

-- Shortcut Number
local scNumber = function(value)
    if value >= 1E10 then
        return ('%.fb'):format(value / 1E9)
    elseif value >= 1E7 then
        return ('%.fm'):format(value / 1E6)
    elseif value >= 1E6 then
        return ('%.1fm'):format(value / 1E6)
    elseif (value >= 1E3) then
        return ('%.fk'):format(value / 1E3)
    else
        return ('%d'):format(value)
    end
end

-- Shortcut String
local scString = function(string, i, dots)
    local bytes = string:len()

    if bytes <= i then
        return string
    else
        local len, pos = 0, 1
        while pos <= bytes do
            len = len + 1
            local c = string:byte(pos)
            if c > 0 and c <= 127 then
                pos = pos + 1
            elseif c >= 194 and c <= 223 then
                pos = pos + 2
            elseif c >= 224 and c <= 239 then
                pos = pos + 3
            elseif c >= 240 and c <= 244 then
                pos = pos + 4
            end
            if len == i then break end
        end
        if len == i and pos <= bytes then
            return string:sub(1, pos - 1)..(dots and '*' or '')
        else
            return string
        end
    end
end

-- Tag Function -------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

-- Return Reaction Color at Tag (usually name)
oUF.Tags.Methods['color'] = function(unit)
    local _, class = UnitClass(unit)
    local reaction = UnitReaction(unit, 'player')

    if (UnitIsTapDenied(unit)) then
        return hex(oUF.colors.tapped)
    elseif (UnitIsPlayer(unit)) then
        return hex(oUF.colors.class[class])
    elseif reaction and not (UnitIsPlayer(unit)) then
        return hex(oUF.colors.reaction[reaction])
    else
        return hex(1, 1, 1)
    end
end
oUF.Tags.Events['color'] = 'UNIT_FACTION'

-- Shortcut name
oUF.Tags.Methods['unit:name4'] = function(unit, raid)
    return scString(UnitName(realUnit or unit or r), 4, true)
end
oUF.Tags.Events['unit:name4'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['unit:name5'] = function(unit, raid)
    return scString(UnitName(realUnit or unit or raid), 5, true)
end
oUF.Tags.Events['unit:name5'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['unit:name8'] = function(unit, raid)
    return scString(UnitName(realUnit or unit or raid), 8, true)
end
oUF.Tags.Events['unit:name8'] = 'UNIT_NAME_UPDATE'
oUF.Tags.Methods['unit:name10'] = function(unit, raid)
    return scString(UnitName(realUnit or unit or raid), 10, true)
end
oUF.Tags.Events['unit:name10'] = 'UNIT_NAME_UPDATE'

-- LV + Classification
oUF.Tags.Methods['unit:lv'] = function(unit)
    local level = UnitLevel(unit)
    local classification = UnitClassification(unit)
    local color = GetQuestDifficultyColor(level)

    if level <= 0 then level = '??' end
    if classification == 'worldboss' then
        return hex(color)..level..'!'
    elseif classification == 'rare' then
        return hex(color)..level..'#'
    elseif classification == 'rareelite' then
        return hex(color)..level..'#+'
    elseif classification == 'elite' then
        return hex(color)..level..'+'
    else
        return hex(color)..level
    end
end
oUF.Tags.Events['unit:lv'] = 'UNIT_NAME_UPDATE'

-- Classification
oUF.Tags.Methods['unit:classification'] = function(unit)
    local classification = UnitClassification(unit)

    if classification == 'worldboss' then
        return '!'
    elseif classification == 'rare' then
        return '#'
    elseif classification == 'rareelite' then
        return '#+'
    elseif classification == 'elite' then
        return '+'
    else
        return false
    end
end
oUF.Tags.Events['unit:classification'] = 'UNIT_NAME_UPDATE'

-- Color HP% for HUD
oUF.Tags.Methods['unit:HPhud'] = function(unit)
    if UnitIsDead(unit) then
        return "|cff66666600|r"
    elseif UnitIsGhost(unit) then
        return "|cff666666##|r"
    elseif not UnitIsConnected(unit) then
        return "|cffe50000--|r"
    end

    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local healthValue = 0
    if max > 0 then healthValue = math.floor(min/max*100) end -- min/max*100+.5
    if healthValue < 10 then
        return hex(healthColor(healthValue)).."0"..healthValue
    elseif healthValue < 100 then
        return hex(healthColor(healthValue))..healthValue
    else
        return hex(healthColor(healthValue)).."00"
    end
end
oUF.Tags.Events['unit:HPhud'] = 'UNIT_HEALTH UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

-- Color HP%
oUF.Tags.Methods['unit:HPpercent'] = function(unit)
    if UnitIsDead(unit) then
        return "|cff666666Dead|r"
    elseif UnitIsGhost(unit) then
        return "|cff666666Ghost|r"
    elseif not UnitIsConnected(unit) then
        return "|cffe50000Offline|r"
    end

    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local healthValue = 0
    if max > 0 then healthValue = math.floor(min/max*100) end -- min/max*100+.5
    return hex(healthColor(healthValue))..healthValue
end
oUF.Tags.Events['unit:HPpercent'] = 'UNIT_HEALTH UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

-- Current HP
oUF.Tags.Methods['unit:HPcurrent'] = function(unit)
    return scNumber(UnitHealth(unit))
end
oUF.Tags.Events['unit:HPcurrent'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

-- Current HP if HP = 100%, not Color HP%
oUF.Tags.Methods['unit:HPmix'] = function(unit)
    if UnitIsDead(unit) then
        return "|cff666666Dead|r"
    elseif UnitIsGhost(unit) then
        return "|cff666666Ghost|r"
    elseif not UnitIsConnected(unit) then
        return "|cffe50000Offline|r"
    end

    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local healthValue = 0
    if (max > 0) and (min < max) then
        healthValue = math.floor(min/max*100) -- min/max*100+.5
        return hex(healthColor(healthValue))..healthValue
    else
        return scNumber(min)
    end
end
oUF.Tags.Events['unit:HPmix'] = 'UNIT_HEALTH UNIT_CONNECTION UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH'

-- PP% if Using % power, not Current PP
oUF.Tags.Methods['unit:PPflex'] = function(unit)
    local min, max = UnitPower(unit), UnitPowerMax(unit)
    local ptype = UnitPowerType(unit)
    local powerValue = math.floor(min / max * 100 + 0.5)

    if ptype == SPELL_POWER_MANA then
        return hex(powerColor(unit))..powerValue
    elseif powerColor(unit) then
        return hex(powerColor(unit))..min
    else
        return "|cffff00ff"..min.."|r"
    end
end
oUF.Tags.Events['unit:PPflex'] = 'UNIT_DISPLAYPOWER UNIT_POWER_FREQUENT UNIT_MAXPOWER'

-- Unit's Target is ME!
oUF.Tags.Methods['unit:TargetMe'] = function(unit)
    local isTargetPlayer = UnitIsUnit(unit.."target", "player")

    if isTargetPlayer then
        return "!!"
    else
        return ""
    end
end
oUF.Tags.Events['unit:TargetMe'] = 'NAME_PLATE_CREATED NAME_PLATE_UNIT_ADDED NAME_PLATE_UNIT_REMOVED UNIT_AURA UNIT_HEALTH UNIT_THREAT_SITUATION_UPDATE UNIT_THREAT_LIST_UPDATE'

-- Player Class Resource
oUF.Tags.Methods['player:Resource'] = function()
    local playerClass = select(2, UnitClass('player'))
    local playerClassSpec = GetSpecializationInfo(GetSpecialization())
    local num = 0

    if UnitHasVehicleUI'player' then
        num = UnitPower('vehicle', SPELL_POWER_COMBO_POINTS)
    -- Soul Shard
    elseif playerClass == 'WARLOCK' then
        num = UnitPower('player', SPELL_POWER_SOUL_SHARDS)
    -- Combo Points
    elseif playerClass == 'ROGUE'
    -- PlayerClass == 'DRUID' and RequireSpell = 5221 -- Shred
    or playerClassSpec == 104 -- Druid Feral
    or playerClassSpec == 103 -- Druid Guardian
        then
        num = UnitPower('player', SPELL_POWER_COMBO_POINTS)
    -- Chi
    elseif playerClassSpec == 269 then -- Monk Windwalker
        num = UnitPower('player', SPELL_POWER_CHI)
    -- Holy Power
    elseif playerClassSpec == 70 then -- Paladin Retribution
        num = UnitPower('player', SPELL_POWER_HOLY_POWER)
    -- Arcane Charge
    elseif playerClassSpec == 62 then -- Mage Arcane
        num = UnitPower('player', SPELL_POWER_ARCANE_CHARGES)
    else
        return
    end

    if(num > 0) then
        return num
    end
end
oUF.Tags.Events['player:Resource'] = 'UNIT_POWER_UPDATE SPELLS_CHANGED PLAYER_SPECIALIZATION_CHANGED'

-- Player Mana if Mana is Sub Resource
oUF.Tags.Methods['player:SubMana'] = function()
    local playerClassSpec = GetSpecializationInfo(GetSpecialization())

    if playerClassSpec == 263 -- Shaman Elemental
    or playerClassSpec == 262 -- Shaman Enhancement
    or playerClassSpec == 104 -- Druid Guardian
    or playerClassSpec == 103 -- Druid Feral
    or playerClassSpec == 102 -- Druid Balance
    or playerClassSpec == 258 -- Priest Shadow
        then
        return "|cff5e99ff"..math.floor(UnitPower('player', SPELL_POWER_MANA) / UnitPowerMax('player', SPELL_POWER_MANA) * 100 + 0.5).."|r"
    end
end
oUF.Tags.Events['player:SubMana'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER PLAYER_SPECIALIZATION_CHANGED'

-- Stagger% for Monk BM
oUF.Tags.Methods['player:StaggerPercent'] = function()
    local curStagger = UnitStagger("player") or 0
    local stagger = curStagger / UnitHealthMax("player") * 100
    local staggerText = scNumber(stagger)

    if stagger >= 60 then return hex(1, 0.42, 0.42)..staggerText
    elseif stagger >= 30 then return hex(1, 0.98, 0.72)..staggerText
    elseif stagger > 0 then return hex(0.52, 1, 0.52)..staggerText
    else
        return
    end
end
oUF.Tags.Events['player:StaggerPercent'] = 'UNIT_AURA UNIT_DISPLAYPOWER PLAYER_SPECIALIZATION_CHANGED PLAYER_TALENT_UPDATE'
-- UNIT_DISPLAYPOWER PLAYER_TALENT_UPDATE PLAYER_ENTERING_WORLD PLAYER_SPECIALIZATION_CHANGED UNIT_DISPLAYPOWER UNIT_EXITED_VEHICLE

-- Current Stagger for Monk BM
oUF.Tags.Methods['player:StaggerCurrent'] = function()
    local stagger = UnitStagger("player") or 0
    if stagger > 0 then return scNumber(stagger)
    else
        return
    end
end
oUF.Tags.Events['player:StaggerCurrent'] = 'UNIT_AURA UNIT_DISPLAYPOWER PLAYER_SPECIALIZATION_CHANGED PLAYER_TALENT_UPDATE'
