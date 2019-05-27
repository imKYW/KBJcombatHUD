local _, ns = ...
local cfg = ns.cfg

local kbjStyle = {}

function kbjStyle:PostCastStart(unit, name, rank, castid)
    local color
    if self.notInterruptible then
        color = { 1, 1, 1 }
    elseif UnitIsFriend(unit, "player") then
        color = { 0.1, 0.8, 0.1 }
    else
        color = { 1, 0.7, 0 }
    end
    local r, g, b = color[1], color[2], color[3]
    self:SetStatusBarColor(r, g, b)
    self.bg:SetVertexColor(r * 0.2, g * 0.2, b * 0.2)

    self.__castType = "CAST"
end

function kbjStyle:PostChannelStart(unit, name, rank, text)
    local color
    if self.notInterruptible then
        color = { 1, 1, 1 }
    elseif UnitIsFriend(unit, "player") then
        color = { 0.1, 0.8, 0.1 }
    else
        color = { 1, 0.7, 0 }
    end
    local r, g, b = color[1], color[2], color[3]
    self:SetStatusBarColor(r, g, b)
    self.bg:SetVertexColor(r * 0.2, g * 0.2, b * 0.2)

    self.__castType = "CHANNEL"
end

function kbjStyle:CustomDelayText(duration)
    self.Time:SetFormattedText("%.1f|cffff0000%.1f|r", self.max - duration, -self.delay)
end

function kbjStyle:CustomTimeText(duration)
    self.Time:SetFormattedText("%.1f", self.max - duration)
end

function extCastbar(self)
    local castbar = CreateFrame('StatusBar', nil, self)
    castbar:SetStatusBarTexture(cfg.texture)
    castbar:SetFrameStrata('MEDIUM')
    local castbarBG = castbar:CreateTexture(nil, 'BACKGROUND')
    castbarBG:SetTexture(cfg.texture)
    castbarBG:SetAllPoints()
    fBackDrop(castbar, castbar)

    local castbarIcon = castbar:CreateTexture(nil, 'BACKGROUND', nil, -8)
    castbarIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    fBackDrop(castbar, castbarIcon)
    local castbarName = castbar:CreateFontString(nil, nil)
    castbarName:SetShadowOffset(0, 0)
    castbarName:SetTextColor(1, 1, 1)
    local castbarTime = castbar:CreateFontString(nil, nil)
    castbarTime:SetShadowOffset(0, 0)
    castbarTime:SetTextColor(1, 1, 1)
    local castbarShield = castbar:CreateTexture(nil, "OVERLAY")
    castbarShield:SetTexture("Interface\\AddOns\\KBJcombatHUD\\Media\\shieldAura.tga")

    if self.unit == 'player' then
        castbar:SetSize(cfg.castbar.player.width, cfg.castbar.player.height)
        castbar:SetPoint(cfg.castbar.player.position.sa, cfg.castbar.player.position.a, cfg.castbar.player.position.pa, cfg.castbar.player.position.x, cfg.castbar.player.position.y)
        castbarIcon:SetSize(cfg.castbar.player.height, cfg.castbar.player.height)
        castbarIcon:SetPoint('BOTTOMRIGHT', castbar, 'BOTTOMLEFT', -3, 0)
        castbarName:SetFont(cfg.font, 11, cfg.fontflag)
        castbarName:SetJustifyH('LEFT')
        castbarName:SetPoint('LEFT', castbar, 'LEFT', 1, 0)
        castbarTime:SetFont(cfg.bfont, 11, cfg.fontflag)
        castbarTime:SetJustifyH('RIGHT')
        castbarTime:SetPoint('RIGHT', castbar, 'RIGHT', 0, 0)
        castbarShield:SetSize(cfg.castbar.player.height*2.7, cfg.castbar.player.height*2.7)
        castbarShield:SetPoint("CENTER", castbarIcon, "CENTER", 0, 1)
    elseif self.unit == 'target' then
        castbar:SetSize(cfg.castbar.target.width, cfg.castbar.target.height)
        castbar:SetPoint(cfg.castbar.target.position.sa, cfg.castbar.target.position.a, cfg.castbar.target.position.pa, cfg.castbar.target.position.x, cfg.castbar.target.position.y)
        castbarIcon:SetSize(cfg.castbar.target.height*1.7, cfg.castbar.target.height*1.7)
        castbarIcon:SetPoint('RIGHT', castbar, 'LEFT', -3, 0)
        castbarName:SetFont(cfg.font, 13, cfg.fontflag)
        castbarName:SetJustifyH('LEFT')
        castbarName:SetPoint('LEFT', castbar, 'LEFT', 1, 0)
        castbarTime:SetFont(cfg.bfont, 13, cfg.fontflag)
        castbarTime:SetJustifyH('RIGHT')
        castbarTime:SetPoint('RIGHT', castbar, 'RIGHT', 0, 0)
        castbarShield:SetSize(cfg.castbar.target.height*4, cfg.castbar.target.height*4)
        castbarShield:SetPoint("CENTER", castbarIcon, "CENTER", 0, 1)
    elseif self.unit == 'focus' then
        castbar:SetSize(cfg.castbar.focus.width, cfg.castbar.focus.height)
        castbar:SetPoint(cfg.castbar.focus.position.sa, cfg.castbar.focus.position.a, cfg.castbar.focus.position.pa, cfg.castbar.focus.position.x, cfg.castbar.focus.position.y)
        castbarIcon:SetSize(cfg.castbar.focus.height, cfg.castbar.focus.height)
        castbarIcon:SetPoint('RIGHT', castbar, 'LEFT', -3, 0)
        castbarName:SetFont(cfg.font, 11, cfg.fontflag)
        castbarName:SetJustifyH('LEFT')
        castbarName:SetPoint('LEFT', castbar, 'LEFT', 1, 0)
        castbarTime:SetFont(cfg.bfont, 11, cfg.fontflag)
        castbarTime:SetJustifyH('RIGHT')
        castbarTime:SetPoint('RIGHT', castbar, 'RIGHT', 0, 0)
        castbarShield:SetSize(cfg.castbar.focus.height*4, cfg.castbar.focus.height*4)
        castbarShield:SetPoint("CENTER", castbarIcon, "CENTER", 0, 1)
    elseif self.unit == 'nameplate' then
        castbar:SetSize(90, 7)
        castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -6)
        castbarIcon:SetSize(23, 23)
        castbarIcon:SetPoint('BOTTOMRIGHT', castbar, 'BOTTOMLEFT', -3, 0)
        castbarName:SetFont(cfg.font, 7, cfg.fontflag)
        castbarName:SetJustifyH('LEFT')
        castbarName:SetPoint('LEFT', castbar, 'LEFT', 1, 0)
        castbarTime:SetFont(cfg.bfont, 7, cfg.fontflag)
        castbarTime:SetJustifyH('RIGHT')
        castbarTime:SetPoint('RIGHT', castbar, 'RIGHT', 0, 0)
        castbarShield:SetSize(49, 49)
        castbarShield:SetPoint("CENTER", castbarIcon, "CENTER", 0, 1)
    end

    local castbarSpark = castbar:CreateTexture(nil, "OVERLAY")
    castbarSpark:SetBlendMode("ADD")
    castbarSpark:SetSize(14, 35)

    local castbarSafeZone = castbar:CreateTexture(nil, 'ARTWORK')
    castbarSafeZone:SetTexture(cfg.texture)
    castbarSafeZone:SetVertexColor(0.8, 0.11, 0.15, 0.7)

    for k, v in pairs(kbjStyle) do
        castbar[k] = v
    end

    self.Castbar = castbar
    self.Castbar.bg = castbarBG
    self.Castbar.Text = castbarName
    self.Castbar.Time = castbarTime
    self.Castbar.Icon = castbarIcon
    self.Castbar.Shield = castbarShield
    self.Castbar.Spark = castbarSpark
    self.Castbar.SafeZone = castbarSafeZone
end
