--天空聖者メルティウス
---@param c Card
function c49905576.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--recover&destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c49905576.drop)
	c:RegisterEffect(e1)
end
function c49905576.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_COUNTER) or not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return end
	Duel.Recover(tp,1000,REASON_EFFECT)
	if not Duel.IsEnvironment(56433456) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
