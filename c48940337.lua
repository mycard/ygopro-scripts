--ランスフォリンクス
---@param c Card
function c48940337.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c48940337.target)
	c:RegisterEffect(e2)
end
function c48940337.target(e,c)
	return c:IsType(TYPE_NORMAL)
end
