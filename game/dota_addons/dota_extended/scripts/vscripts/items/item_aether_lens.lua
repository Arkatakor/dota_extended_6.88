--[[
		By: AtroCty
		Date: 17.05.2017
		Updated:  17.05.2017
	]]
-------------------------------------------
--			AETHER LENS
-------------------------------------------
LinkLuaModifier("modifier_extended_aether_lens", "items/item_aether_lens.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------

item_extended_aether_lens = item_extended_aether_lens or class({})
-------------------------------------------
function item_extended_aether_lens:GetIntrinsicModifierName()
    return "modifier_extended_aether_lens"
end

-------------------------------------------
modifier_extended_aether_lens = modifier_extended_aether_lens or class({})
function modifier_extended_aether_lens:IsDebuff() return false end
function modifier_extended_aether_lens:IsHidden() return true end
function modifier_extended_aether_lens:IsPermanent() return true end
function modifier_extended_aether_lens:IsPurgable() return false end
function modifier_extended_aether_lens:IsPurgeException() return false end
function modifier_extended_aether_lens:IsStunDebuff() return false end
function modifier_extended_aether_lens:RemoveOnDeath() return false end
function modifier_extended_aether_lens:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_extended_aether_lens:OnDestroy()
	self:CheckUnique(false)
end

function modifier_extended_aether_lens:OnCreated()
	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_mana = item:GetSpecialValueFor("bonus_mana")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.cast_range_bonus = item:GetSpecialValueFor("cast_range_bonus")
		self.spell_power = item:GetSpecialValueFor("spell_power")
		self:CheckUnique(true)
	end
end

function modifier_extended_aether_lens:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE
    }
    return decFuns
end

function modifier_extended_aether_lens:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,{"modifier_extended_elder_staff","modifier_extended_nether_wand"})
end

function modifier_extended_aether_lens:GetModifierPercentageManaRegen()
	return self.bonus_mana_regen
end

function modifier_extended_aether_lens:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_extended_aether_lens:GetModifierCastRangeBonus()
	return self:CheckUniqueValue(self.cast_range_bonus, {"modifier_extended_elder_staff"})
end