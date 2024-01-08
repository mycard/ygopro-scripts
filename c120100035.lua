local m=120100035
local cm=_G["c"..m]
cm.name="ジェスペル・ウィザード"
function cm.initial_effect(c)
    --Attack Boost
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.condition)
    e1:SetCost(cm.cost)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
end
--If you have 10 or more Spell Cards in your Graveyard
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(function(c) return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL) end,tp,LOCATION_GRAVE,0,nil)>=10
end
--Shuffle 2 Spell Cards from your Graveyard into the Deck
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL) end,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,function(c) return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_SPELL) end,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--This card gains 500 ATK until the end of your opponent's next turn
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,tp,500)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        e1:SetValue(d)
        c:RegisterEffect(e1)
    end
end