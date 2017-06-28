--	Author: Rook
--	Date: 			26.01.2015		<-- Dinosaurs roamed the earth
--	Converted to lua by Firetoad
--	Last Update:	26.03.2017
--	Arcane Boots, Mekansm, and Guardian Greaves

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots definition
-----------------------------------------------------------------------------------------------------------

if item_extended_arcane_boots == nil then item_extended_arcane_boots = class({}) end
LinkLuaModifier( "modifier_item_extended_arcane_boots", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable

function item_extended_arcane_boots:GetIntrinsicModifierName()
	return "modifier_item_extended_arcane_boots" end

function item_extended_arcane_boots:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local replenish_mana = self:GetSpecialValueFor("base_replenish_mana") + self:GetSpecialValueFor("replenish_mana_pct") * caster:GetMaxMana() * 0.01
		local replenish_radius = self:GetSpecialValueFor("replenish_radius")

		-- Play activation sound and particle
		caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
		local arcane_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(arcane_pfx)

		-- Iterate through nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, replenish_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do

			-- Grant the ally mana 
			ally:GiveMana(replenish_mana)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , ally, replenish_mana, nil)

			-- Play the "hit" particle
			local arcane_target_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(arcane_target_pfx)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_arcane_boots == nil then modifier_item_extended_arcane_boots = class({}) end
function modifier_item_extended_arcane_boots:IsHidden() return true end
function modifier_item_extended_arcane_boots:IsDebuff() return false end
function modifier_item_extended_arcane_boots:IsPurgable() return false end
function modifier_item_extended_arcane_boots:IsPermanent() return true end
function modifier_item_extended_arcane_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_extended_arcane_boots:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_extended_arcane_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_extended_arcane_boots:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana") end



-----------------------------------------------------------------------------------------------------------
--	Mekansm definition
-----------------------------------------------------------------------------------------------------------

if item_extended_mekansm == nil then item_extended_mekansm = class({}) end
LinkLuaModifier( "modifier_item_extended_mekansm", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_extended_mekansm_aura_emitter", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_extended_mekansm_aura", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff
LinkLuaModifier( "modifier_item_extended_mekansm_heal", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Heal buff

function item_extended_mekansm:GetIntrinsicModifierName()
	return "modifier_item_extended_mekansm" end

function item_extended_mekansm:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local heal_amount = self:GetSpecialValueFor("heal_amount") * (1 + caster:GetSpellPower() * 0.01)
		local heal_radius = self:GetSpecialValueFor("heal_radius")
		local heal_duration = self:GetSpecialValueFor("heal_duration")

		-- Play activation sound and particle
		caster:EmitSound("DOTA_Item.Mekansm.Activate")
		local mekansm_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(mekansm_pfx)

		-- Iterate through nearby allies
		local caster_loc = caster:GetAbsOrigin()
		local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do

			-- Heal the ally
			ally:Heal(heal_amount, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)

			-- Play healing sound & particle
			ally:EmitSound("DOTA_Item.Mekansm.Target")
			local mekansm_target_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 0, caster_loc)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 1, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(mekansm_target_pfx)

			-- Apply armor & heal over time buff
			ally:AddNewModifier(caster, self, "modifier_item_extended_mekansm_heal", {duration = heal_duration})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mekansm owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_mekansm == nil then modifier_item_extended_mekansm = class({}) end
function modifier_item_extended_mekansm:IsHidden() return true end
function modifier_item_extended_mekansm:IsDebuff() return false end
function modifier_item_extended_mekansm:IsPurgable() return false end
function modifier_item_extended_mekansm:IsPermanent() return true end
function modifier_item_extended_mekansm:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_extended_mekansm:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_extended_mekansm_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_extended_mekansm_aura_emitter", {})
		end
	end
end

-- Removes the aura emitter from the caster if this is the last mekansm in its inventory
function modifier_item_extended_mekansm:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_extended_mekansm") then
			parent:RemoveModifierByName("modifier_item_extended_mekansm_aura_emitter")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_extended_mekansm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_extended_mekansm:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_mekansm:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_mekansm:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_mekansm:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_mekansm_aura_emitter == nil then modifier_item_extended_mekansm_aura_emitter = class({}) end
function modifier_item_extended_mekansm_aura_emitter:IsAura() return true end
function modifier_item_extended_mekansm_aura_emitter:IsHidden() return true end
function modifier_item_extended_mekansm_aura_emitter:IsDebuff() return false end
function modifier_item_extended_mekansm_aura_emitter:IsPurgable() return false end

function modifier_item_extended_mekansm_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
	
function modifier_item_extended_mekansm_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
	
function modifier_item_extended_mekansm_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_extended_mekansm_aura"
		else
			return nil
		end
	end
end
	
function modifier_item_extended_mekansm_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_mekansm_aura == nil then modifier_item_extended_mekansm_aura = class({}) end
function modifier_item_extended_mekansm_aura:IsHidden() return false end
function modifier_item_extended_mekansm_aura:IsDebuff() return false end
function modifier_item_extended_mekansm_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_extended_mekansm_aura:GetTexture()
	return "custom/extended_mekansm" end

-- Stores the aura's parameters to prevent errors when the item is destroyed
function modifier_item_extended_mekansm_aura:OnCreated(keys)
	self.aura_health_regen = self:GetAbility():GetSpecialValueFor("aura_health_regen")
end

-- Declare modifier events/properties
function modifier_item_extended_mekansm_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_extended_mekansm_aura:GetModifierConstantHealthRegen()
	return self.aura_health_regen end

-----------------------------------------------------------------------------------------------------------
--	Mekansm heal over time
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_mekansm_heal == nil then modifier_item_extended_mekansm_heal = class({}) end
function modifier_item_extended_mekansm_heal:IsHidden() return false end
function modifier_item_extended_mekansm_heal:IsDebuff() return false end
function modifier_item_extended_mekansm_heal:IsPurgable() return true end

-- Modifier texture
function modifier_item_extended_mekansm_heal:GetTexture()
	return "custom/extended_mekansm" end

-- Stores the ability's parameters to prevent errors if the item is destroyed
function modifier_item_extended_mekansm_heal:OnCreated(keys)
	self.heal_bonus_armor = self:GetAbility():GetSpecialValueFor("heal_bonus_armor")
	self.heal_percentage = self:GetAbility():GetSpecialValueFor("heal_percentage")
end

-- Declare modifier events/properties
function modifier_item_extended_mekansm_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
	}
	return funcs
end

function modifier_item_extended_mekansm_heal:GetModifierHealthRegenPercentage()
	return self.heal_percentage end

function modifier_item_extended_mekansm_heal:GetModifierPhysicalArmorBonusUniqueActive()
	return self.heal_bonus_armor end



-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves definition
-----------------------------------------------------------------------------------------------------------

if item_extended_guardian_greaves == nil then item_extended_guardian_greaves = class({}) end
LinkLuaModifier( "modifier_item_extended_guardian_greaves", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_extended_guardian_greaves_aura_emitter", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_extended_guardian_greaves_aura", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff
LinkLuaModifier( "modifier_item_extended_guardian_greaves_heal", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Heal buff

function item_extended_guardian_greaves:GetIntrinsicModifierName()
	return "modifier_item_extended_guardian_greaves" end

function item_extended_guardian_greaves:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local heal_amount = self:GetSpecialValueFor("mend_base_health") * (1 + caster:GetSpellPower() * 0.01)
		local mana_amount = self:GetSpecialValueFor("mend_base_mana") + self:GetSpecialValueFor("mend_mana_pct") * caster:GetMaxMana() * 0.01
		local heal_radius = self:GetSpecialValueFor("aura_radius")
		local heal_duration = self:GetSpecialValueFor("mend_duration")

		-- Cast Mend
		GreavesActivate(caster, self, heal_amount, mana_amount, heal_radius, heal_duration)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_guardian_greaves == nil then modifier_item_extended_guardian_greaves = class({}) end
function modifier_item_extended_guardian_greaves:IsHidden() return true end
function modifier_item_extended_guardian_greaves:IsDebuff() return false end
function modifier_item_extended_guardian_greaves:IsPurgable() return false end
function modifier_item_extended_guardian_greaves:IsPermanent() return true end
function modifier_item_extended_guardian_greaves:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_extended_guardian_greaves:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_extended_guardian_greaves_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_extended_guardian_greaves_aura_emitter", {})
		end
	end
end

-- Removes the aura emitter from the caster if this is the last greaves in its inventory
function modifier_item_extended_guardian_greaves:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_extended_guardian_greaves") then
			parent:RemoveModifierByName("modifier_item_extended_guardian_greaves_aura_emitter")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_extended_guardian_greaves:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_extended_guardian_greaves:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_extended_guardian_greaves:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana") end

function modifier_item_extended_guardian_greaves:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_guardian_greaves:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_guardian_greaves:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_extended_guardian_greaves:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_guardian_greaves_aura_emitter == nil then modifier_item_extended_guardian_greaves_aura_emitter = class({}) end
function modifier_item_extended_guardian_greaves_aura_emitter:IsAura() return true end
function modifier_item_extended_guardian_greaves_aura_emitter:IsHidden() return true end
function modifier_item_extended_guardian_greaves_aura_emitter:IsDebuff() return false end
function modifier_item_extended_guardian_greaves_aura_emitter:IsPurgable() return false end

function modifier_item_extended_guardian_greaves_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
	
function modifier_item_extended_guardian_greaves_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
	
function modifier_item_extended_guardian_greaves_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_extended_guardian_greaves_aura"
		else
			return nil
		end
	end
end
	
function modifier_item_extended_guardian_greaves_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

-- Declare modifier events/properties
function modifier_item_extended_guardian_greaves_aura_emitter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- Psssive activation when below the threshold
function modifier_item_extended_guardian_greaves_aura_emitter:OnTakeDamage( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if owner ~= keys.unit then
			return end

		-- If this is an illusion, do nothing
		if owner:IsIllusion() then
			return end

		-- If the owner's health is below the threshold, and Mend is off cooldown, activate it
		local ability = self:GetAbility()
		if owner:GetHealthPercent() <= ability:GetSpecialValueFor("min_health_threshold") and ability:IsCooldownReady() then
			local heal_amount = ability:GetSpecialValueFor("mend_base_health") * (1 + owner:GetSpellPower() * 0.01)
			local mana_amount = ability:GetSpecialValueFor("mend_base_mana") + ability:GetSpecialValueFor("mend_mana_pct") * owner:GetMaxMana() * 0.01
			local heal_radius = ability:GetSpecialValueFor("aura_radius")
			local heal_duration = ability:GetSpecialValueFor("mend_duration")
			GreavesActivate(owner, ability, heal_amount, mana_amount, heal_radius, heal_duration)
			ability:StartCooldown(ability:GetCooldown(1) * GetCooldownReduction(owner))
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_guardian_greaves_aura == nil then modifier_item_extended_guardian_greaves_aura = class({}) end
function modifier_item_extended_guardian_greaves_aura:IsHidden() return false end
function modifier_item_extended_guardian_greaves_aura:IsDebuff() return false end
function modifier_item_extended_guardian_greaves_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_extended_guardian_greaves_aura:GetTexture()
	return "custom/extended_guardian_greaves" end

-- Stores the aura's parameters to prevent errors when the item is destroyed
function modifier_item_extended_guardian_greaves_aura:OnCreated(keys)
	local ability = self:GetAbility()
	self.aura_regen = ability:GetSpecialValueFor("aura_regen")
	self.aura_armor = ability:GetSpecialValueFor("aura_armor")
	self.aura_max_regen_bonus = ability:GetSpecialValueFor("aura_max_regen_bonus")
	self.aura_max_armor_bonus = ability:GetSpecialValueFor("aura_max_armor_bonus")
	self.min_health_threshold = ability:GetSpecialValueFor("min_health_threshold")
end

-- Declare modifier events/properties
function modifier_item_extended_guardian_greaves_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_extended_guardian_greaves_aura:GetModifierPhysicalArmorBonus()
	local owner = self:GetParent()

	-- Hero-only health-scaling bonus
	if owner:IsRealHero() then
		local bonus_power = (1 - math.max(owner:GetHealthPercent(), self.min_health_threshold) * 0.01) / (1 - self.min_health_threshold * 0.01)
		return self.aura_armor + (self.aura_max_armor_bonus - self.aura_armor) * bonus_power
	end

	return self.aura_armor
end

function modifier_item_extended_guardian_greaves_aura:GetModifierConstantHealthRegen()
	local owner = self:GetParent()

	-- Hero-only health-scaling bonus
	if owner:IsRealHero() then
		local bonus_power = (1 - math.max(owner:GetHealthPercent(), self.min_health_threshold) * 0.01) / (1 - self.min_health_threshold * 0.01)
		return self.aura_regen + (self.aura_max_regen_bonus - self.aura_regen) * bonus_power
	end

	return self.aura_regen
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves heal over time
-----------------------------------------------------------------------------------------------------------

if modifier_item_extended_guardian_greaves_heal == nil then modifier_item_extended_guardian_greaves_heal = class({}) end
function modifier_item_extended_guardian_greaves_heal:IsHidden() return false end
function modifier_item_extended_guardian_greaves_heal:IsDebuff() return false end
function modifier_item_extended_guardian_greaves_heal:IsPurgable() return true end

-- Modifier texture
function modifier_item_extended_guardian_greaves_heal:GetTexture()
	return "custom/extended_guardian_greaves" end

-- Stores the ability's parameters to prevent errors if the item is destroyed
function modifier_item_extended_guardian_greaves_heal:OnCreated(keys)
	self.mend_regen = self:GetAbility():GetSpecialValueFor("mend_regen")
end

-- Declare modifier events/properties
function modifier_item_extended_guardian_greaves_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_item_extended_guardian_greaves_heal:GetModifierHealthRegenPercentage()
	return self.mend_regen end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves active
-----------------------------------------------------------------------------------------------------------

function GreavesActivate(caster, ability, heal_amount, mana_amount, heal_radius, heal_duration)

	-- Purge debuffs from the caster
	caster:Purge(false, true, false, true, false)

	-- Play activation sound and particle
	caster:EmitSound("Item.GuardianGreaves.Activate")
	local cast_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	-- Iterate through nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(nearby_allies) do

		-- Heal & replenish mana
		ally:Heal(heal_amount, caster)
		ally:GiveMana(mana_amount)

		-- Show hp & mana overhead messages
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_amount, nil)
		
		-- Play target sound
		ally:EmitSound("Item.GuardianGreaves.Target")

		-- Choose target particle
		local particle_target = "particles/items3_fx/warmage_recipient_nonhero.vpcf"
		if ally:IsHero() then
			particle_target = "particles/items3_fx/warmage_recipient.vpcf"
		end

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:SetParticleControl(target_pfx, 0, ally:GetAbsOrigin())

		-- Apply heal over time buff
		ally:AddNewModifier(caster, ability, "modifier_item_extended_guardian_greaves_heal", {duration = heal_duration})
	end
end