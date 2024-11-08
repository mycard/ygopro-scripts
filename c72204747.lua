--オーバー・デステニー
---@param c Card
function c72204747.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c72204747.target)
	e1:SetOperation(c72204747.activate)
	c:RegisterEffect(e1)
end
function c72204747.filter1(c,e,sp)
	local lv=math.floor(c:GetLevel()/2)
	return lv>0 and c:IsSetCard(0xc008)
		and Duel.IsExistingMatchingCard(c72204747.filter2,sp,LOCATION_DECK,0,1,nil,lv,e,sp)
end
function c72204747.filter2(c,lv,e,sp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c72204747.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c72204747.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c72204747.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(72204747,0))
	Duel.SelectTarget(tp,c72204747.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72204747.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.SelectMatchingCard(tp,c72204747.filter2,tp,LOCATION_DECK,0,1,1,nil,math.floor(tc:GetLevel()/2),e,tp)
	if cg:GetCount()==0 then return end
	local sc=cg:GetFirst()
	if Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--destroy
		local fid=e:GetHandler():GetFieldID()
		sc:RegisterFlagEffect(72204747,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c72204747.descon)
		e1:SetOperation(c72204747.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c72204747.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(72204747)==e:GetLabel()
end
function c72204747.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
