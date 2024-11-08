--ダブルツールD＆C
---@param c Card
function c63730624.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c63730624.target)
	e1:SetOperation(c63730624.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c63730624.eqlimit)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c63730624.scon1)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c63730624.scon2)
	e4:SetOperation(c63730624.sop2)
	c:RegisterEffect(e4)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetTarget(c63730624.distg)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e8)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c63730624.ocon1)
	e5:SetValue(c63730624.atlimit)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(63730624,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c63730624.ocon2)
	e6:SetTarget(c63730624.otg2)
	e6:SetOperation(c63730624.oop2)
	c:RegisterEffect(e6)
end
function c63730624.eqlimit(e,c)
	return c:GetControler()==e:GetHandler():GetControler()
		and (c:IsCode(2403771) or (c:IsSetCard(0x26) and c:IsLevelAbove(4) and c:IsRace(RACE_MACHINE)))
end
function c63730624.filter(c,tp)
	return c:IsControler(tp) and c:IsFaceup()
		and (c:IsCode(2403771) or (c:IsSetCard(0x26) and c:IsLevelAbove(4) and c:IsRace(RACE_MACHINE)))
end
function c63730624.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c63730624.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c63730624.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c63730624.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c63730624.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c63730624.scon1(e)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
function c63730624.scon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetAttacker()==e:GetHandler():GetEquipTarget()
end
function c63730624.sop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	d:RegisterFlagEffect(63730624,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c63730624.distg(e,c)
	return c:GetFlagEffect(63730624)~=0
end
function c63730624.ocon1(e)
	return e:GetHandler():GetEquipTarget() and Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c63730624.atlimit(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function c63730624.ocon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local tc=e:GetHandler():GetEquipTarget()
	return tc and Duel.GetTurnPlayer()~=tp and d==tc and a:IsRelateToBattle()
end
function c63730624.otg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function c63730624.oop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.Destroy(a,REASON_EFFECT)
	end
end
