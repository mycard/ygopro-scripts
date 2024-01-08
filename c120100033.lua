local m=120100033
local cm=_G["c"..m]
cm.name="エクリケラス・ドラコーン"
function cm.initial_effect(c)
    --[Effect] The SetCountLimit makes it so that this effect can only be used once per turn. As the Condition checks if the monster is Normal or Special Summoned, this impliments a soft Once Per Turn so the effect both cannot be used the next turn AND can't be used if flipped face-down and back face-up.
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.Condition)
    e1:SetTarget(cm.Target)
    e1:SetOperation(cm.Operation)
    c:RegisterEffect(e1)
end
--[Condition] During the turn you Normal Summon or Special Summon this card while you have a monster in your Graveyard that fits cm.Filter.
function cm.Condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:GetSummonType()==SUMMON_TYPE_NORMAL or c:GetSummonType()==SUMMON_TYPE_SPECIAL) 
        and Duel.IsExistingMatchingCard(cm.Filter,tp,LOCATION_GRAVE,0,1,nil)
end
--[Target] Makes sure you have a monster in your Graveyard that fits cm.Filter.
function cm.Target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.Filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
--[Target] [Filter] DARK Attribute Dragon Type or Fiend Type monster with 1200 DEF that can be added to your hand.
function cm.Filter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON+RACE_FIEND) and c:IsDefense(1200) and c:IsAbleToHand()
end
--[Operation] Add 1 DARK Attribute Dragon Type or Fiend Type monster with 1200 DEF from your Graveyard to your hand.
function cm.Operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.Filter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        e1:SetTargetRange(LOCATION_MZONE,0)
        e1:SetTarget(cm.AntiBattleFilter)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
--[Operation] Your Level 6 or lower Effect Monsters cannot attack this turn.
function cm.AntiBattleFilter(e,c)
    return c:IsLevelBelow(6) and c:IsType(TYPE_EFFECT)
end