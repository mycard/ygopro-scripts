local m=120254024
local list={120120000,120252003,120252027}
local cm=_G["c"..m]
cm.name="エンジン・オブ・デストラクション"
function cm.initial_effect(c)
    RD.AddCodeList(c,list)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.Condition)
    e1:SetTarget(cm.Target)
    e1:SetOperation(cm.Operation)
    c:RegisterEffect(e1)
end
--[Condition]
function cm.Condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.ConditionFilter,tp,LOCATION_MZONE,0,1,nil)
end
--[Target]
function cm.Target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.TargetFilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
--[Operation]
function cm.Operation(e,tp,eg,ep,ev,re,r,rp)
	RD.SelectAndDoAction(HINTMSG_ATOHAND,aux.NecroValleyFilter(cm.TargetFilter),tp,LOCATION_GRAVE,0,1,1,nil,function(g)
		if RD.SendToHandAndExists(g,1-tp,cm.OperationFilter,1,nil) then
			RD.CanSelectAndDoAction(aux.Stringid(m,1),HINTMSG_ATOHAND,aux.NecroValleyFilter(cm.AdditionalFilter),tp,LOCATION_GRAVE,0,1,1,nil,function(sg)
				RD.SendToHandAndExists(sg,1-tp)
			end)
		end
	end)
end
--[Condition] [Filter] If you have "Blue-Eyes White Dragon" face-up on your field.
function cm.ConditionFilter(c)
    return c:GetCode()==list[1] and c:IsFaceup()
end
--[Target] [Filter] If you have a Level 8 LIGHT Attribute Dragon Type monster in your Graveyard.
function cm.TargetFilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:IsLevel(8) and c:IsAbleToHand()
end
--[Operation] [Filter] "Blue-Eyes Bright Dragon" is in your hand.
function cm.OperationFilter(c)
    return c:GetOriginalCode()==list[2] and c:IsLocation(LOCATION_HAND)
end
--[Operation] [Filter] "The Ultimate Blue-Eyed Legend" is in your Graveyard.
function cm.AdditionalFilter(c)
    return c:GetCode()==list[3] and c:IsLocation(LOCATION_GRAVE)
end