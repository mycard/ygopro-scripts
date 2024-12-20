--サルベージ
---@param c Card
function c96947648.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c96947648.target)
	e1:SetOperation(c96947648.activate)
	c:RegisterEffect(e1)
end
function c96947648.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(1500) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c96947648.opfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c96947648.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c96947648.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c96947648.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c96947648.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c96947648.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c96947648.opfilter,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
