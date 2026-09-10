
-- ===========================================================================
--   Event PopupChoice						--YOU NEED TO COPYPASTE THIS IN YOUR MOD FOR IT TO WORK
-- ===========================================================================

--MANDATORY COPY PASTE FROM HERE
local m_FUEventDefs:table = {};	


function OnEventPopupChoice(ePlayer : number, params : table)
	local pEventData : table = m_FUEventDefs[params.EventKey];
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


function CheckEventsTriggers( turn:number )
	
	for _, iPlayerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
		
		if (Game.GetCurrentGameTurn() == 1) then
			m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].Activate(iPlayerID);
		end
		
		if (Game.GetCurrentGameTurn() == 2) then
			m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].Activate(iPlayerID);
		end
		
		if (Game.GetCurrentGameTurn() == 3) then
			m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].Activate(iPlayerID);
		end
		
		if (Game.GetCurrentGameTurn() == 4) then
			m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].Activate(iPlayerID);
		end
		
	end
end
GameEvents.OnGameTurnStarted.Add(CheckEventsTriggers);



for row in GameInfo.EventPopupData() do
	m_FUEventDefs[row.Type] = {};
end





-- ===========================================================================
--	 One Choices Event
-- ===========================================================================



m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].EventKey = 'EVENT_TEMPLATE_ONE_CHOICE'
m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].Activate = function(playerID)
	local sEventKey = 'EVENT_TEMPLATE_ONE_CHOICE'
	local pPlayer = Players[playerID];
	--Prepare UI
	EffectText = Locale.Lookup("LOC_EVENT_TEMPLATE_ONE_CHOICE_EFFECT");
	unlock = {};
	unlock.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_ONE_CHOICE")};
	unlock.EffectIcons = {{"Gold"}};
	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ContinueText ="LOC_"..sEventKey.."_CONTINUE",Unlocks=unlock});
	pPlayer:GetTreasury():ChangeGoldBalance(10);
	
end



-- ===========================================================================
--	 Two Choices Event
-- ===========================================================================



m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].EventKey = 'EVENT_TEMPLATE_TWO_CHOICE'
m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].Activate = function(playerID)
	local sEventKey = 'EVENT_TEMPLATE_TWO_CHOICE'
	local pPlayer = Players[playerID];
	
	--Prepare UI
	EffectText = Locale.Lookup("LOC_EVENT_TEMPLATE_TWO_CHOICE_EFFECT");
	unlockA = {};
	unlockA.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_TWO_CHOICE_1")};
	unlockA.EffectIcons = {{"ICON_EVENT_EFFECT"}}; 
	unlockB = {};
	unlockB.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_TWO_CHOICE_2")};
	unlockB.EffectIcons = {{"PROPOSE_TRADE"}};
	
	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ChoiceAText ="LOC_"..sEventKey.."_CHOICE_A", ChoiceBText="LOC_"..sEventKey.."_CHOICE_B", ChoiceAUnlocks=unlockA,ChoiceBUnlocks=unlockB});
end

--CHOICE A
m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].ACallback = function(kParams : table)
	
	local pPlayer : object = Players[kParams.ForPlayer];
	pPlayer:GetTreasury():ChangeGoldBalance(6);

end

--CHOICE B
m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].BCallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].Activate(kParams.ForPlayer);	
end




-- ===========================================================================
--	 Three Choices Event
-- ===========================================================================



m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].EventKey = 'EVENT_TEMPLATE_THREE_CHOICE'
m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].Activate = function(playerID)
	local sEventKey = 'EVENT_TEMPLATE_THREE_CHOICE'
	local pPlayer = Players[playerID];
	
	--Prepare UI
	EffectText = Locale.Lookup("LOC_EVENT_TEMPLATE_THREE_CHOICE_EFFECT");
	unlockA = {};
	unlockA.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_THREE_CHOICE_1")};
	unlockA.EffectIcons = {{"ICON_DIFFICULTY_SETTLER"}}; 
	unlockB = {};
	unlockB.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_THREE_CHOICE_2")};
	unlockB.EffectIcons = {{"ICON_DIFFICULTY_CHIEFTAIN"}};
	
	unlockC = {};
	unlockC.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_THREE_CHOICE_3")};
	unlockC.EffectIcons = {{"ICON_EVENT_EFFECT"}}; 
	
	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ChoiceAText ="LOC_"..sEventKey.."_CHOICE_A", ChoiceBText="LOC_"..sEventKey.."_CHOICE_B", ChoiceCText = "LOC_"..sEventKey.."_CHOICE_C", ChoiceAUnlocks=unlockA,ChoiceBUnlocks=unlockB, ChoiceCUnlocks=unlockC});
end

--CHOICE A
m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].ACallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].Activate(kParams.ForPlayer);	

end

--CHOICE B
m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].BCallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].Activate(kParams.ForPlayer);	
end

--CHOICE C
m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].CCallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].Activate(kParams.ForPlayer);	
end




-- ===========================================================================
--	 Six Choices Event
-- ===========================================================================



m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].EventKey = 'EVENT_TEMPLATE_SIX_CHOICE'
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].Activate = function(playerID)
	local sEventKey = 'EVENT_TEMPLATE_SIX_CHOICE'
	local pPlayer = Players[playerID];
	
	--Prepare UI
	EffectText = Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_EFFECT");
	unlockA = {};
	unlockA.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_1")};
	unlockA.EffectIcons = {{"ICON_DIFFICULTY_SETTLER"}}; 
	unlockB = {};
	unlockB.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_2")};
	unlockB.EffectIcons = {{"ICON_DIFFICULTY_CHIEFTAIN"}};
	
	unlockC = {};
	unlockC.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_3")};
	unlockC.EffectIcons = {{"ICON_DIFFICULTY_WARLORD"}}; 
	
	unlockD = {};
	unlockD.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_4")};
	unlockD.EffectIcons = {{"ICON_DIFFICULTY_PRINCE"}}; 
	
	unlockE = {};
	unlockE.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_5")};
	unlockE.EffectIcons = {{"ICON_DIFFICULTY_KING"}}; 
	
	unlockF = {};
	unlockF.Effects = {Locale.Lookup("LOC_EVENT_TEMPLATE_SIX_CHOICE_6")};
	unlockF.EffectIcons = {{"ICON_DIFFICULTY_EMPEROR"}}; 
	
	--Call event popup
	ReportingEvents.Send("EVENT_POPUP_REQUEST", { EventEffect = EffectText,ForPlayer = playerID, EventKey = sEventKey, ChoiceAText ="LOC_"..sEventKey.."_CHOICE_A", ChoiceBText="LOC_"..sEventKey.."_CHOICE_B", ChoiceCText = "LOC_"..sEventKey.."_CHOICE_C", ChoiceDText = "LOC_"..sEventKey.."_CHOICE_D", ChoiceEText = "LOC_"..sEventKey.."_CHOICE_E", ChoiceFText = "LOC_"..sEventKey.."_CHOICE_F", ChoiceAUnlocks=unlockA,ChoiceBUnlocks=unlockB, ChoiceCUnlocks=unlockC, ChoiceDUnlocks=unlockD, ChoiceEUnlocks = unlockE, ChoiceFUnlocks = unlockF});
end

--CHOICE A
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].ACallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_ONE_CHOICE'].Activate(kParams.ForPlayer);	

end

--CHOICE B
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].BCallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_TWO_CHOICE'].Activate(kParams.ForPlayer);	
end

--CHOICE C
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].CCallback = function(kParams : table)
	
	m_FUEventDefs['EVENT_TEMPLATE_THREE_CHOICE'].Activate(kParams.ForPlayer);	
end

--CHOICE D
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].DCallback = function(kParams : table)
	
	pPlayer:GetTreasury():ChangeGoldBalance(4);
end

--CHOICE E
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].ECallback = function(kParams : table)
	
	pPlayer:GetTreasury():ChangeGoldBalance(5);
end

--CHOICE F
m_FUEventDefs['EVENT_TEMPLATE_SIX_CHOICE'].FCallback = function(kParams : table)
	
	pPlayer:GetTreasury():ChangeGoldBalance(6);
end
