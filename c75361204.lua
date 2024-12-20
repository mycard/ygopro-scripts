--グレイドル・スプリット
---@param c Card
function c75361204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c75361204.cost)
	e1:SetTarget(c75361204.target)
	e1:SetOperation(c75361204.operation)
	c:RegisterEffect(e1)
end
function c75361204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(c75361204.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c75361204.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function c75361204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return e:IsCostChecked()
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75361204.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(c75361204.eqlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetCountLimit(1,75361204)
		e3:SetCondition(c75361204.spcon)
		e3:SetCost(c75361204.spcost)
		e3:SetTarget(c75361204.sptg)
		e3:SetOperation(c75361204.spop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
end
function c75361204.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c or c:IsControler(e:GetHandlerPlayer())
end
function c75361204.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c75361204.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabelObject(e:GetHandler():GetEquipTarget())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c75361204.spfilter1(c,e,tp)
	return c:IsSetCard(0xd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c75361204.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c75361204.spfilter2(c,e,tp,code)
	return c:IsSetCard(0xd1) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75361204.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75361204.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local ec=e:GetLabelObject()
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c75361204.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if ec:IsRelateToEffect(e) and ec:IsFaceup() and Duel.Destroy(ec,REASON_EFFECT)~=0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c75361204.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c75361204.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		tc1:RegisterFlagEffect(75361204,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc2:RegisterFlagEffect(75361204,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		Duel.SpecialSummonComplete()
		g1:Merge(g2)
		g1:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g1)
		e1:SetCondition(c75361204.descon)
		e1:SetOperation(c75361204.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75361204.desfilter(c,fid)
	return c:GetFlagEffectLabel(75361204)==fid
end
function c75361204.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c75361204.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c75361204.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c75361204.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
