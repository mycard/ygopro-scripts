--雲魔物のスコール
---@param c Card
function c90135989.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90135989,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c90135989.condition)
	e2:SetOperation(c90135989.operation)
	c:RegisterEffect(e2)
end
function c90135989.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90135989.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1019,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1019,1)
		tc=g:GetNext()
	end
end
