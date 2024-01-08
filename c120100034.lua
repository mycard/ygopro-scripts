local m=120100034
local cm=_G["c"..m]
cm.name="無貌のカルドサック"
function cm.initial_effect(c)
    --Special Summon Procedure
    RD.AddHandSpecialSummonProcedure(c,aux.Stringid(m,0),cm.SpecialCost,cm.SpecialTarget,cm.SpecialOperation)
    --Attack Boost for Fiend Type monsters you control
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.Condition)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(300)
    c:RegisterEffect(e1)
end
--Condition for Attack Boost
function cm.Condition(e,c)
    return c:IsRace(RACE_FIEND) and c:IsControler(e:GetHandlerPlayer())
end
--Special Summon Procedure
function cm.SpecialCost(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.SpecialConditionFilter,tp,LOCATION_HAND,0,1,c)
end
--Reveal 1 Fiend Type monster from your hand
function cm.SpecialTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,cm.SpecialConditionFilter,tp,LOCATION_HAND,0,1,1,c)
    if g:GetCount()>0 then
        g:KeepAlive()
        e:SetLabelObject(g)
        return true
    else
        return false
    end
end
--Special Summon
function cm.SpecialOperation(e,tp,eg,ep,ev,re,r,rp,c)
    local g=e:GetLabelObject()
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
    local tc=g:GetFirst()
    tc:ResetEffect(EFFECT_PUBLIC,RESET_CARD)
    g:DeleteGroup()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e:GetHandler():RegisterEffect(e1)
end
--Fiend Type Hand Filter
function cm.SpecialConditionFilter(c,tc)
    return c:IsRace(RACE_FIEND) and c~=tc and not c:IsPublic()
end