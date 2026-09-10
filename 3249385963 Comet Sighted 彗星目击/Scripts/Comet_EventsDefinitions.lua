
local event_MeteorShower			= "RANDOM_EVENT_METEOR_SHOWER"
local m_CometSense = GameInfo.Technologies["TECH_ASTRONOMY"].Index;
local m_KometPlane = GameInfo.Technologies["TECH_ROCKETRY"].Index;

-- ===========================================================================
--   Event PopupChoice						--YOU NEED TO COPYPASTE THIS IN YOUR MOD FOR IT TO WORK
-- ===========================================================================

--MANDATORY COPY PASTE FROM HERE
local m_CometEventDefs:table = {};	

for row in GameInfo.EventPopupData() do
	m_CometEventDefs[row.Type] = {};
end

function OnEventPopupChoice(ePlayer : number, params : table)
	local pEventData : table = m_CometEventDefs[params.EventKey];
	if (pEventData == nil) then
		print("OnEventPopupChoice: " .. params.EventKey .. "entry not found in ScenarioEventDefinitions");
		return;
	end

	local iResponseIndex : number = params.ResponseIndex or -1;
	if (iResponseIndex < 0) then
		return;
	end

	-- Determine if A or B was chosen
	local pCallback = nil;
	if (iResponseIndex == 0 ) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice A");
		pCallbackFunc = pEventData.ACallback;
	elseif (iResponseIndex == 1) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice B");
		pCallbackFunc = pEventData.BCallback;
	elseif (iResponseIndex == 2) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice C");
		pCallbackFunc = pEventData.CCallback;
	elseif (iResponseIndex == 3) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice D");
		pCallbackFunc = pEventData.DCallback;
	elseif (iResponseIndex == 4) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice E");
		pCallbackFunc = pEventData.ECallback;
	elseif (iResponseIndex == 5) then
		print("OnEventPopupResponse: " .. params.EventKey .. " handling Choice F");
		pCallbackFunc = pEventData.FCallback;
	end

	-- Fire callback
	if (pCallbackFunc ~= nil) then
		pCallbackFunc(params);
	end	
end


GameEvents.EventPopupChoice.Add( OnEventPopupChoice );	
--COPY PASTE TO THERE


-- ===========================================================================
--   Event Triggers Function
-- ===========================================================================


--function CheckEventsTriggers( turn:number )
	--if (Game.GetCurrentGameTurn() == 1) then
--		OnCometSighted();
	--end
--end


function OnRandomEventOccurred(iType)
	local info:table = GameInfo.RandomEvents[iType];

	if info ~= nil then
		local sDisasterType = info.RandomEventType
		if sDisasterType ~= event_MeteorShower then 
			return 
		end
		OnCometSighted();
	end
end

function OnKometCreated( PlayerID : number, UnitID : number )
	
	local pPlayer = Players[ PlayerID ];
	if pPlayer then
		if (pPlayer:GetTechs():HasTech(m_KometPlane) and pPlayer:GetProperty("HasKomet") == nil) then
		
			local pUnit = pPlayer:GetUnits():FindID( UnitID );
		
			if pUnit then
				local unitType = GameInfo.Units[pUnit:GetType()].UnitType;
			
				if (unitType == "UNIT_JET_FIGHTER" or unitType == "UNIT_JET_BOMBER" or unitType == "UNIT_FIGHTER") then
					pUnit:GetExperience():ChangeExperience(50);
					pUnit:GetExperience():SetVeteranName("Komet");
					pPlayer:SetProperty("HasKomet", true);

					m_CometEventDefs['EVENT_KOMET_PLANE'].Activate(iPlayerID);
				end
			else return	end
		end
	else return end
end



GameEvents.OnGameTurnStarted.Add(CheckEventsTriggers);
Events.RandomEventOccurred.Add(OnRandomEventOccurred)
GameEvents.UnitCreated.Add( OnKometCreated );


function OnCometSighted()
	local era=Game:GetEras():GetCurrentEra();


	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		local pPlayer = Players[iPlayerID];
		--print(m_CometSense, pPlayer);
		if pPlayer:GetTechs():HasTech(m_CometSense) then
		 
			
			if era >= 6 then
				local randomizer = math.random(1,2); 
				if (randomizer == 1) then
					m_CometEventDefs['EVENT_COMET_MODERN'].Activate(iPlayerID);
				else
					m_CometEventDefs['EVENT_COMET_BAD_MODERN'].Activate(iPlayerID);
				end
			else
				m_CometEventDefs['EVENT_COMET_GOOD'].Activate(iPlayerID);
			end
			
		else
			m_CometEventDefs['EVENT_COMET_BAD'].Activate(iPlayerID);
		end
	end
end




-- ===========================================================================
--	 Bad Comet Event
-- ===========================================================================

--ICON_GAMEMODE_APOCALYPSE
--ICON_NOTIFICATION_COMET_LANDS
--ICON_NOTIFICATION_METEOR_STRIKES

m_CometEventDefs['EVENT_COMET_BAD'].EventKey = 'EVENT_COMET_BAD'
m_CometEventDefs['EVENT_COMET_BAD'].Activate = function(playerID)
	local sEventKey = 'EVENT_COMET_BAD'
	local pPlayer = Players[playerID];
	
	
	unlockA = {};
	unlockA.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_A")};
	unlockA.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}}; 
	unlockB = {};
	unlockB.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_B")};
	unlockB.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}};
	
	unlockC = {};
	unlockC.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_C")};
	unlockC.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}}; 
	
	unlockD = {};
	unlockD.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_D")};
	unlockD.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}}; 
	
	unlockE = {};
	unlockE.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_E")};
	unlockE.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}}; 
	
	unlockF = {};
	unlockF.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_DESCRIPTION_A")};
	unlockF.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}}; 
	
	local randomizer = math.random(1,2); 
	if (randomizer == 1) then
		EffectText = Locale.Lookup("LOC_EVENT_COMET_BAD_TEXT_EU4");
		AText = "LOC_EVENT_COMET_BAD_TEXT_A_EU4"
		BText = "LOC_EVENT_COMET_BAD_TEXT_B_EU4"
		CText = "LOC_EVENT_COMET_BAD_TEXT_C_EU4"
		DText = "LOC_EVENT_COMET_BAD_TEXT_D_EU4"
		EText = "LOC_EVENT_COMET_BAD_TEXT_E_EU4"
		FText = "LOC_EVENT_COMET_BAD_TEXT_F_EU4"
		
	else
		EffectText = Locale.Lookup("LOC_EVENT_COMET_BAD_TEXT_CK3");
		AText = "LOC_EVENT_COMET_BAD_TEXT_A_CK3"
		BText = "LOC_EVENT_COMET_BAD_TEXT_B_CK3"
		CText = "LOC_EVENT_COMET_BAD_TEXT_C_CK3"
		DText = "LOC_EVENT_COMET_BAD_TEXT_D_CK3"
		EText = "LOC_EVENT_COMET_BAD_TEXT_E_CK3"
		FText = "LOC_EVENT_COMET_BAD_TEXT_F_CK3"
	end

	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ChoiceAText = AText, ChoiceBText= BText, ChoiceCText = CText, ChoiceDText = DText, ChoiceEText = EText, ChoiceFText = FText, ChoiceAUnlocks=unlockA,ChoiceBUnlocks=unlockB, ChoiceCUnlocks=unlockC, ChoiceDUnlocks=unlockD, ChoiceEUnlocks = unlockE, ChoiceFUnlocks = unlockF});
end

--CHOICE A
m_CometEventDefs['EVENT_COMET_BAD'].ACallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_FAITH_TURN")
end

--CHOICE B
m_CometEventDefs['EVENT_COMET_BAD'].BCallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_CULTURE_TURN")
end

--CHOICE C
m_CometEventDefs['EVENT_COMET_BAD'].CCallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_GOLD_TURN")
end

--CHOICE D
m_CometEventDefs['EVENT_COMET_BAD'].DCallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_SCIENCE_TURN")
end

--CHOICE E
m_CometEventDefs['EVENT_COMET_BAD'].ECallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_SCIENCE_TURN")
	pPlayer:AttachModifierByID("COMET_REMOVE_SCIENCE_TURN")
	pPlayer:GetTechs():TriggerBoost(m_CometSense);
end

--CHOICE F
m_CometEventDefs['EVENT_COMET_BAD'].FCallback = function(kParams : table)
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_REMOVE_FAITH_TURN")
end


-- ===========================================================================
--	 Good Comet Event
-- ===========================================================================



m_CometEventDefs['EVENT_COMET_GOOD'].EventKey = 'EVENT_COMET_GOOD'
m_CometEventDefs['EVENT_COMET_GOOD'].Activate = function(playerID)
	local sEventKey = 'EVENT_COMET_GOOD'
	local pPlayer = Players[playerID];
	
	--Prepare UI
	EffectText = Locale.Lookup("LOC_EVENT_COMET_GOOD_EFFECT");
	unlockA = {};
	unlockA.Effects = {Locale.Lookup("LOC_EVENT_COMET_GOOD_DESCRIPTION")};
	unlockA.EffectIcons = {{"ICON_GAMEMODE_APOCALYPSE"}}; 
	unlockB = {};
	unlockB.Effects = {Locale.Lookup("LOC_EVENT_COMET_GOOD_DESCRIPTION")};
	unlockB.EffectIcons = {{"ICON_GAMEMODE_APOCALYPSE"}};
	
	unlockC = {};
	unlockC.Effects = {Locale.Lookup("LOC_EVENT_COMET_GOOD_DESCRIPTION")};
	unlockC.EffectIcons = {{"ICON_GAMEMODE_APOCALYPSE"}}; 
	
	unlockD = {};
	unlockD.Effects = {Locale.Lookup("LOC_EVENT_COMET_GOOD_DESCRIPTION")};
	unlockD.EffectIcons = {{"ICON_GAMEMODE_APOCALYPSE"}}; 
	
	
	
	local randomizer = math.random(1,2); 
	if (randomizer == 1) then
		EffectText = Locale.Lookup("LOC_EVENT_COMET_GOOD_TEXT");
	else
		EffectText = Locale.Lookup("LOC_EVENT_COMET_GOOD_TEXT_GREAT");
	end
	
	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ChoiceAText ="LOC_"..sEventKey.."_CHOICE_A", ChoiceBText="LOC_"..sEventKey.."_CHOICE_B", ChoiceCText = "LOC_"..sEventKey.."_CHOICE_C", ChoiceDText = "LOC_"..sEventKey.."_CHOICE_D", ChoiceAUnlocks=unlockA,ChoiceBUnlocks=unlockB, ChoiceCUnlocks=unlockC, ChoiceDUnlocks=unlockD, ChoiceEUnlocks = unlockE, ChoiceFUnlocks = unlockF});
end

--CHOICE A
m_CometEventDefs['EVENT_COMET_GOOD'].ACallback = function(kParams : table)
	
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_GAIN_SCIENCE_TURN")

end

--CHOICE B
m_CometEventDefs['EVENT_COMET_GOOD'].BCallback = function(kParams : table)
	
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_GAIN_SCIENCE_TURN")
end

--CHOICE C
m_CometEventDefs['EVENT_COMET_GOOD'].CCallback = function(kParams : table)
	
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_GAIN_SCIENCE_TURN")
end

--CHOICE D
m_CometEventDefs['EVENT_COMET_GOOD'].DCallback = function(kParams : table)
	
	local pPlayer = Players[kParams.ForPlayer];
	pPlayer:AttachModifierByID("COMET_GAIN_SCIENCE_TURN")
end






-- ===========================================================================
--	 Good Comet Event
-- ===========================================================================



m_CometEventDefs['EVENT_COMET_MODERN'].EventKey = 'EVENT_COMET_MODERN'
m_CometEventDefs['EVENT_COMET_MODERN'].Activate = function(playerID)
	local sEventKey = 'EVENT_COMET_MODERN'
	local pPlayer = Players[playerID];
	
	--Prepare UI
		
		local randomizer = math.random(1,7); 
		if (randomizer == 1) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_A");
		elseif (randomizer == 2) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_B");
		elseif (randomizer == 3) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_C");
		elseif (randomizer == 4) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_D");
		elseif (randomizer == 5) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_E");
		elseif (randomizer == 6) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_F");
		elseif (randomizer == 7) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_MODERN_TEXT_G");
		end
		
		
		unlock = {};
		unlock.Effects = {Locale.Lookup("LOC_EVENT_COMET_MODERN_CHOICE_A")};
		unlock.EffectIcons = {{"ICON_GAMEMODE_APOCALYPSE"}};
	
	
		ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ContinueText ="LOC_"..sEventKey.."_CONTINUE",Unlocks=unlock});
	
	
	pPlayer:AttachModifierByID("COMET_GAIN_CULTURE_TURN")
	
end


m_CometEventDefs['EVENT_COMET_BAD_MODERN'].EventKey = 'EVENT_COMET_BAD_MODERN'
m_CometEventDefs['EVENT_COMET_BAD_MODERN'].Activate = function(playerID)
	local sEventKey = 'EVENT_COMET_BAD_MODERN'
	local pPlayer = Players[playerID];
	
	--Prepare UI
		
		local randomizer = math.random(1,2); 
		if (randomizer == 1) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_BAD_MODERN_TEXT_A");
		elseif (randomizer == 2) then
			EffectText = Locale.Lookup("LOC_EVENT_COMET_BAD_MODERN_TEXT_B");
		end
		
		
		unlock = {};
		unlock.Effects = {Locale.Lookup("LOC_EVENT_COMET_BAD_MODERN_CHOICE_A")};
		unlock.EffectIcons = {{"ICON_NOTIFICATION_METEOR_STRIKES"}};
	
	
		ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ContinueText ="LOC_"..sEventKey.."_CONTINUE",Unlocks=unlock});
	
	
	pPlayer:AttachModifierByID("COMET_REMOVE_CULTURE_TURN")
	
end


m_CometEventDefs['EVENT_KOMET_PLANE'].EventKey = 'EVENT_KOMET_PLANE'
m_CometEventDefs['EVENT_KOMET_PLANE'].Activate = function(playerID)
	local sEventKey = 'EVENT_KOMET_PLANE'
	local pPlayer = Players[playerID];
	

	EffectText = Locale.Lookup("LOC_EVENT_KOMET_PLANE_TEXT");
		
		
		
	unlock = {};
	unlock.Effects = {Locale.Lookup("LOC_EVENT_KOMET_PLANE_CHOICE")};
	unlock.EffectIcons = {{"ICON_TECHUNLOCK_13"}};


	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ContinueText ="LOC_"..sEventKey.."_CONTINUE",Unlocks=unlock});
	
end

