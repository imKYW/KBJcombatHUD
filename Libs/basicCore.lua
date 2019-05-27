local name, ns = ...
local cfg = ns.cfg

--[[ Temp
PetCastingBarFrame:UnregisterAllEvents()
PetCastingBarFrame.Show = function() end
PetCastingBarFrame:Hide()
]]

-- Setup FloatingCombatText -------------------------------------------------------------
CombatTextFont:SetFont(cfg.font, cfg.plugin.fcf.size, cfg.fontflag)
CombatTextFont:SetShadowOffset(0,0)
CombatTextFont:SetShadowColor(0,0,0,0.4)

-- Frame Backdrop -----------------------------------------------------------------------
function fBackDrop(parent, anchor)
    local f = CreateFrame('Frame', nil, parent)
    f:SetFrameLevel(parent:GetFrameLevel()-1 or 0)
    f:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -3, 3)
    f:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 3, -3)
    f:SetBackdrop({
        edgeFile = cfg.glow, edgeSize = 3,
        bgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
        insets = { left = 3, right = 3, top = 3, bottom = 3 } })
    f:SetBackdropColor(0, 0, 0)
    f:SetBackdropBorderColor(0, 0, 0)
    return f
end

-- Statusbar Texture --------------------------------------------------------------------
function cStatusbar(parent, texture, layer, width, height, r, g, b, alpha)
    local sb = CreateFrame('StatusBar', nil, parent)
    sb:SetParent(parent)
    if width then sb:SetWidth(width) end
    if height then sb:SetHeight(height) end
    sb:SetStatusBarTexture(texture, layer)
    sb:SetStatusBarColor(r, g, b, alpha)
    return sb
end

-- Font String --------------------------------------------------------------------------
function cFontString(parent, layer, font, fontsize, fontflag, r, g, b, justify)
    local fs = parent:CreateFontString(nil, layer)
    fs:SetFont(font, fontsize, fontflag)
    fs:SetShadowOffset(cfg.shadowoffsetX, cfg.shadowoffsetY)
    fs:SetTextColor(r, g, b)
    if justify then fs:SetJustifyH(justify) end
    return fs
end

-- Highlight On/Off ---------------------------------------------------------------------
function OnEnterHL(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()
end

function OnLeaveHL(self)
    UnitFrame_OnLeave(self)
    self.Highlight:Hide()
end

-- Health / Power -----------------------------------------------------------------------
local PostUpdateHealth = function(health, unit)
    if UnitIsDead(unit) then
        health:SetValue(0)
    elseif UnitIsGhost(unit) then
        health:SetValue(0)
    elseif not UnitIsConnected(unit) then
        health:SetValue(0)
    end
end

function Health(self)
    local h = cStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)
    h:SetPoint('TOP')
    h:SetPoint('LEFT')
    h:SetPoint('RIGHT')

    local hbg = h:CreateTexture(nil, 'BACKGROUND')
    hbg:SetAllPoints(h)
    hbg:SetTexture(cfg.texture)
    hbg.multiplier = 0.3

    local hl = h:CreateTexture(nil, 'OVERLAY')
    hl:SetAllPoints(h)
    hl:SetTexture('Interface\\Buttons\\WHITE8x8')
    hl:SetVertexColor(1, 1, 1, 0.05)
    hl:SetBlendMode('ADD')
    hl:Hide()

    h.Smooth = true
    h.colorClass = true
    h.colorReaction = true
    h.frequentUpdates = false

    self.Health = h
    self.Health.bg = hbg
    self.Health.PostUpdate = PostUpdateHealth
    self.Highlight = hl
end

function Power(self, direction) -- TOP else BOTTOM
    local p = cStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)
    p:SetPoint('LEFT')
    p:SetPoint('RIGHT')
    if direction == 'TOP' then
        p:SetPoint('BOTTOM', self.Health, 'TOP', 0, 1)
    elseif direction == 'BOTTOM' then
        p:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
    else
        p:SetPoint('TOP')
    end

    local pbg = p:CreateTexture(nil, 'BACKGROUND')
    pbg:SetAllPoints(p)
    pbg:SetTexture(cfg.texture)
    pbg.multiplier = 0.4

    p.Smooth = true
    p.colorPower = true

    if unit == 'player' and powerType ~= 0 then p.frequentUpdates = true end

    self.Power = p
    self.Power.bg = pbg
end

function HealthPrediction(self)
    local myBar = CreateFrame('StatusBar', nil, self.Health)
    myBar:SetPoint('TOP')
    myBar:SetPoint('BOTTOM')
    myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    myBar:SetStatusBarTexture(cfg.absorb)
    myBar:SetStatusBarColor(0.1, 1, 0.3, 0.5)
    myBar:SetWidth(200)

    local otherBar = CreateFrame('StatusBar', nil, self.Health)
    otherBar:SetPoint('TOP')
    otherBar:SetPoint('BOTTOM')
    otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    otherBar:SetStatusBarTexture(cfg.absorb)
    otherBar:SetStatusBarColor(0.1, 1, 0.3, 0.5)
    otherBar:SetWidth(200)

    local absorbBar = CreateFrame('StatusBar', nil, self.Health)
    absorbBar:SetPoint('TOP')
    absorbBar:SetPoint('BOTTOM')
    absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
    absorbBar:SetStatusBarTexture(cfg.absorb)
    absorbBar:SetStatusBarColor(0.1, 1, 1, 0.5)
    absorbBar:SetWidth(200)

    local healAbsorbBar = CreateFrame('StatusBar', nil, self.Health)
    healAbsorbBar:SetPoint('TOP')
    healAbsorbBar:SetPoint('BOTTOM')
    healAbsorbBar:SetPoint('RIGHT', self.Health:GetStatusBarTexture())
    healAbsorbBar:SetStatusBarTexture(cfg.absorb)
    healAbsorbBar:SetStatusBarColor(0.1, 0.1, 0.1, 0.6)
    healAbsorbBar:SetWidth(200)
    healAbsorbBar:SetReverseFill(true)

    local overAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
    overAbsorb:SetPoint('TOP')
    overAbsorb:SetPoint('BOTTOM')
    overAbsorb:SetPoint('LEFT', self.Health, 'RIGHT')
    overAbsorb:SetWidth(5)

    local overHealAbsorb = self.Health:CreateTexture(nil, "OVERLAY")
    overHealAbsorb:SetPoint('TOP')
    overHealAbsorb:SetPoint('BOTTOM')
    overHealAbsorb:SetPoint('RIGHT', self.Health, 'LEFT')
    overHealAbsorb:SetWidth(5)

    -- Register with oUF
    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        absorbBar = absorbBar,
        healAbsorbBar = healAbsorbBar,
        overAbsorb = overAbsorb,
        overHealAbsorb = overHealAbsorb,
        maxOverflow = 1.05,
        frequentUpdates = true,
    }
end

-- PhaseIndicator -----------------------------------------------------------------------
function Phase(self)
    local pi = CreateFrame('Frame', nil, self.Health)
    pi:SetFrameLevel(self.Health:GetFrameLevel()+1)
    pi:SetSize(10, 10)
    pi:SetPoint('CENTER', 0,-3)
    pi:SetAlpha(0.2)
    pi.text = cFontString(pi, 'OVERLAY', cfg.symbol, 18, '', 1, 0, 1)
    pi.text:SetShadowOffset(1, -1)
    pi.text:SetPoint('CENTER')
    pi.text:SetText('M')
    self.PhaseIndicator = pi
end

-- SummonIndicator ----------------------------------------------------------------------
local function UpdateSummon(self, event)
    local element = self.SummonIndicator
    local icon = element.Icon

    local status = C_IncomingSummon.IncomingSummonStatus(self.unit)
    if(status == Enum.SummonStatus.None) then
        element:Hide()
    else
        element:Show()

        if(status == Enum.SummonStatus.Pending) then
            icon:SetVertexColor(1, 1, 1)
            icon:SetDesaturated(false)
            element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_PENDING
        elseif(status == Enum.SummonStatus.Accepted) then
            icon:SetVertexColor(0, 1, 0)
            icon:SetDesaturated(true)
            element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_ACCEPTED
        elseif(status == Enum.SummonStatus.Declined) then
            icon:SetVertexColor(1, 0.3, 0.3)
            icon:SetDesaturated(true)
            element.tooltip = INCOMING_SUMMON_TOOLTIP_SUMMON_DECLINED
        end
    end
end

local function OnSummonEnter(self)
    GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    GameTooltip:SetText(self.tooltip)
    GameTooltip:Show()
end

-- Current Target/Focus -----------------------------------------------------------------
local CurrentTarget = function(self)
    if UnitIsUnit('target', self.unit) then
        self.TargetBorder:Show()
    else
        self.TargetBorder:Hide()
    end
end

local CurrentFocus = function(self)
    if UnitIsUnit('focus', self.unit) then
        self.FocusBorder:Show()
    else
        self.FocusBorder:Hide()
    end
end

function ctfBorder(self)
    local ctfBackdrop = {
        bgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
        insets = { left = -2, right = -2, top = -2, bottom = -2 }
    }

    local ctBorder = CreateFrame('Frame', nil, self)
    ctBorder:SetPoint('TOPLEFT', self, 'TOPLEFT')
    ctBorder:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT')
    ctBorder:SetBackdrop(ctfBackdrop)
    ctBorder:SetBackdropColor(0.9, 0.9, 0.9, 1)
    ctBorder:SetFrameLevel(1)
    ctBorder:Hide()

    local cfBorder = CreateFrame('Frame', nil, self)
    cfBorder:SetPoint('TOPLEFT', self, 'TOPLEFT')
    cfBorder:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT')
    cfBorder:SetBackdrop(ctfBackdrop)
    cfBorder:SetBackdropColor(0.6, 0.9, 0, 1)
    cfBorder:SetFrameLevel(1)
    cfBorder:Hide()

    self.TargetBorder = ctBorder
    self.FocusBorder = cfBorder

    self:RegisterEvent('PLAYER_TARGET_CHANGED', CurrentTarget, true)
    self:RegisterEvent('PLAYER_FOCUS_CHANGED', CurrentFocus, true)
end

-- Buff/Debuff/Aura Icon ----------------------------------------------------------------
local GetTime = GetTime
local day, hour, minute = 86400, 3600, 60
local FormatTime = function(s)
    if s >= day then
        return format('%d', floor(s/day + 0.5))
    elseif s >= hour then
        return format('%d', floor(s/hour + 0.5))
    elseif s >= minute then
        return format('%d', floor(s/minute + 0.5))
    end
    return format('%d', math.fmod(s, minute))
end

local CreateAuraTimer = function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 0.1 then
        self.timeLeft = self.expires - GetTime()
        if self.timeLeft > 0 then
            local time = FormatTime(self.timeLeft)
                self.remaining:SetText(time)
            if self.timeLeft < 6 then
                self.remaining:SetTextColor(0.69, 0.31, 0.31)
            elseif self.timeLeft < 60 then
                self.remaining:SetTextColor(1, 0.85, 0)
            elseif self.timeLeft < 3600 then
                self.remaining:SetTextColor(0.35, 0.85, 0.35)
            else
                self.remaining:SetTextColor(1, 1, 1)
            end
        else
            self.remaining:Hide()
            self:SetScript('OnUpdate', nil)
        end
        self.elapsed = 0
    end
end

function PostCreateIconNP(auras, button)
    local btnC = button.count
    btnC:ClearAllPoints()
    btnC:SetPoint('CENTER', button, 'BOTTOMRIGHT', 1, 0)
    btnC:SetFontObject(nil)
    btnC:SetFont(cfg.aurafont, 8, cfg.fontflag)
    btnC:SetTextColor(1, 1, 1)

    auras.disableCooldown = true
    auras.showDebuffType = true

    button.overlay:SetTexture(nil)
    button.icon:SetTexCoord(.1, .9, .1, .9)
    button:SetBackdrop(backdrop)
    button:SetBackdropColor(0, 0, 0, 1)

    button.glow = CreateFrame('Frame', nil, button)
    button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -3, 3)
    button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 3, -3)
    button.glow:SetFrameLevel(button:GetFrameLevel()-1)
    button.glow:SetBackdrop({bgFile = '', edgeFile = cfg.glow, edgeSize = 4,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })

    local remaining = cFontString(button, 'OVERLAY', cfg.aurafont, 6, cfg.fontflag, 1, 1, 1)
    remaining:SetPoint('TOPLEFT')
    button.remaining = remaining
end

function PostCreateIconSmall(auras, button)
    local btnC = button.count
    btnC:ClearAllPoints()
    btnC:SetPoint('CENTER', button, 'BOTTOMRIGHT', 1, 0)
    btnC:SetFontObject(nil)
    btnC:SetFont(cfg.aurafont, 8, cfg.fontflag)
    btnC:SetTextColor(1, 1, 1)

    auras.disableCooldown = true
    auras.showDebuffType = true

    button.overlay:SetTexture(nil)
    button.icon:SetTexCoord(.1, .9, .1, .9)
    button:SetBackdrop(backdrop)
    button:SetBackdropColor(0, 0, 0, 1)

    button.glow = CreateFrame('Frame', nil, button)
    button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -3, 3)
    button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 3, -3)
    button.glow:SetFrameLevel(button:GetFrameLevel()-1)
    button.glow:SetBackdrop({bgFile = '', edgeFile = cfg.glow, edgeSize = 4,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })

    local remaining = cFontString(button, 'OVERLAY', cfg.aurafont, 8, cfg.fontflag, 1, 1, 1)
    remaining:SetPoint('TOPLEFT')
    button.remaining = remaining
end

function PostCreateIconNormal(auras, button)
    local btnC = button.count
    btnC:ClearAllPoints()
    btnC:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 2, 0)
    btnC:SetFontObject(nil)
    btnC:SetFont(cfg.aurafont, 10, cfg.fontflag)
    btnC:SetTextColor(1, 1, 1)

    auras.disableCooldown = true
    auras.showDebuffType = true

    button.overlay:SetTexture(nil)
    button.icon:SetTexCoord(.1, .9, .1, .9)
    button:SetBackdrop(backdrop)
    button:SetBackdropColor(0, 0, 0, 1)

    button.glow = CreateFrame('Frame', nil, button)
    button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -3, 3)
    button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 3, -3)
    button.glow:SetFrameLevel(button:GetFrameLevel()-1)
    button.glow:SetBackdrop({bgFile = '', edgeFile = cfg.glow, edgeSize = 4,
    insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })

    local remaining = cFontString(button, 'OVERLAY', cfg.font, 12, cfg.fontflag, 1, 1, 1)
    remaining:SetPoint('TOPLEFT', 1, 0)
    button.remaining = remaining
end

function PostUpdateIcon(icons, unit, icon, index, offset)
    local name, _, _, dtype, duration, expirationTime, unitCaster = UnitAura(unit, index, icon.filter)
    local texture = icon.icon
    if icon.isPlayer or UnitIsFriend('player', unit) or not icon.isDebuff then
        texture:SetDesaturated(false)
    else
        texture:SetDesaturated(true)
    end
    if duration and duration > 0 then
        icon.remaining:Show()
    else
        icon.remaining:Hide()
    end

    local r,g,b = icon.overlay:GetVertexColor()
    if icon.isDebuff then
        icon.glow:SetBackdropBorderColor(r, g, b, 1)
    else
        icon.glow:SetBackdropBorderColor(0, 0, 0, 1)
    end

    icon.duration = duration
    icon.expires = expirationTime
    icon:SetScript('OnUpdate', CreateAuraTimer)
end

-- AuraTracker --------------------------------------------------------------------------
function AuraTracker(self, size, sa, a, pa, x, y)
    self.FreebAuras = CreateFrame('Frame', nil, self)
    self.FreebAuras:SetSize(size, size)
    self.FreebAuras:SetPoint(sa, a, pa, x, y)
end
