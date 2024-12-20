--ダークファミリア
---@param c Card
function c58551308.initial_effect(c)
	--flip effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c58551308.flipop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(58551308,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c58551308.sptg)
	e2:SetOperation(c58551308.spop)
	c:RegisterEffect(e2)
end
function c58551308.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) then
		c:RegisterFlagEffect(58551308,RESET_EVENT+0x57a0000,0,1)
	end
end
function c58551308.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
end
function c58551308.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return e:GetHandler():GetFlagEffect(58551308)~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c58551308.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(1-tp,c58551308.filter,1-tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,1-tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,#g1,0,0)
end
function c58551308.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then return end
	local tc=sg:GetFirst()
	if tc and Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0 then
		local sp=tc:GetControler()
		Duel.SpecialSummonStep(tc,0,sp,sp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	end
	tc=sg:GetNext()
	if tc and Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)>0 then
		local sp=tc:GetControler()
		Duel.SpecialSummonStep(tc,0,sp,sp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
