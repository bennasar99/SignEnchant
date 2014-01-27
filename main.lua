function Initialize(Plugin)
	Plugin:SetName("SignEnchant")
	Plugin:SetVersion(1)

	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
	cPluginManager:AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign);

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	
	return true
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
    if Line1 == "[Enchant]" then
        if Player:HasPermission("signenchant.sign") then
            return false
        else
            return true
        end
    end
end 

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
    if BlockType == E_BLOCK_SIGN then
        Read, Line1, Line2, Line3, Line4 = Player:GetWorld():GetSignLines( BlockX, BlockY, BlockZ , "", "", "", "" )
        if Line1 == "[Enchant]" and Line2 ~= "" and Line3 ~= "" and Line4 ~= "" then
            HeldItem = Player:GetEquippedItem();
            HeldItemType = HeldItem.m_ItemType;
            ItemEnchant = HeldItem.m_Enchantments;
            level = Player:GetXpLevel();
            Enchantment = cEnchantments:StringToEnchantmentID(Line2);
            MaxLevel = Line3;
            LevelNeeded = Line4;
            CurrentItemLevel = HeldItem.m_Enchantments:GetLevel(Enchantment);
            NextLevel = CurrentItemLevel + 1;
            toremove = tonumber(Line4) * NextLevel
            if CurrentItemLevel == tonumber(Line3) or level < tonumber(Line4) then
                return false
            else
                if IsEnchantable() == true then
                    ItemEnchant:SetLevel(Enchantment, NextLevel)
                    Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HeldItem)
                    Player:DeltaExperience(-toremove * 17)
                else
                    Player:SendMessage("This item is not enchantable")
                end
            end
        end
    end
end

function IsEnchantable()
	if (HeldItemType >= 256) and (HeldItemType <= 259) then
		return true;
	elseif (HeldItemType >= 267) and (HeldItemType <= 279) then
		return true;
	elseif (HeldItemType >= 283) and (HeldItemType <= 286) then
		return true;
	elseif (HeldItemType >= 290) and (HeldItemType <= 294) then
		return true;
	elseif (HeldItemType >= 298) and (HeldItemType <= 317) then
		return true;
	elseif (HeldItemType >= 290) and (HeldItemType <= 294) then
		return true;
	elseif (HeldItemType == 346) or (HeldItemType == 359) or (HeldItemType == 261) then
		return true;
    end
end
