--有翼賢者ファルコス
---@param c Card
function c87523462.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87523462,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(c87523462.tdcon)
	e1:SetTarget(c87523462.tdtg)
	e1:SetOperation(c87523462.tdop)
	c:RegisterEffect(e1)
end
function c87523462.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and bc:IsControler(1-tp) and bc:GetBattlePosition()==POS_FACEUP_ATTACK
end
function c87523462.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToDeck() end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function c87523462.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
