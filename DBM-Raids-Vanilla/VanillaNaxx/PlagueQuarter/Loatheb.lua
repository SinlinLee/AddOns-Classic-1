local mod	= DBM:NewMod("LoathebVanilla", "DBM-Raids-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

if DBM:IsSeasonal("SeasonOfDiscovery") then
	mod.statTypes = "normal,heroic,mythic"
else
	mod.statTypes = "normal"
end

mod:SetRevision("20250211214854")
mod:SetCreatureID(16011)
mod:SetEncounterID(1115)
mod:SetModelID(16110)
mod:SetZone(533)

mod:RegisterCombat("combat")--Maybe change to a yell later so pull detection works if you chain pull him from tash gauntlet

-- New spell ID found in logs on SoD
-- 1225419 (Necrotic Aura)
-- That's the WotLK healer mechanic. On PTR it was using the Classic stuff, but they forgot to add the new SoD healing spells, so they weren't blocked :>
-- Maybe they were too lazy to fix that or tuning for 20 players needed the different mechanic?

-- There are two types of Corrupted Mind spells for each class.
-- Let's refer to them as "Corrupted Mind Aura" and "Corrupted Mind Debuff" for clarify
-- Corrupted Mind Aura
--   * This is a 2 min debuff that gives you a Corrupted Mind Debuff if you cast a heal.
--   * This is refreshed every 11 seconds if you're in combat with Loatheb.
-- Corrupted Mind Debuff
--   * This is a 1 min debuff that doesn't let you heal.
--   * This is applied if you heal when you have the Corrupted Mind Aura.

-- Corrupted Mind Aura spell IDs (in the order of Priest, Druid, Paladin, Shaman)
-- 29185 29194 29196 29198

-- Corrupted Mind Debuff spell IDs (in the order of Priest, Druid, Paladin, Shaman)
-- 29184 29195 29197 29199

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 29184 29195 29197 29199",
	"SPELL_AURA_REMOVED 29184 29195 29197 29199",
	"SPELL_CAST_SUCCESS 29234 29204 30281 1225419",
	"UNIT_DIED"
)

local warnSporeNow			= mod:NewCountAnnounce(29234, 2, "134530")
local warnSporeSoon			= mod:NewSoonAnnounce(29234, 1, "134530")
local warnDoomNow			= mod:NewCountAnnounce(29204, 3)
local warnRemoveCurse		= mod:NewSpellAnnounce(30281, 3)
local warnHealSoon, warnHealNow
if DBM:IsSeasonal("SeasonOfDiscovery") then
	warnHealSoon			= mod:NewAnnounce("WarningHealSoon", 4, 1225419, nil, nil, nil, 1225419)
	warnHealNow				= mod:NewSpecialWarning("WarningHealNow", "Healer", nil, nil, 2, 8, nil, 1225419, 1225419) -- keep name like a warning, not special warning to use same logic/locales as era above
else
	warnHealSoon			= mod:NewAnnounce("WarningHealSoon", 4, 29184)
	warnHealNow				= mod:NewAnnounce("WarningHealNow", 1, 29184, false)
end

local timerSpore			= mod:NewNextCountTimer(12.9, 29234, nil, nil, nil, 5, "134530", DBM_COMMON_L.DAMAGE_ICON)-- initial 11.3 then 12.92-12.99
local timerDoom				= mod:NewNextTimer(29, 29204, nil, nil, nil, 2)-- initial 130 then 29.1-32.4
local timerRemoveCurseCD	= mod:NewNextTimer(30.8, 30281, nil, nil, nil, 5)

-- SoD
-- TODO: remove alerts from non-SoD clients to fix UI, but I real want to handle that better in Core rather than special-casing it in all the mods
local timerAura				= mod:NewBuffActiveTimer(17, 1225419, nil, nil, nil, 5, nil, DBM_COMMON_L.HEALER_ICON)
local timerNextAura			= mod:NewVarTimer("v20.1-21.5", 1225419)



mod:AddInfoFrameOption(29184, "Tank|Healer")
mod:AddDropdownOption("CorruptedSorting", {"Alphabetical", "Duration"}, "Alphabetical", "misc", nil, 29184)

mod.vb.doomCounter	= 0
mod.vb.sporeTimer	= 12.9
mod.vb.sporeCounter = 0
local hadCorrupted	= {}

local updateInfoFrame
do
	local ipairs, pairs, tostring = ipairs, pairs, tostring
	local mfloor, mmax, tinsert, tsort, twipe = math.floor, math.max, table.insert, table.sort, table.wipe
	local lines, sortedLines, corruptKeys, durToName = {}, {}, {}, {}
	local function addLine(key, value)
		-- sort by insertion order
		lines[key] = value
		sortedLines[#sortedLines + 1] = key
	end
	updateInfoFrame = function()
		twipe(lines)
		twipe(sortedLines)
		twipe(corruptKeys)

		local refreshTime = GetTime()

		for name, _ in pairs(hadCorrupted) do
			tinsert(corruptKeys, name)
		end
		if mod.Options.CorruptedSorting == "Duration" then
			tsort(corruptKeys, function (a, b) return (hadCorrupted[a] or refreshTime) > (hadCorrupted[b] or refreshTime) end)
		else
			tsort(corruptKeys)
		end

		for _, name in ipairs(corruptKeys) do
			addLine(name, tostring(mfloor(mmax(hadCorrupted[name] - refreshTime, 0))))
		end

		return lines, sortedLines
	end
end

function mod:OnCombatStart(delay)
	self.vb.doomCounter = 0
	self.vb.sporeCounter = 0
	if DBM:IsSeasonal("SeasonOfDiscovery") then
		timerNextAura:Start(10) -- TODO: exact timer unclear? seen as early as 11, but also not too important
	end
	timerRemoveCurseCD:Start(3 - delay)
	timerSpore:Start(11.3 - delay, 1)
	warnSporeSoon:Schedule(self.vb.sporeTimer - 5 - delay)
	timerDoom:Start(121.4 - delay, self.vb.doomCounter + 1)

	local startTime = GetTime()
	table.wipe(hadCorrupted)
	for uId in DBM:GetGroupMembers() do
		local _, cls = UnitClass(uId)
		local _, _, _, mapId = UnitPosition(uId)
		if not UnitIsDeadOrGhost(uId) and mapId == 533 and (cls == "DRUID" or cls == "PALADIN" or cls == "PRIEST" or cls == "SHAMAN") then
			hadCorrupted[DBM:GetUnitFullName(uId)] = startTime
		end
	end
	if not DBM:IsSeasonal("SeasonOfDiscovery") and self.Options.InfoFrame and not DBM.InfoFrame:IsShown() then
		DBM.InfoFrame:SetHeader(DBM:GetSpellName(29184))
		DBM.InfoFrame:Show(40, "function", updateInfoFrame, false, false)
		DBM.InfoFrame:SetColumns(2)
	end
end

function mod:OnCombatEnd()
	if DBM.InfoFrame:IsShown() then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpell(29234) then
		self.vb.sporeCounter = self.vb.sporeCounter + 1
		timerSpore:Start(self.vb.sporeTimer, self.vb.sporeCounter+1)
		warnSporeNow:Show(self.vb.sporeCounter)
		warnSporeSoon:Schedule(self.vb.sporeTimer - 5)
	elseif args:IsSpell(29204) then
		self.vb.doomCounter = self.vb.doomCounter + 1
		local timer = self.vb.doomCounter % 2 == 0 and 32.4 or 29.1
		if self.vb.doomCounter >= 7 then
			timer = self.vb.doomCounter == 7 and 9.7 or self.vb.doomCounter % 2 == 0 and 19.4 or 11.3
		end
		warnDoomNow:Show(self.vb.doomCounter)
		timerDoom:Start(timer, self.vb.doomCounter + 1)
	elseif args:IsSpell(30281) then
		warnRemoveCurse:Show()
		timerRemoveCurseCD:Start()
	elseif args:IsSpell(1225419) then -- SoD spell ID
		timerAura:Start()
		timerNextAura:Start()
		warnHealSoon:Schedule(14)
		warnHealNow:Schedule(17)
		warnHealNow:ScheduleVoice(17, "healall")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpell(29184, 29195, 29197, 29199) then
		hadCorrupted[args.destName] = GetTime() + 60
		if args:IsPlayer() then
			warnHealSoon:Schedule(55)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpell(29184, 29195, 29197, 29199) then
		if args:IsPlayer() then
			warnHealNow:Show()
		end
	end
end

--because in all likelyhood, pull detection failed (cause 90s like to charge in there trash and all and pull it
--We unschedule the pre warnings on death as a failsafe
function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 16011 then
		warnSporeSoon:Cancel()
		--warnHealSoon:Cancel()
		--warnHealNow:Cancel()
	elseif hadCorrupted[args.destName] then
		hadCorrupted[args.destName] = nil
	end
end
