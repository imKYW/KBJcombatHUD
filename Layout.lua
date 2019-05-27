local _, A = ...
local cfg = A.cfg
local oUF = A.oUF or oUF
local class = select(2, UnitClass('player'))

local auraLoader = CreateFrame('Frame')
auraLoader:RegisterEvent('ADDON_LOADED')
auraLoader:SetScript('OnEvent', function(self, event, addon)
	ActivityAuras = ActivityAuras or {}
	PersonalAuras = PersonalAuras or {}
	--NameplateBuffs = NameplateBuffs or {}
	UpdateAuraList()
end)

local Shared = function(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', OnEnterHL)
	self:SetScript('OnLeave', OnLeaveHL)

	Health(self)

	self.fBackDrop = fBackDrop(self, self)
	self.Range = { insideAlpha = 1, outsideAlpha = 0.4 }
end

local UnitSpecific = {
	player = function(self, ...)
		Shared(self, ...)
		self.unit = 'player'

		--Power(self, 'BOTTOM')
		--HealthPrediction(self)
		extCastbar(self)

		self:SetSize(32, cfg.mainUF.player.height)
		--self.Health:SetHeight(cfg.mainUF.player.height-3)
		--self.Power:SetHeight(2)

		local htext = cFontString(self, nil, cfg.hudfont, 24, cfg.fontflag, 1, 1, 1, 'LEFT')
		htext:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 0)
		self:Tag(htext, '[unit:HPhud]')
		local ptext = cFontString(self, nil, cfg.bfont, 10, cfg.fontflag, 1, 1, 1, 'RIGHT')
		ptext:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 2, -3)
		self:Tag(ptext, '[unit:PPflex]')
		local cres = cFontString(self, nil, cfg.bfont, 18, cfg.fontflag, 1, 1, 1, 'LEFT')
		cres:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, 0)
		self:Tag(cres, '[color][player:Resource]')

		local subpower = cFontString(self, nil, cfg.bfont, 10, cfg.fontflag, 1, 1, 1, 'RIGHT')
		subpower:SetPoint('TOPRIGHT', ptext, 'BOTTOMRIGHT', 0, -3)
		self:Tag(subpower, '[player:SubMana]')

		if class == 'MONK' and not UnitHasVehicleUI('player') then
			local staggerPercent = cFontString(self, nil, cfg.hudfont, 20, cfg.fontflag, 1, 1, 1, 'RIGHT')
			staggerPercent:SetPoint('BOTTOMRIGHT', htext, 'BOTTOMLEFT', -5, 1)
			self:Tag(staggerPercent, '[player:StaggerPercent]')

			local staggerCurrent = cFontString(self, nil, cfg.bfont, 10, cfg.fontflag, 1, 1, 1, 'RIGHT')
			staggerCurrent:SetPoint('BOTTOMRIGHT', staggerPercent, 'TOPRIGHT', -1, 0)
			self:Tag(staggerCurrent, '[player:StaggerCurrent]')
		end
		--[[

		if class == 'DEATHKNIGHT' and not UnitHasVehicleUI('player') then
			local runes = CreateFrame('Frame', nil, self)
			runes:SetSize(cfg.mainUF.player.width, 5)
			runes:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
			runes.bg = fBackDrop(runes, runes)
			local i = 6
			for index = 1, 6 do
				runes[i] = cStatusbar(runes, cfg.texture, nil, cfg.mainUF.player.width/6-1, 5, 0.21, 0.6, 0.7, 1)
				if i == 6 then
					runes[i]:SetPoint('TOPRIGHT', runes, 'TOPRIGHT', 0, 0)
				else
					runes[i]:SetPoint('RIGHT', runes[i+1], 'LEFT', -1, 0)
				end
				runes[i].bg = runes[i]:CreateTexture(nil, 'BACKGROUND')
				runes[i].bg:SetAllPoints(runes[i])
				runes[i].bg:SetTexture(cfg.texture)
				runes[i].bg.multiplier = 0.3

				i=i-1
			end
			self.Runes = runes
		-- elseif class == 'DRUID' then
			-- TODO : MushroomBar?
		-- elseif class == 'SHAMAN' then
			-- TODO : TotemBar? like Runebar
		end
		]]

		local playerIndicatorFrame = CreateFrame('Frame', nil, self)
		playerIndicatorFrame:SetSize(cfg.mainUF.player.height, cfg.mainUF.player.height)
		playerIndicatorFrame:SetPoint('RIGHT', self, 'LEFT', -5, 0)
		playerIndicatorFrame = fBackDrop(playerIndicatorFrame, playerIndicatorFrame)

		local NoneIndicator = self:CreateTexture(nil, 'OVERLAY')
		NoneIndicator:SetSize(cfg.mainUF.player.height, cfg.mainUF.player.height)
		NoneIndicator:SetPoint('CENTER', playerIndicatorFrame, 'CENTER', 0, 0)
		NoneIndicator:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		NoneIndicator:SetVertexColor(0.0, 0.9, 0.4)

		self.RestingIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.RestingIndicator:SetSize(cfg.mainUF.player.height, cfg.mainUF.player.height)
		self.RestingIndicator:SetPoint('CENTER', playerIndicatorFrame, 'CENTER', 0, 0)
		self.RestingIndicator:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		self.RestingIndicator:SetVertexColor(0, 0.4, 0.9)

		self.CombatIndicator = self:CreateTexture(nil, 'OVERLAY')
		self.CombatIndicator:SetSize(cfg.mainUF.player.height, cfg.mainUF.player.height)
		self.CombatIndicator:SetPoint('CENTER', playerIndicatorFrame, 'CENTER', 0, 0)
		self.CombatIndicator:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		self.CombatIndicator:SetVertexColor(0.9, 0.1, 0.1)

		-- EXP Bar
		local Experience = CreateFrame('StatusBar', nil, self, 'AnimatedStatusBarTemplate')
		Experience:SetPoint('TOP', UIParent, 'TOP',0, -5)
		Experience:SetSize(300, 8)
		Experience:SetStatusBarTexture(cfg.texture)
		Experience.bg = fBackDrop(Experience, Experience)

		local Rested = CreateFrame('StatusBar', nil, Experience)
		Rested:SetAllPoints()
		Rested:SetStatusBarTexture(cfg.texture)
		Rested:SetAlpha(0.7)
		Rested:SetBackdrop({
			bgFile = 'Interface\\ChatFrame\\ChatFrameBackground',
			insets = {top = -1, left = -1, bottom = -1, right = -1},
		})
		Rested:SetBackdropColor(0, 0, 0)

		local ExperienceLv = cFontString(Experience, 'OVERLAY', cfg.font, 11, cfg.fontflag, 1, 1, 1)
		ExperienceLv:SetPoint('RIGHT', Experience, 'LEFT', -1, 0)
		ExperienceLv:SetJustifyH('CENTER')
		self:Tag(ExperienceLv, 'Lv [level]')

		local ExperienceInfo = cFontString(Experience, 'OVERLAY', cfg.font, 9, cfg.fontflag, 1, 1, 1)
		ExperienceInfo:SetPoint('CENTER', Experience, 'CENTER', 0, 0)
		ExperienceInfo:SetJustifyH('CENTER')
		self:Tag(ExperienceInfo, '[experience:per]% / TNL : [experience:tnl] (Rest : [experience:perrested]%)')

		local ExperienceBG = Rested:CreateTexture(nil, 'BORDER')
		ExperienceBG:SetAllPoints()
		ExperienceBG:SetColorTexture(1/3, 1/3, 1/3)

		self.Experience = Experience
		self.Experience.Rested = Rested

		--[[
		local personalBuff = CreateFrame('Frame', nil, self)
		personalBuff.size = 36
		personalBuff.spacing = 4
		personalBuff.num = 4
		personalBuff:SetSize((personalBuff.size+personalBuff.spacing)*personalBuff.num-personalBuff.spacing, personalBuff.size)
		personalBuff:SetPoint('CENTER', UIParent, 'CENTER', 75, 0)
		personalBuff.initialAnchor = 'CENTER'
		personalBuff['growth-x'] = 'RIGHT'
		personalBuff['growth-y'] = 'DOWN'
		personalBuff.PostCreateIcon = PostCreateIconNormal
		personalBuff.PostUpdateIcon = PostUpdateIcon
		personalBuff.CustomFilter = CustomAuraFilters.personal
		self.Auras = personalBuff

		local activityBuff = CreateFrame('Frame', nil, self)
		activityBuff.size = 30
		activityBuff.spacing = 4
		activityBuff.num = 10
		activityBuff:SetSize((activityBuff.size+activityBuff.spacing)*(activityBuff.num/2)-activityBuff.spacing, activityBuff.size*2+activityBuff.spacing)
		activityBuff:SetPoint('CENTER', UIParent, 'CENTER', -75, 0)
		activityBuff.initialAnchor = 'CENTER'
		activityBuff['growth-x'] = 'LEFT'
		activityBuff['growth-y'] = 'DOWN'
		activityBuff.PostCreateIcon = PostCreateIconNormal
		activityBuff.PostUpdateIcon = PostUpdateIcon
		activityBuff.CustomFilter = CustomAuraFilters.activity
		self.Buffs = activityBuff
		]]

		local PlayerFCF = CreateFrame("Frame", nil, self)
		PlayerFCF:SetSize(35, 35)
		PlayerFCF:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
		for i = 1, 8 do
			PlayerFCF[i] = PlayerFCF:CreateFontString(nil, "OVERLAY", "CombatTextFont")
		end
		PlayerFCF.mode = "Fountain"
		--PlayerFCF.xOffset = 30
		PlayerFCF.fontHeight = cfg.plugin.fcf.size
		PlayerFCF.abbreviateNumbers = true
		self.FloatingCombatFeedback = PlayerFCF
	end,

	target = function(self, ...)
		Shared(self, ...)
		self.unit = 'target'

		--HealthPrediction(self)
		extCastbar(self)

		self:SetSize(52, cfg.mainUF.player.height)
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true

		local name = cFontString(self, nil, cfg.font, 13, cfg.fontflag, 1, 1, 1, 'LEFT')
		name:SetPoint('LEFT', self, 'RIGHT', 3, 0)
		self:Tag(name, '[unit:lv] [color][name]')
		local hptext = cFontString(self, nil, cfg.hudfont, 40, cfg.fontflag, 1, 1, 1, 'LEFT')
		hptext:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, -2)
		self:Tag(hptext, '[unit:HPhud]')
		local hctext = cFontString(self, nil, cfg.bfont, 10, cfg.fontflag, 1, 1, 1, 'RIGHT')
		hctext:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 2, -3)
		self:Tag(hctext, '[unit:HPcurrent]')

		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(14, 14)
		self.RaidTargetIndicator:SetAlpha(0.7)
		self.RaidTargetIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)

		local unitBuff = CreateFrame('Frame', nil, self)
		unitBuff.size = 18
		unitBuff.spacing = 4
		unitBuff.num = 6
		unitBuff:SetSize(unitBuff.size*unitBuff.num+unitBuff.spacing*(unitBuff.num-1), unitBuff.size)
		unitBuff:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT', 5, 10)
		unitBuff.initialAnchor = 'LEFT'
		unitBuff.PostCreateIcon = PostCreateIconSmall
		unitBuff.PostUpdateIcon = PostUpdateIcon
		--unitBuff.CustomFilter = CustomFilter
		self.Buffs = unitBuff

		--[[
		local unitDebuff = CreateFrame('Frame', nil, self)
		unitDebuff.size = 16
		unitDebuff.spacing = 4
		unitDebuff.num = 8
		unitDebuff:SetSize(unitDebuff.size*unitDebuff.num+unitDebuff.spacing*(unitDebuff.num-1), unitDebuff.size)
		unitDebuff:SetPoint('TOPLEFT', self.Health, 'BOTTOMLEFT', 0, -5)
		unitDebuff.initialAnchor = 'LEFT'
		unitDebuff.onlyShowPlayer = true
		unitDebuff.PostCreateIcon = PostCreateIconSmall
		unitDebuff.PostUpdateIcon = PostUpdateIcon
		--unitDebuff.CustomFilter = CustomFilter
		self.Debuffs = unitDebuff

		AuraTracker(self, 32, 'BOTTOMLEFT', self, 'TOPLEFT', 0, 5)
		]]
	end,

	focus = function(self, ...)
		Shared(self, ...)
		self.unit = 'focus'

		extCastbar(self)

		self:SetSize(cfg.mainUF.focus.width, cfg.mainUF.focus.height)
		self.Health:SetHeight(cfg.mainUF.focus.height)

		local name = cFontString(self.Health, nil, cfg.font, 13, cfg.fontflag, 1, 1, 1, 'LEFT')
		name:SetPoint('LEFT', self.Health, 'RIGHT', 3, 0)
		self:Tag(name, '[color][name]')

		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(14, 14)
		self.RaidTargetIndicator:SetAlpha(0.7)
		self.RaidTargetIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)

		AuraTracker(self, cfg.mainUF.focus.height*2.2, 'RIGHT', self, 'LEFT', -5, 0)
	end,

	pet = function(self, ...)
		Shared(self, ...)
		self.unit = 'pet'

		self:SetSize(cfg.mainUF.player.width/3, 2)
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true
	end,

	targettarget = function(self, ...)
		Shared(self, ...)
		self.unit = 'targettarget'

		self:SetSize(32, cfg.mainUF.player.height)
		self.Health.colorClass = false
    	self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true

		local name = cFontString(self.Health, nil, cfg.font, 12, cfg.fontflag, 1, 1, 1, 'LEFT')
	    name:SetPoint('LEFT', self.Health, 'RIGHT', 3, 0)
		self:Tag(name, '[color][name]')
	end,

	focustarget = function(self, ...)
		Shared(self, ...)
		self.unit = 'focustarget'

		self:SetSize(cfg.mainUF.focus.width*0.75, cfg.mainUF.focus.height*0.5)
		self.Health.colorClass = false
    	self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true

		local name = cFontString(self.Health, nil, cfg.font, 12, cfg.fontflag, 1, 1, 1, 'LEFT')
	    name:SetPoint('LEFT', self.Health, 'RIGHT', 3, 0.5)
		self:Tag(name, '[color][name]')
	end,

	party = function(self, ...)
		Shared(self, ...)
		self.unit = 'party'

		Power(self, 'BOTTOM')
		Phase(self)
		ctfBorder(self)

		self:SetSize(cfg.subUF.party.width, cfg.subUF.party.height)
		self.Health:SetPoint("TOPLEFT")
		self.Health:SetPoint("TOPRIGHT")
		self.Health:SetHeight(cfg.subUF.party.height-3)
		self.Health:SetReverseFill(true)
		self.Power:SetHeight(2)
		self.Power:SetReverseFill(true)
		self.Range = {}

		local name = cFontString(self.Health, nil, cfg.font, 12, cfg.fontflag, 1, 1, 1, 'LEFT')
		name:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 2, 2)
		self:Tag(name, '[color][name]')
		local htext = cFontString(self.Health, nil, cfg.bfont, 18, cfg.fontflag, 1, 1, 1, 'RIGHT')
		htext:SetPoint('LEFT', self.Health, 'LEFT')
		htext:SetPoint('RIGHT', self.Health, 'RIGHT', 1, 0)
		self:Tag(htext, '[unit:HPmix]')

		self.DebuffHighlight = true

		self.LeaderIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.LeaderIndicator:SetSize(11, 11)
		self.LeaderIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
		self.AssistantIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.AssistantIndicator:SetSize(11, 11)
		self.AssistantIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(18, 18)
		self.RaidTargetIndicator:SetAlpha(0.9)
		self.RaidTargetIndicator:SetPoint("LEFT", self.Health, "LEFT", 1, 0)
		self.GroupRoleIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.GroupRoleIndicator:SetSize(10, 10)
		self.GroupRoleIndicator:SetPoint("CENTER", self.Health, "TOPLEFT", 6, -6)
		self.ReadyCheckIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheckIndicator:SetSize(22, 22)
		self.ReadyCheckIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self.ResurrectIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.ResurrectIndicator:SetSize(16, 16)
		self.ResurrectIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self.SummonIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.SummonIndicator:SetSize(32, 32)
		self.SummonIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)

		local unitDebuff = CreateFrame('Frame', nil, self)
		unitDebuff.size = cfg.subUF.party.height
		unitDebuff.spacing = 5
		unitDebuff.num = 4
		unitDebuff:SetSize(unitDebuff.size*unitDebuff.num+unitDebuff.spacing*(unitDebuff.num-1), unitDebuff.size)
		unitDebuff:SetPoint('RIGHT', self, 'LEFT', -5, 0)
		unitDebuff.initialAnchor = 'RIGHT'
		unitDebuff['growth-x'] = 'LEFT'
		unitDebuff.PostCreateIcon = PostCreateIconSmall
		unitDebuff.PostUpdateIcon = PostUpdateIcon
		--unitDebuff.CustomFilter = CustomFilter
		self.Debuffs = unitDebuff

		AuraTracker(self, cfg.subUF.party.height*1.4, 'CENTER', self, 'CENTER', 0, 0)
	end,

	partypet = function(self, ...)
		Shared(self, ...)
		self.unit = 'partypet'

		self:SetSize(cfg.subUF.party.width/3, 2)
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true
	end,

	partytarget = function(self, ...)
		Shared(self, ...)
		self.unit = 'partytarget'

		self:SetSize(3, 10)
		self.Health:SetHeight(10)
		self.Health:SetOrientation("VERTICAL")
		self.Health.colorClass = false
    	self.Health.colorReaction = false
		self.Health.colorHealth = true
		self.Health.colorSmooth = true

		local name = cFontString(self.Health, nil, cfg.font, 12, cfg.fontflag, 1, 1, 1, 'LEFT')
	    name:SetPoint('LEFT', self.Health, 'RIGHT', 3, 0.5)
		self:Tag(name, '[color][name]')
	end,

	raid = function(self, ...)
		Shared(self, ...)
		self.unit = 'raid'
		self:SetAttribute("type2", "focus")

		Power(self, 'BOTTOM')
		Phase(self)
		ctfBorder(self)

		self:SetSize(cfg.subUF.raid.width, cfg.subUF.raid.height)
		self.Health:SetHeight(cfg.subUF.raid.height-3)
		self.Health:SetOrientation("VERTICAL")
		self.Power:SetHeight(2)

		local name = cFontString(self.Health, nil, cfg.bfont, 10, 'none', 1, 1, 1)
		name:SetPoint('TOPLEFT', 1, 0)
		name:SetShadowOffset(1, -1)
	    name:SetJustifyH('LEFT')
		self:Tag(name, '[unit:name4]')
	    local htext = cFontString(self.Health, nil, cfg.bfont, 10, cfg.fontflag, 1, 1, 1)
	    htext:SetPoint('BOTTOMRIGHT', 2, 0)
		htext:SetJustifyH('RIGHT')
	    self:Tag(htext, '[unit:HPpercent]')

	    self.LeaderIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.LeaderIndicator:SetSize(11, 11)
		self.LeaderIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
		self.AssistantIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.AssistantIndicator:SetSize(11, 11)
		self.AssistantIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(16, 16)
		self.RaidTargetIndicator:SetPoint("CENTER", self, "LEFT", 0, 0)
		self.GroupRoleIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.GroupRoleIndicator:SetSize(10, 10)
		self.GroupRoleIndicator:SetPoint("CENTER", self, "TOPRIGHT", -6, -6)
		self.ReadyCheckIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheckIndicator:SetSize(32, 32)
		self.ReadyCheckIndicator:SetPoint("CENTER", self, "CENTER", 0, 0)
		self.ResurrectIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.ResurrectIndicator:SetSize(16, 16)
		self.ResurrectIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self.SummonIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.SummonIndicator:SetSize(32, 32)
		self.SummonIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)

		AuraTracker(self, cfg.subUF.raid.width*0.65, 'CENTER', self.Health)
	end,

	tank = function(self, ...)
		Shared(self, ...)
		self.unit = 'tank'

		Power(self, 'BOTTOM')
		ctfBorder(self)

		self:SetSize(cfg.subUF.party.width, cfg.subUF.party.height)
		self.Health:SetHeight(cfg.subUF.party.height-3)
		self.Health:SetReverseFill(true)
		self.Power:SetHeight(2)
		self.Power:SetReverseFill(true)

		local name = cFontString(self.Health, nil, cfg.font, 11, cfg.fontflag, 1, 1, 1, 'RIGHT')
		name:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', 2, 2)
		self:Tag(name, '[color][name]')

		local htext = cFontString(self.Health, nil, cfg.bfont, 18, cfg.fontflag, 1, 1, 1, 'RIGHT')
		htext:SetPoint('LEFT', self.Health, 'LEFT')
		htext:SetPoint('RIGHT', self.Health, 'RIGHT', 1, 0)
		self:Tag(htext, '[unit:HPmix]')

		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(18, 18)
		self.RaidTargetIndicator:SetAlpha(0.9)
		self.RaidTargetIndicator:SetPoint("LEFT", self.Health, "LEFT", 0, 0)

		local unitDebuff = CreateFrame('Frame', nil, self)
		unitDebuff.size = cfg.subUF.party.height
		unitDebuff.spacing = 5
		unitDebuff.num = 5
		unitDebuff:SetSize(unitDebuff.size*unitDebuff.num+unitDebuff.spacing*(unitDebuff.num-1), unitDebuff.size)
		unitDebuff:SetPoint('RIGHT', self, 'LEFT', -5, 0)
		unitDebuff.initialAnchor = 'RIGHT'
		unitDebuff['growth-x'] = 'LEFT'
		unitDebuff.PostCreateIcon = PostCreateIconSmall
		unitDebuff.PostUpdateIcon = PostUpdateIcon
		--unitDebuff.CustomFilter = CustomFilter
		self.Debuffs = unitDebuff

		AuraTracker(self, cfg.subUF.party.height, 'LEFT', self, 'RIGHT', 5, 0)
	end,

	boss = function(self, ...)
		Shared(self, ...)
		self.unit = 'boss'

		Power(self, 'BOTTOM')
		ctfBorder(self)

		self:SetSize(cfg.subUF.party.width, cfg.subUF.party.height)
		self.Health:SetHeight(cfg.subUF.party.height-3)
		self.Power:SetHeight(2)

		local name = cFontString(self.Health, nil, cfg.font, 11, cfg.fontflag, 1, 1, 1, 'LEFT')
		name:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 2)
		self:Tag(name, '[color][name]')

		local htext = cFontString(self.Health, nil, cfg.bfont, 18, cfg.fontflag, 1, 1, 1, 'LEFT')
		htext:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
		self:Tag(htext, '[unit:HPmix]')

		self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetSize(18, 18)
		self.RaidTargetIndicator:SetAlpha(0.9)
		self.RaidTargetIndicator:SetPoint("RIGHT", self.Health, "RIGHT", -1, 0)

	    --[[
	    local altp = createStatusbar(self, cfg.texture, nil, cfg.AlternativePower.boss.height, cfg.AlternativePower.boss.width, 1, 1, 1, 1)
        altp:SetPoint(unpack(cfg.AlternativePower.boss.pos))
		altp.bd = framebd(altp, altp)
        altp.bg = altp:CreateTexture(nil, 'BORDER')
        altp.bg:SetAllPoints(altp)
        altp.bg:SetTexture(cfg.texture)
        altp.bg:SetVertexColor(1, 1, 1, 0.3)
        altp.Text = fs(altp, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
        altp.Text:SetPoint('CENTER')
        self:Tag(altp.Text, '[altpower]')
		altp:EnableMouse(true)
        self.AlternativePower = altp
        ]]

		local unitBuff = CreateFrame('Frame', nil, self)
		unitBuff.size = cfg.subUF.party.height
		unitBuff.spacing = 5
		unitBuff.num = 2
		unitBuff:SetSize(unitBuff.size*unitBuff.num+unitBuff.spacing*(unitBuff.num-1), unitBuff.size)
		unitBuff:SetPoint('RIGHT', self, 'LEFT', -5, 0)
		--unitBuff:SetAlpha(0.7)
		unitBuff.initialAnchor = 'RIGHT'
		unitBuff['growth-x'] = 'LEFT'
		unitBuff.PostCreateIcon = PostCreateIconSmall
		unitBuff.PostUpdateIcon = PostUpdateIcon
		self.Buffs = unitBuff

		local unitDebuff = CreateFrame('Frame', nil, self)
		unitDebuff.size = cfg.subUF.party.height
		unitDebuff.spacing = 5
		unitDebuff.num = 5
		unitDebuff:SetSize(unitDebuff.size*unitDebuff.num+unitDebuff.spacing*(unitDebuff.num-1), unitDebuff.size)
		unitDebuff:SetPoint('LEFT', self, 'RIGHT', 5, 0)
		--unitDebuff:SetAlpha(0.7)
		unitDebuff.PostCreateIcon = PostCreateIconSmall
		unitDebuff.PostUpdateIcon = PostUpdateIcon
		--unitDebuff.CustomFilter = CustomFilter
		self.Debuffs = unitDebuff
	end,

--[[ DEBUG
    debugparty = function(self, ...)
        Shared(self, ...)
        self.unit = 'target'

        Power(self, 'BOTTOM')
        Phase(self)
        ctfBorder(self)

        self:SetSize(cfg.subUF.party.width, cfg.subUF.party.height)
        self.Health:SetPoint("TOPLEFT")
        self.Health:SetPoint("TOPRIGHT")
        self.Health:SetHeight(cfg.subUF.party.height-3)
        self.Health:SetReverseFill(true)
        self.Power:SetHeight(2)
        self.Power:SetReverseFill(true)
        self.Range = {}

        local name = cFontString(self.Health, nil, cfg.font, 12, cfg.fontflag, 1, 1, 1, 'LEFT')
        name:SetPoint('TOPLEFT', self.Health, 'TOPRIGHT', 2, 2)
        self:Tag(name, '[color][name]')
        local htext = cFontString(self.Health, nil, cfg.bfont, 18, cfg.fontflag, 1, 1, 1, 'RIGHT')
        htext:SetPoint('LEFT', self.Health, 'LEFT')
        htext:SetPoint('RIGHT', self.Health, 'RIGHT', 1, 0)
        self:Tag(htext, '[unit:HPmix]')

        self.DebuffHighlight = true

        self.LeaderIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.LeaderIndicator:SetSize(11, 11)
        self.LeaderIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
        self.AssistantIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.AssistantIndicator:SetSize(11, 11)
        self.AssistantIndicator:SetPoint("CENTER", self, "TOPLEFT", 4, 5)
        self.RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.RaidTargetIndicator:SetSize(18, 18)
        self.RaidTargetIndicator:SetAlpha(0.9)
        self.RaidTargetIndicator:SetPoint("LEFT", self.Health, "LEFT", 1, 0)
        self.GroupRoleIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.GroupRoleIndicator:SetSize(10, 10)
        self.GroupRoleIndicator:SetPoint("CENTER", self.Health, "TOPLEFT", 6, -6)
        self.ReadyCheckIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.ReadyCheckIndicator:SetSize(22, 22)
        self.ReadyCheckIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
        self.ResurrectIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.ResurrectIndicator:SetSize(16, 16)
        self.ResurrectIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
        self.SummonIndicator = self.Health:CreateTexture(nil, "OVERLAY")
        self.SummonIndicator:SetSize(32, 32)
        self.SummonIndicator:SetPoint("CENTER", self.Health, "CENTER", 0, 0)

        local unitDebuff = CreateFrame('Frame', nil, self)
        unitDebuff.size = cfg.subUF.party.height
        unitDebuff.spacing = 5
        unitDebuff.num = 4
        unitDebuff:SetSize(unitDebuff.size*unitDebuff.num+unitDebuff.spacing*(unitDebuff.num-1), unitDebuff.size)
        unitDebuff:SetPoint('RIGHT', self, 'LEFT', -5, 0)
        unitDebuff.initialAnchor = 'RIGHT'
        unitDebuff['growth-x'] = 'LEFT'
        unitDebuff.PostCreateIcon = PostCreateIconSmall
        unitDebuff.PostUpdateIcon = PostUpdateIcon
        --unitDebuff.CustomFilter = CustomFilter
        self.Debuffs = unitDebuff

        AuraTracker(self, cfg.subUF.party.height*1.4, 'CENTER', self, 'CENTER', 0, 0)
    end,
]]
}

oUF:RegisterStyle('CombatHUD', Shared)
for unit,layout in next, UnitSpecific do
    oUF:RegisterStyle('CombatHUD - ' .. unit:gsub('^%l', string.upper), layout)
end

-- Spawn Helper -------------------------------------------------------------------------
local spawnHelper = function(self, unit, ...)
    if(UnitSpecific[unit]) then
        self:SetActiveStyle('CombatHUD - ' .. unit:gsub('^%l', string.upper))
    elseif(UnitSpecific[unit:match('[^%d]+')]) then
        self:SetActiveStyle('CombatHUD - ' .. unit:match('[^%d]+'):gsub('^%l', string.upper))
    else
        self:SetActiveStyle('CombatHUD')
    end
    local object = self:Spawn(unit)
    object:SetPoint(...)
    return object
end

oUF:Factory(function(self)
	spawnHelper(self, 'player', cfg.mainUF.player.position.sa, cfg.mainUF.player.position.a, cfg.mainUF.player.position.pa, cfg.mainUF.player.position.x, cfg.mainUF.player.position.y)
	spawnHelper(self, 'pet', 'BOTTOMLEFT', 'oUF_CombatHUDPlayer', 'TOPLEFT', 0, 5)
	spawnHelper(self, 'target', 'LEFT', 'oUF_CombatHUDPlayer', 'RIGHT', 6, 0)
	spawnHelper(self, 'targettarget', 'TOPRIGHT', 'oUF_CombatHUDTarget', 'BOTTOMRIGHT', 0, -20)
	spawnHelper(self, 'focus', 'CENTER', 'oUF_CombatHUDTarget', 'RIGHT', 0, 75)
	spawnHelper(self, 'focustarget', 'TOPRIGHT', 'oUF_CombatHUDFocus','BOTTOMRIGHT', 0, -10)

	self:SetActiveStyle('CombatHUD - Party') -- custom [group:party,nogroup:raid][@raid4,noexists,group:raid]show; hide
	self:SpawnHeader('oUF_Party', nil, 'custom [group:party,nogroup:raid][@raid4,noexists,group:raid]show; hide',
		'showParty', true, 'showPlayer', true, 'showSolo', true, 'showRaid', true,
		'yOffset', 18,
		'point', 'BOTTOM',
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER'
	):SetPoint(cfg.subUF.party.position.sa, cfg.subUF.party.position.a, cfg.subUF.party.position.pa, cfg.subUF.party.position.x, cfg.subUF.party.position.y)

	self:SetActiveStyle('CombatHUD - Partypet')
	self:SpawnHeader('oUF_PartyPets', nil, 'custom [group:party,nogroup:raid][@raid4,noexists,group:raid]show; hide',
		'showParty', true, 'showPlayer', true, 'showSolo', true, 'showRaid', true,
		'yOffset', 16+cfg.subUF.party.height,
		'point', 'BOTTOM',
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', ([[
			self:SetAttribute('unitsuffix', 'pet')
		]])
	):SetPoint("TOPRIGHT", 'oUF_Party', "TOPRIGHT", 0, 5)

	self:SetActiveStyle('CombatHUD - Partytarget')
	self:SpawnHeader('oUF_PartyTargets', nil, 'custom [group:party,nogroup:raid][@raid4,noexists,group:raid]show; hide',
		'showParty', true, 'showPlayer', true, 'showSolo', true, 'showRaid', true,
		'yOffset', 8+cfg.subUF.party.height,
		'point', 'BOTTOM',
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'TANK,HEALER,DAMAGER',
		'oUF-initialConfigFunction', ([[
			self:SetAttribute('unitsuffix', 'target')
		]])
	):SetPoint('BOTTOMLEFT', 'oUF_Party', 'BOTTOMRIGHT', 5, 0)

	self:SetActiveStyle('CombatHUD - Raid')
	self:SpawnHeader('oUF_Raid', nil, 'custom show',
		'showParty', false, 'showPlayer', true, 'showSolo', false, 'showRaid', true,
		'xoffset', 5,
		'yOffset', -12,
		'point', 'TOP',
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'HEALER,TANK,DAMAGER',
		'maxColumns', 5,
		'unitsPerColumn', 7,
		'columnSpacing', 5,
		'columnAnchorPoint', 'LEFT'
	):SetPoint(cfg.subUF.raid.position.sa, cfg.subUF.raid.position.a, cfg.subUF.raid.position.pa, cfg.subUF.raid.position.x, cfg.subUF.raid.position.y)

	self:SetActiveStyle('CombatHUD - Tank')
	self:SpawnHeader('oUF_MainTank', nil, 'raid',
		'showParty', false, 'showPlayer', true, 'showSolo', false, 'showRaid', true,
		'groupFilter', 'MAINTANK',
		'yOffset', 18,
		'point', 'BOTTOM'
	):SetPoint(cfg.subUF.party.position.sa, cfg.subUF.party.position.a, cfg.subUF.party.position.pa, cfg.subUF.party.position.x, cfg.subUF.party.position.y)

	for i = 1, MAX_BOSS_FRAMES do
		spawnHelper(self, 'boss'..i, cfg.subUF.boss.position.sa, cfg.subUF.boss.position.a, cfg.subUF.boss.position.pa, cfg.subUF.boss.position.x, cfg.subUF.boss.position.y-43+(43*i))
	end

    -- DEBUG
    for i = 1, 5 do
        spawnHelper(self, 'debugparty'..i, cfg.subUF.party.position.sa, cfg.subUF.party.position.a, cfg.subUF.party.position.pa, cfg.subUF.party.position.x, cfg.subUF.party.position.y-43+(43*i))
    end
end)

----------------------------------------------------------------------------------------
--	Test UnitFrames(by community)
----------------------------------------------------------------------------------------
-- For testing /run oUFAbu.TestArena()
function TUF()
	oUF_CombatHUDBoss1:Show(); oUF_CombatHUDBoss1.Hide = function() end oUF_CombatHUDBoss1.unit = "target"
	oUF_CombatHUDBoss2:Show(); oUF_CombatHUDBoss2.Hide = function() end oUF_CombatHUDBoss2.unit = "target"
    oUF_CombatHUDBoss3:Show(); oUF_CombatHUDBoss3.Hide = function() end oUF_CombatHUDBoss3.unit = "target"
	--oUF_Party:Show(); oUF_Party.Hide = function() end oUF_Party.unit = "target"
	--oUF_PartyPets:Show(); oUF_PartyPets.Hide = function() end oUF_PartyPets.unit = "target"
	--oUF_PartyTargets:Show(); oUF_PartyTargets.Hide = function() end oUF_PartyTargets.unit = "target"

	--oUF_MainTank:Show(); oUF_MainTank.Hide = function() end oUF_MainTank.unit = "target"

    oUF_CombatHUDDebugparty1:Show(); oUF_CombatHUDDebugparty1.Hide = function() end oUF_CombatHUDDebugparty1.unit = "target"
    oUF_CombatHUDDebugparty2:Show(); oUF_CombatHUDDebugparty2.Hide = function() end oUF_CombatHUDDebugparty2.unit = "target"
    oUF_CombatHUDDebugparty3:Show(); oUF_CombatHUDDebugparty3.Hide = function() end oUF_CombatHUDDebugparty3.unit = "target"
    oUF_CombatHUDDebugparty4:Show(); oUF_CombatHUDDebugparty4.Hide = function() end oUF_CombatHUDDebugparty4.unit = "target"
    oUF_CombatHUDDebugparty5:Show(); oUF_CombatHUDDebugparty5.Hide = function() end oUF_CombatHUDDebugparty5.unit = "target"

	local time = 0
	local f = CreateFrame("Frame")
	f:SetScript("OnUpdate", function(self, elapsed)
		time = time + elapsed
		if time > 5 then
			oUF_CombatHUDBoss1:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit
			oUF_CombatHUDBoss2:UpdateAllElements("ForceUpdate")
            oUF_CombatHUDBoss3:UpdateAllElements("ForceUpdate")
			--oUF_Party:UpdateAllElements("RefreshUnit")
			--oUF_Party1Pets:UpdateAllElements("ForceUpdate")
			--oUF_Party1Targets:UpdateAllElements("ForceUpdate")
			--oUF_MainTank:UpdateAllElements("ForceUpdate")

            oUF_CombatHUDDebugparty1:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit
            oUF_CombatHUDDebugparty2:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit
            oUF_CombatHUDDebugparty3:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit
            oUF_CombatHUDDebugparty4:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit
            oUF_CombatHUDDebugparty5:UpdateAllElements("ForceUpdate") -- OnUpdate RefreshUnit

			time = 0
		end
	end)
end
