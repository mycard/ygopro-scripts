--ディメンション・マジック
---@param c Card
function c28553439.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c28553439.condition)
	e1:SetTarget(c28553439.target)
	e1:SetOperation(c28553439.activate)
	c:RegisterEffect(e1)
end
function c28553439.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c28553439.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28553439.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c28553439.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28553439.rfilter(c,e,tp,ft)
	return c:IsCanBeEffectTarget(e)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c28553439.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c28553439.rfilter(chkc,e,tp,ft) end
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupEx(tp,c28553439.rfilter,1,REASON_EFFECT,false,nil,e,tp,ft)
		and Duel.IsExistingMatchingCard(c28553439.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c28553439.rfilter,1,1,REASON_EFFECT,false,nil,e,tp,ft)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c28553439.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		if Duel.Release(tc,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28553439.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()==0 then return end
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(28553439,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local des=dg:Select(tp,1,1,nil)
			Duel.HintSelection(des)
			Duel.BreakEffect()
			Duel.Destroy(des,REASON_EFFECT)
		end
	end
end
