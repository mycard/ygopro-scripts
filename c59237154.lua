--うごめく影
---@param c Card
function c59237154.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59237154,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c59237154.cost)
	e2:SetTarget(c59237154.target)
	e2:SetOperation(c59237154.operation)
	c:RegisterEffect(e2)
end
function c59237154.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,300) end
	Duel.PayLPCost(tp,300)
end
function c59237154.filter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c59237154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59237154.filter,tp,LOCATION_MZONE,0,2,nil) end
end
function c59237154.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59237154.filter,tp,LOCATION_MZONE,0,nil)
	Duel.ShuffleSetCard(g)
end
