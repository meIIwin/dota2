local Mars = {}

Mars.optionEnable = Menu.AddOptionBool({"Hero Specific","Mars"},"Enabled",false)
Mars.optionAutoSpearOfMars = Menu.AddOptionBool({"Hero Specific","Mars"}, "Auto Spear of Mars", false)
Mars.optionAutoGodsRebuke = Menu.AddOptionBool({"Hero Specific","Mars"}, "Auto God's Rebuke", false)
Mars.optionAutoInitiate = Menu.AddOption({"Hero Specific", "Mars"}, "Auto Initiate", false)
Mars.optionAutoItem = Menu.AddOption({"Hero Specific", "Mars"}, "Auto Use Items", false)
Mars.optionKey = Menu.AddKeyOption({"Hero Specific", "Mars"}, "Auto Initiate Key", Enum.ButtonCode.KEY_K)

local shouldAutoInitiate = false

-- auto initiate when enemy heroes are near
-- (this mode can be turn on/off by pressing key)
function Mars.OnDraw()
    if not Menu.IsEnabled(Mars.optionAutoInitiate) then return end

    local myHero = Heroes.GetLocal()
    if not myHero or NPC.GetUnitName(myHero) ~= "npc_dota_hero_mars" then return end
    if (not Entity.IsAlive(myHero)) or NPC.IsStunned(myHero) or NPC.IsSilenced(myHero) then return end

    if Menu.IsKeyDownOnce(Mars.key) then
        shouldAutoInitiate = not shouldAutoInitiate
    end

    if not shouldAutoInitiate then return end

    -- draw text when auto initiate key is up
    local pos = Entity.GetAbsOrigin(myHero)
    local x, y, visible = Renderer.WorldToScreen(pos)
    Renderer.SetDrawColor(0, 255, 0, 255)
    Renderer.DrawTextCentered(Mars.font, x, y, "Auto", 1)

    if not NPC.HasItem(myHero, "item_blink", true) then return end
    local blink = NPC.GetItem(myHero, "item_blink", true)
    if not blink or not Ability.IsCastable(blink, 0) then return end

    local spear = NPC.GetAbilityByIndex(myHero, 0)
    if not spear or not Ability.IsCastable(spear, NPC.GetMana(myHero)) then return end 
	
	local gods = NPC.GetAbilityByIndex(myHero, 1)
    if not gods or not Ability.IsCastable(gods, NPC.GetMana(myHero)) then return end

    local spear_radius = 900
    local gods_radius = 500

    local pos = Utility.BestPosition(enemyHeroes, spear_radius)
    if pos then
        Ability.CastPosition(blink, pos)
    end
    Ability.CastNoTarget(spear)

end

return Mars