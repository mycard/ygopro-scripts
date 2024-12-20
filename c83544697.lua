--ガスタの交信
---@param c Card
function c83544697.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c83544697.target)
	e1:SetOperation(c83544697.activate)
	c:RegisterEffect(e1)
end
function c83544697.filter1(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c83544697.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c83544697.filter1,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c83544697.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c83544697.filter2(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c83544697.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local g2=g:Filter(c83544697.filter2,nil,1-tp)
	if g1:GetCount()==2 and Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==2 then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==2 and g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
