--EMヒックリカエル
---@param c Card
function c4239451.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--swap1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4239451,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c4239451.adtg1)
	e2:SetOperation(c4239451.adop1)
	c:RegisterEffect(e2)
	--swap2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4239451,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c4239451.adcon2)
	e3:SetTarget(c4239451.adtg2)
	e3:SetOperation(c4239451.adop2)
	c:RegisterEffect(e3)
end
function c4239451.filter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c4239451.adtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4239451.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4239451.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c4239451.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c4239451.adop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c4239451.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function c4239451.adtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsDefenseAbove(0) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDefenseAbove,tp,LOCATION_MZONE,0,1,nil,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsDefenseAbove,tp,LOCATION_MZONE,0,1,1,nil,0)
end
function c4239451.adop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
