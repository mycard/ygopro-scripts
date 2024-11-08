--叛逆者エト
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Traitor_chaining_effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(s.fuslimit)
	c:RegisterEffect(e7)
	--immune
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.efilter)
	c:RegisterEffect(e8)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not s.globle_check then
		s.globle_check=true
		s.Traitor_RegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(Card_c,Effect_e,bool)
			if Effect_e:GetType() and bit.band(Effect_e:GetType(),EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)~=0 then
				if Effect_e:GetCode() and Effect_e:GetCode()==EVENT_CHAINING then
					Card_c:RegisterFlagEffect(id,0,0,1)
				end
			end
			if bool then
				s.Traitor_RegisterEffect(Card_c,Effect_e,bool)
			else
				s.Traitor_RegisterEffect(Card_c,Effect_e,false)
			end
		end
		local rg=Duel.GetMatchingGroup(Card.IsType,tp,0xff,0xff,nil,TYPE_MONSTER)
		for tc in aux.Next(rg) do
			if tc.initial_effect then
				local Traitor_initial_effect=s.initial_effect
				s.initial_effect=function() end
				tc:ReplaceEffect(id,0)
				s.initial_effect=Traitor_initial_effect
				tc.initial_effect(tc)
			end
		end
		Card.RegisterEffect=s.Traitor_RegisterEffect
	end
end
function s.cfilter(c)
	return (c:GetFlagEffect(id)>0 or c.Traitor_chaining_effect) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER
		and c:IsFaceupEx()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,c:GetControler(),0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function s.efilter(e,re)
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() and e:GetHandlerPlayer()~=re:GetOwnerPlayer()
		and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) then
		local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
		return LOCATION_ONFIELD&loc~=0
	end
	return false
end
