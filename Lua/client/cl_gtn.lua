if CLIENT then

if file.IsDir("gtn", "DATA") == false then
    file.CreateDir("gtn")
end

local ICON16_USER_SUIT = Material("icon16/user_suit.png")
local ICON16_PAGE_WHITE = Material("icon16/page_white.png")
local ICON16_DATABASE_DELETE = Material("icon16/database_delete.png")

local GTN_ICON_MENU = Material("gtn/menu.png")
local GTN_ICON_POWER = Material("gtn/power.png")
local GTN_ICON_BACK = Material("gtn/back.png")
local GTN_ICON_PUBLISH = Material("gtn/publish.png")
local GTN_ICON_SETTINGS = Material("gtn/settings.png")
local GTN_ICON_HELP = Material("gtn/help.png")
local GTN_ICON_BUILD = Material("gtn/build.png")
local GTN_ICON_LIST = Material("gtn/list.png")
local GTN_ICON_EDIT = Material("gtn/edit.png")
local GTN_ICON_FORWARD = Material("gtn/forward.png")

surface.CreateFont("gtnMenuFont", {
    font = "Roboto",
    extended = false,
    size = 24,
    weight = 350,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("gtnMenuFontSmall", {
    font = "Roboto",
    extended = false,
    size = 17,
    weight = 350,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("gtnHelpFont", {
    font = "Roboto",
    extended = false,
    size = 20,
    weight = 350,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

surface.CreateFont("gtnHelpFontBold", {
    font = "Roboto",
    extended = false,
    size = 24,
    weight = 400,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

-- Colours.

local gtnDefaultColourMenu = Color(220, 220, 220)

local gtnDarkColourBox = Color(97, 97, 97)
local gtnNormalColourBox = Color(238, 238, 238)

local gtnDarkColourHeader = Color(0, 137, 123)
local gtnDarkColourHeaderHovered = Color(0, 150, 136)
local gtnDarkColourHeaderDarker = Color(0, 121, 107)
local gtnDarkColourHeaderShadow = Color(0, 105, 92, 220)
local gtnNormalColourHeader = Color(2, 136, 209)
local gtnNormalColourHeaderHovered = Color(33, 150, 243)
local gtnNormalColourHeaderDarker = Color(21, 116, 192)
local gtnNormalColourHeaderShadow = Color(2, 109, 179)

local gtnDarkColourText = Color(220, 220, 220)
local gtnDarkColourTextHovered = Color(50, 50, 50)
local gtnNormalColourText = Color(50, 50, 50)
local gtnNormalColourTextHovered = Color(150, 150, 150)

-- We need to set all windows to 'not opened yet' by default, otherwise we will receive an error.

local gtnIsCreateGameOpen = false
local gtnIsHelpPageOpen = false
local gtnIsSettingsOpen = false
local gtnIsAdminSettingsOpen = false
local gtnIsAdminSettingsWhitelistOpen = false
local gtnIsCreateGameRandomNumberHelpOpen = false
local gtnIsCreateGameWeaponHelpOpen = false
local gtnIsAdminSettingsPlayersRequiredHelpOpen = false
local gtnIsAdminSettingsWhitelistHelpOpen = false
local gtnIsCommandsOpen = false
local gtnIsLeaderboardOpen = false

-- We need to read the client's saved values from Settings on addon start.

local gtnDarkModeSavedValue = tobool(file.Read("gtn/gtn_darkmode.txt", "DATA"))
local gtnDarkModeIsActive = gtnDarkModeSavedValue

local gtnDisableSoundSavedValue = tobool(file.Read("gtn/gtn_disablesound.txt", "DATA"))
local gtnDisableSoundIsActive = gtnDisableSoundSavedValue

local gtnEnableHintsSavedValue = tobool(file.Read("gtn/gtn_enablehints.txt", "DATA"))
local gtnEnableHintsIsActive = gtnEnableHintsSavedValue

function gtnOpenMenu()
    surface.PlaySound("garrysmod/ui_click.wav")
    net.Start("gtnCheckOwnerGroup")
    net.SendToServer()
    net.Start("gtnCheckPlayersRequired")
    net.SendToServer()
    net.Start("gtnCheckAccess")
    net.SendToServer()
    net.Start("gtnCheckPointShopInstalled")
    net.SendToServer()
    net.Start("gtnCheckPointShop2Installed")
    net.SendToServer()
    net.Start("gtnCheckLeaderboard")
    net.SendToServer()
    local gtnMenu = vgui.Create("DFrame")
        gtnMenu:SetSize(378, 275)
        gtnMenu:Center()
        gtnMenu:MakePopup()
        gtnMenu:SetVisible(true)
        gtnMenu:SetDraggable(false)
        gtnMenu:ShowCloseButton(false)
        gtnMenu:SetTitle("")
        gtnMenu:RequestFocus()

        gtnMenu.OnKeyCodePressed = function(self, key)
            if key ~= KEY_ENTER then return end
                if gtnIsGroupInTable == true then
                    if gtnIsCreateGameOpen == false then
                        gtnCreateGameButton:OnMousePressed()
                    else
                        surface.PlaySound("resource/warning.wav")
                        chat.AddText("[GTN] Please exit the window before opening another.")
                    end
                else
                    surface.PlaySound("common/wpn_denyselect.wav")
                    chat.AddText("[GTN] You must be in a whitelisted group to create a game.")
                end
        end

        gtnMenu.Paint = function(s, w, h)
            if gtnDarkModeIsActive == true then
                draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                draw.NoTexture()
                surface.SetDrawColor(gtnDarkColourHeader)
                surface.DrawTexturedRect(0, 0, 400, 35)

                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                surface.DrawTexturedRect(0, 33, 400, 2)
            else
                draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                draw.NoTexture()
                surface.SetDrawColor(gtnNormalColourHeader)
                surface.DrawTexturedRect(0, 0, 400, 35)

                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                surface.DrawTexturedRect(0, 33, 400, 2)
            end

            surface.SetDrawColor(gtnDefaultColourMenu)
            surface.SetMaterial(GTN_ICON_MENU)
            surface.DrawTexturedRect(6, 6, 24, 24)
            draw.NoTexture()
        end

        local gtnMenuTitle = vgui.Create("DLabel", gtnMenu)
            gtnMenuTitle:SetSize(200, 30)
            gtnMenuTitle:SetPos(40, 4)
            gtnMenuTitle:SetText("Main menu")
            gtnMenuTitle:SetFont("gtnMenuFont")
            gtnMenuTitle:SetColor(gtnDefaultColourMenu)

        local gtnMenuBugReport = vgui.Create("DImageButton", gtnMenu)
            gtnMenuBugReport:SetSize(90, 22)
            gtnMenuBugReport:SetFont("gtnMenuFontSmall")
            gtnMenuBugReport:SetText("Report Bug")
            gtnMenuBugReport:SetTextColor(gtnDefaultColourMenu)
            gtnMenuBugReport:Center()
            gtnMenuBugReport:SetPos(gtnMenuBugReport:GetPos() + 130, 12)
            gtnMenuBugReport.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnMenuBugReport:IsHovered() == true then
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawOutlinedRect(0, 0, 90, 22)

                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 88, 20)
                    else
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawOutlinedRect(0, 0, 90, 22)

                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderDarker)
                        surface.DrawTexturedRect(1, 1, 88, 20)
                    end
                else
                    if gtnMenuBugReport:IsHovered() == true then
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawOutlinedRect(0, 0, 90, 22)

                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 88, 20)
                    else
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawOutlinedRect(0, 0, 90, 22)

                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderDarker)
                        surface.DrawTexturedRect(1, 1, 88, 20)
                    end
                end
            end

            function gtnMenuBugReport:OnMousePressed()
                surface.PlaySound("garrysmod/ui_click.wav")
                gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/discussions/1181687249")
            end

        local gtnExitMenu = vgui.Create("DImageButton", gtnMenu)
            gtnExitMenu:SetSize(36, 36)
            gtnExitMenu:SetText("")
            gtnExitMenu:Center()
            gtnExitMenu:SetPos(gtnExitMenu:GetPos(), 232)
            gtnExitMenu.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnExitMenu:IsHovered() == true then
                        surface.SetDrawColor(gtnDarkColourTextHovered)
                    else
                        surface.SetDrawColor(gtnDarkColourText)
                    end
                else
                    if gtnExitMenu:IsHovered() == true then
                        surface.SetDrawColor(gtnNormalColourTextHovered)
                    else
                        surface.SetDrawColor(Color(50, 50, 50))
                    end
                end
                surface.SetMaterial(GTN_ICON_POWER)
                surface.DrawTexturedRect(0, 0, 36, 36)
                draw.NoTexture()
            end

            gtnExitMenu.DoClick = function()
                surface.PlaySound("buttons/combine_button2.wav")
                gtnMenu:Close()
            end

        gtnCreateGameButton = vgui.Create("DButton", gtnMenu)
            gtnCreateGameButton:SetSize(170, 50)
            gtnCreateGameButton:Center()
            gtnCreateGameButton:SetFont("gtnMenuFont")
            gtnCreateGameButton:SetColor(gtnDefaultColourMenu)
            gtnCreateGameButton:SetText("Create game")
            gtnCreateGameButton:SetPos(gtnCreateGameButton:GetPos() + 90, 50)
            gtnCreateGameButton.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnCreateGameButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                else
                    if gtnCreateGameButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                end
            end

            function gtnCreateGameButton:OnMousePressed()
                gtnMenu:SetVisible(false)
                if gtnIsGroupInTable == true then
                    if gtnIsCreateGameOpen == false then
                        gtnIsRewardMoney = false
                        gtnIsRewardNothing = true
                        gtnIsRewardWeapon = false
                        gtnIsRewardPSPoints = false
                        gtnIsRewardPS2Points = false
                        gtnRandomNumberRange = 50
                        gtnIsWeaponValueCorrect = false
                        gtnIsMoneyValueCorrect = false
                        surface.PlaySound("garrysmod/ui_click.wav")
                        local gtnCreateGame = vgui.Create("DFrame")
                            gtnIsCreateGameOpen = true
                            gtnCreateGame:SetSize(300, 400)
                            gtnCreateGame:Center()
                            gtnCreateGame:MakePopup()
                            gtnCreateGame:SetDraggable(false)
                            gtnCreateGame:ShowCloseButton(false)
                            gtnCreateGame:SetTitle("")
                            gtnCreateGame.Paint = function(s, w, h)
                                if gtnDarkModeIsActive == true then
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnDarkColourHeader)
                                    surface.DrawTexturedRect(0, 0, 300, 35)

                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 300, 2)
                                else
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnNormalColourHeader)
                                    surface.DrawTexturedRect(0, 0, 300, 35)

                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 300, 2)
                                end

                                surface.SetDrawColor(gtnDefaultColourMenu)
                                surface.SetMaterial(GTN_ICON_EDIT)
                                surface.DrawTexturedRect(10, 9, 20, 20)
                                draw.NoTexture()
                            end

                            local gtnCreateGameTitle = vgui.Create("DLabel", gtnCreateGame)
                                gtnCreateGameTitle:SetSize(200, 30)
                                gtnCreateGameTitle:SetPos(40, 4)
                                gtnCreateGameTitle:SetText("Create game")
                                gtnCreateGameTitle:SetFont("gtnMenuFont")
                                gtnCreateGameTitle:SetColor(gtnDefaultColourMenu)

                            local gtnCreateGameRewardLabelBox = vgui.Create("DFrame", gtnCreateGame)
                                gtnCreateGameRewardLabelBox:SetSize(270, 35)
                                gtnCreateGameRewardLabelBox:Center()
                                gtnCreateGameRewardLabelBox:SetPos(15, 54)
                                gtnCreateGameRewardLabelBox:SetDraggable(false)
                                gtnCreateGameRewardLabelBox:ShowCloseButton(false)
                                gtnCreateGameRewardLabelBox:SetTitle("")
                                gtnCreateGameRewardLabelBox.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnDarkColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    else
                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnNormalColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    end
                                end

                            local gtnCreateGameRewardLabel = vgui.Create("DLabel", gtnCreateGameRewardLabelBox)
                                gtnCreateGameRewardLabel:SetPos(8, 2)
                                gtnCreateGameRewardLabel:SetSize(180, 30)
                                gtnCreateGameRewardLabel:SetText("Reward")
                                gtnCreateGameRewardLabel:SetFont("gtnMenuFont")
                                gtnCreateGameRewardLabel:SetColor(gtnDefaultColourMenu)

                            local gtnCreateGameRewardType = vgui.Create("DComboBox", gtnCreateGame)
                                gtnCreateGameRewardType:SetPos(173, 62)
                                gtnCreateGameRewardType:SetSize(100, 20)
                                gtnCreateGameRewardType:SetSortItems(false)
                                gtnCreateGameRewardType:SetValue("Pick reward")
                                gtnCreateGameRewardType:AddChoice("Money")
                                gtnCreateGameRewardType:AddChoice("Weapon")
                                gtnCreateGameRewardType:AddChoice("Points (PS2)")
                                gtnCreateGameRewardType:AddChoice("Points")
                                gtnCreateGameRewardType:AddChoice("None")
                                gtnCreateGameRewardType.OnSelect = function(panel, index, value)
                                    if index == 1 then
                                        if GAMEMODE.Name == "DarkRP" then
                                            gtnIsRewardMoney = true
                                            gtnIsRewardNothing = false
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = false
                                            gtnIsRewardPS2Points = false
                                            gtnCreateGameMoneyTextEntry:SetVisible(true)
                                            gtnCreateGameMoneyTextEntry:SetText("")
                                            gtnIsMoneyValueCorrect = false
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                            gtnCreateGameNoneLabel:SetVisible(false)
                                            gtnCreateGameMoneyTextEntry:RequestFocus()
                                            surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                            chat.AddText("[GTN] Enter a money value.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        else
                                            gtnIsRewardMoney = false
                                            gtnIsRewardNothing = true
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = false
                                            gtnIsRewardPS2Points = false
                                            gtnCreateGameMoneyTextEntry:SetVisible(false)
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                            gtnCreateGameNoneLabel:SetVisible(true)
                                            surface.PlaySound("resource/warning.wav")
                                            gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                            chat.AddText("[GTN] DarkRP is required to set money rewards.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        end
                                    elseif index == 2 then
                                        gtnIsRewardMoney = false
                                        gtnIsRewardNothing = false
                                        gtnIsRewardWeapon = true
                                        gtnIsRewardPSPoints = false
                                        gtnIsRewardPS2Points = false
                                        gtnCreateGameMoneyTextEntry:SetVisible(false)
                                        gtnCreateGameWeaponTextEntry:SetVisible(true)
                                        gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                        gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                        gtnCreateGameNoneLabel:SetVisible(false)
                                        gtnCreateGameWeaponTextEntry:SetText("")
                                        gtnIsWeaponValueCorrect = false
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameWeaponTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a weapon value.")
                                        gtnCreateGameWeaponHelpButton:SetVisible(true)
                                    elseif index == 3 then
                                        if gtnIsPointShop2Installed == true then
                                            gtnIsRewardMoney = false
                                            gtnIsRewardNothing = false
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = false
                                            gtnIsRewardPS2Points = true
                                            gtnCreateGameMoneyTextEntry:SetVisible(false)
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(true)
                                            gtnCreateGameNoneLabel:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetText("")
                                            gtnIsPS2PointsValueCorrect = false
                                            surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                            gtnCreateGamePS2PointsTextEntry:RequestFocus()
                                            chat.AddText("[GTN] Enter a Pointshop 2 Points value.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        else
                                            gtnIsRewardMoney = false
                                            gtnIsRewardNothing = true
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = false
                                            gtnIsRewardPS2Points = false
                                            gtnCreateGameMoneyTextEntry:SetVisible(false)
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                            gtnCreateGameNoneLabel:SetVisible(true)
                                            surface.PlaySound("resource/warning.wav")
                                            gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                            chat.AddText("[GTN] Pointshop 2 is required to set Points (PS2) rewards.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        end
                                    elseif index == 4 then
                                        if gtnIsPointShopInstalled == true then
                                            gtnIsRewardMoney = false
                                            gtnIsRewardNothing = false
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = true
                                            gtnIsRewardPS2Points = false
                                            gtnCreateGameMoneyTextEntry:SetVisible(false)
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(true)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                            gtnCreateGameNoneLabel:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetText("")
                                            gtnIsPSPointsValueCorrect = false
                                            surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                            gtnCreateGamePSPointsTextEntry:RequestFocus()
                                            chat.AddText("[GTN] Enter a PointShop Points value.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        else
                                            gtnIsRewardMoney = false
                                            gtnIsRewardNothing = true
                                            gtnIsRewardWeapon = false
                                            gtnIsRewardPSPoints = false
                                            gtnIsRewardPS2Points = false
                                            gtnCreateGameMoneyTextEntry:SetVisible(false)
                                            gtnCreateGameWeaponTextEntry:SetVisible(false)
                                            gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                            gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                            gtnCreateGameNoneLabel:SetVisible(true)
                                            surface.PlaySound("resource/warning.wav")
                                            gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                            chat.AddText("[GTN] PointShop is required to set Points rewards.")
                                            gtnCreateGameWeaponHelpButton:SetVisible(false)
                                        end
                                    elseif index == 5 then
                                        gtnIsRewardMoney = false
                                        gtnIsRewardNothing = true
                                        gtnIsRewardWeapon = false
                                        gtnIsRewardPSPoints = false
                                        gtnIsRewardPS2Points = false
                                        gtnCreateGameMoneyTextEntry:SetVisible(false)
                                        gtnCreateGameWeaponTextEntry:SetVisible(false)
                                        gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                        gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                        gtnCreateGameNoneLabel:SetVisible(true)
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a maximum range for the random number.")
                                        gtnCreateGameWeaponHelpButton:SetVisible(false)
                                    end
                                end

                            gtnCreateGameMoneyTextEntry = vgui.Create("DTextEntry", gtnCreateGame)
                                gtnCreateGameMoneyTextEntry:SetPos(17, 110)
                                gtnCreateGameMoneyTextEntry:SetSize(100, 20)
                                gtnCreateGameMoneyTextEntry:SetText("")
                                gtnCreateGameMoneyTextEntry:RequestFocus()
                                gtnCreateGameMoneyTextEntry:SetVisible(false)
                                gtnCreateGameMoneyTextEntry:SetUpdateOnType(true)
                                gtnCreateGameMoneyTextEntry.OnValueChange = function(self)
                                    local gtnEnteredMoneyReward = tonumber(self:GetValue())
                                    if isnumber(gtnEnteredMoneyReward) then
                                        if tonumber(gtnEnteredMoneyReward) > 0 and tonumber(gtnEnteredMoneyReward) <= 4000000000 then
                                            gtnMoneyReward = gtnEnteredMoneyReward
                                            gtnIsMoneyValueCorrect = true
                                        else
                                            gtnIsMoneyValueCorrect = false
                                            surface.PlaySound("resource/warning.wav")
                                            chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                        end
                                    end
                                end

                                gtnCreateGameMoneyTextEntry.OnEnter = function(self)
                                    if gtnIsMoneyValueCorrect == true then
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a maximum range for the random number.")
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        gtnCreateGameMoneyTextEntry:RequestFocus()
                                        chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                    end
                                end

                            gtnCreateGameWeaponTextEntry = vgui.Create("DTextEntry", gtnCreateGame)
                                gtnCreateGameWeaponTextEntry:SetPos(17, 110)
                                gtnCreateGameWeaponTextEntry:SetSize(100, 20)
                                gtnCreateGameWeaponTextEntry:SetText("")
                                gtnCreateGameWeaponTextEntry:RequestFocus()
                                gtnCreateGameWeaponTextEntry:SetVisible(false)
                                gtnCreateGameWeaponTextEntry:SetUpdateOnType(true)
                                gtnCreateGameWeaponTextEntry.OnValueChange = function(self)
                                    gtnIsWeaponValueCorrect = false
                                    gtnEnteredWeapon = self:GetValue()
                                    if isstring(gtnEnteredWeapon) then
                                        gtnWeaponReward = gtnEnteredWeapon
                                        gtnIsWeaponValueCorrect = true
                                    else
                                        gtnIsWeaponValueCorrect = false
                                    end
                                end

                                gtnCreateGameWeaponTextEntry.OnEnter = function(self)
                                    if gtnIsWeaponValueCorrect == true then
                                        gtnWeaponReward = gtnEnteredWeapon
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a maximum range for the random number.")
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        gtnCreateGameWeaponTextEntry:RequestFocus()
                                        chat.AddText("[GTN] You must enter a valid weapon value.")
                                    end
                                end

                                gtnCreateGameWeaponHelpButton = vgui.Create("DImageButton", gtnCreateGame)
                                    gtnCreateGameWeaponHelpButton:SetSize(36, 36)
                                    gtnCreateGameWeaponHelpButton:SetText("")
                                    gtnCreateGameWeaponHelpButton:Center()
                                    gtnCreateGameWeaponHelpButton:RequestFocus()
                                    gtnCreateGameWeaponHelpButton:SetVisible(false)
                                    gtnCreateGameWeaponHelpButton:SetPos(gtnCreateGameWeaponHelpButton:GetPos(), 104)
                                    gtnCreateGameWeaponHelpButton:SetTooltip("Weapon\n\nTo set a weapon reward,\nyou must enter the class\nname of the desired\nweapon.\n\nYou can obtain a weapon's\nclass name by going to\nthe spawnmenu. This can\nbe opened by pressing 'Q'\n(default) on the keyboard.\n\nOnce on the spawnmenu,\nclick on the Weapons tab\nand right -click on the\ndesired weapon.\n\nPress Copy to Clipboard,\nthis copies the class name\nof the weapon.\n\nNow simply enter the\ncopied value into the entry\nbar. This can be done\nby pressing Ctrl + V on\nthe keyboard.")
                                    gtnCreateGameWeaponHelpButton.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            if gtnCreateGameWeaponHelpButton:IsHovered() == true then
                                                surface.SetDrawColor(gtnDarkColourTextHovered)
                                            else
                                                surface.SetDrawColor(gtnDarkColourText)
                                            end
                                        else
                                            if gtnCreateGameWeaponHelpButton:IsHovered() == true then
                                                surface.SetDrawColor(gtnNormalColourTextHovered)
                                            else
                                                surface.SetDrawColor(gtnNormalColourText)
                                            end
                                        end
                                        surface.SetMaterial(GTN_ICON_HELP)
                                        surface.DrawTexturedRect(0, 0, 32, 32)
                                        draw.NoTexture()
                                    end

                                    --[[gtnCreateGameWeaponHelpButton.DoClick = function() -- Commented because we use Tooltips now.
                                        if gtnIsCreateGameWeaponHelpOpen == false then
                                            surface.PlaySound("garrysmod/ui_click.wav")
                                            gtnCreateGameWeaponHelp = vgui.Create("DFrame")
                                                gtnCreateGameWeaponHelp:SetSize(270, 300)
                                                gtnIsCreateGameWeaponHelpOpen = true
                                                gtnCreateGameWeaponHelp:Center()
                                                gtnCreateGameWeaponHelp:SetPos(gtnCreateGameWeaponHelp:GetPos() + 150, 135)
                                                gtnCreateGameWeaponHelp:MakePopup()
                                                gtnCreateGameWeaponHelp:SetDraggable(true)
                                                gtnCreateGameWeaponHelp:ShowCloseButton(false)
                                                gtnCreateGameWeaponHelp:SetTitle("")
                                                gtnCreateGameWeaponHelp:RequestFocus()
                                                gtnCreateGameWeaponHelp.Paint = function(s, w, h)
                                                    if gtnDarkModeIsActive == true then
                                                        draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                        draw.NoTexture()
                                                        surface.SetDrawColor(gtnDarkColourHeader)
                                                        surface.DrawTexturedRect(0, 0, 270, 35)

                                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                        surface.DrawTexturedRect(0, 33, 270, 2)
                                                    else
                                                        draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                        draw.NoTexture()
                                                        surface.SetDrawColor(gtnNormalColourHeader)
                                                        surface.DrawTexturedRect(0, 0, 270, 35)

                                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                        surface.DrawTexturedRect(0, 33, 270, 2)
                                                    end

                                                    surface.SetDrawColor(gtnDefaultColourMenu)
                                                    surface.SetMaterial(GTN_ICON_HELP)
                                                    surface.DrawTexturedRect(2, 1, 32, 32)
                                                    draw.NoTexture()
                                                end

                                                local gtnCreateGameWeaponHelpScrollPanel = vgui.Create("DScrollPanel", gtnCreateGameWeaponHelp)
                                                    gtnCreateGameWeaponHelpScrollPanel:SetPos(15, 50)
                                                    gtnCreateGameWeaponHelpScrollPanel:SetSize(243, 175)

                                                    local gtnCreateGameWeaponHelpText1Title = vgui.Create("DLabel", gtnCreateGameWeaponHelpScrollPanel)
                                                        gtnCreateGameWeaponHelpText1Title:SetSize(250, 30)
                                                        gtnCreateGameWeaponHelpText1Title:SetPos(0, 0)
                                                        gtnCreateGameWeaponHelpText1Title.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                gtnCreateGameWeaponHelpText1Title:SetColor(gtnDarkColourText)
                                                            else
                                                                gtnCreateGameWeaponHelpText1Title:SetColor(gtnNormalColourText)
                                                            end
                                                        end
                                                        gtnCreateGameWeaponHelpText1Title:SetText("Weapon")
                                                        gtnCreateGameWeaponHelpText1Title:SetFont("gtnHelpFontBold")
                                                        gtnCreateGameWeaponHelpText1Title:SizeToContentsY()

                                                    local gtnCreateGameWeaponHelpText1 = vgui.Create("DLabel", gtnCreateGameWeaponHelpScrollPanel)
                                                        gtnCreateGameWeaponHelpText1:SetSize(225, 30)
                                                        gtnCreateGameWeaponHelpText1:SetPos(0, 30)
                                                        gtnCreateGameWeaponHelpText1.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                gtnCreateGameWeaponHelpText1:SetColor(gtnDarkColourText)
                                                            else
                                                                gtnCreateGameWeaponHelpText1:SetColor(gtnNormalColourText)
                                                            end
                                                        end
                                                        gtnCreateGameWeaponHelpText1:SetText("To set a weapon reward,\nyou must enter the class\nname of the desired\nweapon.\n\nYou can obtain a weapon's\nclass name by going to\nthe spawnmenu. This can\nbe opened by pressing 'Q'\n(default) on the keyboard.\n\nOnce on the spawnmenu,\nclick on the Weapons tab\nand right -click on the\ndesired weapon.\n\nPress Copy to Clipboard,\nthis copies the class name\nof the weapon.\n\nNow simply enter the\ncopied value into the entry\nbar. This can be done\nby pressing Ctrl + V on\nthe keyboard.")
                                                        gtnCreateGameWeaponHelpText1:SetFont("gtnHelpFont")
                                                        gtnCreateGameWeaponHelpText1:SizeToContentsY()

                                                local gtnExitCreateGameWeaponHelp = vgui.Create("DImageButton", gtnCreateGameWeaponHelp)
                                                    gtnExitCreateGameWeaponHelp:SetSize(36, 36)
                                                    gtnExitCreateGameWeaponHelp:SetText("")
                                                    gtnExitCreateGameWeaponHelp:Center()
                                                    gtnExitCreateGameWeaponHelp:SetPos(gtnExitCreateGameWeaponHelp:GetPos() - 47, 255)
                                                    gtnExitCreateGameWeaponHelp.Paint = function(s, w, h)
                                                        if gtnDarkModeIsActive == true then
                                                            if gtnExitCreateGameWeaponHelp:IsHovered() == true then
                                                                surface.SetDrawColor(gtnDarkColourTextHovered)
                                                            else
                                                                surface.SetDrawColor(gtnDarkColourText)
                                                            end
                                                        else
                                                            if gtnExitCreateGameWeaponHelp:IsHovered() == true then
                                                                surface.SetDrawColor(gtnNormalColourTextHovered)
                                                            else
                                                                surface.SetDrawColor(gtnNormalColourText)
                                                            end
                                                        end
                                                        surface.SetMaterial(GTN_ICON_BACK)
                                                        surface.DrawTexturedRect(0, 0, 36, 36)
                                                        draw.NoTexture()
                                                    end

                                                    gtnExitCreateGameWeaponHelp.DoClick = function()
                                                        surface.PlaySound("garrysmod/ui_click.wav")
                                                        gtnCreateGameWeaponHelp:Close()
                                                        gtnIsCreateGameWeaponHelpOpen = false
                                                    end

                                                local gtnCreateGameWeaponHelpTitle = vgui.Create("DLabel", gtnCreateGameWeaponHelp)
                                                    gtnCreateGameWeaponHelpTitle:SetSize(200, 30)
                                                    gtnCreateGameWeaponHelpTitle:SetPos(40, 4)
                                                    gtnCreateGameWeaponHelpTitle:SetText("Help")
                                                    gtnCreateGameWeaponHelpTitle:SetFont("gtnMenuFont")
                                                    gtnCreateGameWeaponHelpTitle:SetColor(gtnDefaultColourMenu)
                                        else
                                            surface.PlaySound("resource/warning.wav")
                                            chat.AddText("[GTN] Please exit the window before opening another.")
                                        end
                                    end]]

                            gtnCreateGamePSPointsTextEntry = vgui.Create("DTextEntry", gtnCreateGame)
                                gtnCreateGamePSPointsTextEntry:SetPos(17, 110)
                                gtnCreateGamePSPointsTextEntry:SetSize(100, 20)
                                gtnCreateGamePSPointsTextEntry:SetText("")
                                gtnCreateGamePSPointsTextEntry:RequestFocus()
                                gtnCreateGamePSPointsTextEntry:SetVisible(false)
                                gtnCreateGamePSPointsTextEntry:SetUpdateOnType(true)
                                gtnCreateGamePSPointsTextEntry.OnValueChange = function(self)
                                    local gtnEnteredPSPointsReward = tonumber(self:GetValue())
                                    if isnumber(gtnEnteredPSPointsReward) then
                                        if tonumber(gtnEnteredPSPointsReward) > 0 and tonumber(gtnEnteredPSPointsReward) <= 4000000000 then
                                            gtnPSPointsReward = gtnEnteredPSPointsReward
                                            gtnIsPSPointsValueCorrect = true
                                        else
                                            gtnIsPSPointsValueCorrect = false
                                            surface.PlaySound("resource/warning.wav")
                                            chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                        end
                                    end
                                end

                                gtnCreateGamePSPointsTextEntry.OnEnter = function(self)
                                    if gtnIsPSPointsValueCorrect == true then
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a maximum range for the random number.")
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        gtnCreateGamePSPointsTextEntry:RequestFocus()
                                        chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                    end
                                end

                            gtnCreateGamePS2PointsTextEntry = vgui.Create("DTextEntry", gtnCreateGame)
                                gtnCreateGamePS2PointsTextEntry:SetPos(17, 110)
                                gtnCreateGamePS2PointsTextEntry:SetSize(100, 20)
                                gtnCreateGamePS2PointsTextEntry:SetText("")
                                gtnCreateGamePS2PointsTextEntry:RequestFocus()
                                gtnCreateGamePS2PointsTextEntry:SetVisible(false)
                                gtnCreateGamePS2PointsTextEntry:SetUpdateOnType(true)
                                gtnCreateGamePS2PointsTextEntry.OnValueChange = function(self)
                                    local gtnEnteredPS2PointsReward = tonumber(self:GetValue())
                                    if isnumber(gtnEnteredPS2PointsReward) then
                                        if tonumber(gtnEnteredPS2PointsReward) > 0 and tonumber(gtnEnteredPS2PointsReward) <= 4000000000 then
                                            gtnPS2PointsReward = gtnEnteredPS2PointsReward
                                            gtnIsPS2PointsValueCorrect = true
                                        else
                                            gtnIsPS2PointsValueCorrect = false
                                            surface.PlaySound("resource/warning.wav")
                                            chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                        end
                                    end
                                end

                                gtnCreateGamePS2PointsTextEntry.OnEnter = function(self)
                                    if gtnIsPS2PointsValueCorrect == true then
                                        surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] Enter a maximum range for the random number.")
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        gtnCreateGamePS2PointsTextEntry:RequestFocus()
                                        chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                    end
                                end

                            gtnCreateGameNoneLabel = vgui.Create("DLabel", gtnCreateGame)
                                gtnCreateGameNoneLabel:SetPos(20, 104)
                                gtnCreateGameNoneLabel:SetSize(180, 30)
                                gtnCreateGameNoneLabel:SetFont("gtnMenuFont")
                                gtnCreateGameNoneLabel:SetText("None")
                                gtnCreateGameNoneLabel:SetVisible(true)
                                gtnCreateGameNoneLabel.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnCreateGameNoneLabel:SetTextColor(gtnDefaultColourMenu)
                                    else
                                        gtnCreateGameNoneLabel:SetTextColor(gtnNormalColourText)
                                    end
                                end

                            local gtnCreateGameRandomNumberLabelBox = vgui.Create("DFrame", gtnCreateGame)
                                gtnCreateGameRandomNumberLabelBox:SetSize(270, 35)
                                gtnCreateGameRandomNumberLabelBox:Center()
                                gtnCreateGameRandomNumberLabelBox:SetPos(15, 154)
                                gtnCreateGameRandomNumberLabelBox:SetDraggable(false)
                                gtnCreateGameRandomNumberLabelBox:ShowCloseButton(false)
                                gtnCreateGameRandomNumberLabelBox:SetTitle("")
                                gtnCreateGameRandomNumberLabelBox.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnDarkColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    else
                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnNormalColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    end
                                end

                            local gtnCreateGameRandomNumberLabel = vgui.Create("DLabel", gtnCreateGameRandomNumberLabelBox)
                                gtnCreateGameRandomNumberLabel:SetPos(8, 2)
                                gtnCreateGameRandomNumberLabel:SetSize(180, 30)
                                gtnCreateGameRandomNumberLabel:SetText("Number range")
                                gtnCreateGameRandomNumberLabel:SetFont("gtnMenuFont")
                                gtnCreateGameRandomNumberLabel:SetColor(gtnDefaultColourMenu)

                            gtnCreateGameRandomNumberTextEntry = vgui.Create("DTextEntry", gtnCreateGame)
                                gtnCreateGameRandomNumberTextEntry:SetPos(17, 210)
                                gtnCreateGameRandomNumberTextEntry:SetSize(100, 20)
                                gtnCreateGameRandomNumberTextEntry:SetUpdateOnType(true)
                                gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                gtnIsRandomNumberRangeCorrect = false
                                gtnCreateGameRandomNumberTextEntry.OnValueChange = function(self)
                                    local gtnEnteredRandomNumberRange = tonumber(self:GetValue())
                                    if isnumber(gtnEnteredRandomNumberRange) then
                                        if tonumber(gtnEnteredRandomNumberRange) > 0 and tonumber(gtnEnteredRandomNumberRange) <= 100001 then
                                            --gtnIsRandomNumberRangeOver9000 = false
                                            gtnRandomNumberRange = gtnEnteredRandomNumberRange
                                            gtnIsRandomNumberRangeCorrect = true
                                        --elseif tonumber(gtnEnteredRandomNumberRange) > 9000 then
                                            --gtnIsRandomNumberRangeOver9000 = true
                                            --gtnIsRandomNumberRangeCorrect = false
                                            --surface.PlaySound("resource/warning.wav")
                                            --chat.AddText("[GTN] What?! Nine thousand?! There's no way that could be right!")
                                        else
                                            --gtnIsRandomNumberRangeOver9000 = false
                                            gtnIsRandomNumberRangeCorrect = false
                                            surface.PlaySound("resource/warning.wav")
                                            chat.AddText("[GTN] The specified value must be between 1 and 100,000.")
                                        end
                                    end
                                end

                                gtnCreateGameRandomNumberTextEntry.OnEnter = function(self)
                                    if gtnIsRandomNumberRangeCorrect == true then
                                        surface.PlaySound("garrysmod/ui_click.wav")
                                        gtnStartGame:OnMousePressed()
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                        chat.AddText("[GTN] The specified value must be between 1 and 100,000.")
                                    end
                                end

                            local gtnSettingsEnableHints = vgui.Create("DCheckBoxLabel", gtnCreateGame)
                                gtnSettingsEnableHints:SetParent(gtnCreateGame)
                                gtnSettingsEnableHints:Center()
                                gtnSettingsEnableHints:SetPos(17, 250)
                                gtnSettingsEnableHints:SetFont("gtnMenuFontSmall")
                                gtnSettingsEnableHints:SetText("Enable Hints")
                                gtnSettingsEnableHints.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnSettingsEnableHints:SetTextColor(gtnDarkColourText)
                                    else
                                        gtnSettingsEnableHints:SetTextColor(gtnNormalColourText)
                                    end
                                end

                                gtnSettingsEnableHints:SetValue(gtnEnableHintsSavedValue)

                                function gtnSettingsEnableHints:OnChange(bVal)
                                    gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                    if bVal == true then
                                        surface.PlaySound("garrysmod/ui_click.wav")
                                        chat.AddText("[GTN] Enable Hints set to enabled.")
                                        gtnEnableHintsIsActive = true
                                        file.Write("gtn/gtn_enablehints.txt", tostring(gtnEnableHintsIsActive))
                                        gtnEnableHintsSavedValue = tobool(file.Read("gtn/gtn_enablehints.txt", "DATA"))
                                    elseif bVal == false then
                                        surface.PlaySound("garrysmod/ui_click.wav")
                                        chat.AddText("[GTN] Enable Hints set to disabled.")
                                        gtnEnableHintsIsActive = false
                                        file.Write("gtn/gtn_enablehints.txt", tostring(gtnEnableHintsIsActive))
                                        gtnEnableHintsSavedValue = tobool(file.Read("gtn/gtn_enablehints.txt", "DATA"))
                                    end
                                end

                            gtnCreateGameRandomNumberHelpButton = vgui.Create("DImageButton", gtnCreateGame)
                                gtnCreateGameRandomNumberHelpButton:SetSize(36, 36)
                                gtnCreateGameRandomNumberHelpButton:SetText("")
                                gtnCreateGameRandomNumberHelpButton:Center()
                                gtnCreateGameRandomNumberHelpButton:SetPos(gtnCreateGameRandomNumberHelpButton:GetPos(), 204)
                                gtnCreateGameRandomNumberHelpButton:SetTooltip("Number range\n\nDuring Guess the Number\ngames, people must\nguess a number between\none and the Number\nrange.\n\nThe numbers which\npeople have to guess\nare randomly calculated\nby the server, and their\nmargin is decided by the\nNumber range.")
                                gtnCreateGameRandomNumberHelpButton.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        if gtnCreateGameRandomNumberHelpButton:IsHovered() == true then
                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnDarkColourText)
                                        end
                                    else
                                        if gtnCreateGameRandomNumberHelpButton:IsHovered() == true then
                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnNormalColourText)
                                        end
                                    end
                                    surface.SetMaterial(GTN_ICON_HELP)
                                    surface.DrawTexturedRect(0, 0, 32, 32)
                                    draw.NoTexture()
                                end

                                --[[gtnCreateGameRandomNumberHelpButton.DoClick = function() -- Commented because we use Tooltips now.
                                    if gtnIsCreateGameRandomNumberHelpOpen == false then
                                        surface.PlaySound("garrysmod/ui_click.wav")
                                        gtnCreateGameRandomNumberHelp = vgui.Create("DFrame")
                                            gtnCreateGameRandomNumberHelp:SetSize(270, 300)
                                            gtnIsCreateGameRandomNumberHelpOpen = true
                                            gtnCreateGameRandomNumberHelp:Center()
                                            gtnCreateGameRandomNumberHelp:SetPos(gtnCreateGameRandomNumberHelp:GetPos() + 150, 135)
                                            gtnCreateGameRandomNumberHelp:MakePopup()
                                            gtnCreateGameRandomNumberHelp:SetDraggable(true)
                                            gtnCreateGameRandomNumberHelp:ShowCloseButton(false)
                                            gtnCreateGameRandomNumberHelp:SetTitle("")
                                            gtnCreateGameRandomNumberHelp:RequestFocus()
                                            gtnCreateGameRandomNumberHelp.Paint = function(s, w, h)
                                                if gtnDarkModeIsActive == true then
                                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnDarkColourHeader)
                                                    surface.DrawTexturedRect(0, 0, 270, 35)

                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                    surface.DrawTexturedRect(0, 33, 270, 2)
                                                else
                                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnNormalColourHeader)
                                                    surface.DrawTexturedRect(0, 0, 270, 35)

                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                    surface.DrawTexturedRect(0, 33, 270, 2)
                                                end

                                                surface.SetDrawColor(gtnDefaultColourMenu)
                                                surface.SetMaterial(GTN_ICON_HELP)
                                                surface.DrawTexturedRect(2, 1, 32, 32)
                                                draw.NoTexture()
                                            end

                                            local gtnCreateGameRandomNumberHelpScrollPanel = vgui.Create("DScrollPanel", gtnCreateGameRandomNumberHelp)
                                                gtnCreateGameRandomNumberHelpScrollPanel:SetPos(15, 50)
                                                gtnCreateGameRandomNumberHelpScrollPanel:SetSize(243, 175)

                                                local gtnCreateGameRandomNumberHelpText1Title = vgui.Create("DLabel", gtnCreateGameRandomNumberHelpScrollPanel)
                                                    gtnCreateGameRandomNumberHelpText1Title:SetSize(225, 30)
                                                    gtnCreateGameRandomNumberHelpText1Title:SetPos(0, 0)
                                                    gtnCreateGameRandomNumberHelpText1Title.Paint = function(s, w, h)
                                                        if gtnDarkModeIsActive == true then
                                                            gtnCreateGameRandomNumberHelpText1Title:SetColor(gtnDarkColourText)
                                                        else
                                                            gtnCreateGameRandomNumberHelpText1Title:SetColor(gtnNormalColourText)
                                                        end
                                                    end
                                                    gtnCreateGameRandomNumberHelpText1Title:SetText("Number range")
                                                    gtnCreateGameRandomNumberHelpText1Title:SetFont("gtnHelpFontBold")
                                                    gtnCreateGameRandomNumberHelpText1Title:SizeToContentsY()

                                                local gtnCreateGameRandomNumberHelpText1 = vgui.Create("DLabel", gtnCreateGameRandomNumberHelpScrollPanel)
                                                    gtnCreateGameRandomNumberHelpText1:SetSize(250, 30)
                                                    gtnCreateGameRandomNumberHelpText1:SetPos(0, 30)
                                                    gtnCreateGameRandomNumberHelpText1.Paint = function(s, w, h)
                                                        if gtnDarkModeIsActive == true then
                                                            gtnCreateGameRandomNumberHelpText1:SetColor(gtnDarkColourText)
                                                        else
                                                            gtnCreateGameRandomNumberHelpText1:SetColor(gtnNormalColourText)
                                                        end
                                                    end
                                                    gtnCreateGameRandomNumberHelpText1:SetText("During Guess the Number\ngames, people must\nguess a number between\none and the Number\nrange.\n\nThe numbers which\npeople have to guess\nare randomly calculated\nby the server, and their\nmargin is decided by the\nNumber range.")
                                                    gtnCreateGameRandomNumberHelpText1:SetFont("gtnHelpFont")
                                                    gtnCreateGameRandomNumberHelpText1:SizeToContentsY()

                                            local gtnExitCreateGameRandomNumberHelp = vgui.Create("DImageButton", gtnCreateGameRandomNumberHelp)
                                                gtnExitCreateGameRandomNumberHelp:SetSize(36, 36)
                                                gtnExitCreateGameRandomNumberHelp:SetText("")
                                                gtnExitCreateGameRandomNumberHelp:Center()
                                                gtnExitCreateGameRandomNumberHelp:SetPos(gtnExitCreateGameRandomNumberHelp:GetPos() - 47, 255)
                                                gtnExitCreateGameRandomNumberHelp.Paint = function(s, w, h)
                                                    if gtnDarkModeIsActive == true then
                                                        if gtnExitCreateGameRandomNumberHelp:IsHovered() == true then
                                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                                        else
                                                            surface.SetDrawColor(gtnDarkColourText)
                                                        end
                                                    else
                                                        if gtnExitCreateGameRandomNumberHelp:IsHovered() == true then
                                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                                        else
                                                            surface.SetDrawColor(gtnNormalColourText)
                                                        end
                                                    end
                                                    surface.SetMaterial(GTN_ICON_BACK)
                                                    surface.DrawTexturedRect(0, 0, 36, 36)
                                                    draw.NoTexture()
                                                end

                                            gtnExitCreateGameRandomNumberHelp.DoClick = function()
                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                gtnCreateGameRandomNumberHelp:Close()
                                                gtnIsCreateGameRandomNumberHelpOpen = false
                                            end

                                        local gtnCreateGameRandomNumberHelpTitle = vgui.Create("DLabel", gtnCreateGameRandomNumberHelp)
                                            gtnCreateGameRandomNumberHelpTitle:SetSize(200, 30)
                                            gtnCreateGameRandomNumberHelpTitle:SetPos(40, 4)
                                            gtnCreateGameRandomNumberHelpTitle:SetText("Help")
                                            gtnCreateGameRandomNumberHelpTitle:SetFont("gtnMenuFont")
                                            gtnCreateGameRandomNumberHelpTitle:SetColor(gtnDefaultColourMenu)
                                    else
                                        surface.PlaySound("resource/warning.wav")
                                        chat.AddText("[GTN] Please exit the window before opening another.")
                                    end
                                end]]

                            local gtnExitCreateGame = vgui.Create("DImageButton", gtnCreateGame)
                                gtnExitCreateGame:SetSize(36, 36)
                                gtnExitCreateGame:SetText("")
                                gtnExitCreateGame:Center()
                                gtnExitCreateGame:SetPos(gtnExitCreateGame:GetPos() - 53, 355)
                                gtnExitCreateGame.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        if gtnExitCreateGame:IsHovered() == true then
                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnDarkColourText)
                                        end
                                    else
                                        if gtnExitCreateGame:IsHovered() == true then
                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnNormalColourText)
                                        end
                                    end
                                    surface.SetMaterial(GTN_ICON_BACK)
                                    surface.DrawTexturedRect(0, 0, 36, 36)
                                    draw.NoTexture()
                                end

                                gtnExitCreateGame.DoClick = function()
                                    gtnMenu:SetVisible(true)
                                    surface.PlaySound("garrysmod/ui_click.wav")
                                    net.Start("gtnCheckPlayersRequired")
                                    net.SendToServer()
                                    gtnIsRewardMoney = false
                                    gtnIsRewardNothing = true
                                    gtnIsRewardWeapon = false
                                    gtnIsRewardPSPoints = false
                                    gtnIsRewardPS2Points = false
                                    gtnRandomNumberRange = 50
                                    gtnIsWeaponValueCorrect = false
                                    gtnIsMoneyValueCorrect = false
                                    gtnCreateGame:Close()
                                    gtnIsCreateGameOpen = false
                                end

                            gtnStartGame = vgui.Create("DImageButton", gtnCreateGame)
                                gtnStartGame:SetSize(36, 36)
                                gtnStartGame:SetText("")
                                gtnStartGame:Center()
                                gtnStartGame:SetPos(gtnStartGame:GetPos() + 53, 355)
                                gtnStartGame.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        if gtnStartGame:IsHovered() == true then
                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnDarkColourText)
                                        end
                                    else
                                        if gtnStartGame:IsHovered() == true then
                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnNormalColourText)
                                        end
                                    end
                                    surface.SetMaterial(GTN_ICON_PUBLISH)
                                    surface.DrawTexturedRect(0, 0, 36, 36)
                                    draw.NoTexture()
                                end

                                function gtnStartGame:OnMousePressed()
                                    net.Start("gtnIsActiveCheck")
                                    net.SendToServer()
                                    net.Receive("gtnReturnIsActiveCheck", function()
                                        gtnIsActive = net.ReadBool()
                                        if gtnIsActive == false then
                                            if gtnIsRewardMoney == true then
                                                if gtnIsRandomNumberRangeCorrect == true then
                                                    if gtnIsMoneyValueCorrect == true then
                                                        if isnumber(gtnRandomNumberRange) and isnumber(gtnMoneyReward) then
                                                            net.Start("gtnStartGameRequest")
                                                                net.WriteBool(gtnIsRewardMoney)
                                                                net.WriteBool(gtnIsRewardWeapon)
                                                                net.WriteBool(gtnIsRewardPSPoints)
                                                                net.WriteBool(gtnIsRewardPS2Points)
                                                                net.WriteInt(gtnMoneyReward, 32)
                                                                net.WriteInt(gtnRandomNumberRange, 32)
                                                            net.SendToServer()
                                                            net.Start("gtnSendEnableHintsIsActive") -- We need a separate network string for this due to unintended consequences from bools.
                                                                net.WriteBool(gtnEnableHintsIsActive)
                                                            net.SendToServer()
                                                            gtnCreateGame:Close()
                                                            gtnMenu:Close()
                                                            gtnIsCreateGameOpen = false
                                                        else
                                                            surface.PlaySound("resource/warning.wav")
                                                            chat.AddText("[GTN] Please specify all fields before starting a game.")
                                                        end
                                                    else
                                                        surface.PlaySound("resource/warning.wav")
                                                        gtnCreateGameMoneyTextEntry:RequestFocus()
                                                        chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                                    end
                                                else
                                                    surface.PlaySound("resource/warning.wav")
                                                    gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                                    chat.AddText("[GTN] The specified value must be between 1 and 9,000.")
                                                end
                                            end

                                            if gtnIsRewardNothing == true and gtnIsRandomNumberRangeCorrect == true and isnumber(gtnRandomNumberRange) then
                                                net.Start("gtnStartGameRequest")
                                                    net.WriteBool(gtnIsRewardMoney)
                                                    net.WriteBool(gtnIsRewardWeapon)
                                                    net.WriteBool(gtnIsRewardPSPoints)
                                                    net.WriteBool(gtnIsRewardPS2Points)
                                                    net.WriteInt(gtnRandomNumberRange, 32)
                                                net.SendToServer()
                                                net.Start("gtnSendEnableHintsIsActive") -- We need a separate network string for this due to unintended consequences from bools.
                                                    net.WriteBool(gtnEnableHintsIsActive)
                                                net.SendToServer()
                                                gtnCreateGame:Close()
                                                gtnMenu:Close()
                                                gtnIsCreateGameOpen = false
                                            elseif gtnIsRewardNothing == true and gtnIsRandomNumberRangeCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 9,000.")

                                            elseif gtnIsRewardWeapon == true and gtnIsWeaponValueCorrect == true and gtnIsRandomNumberRangeCorrect == true and isnumber(gtnRandomNumberRange) then
                                                net.Start("gtnStartGameRequest")
                                                    net.WriteBool(gtnIsRewardMoney)
                                                    net.WriteBool(gtnIsRewardWeapon)
                                                    net.WriteBool(gtnIsRewardPSPoints)
                                                    net.WriteBool(gtnIsRewardPS2Points)
                                                    net.WriteString(gtnWeaponReward)
                                                    net.WriteInt(gtnRandomNumberRange, 32)
                                                net.SendToServer()
                                                net.Start("gtnSendEnableHintsIsActive") -- We need a separate network string for this due to unintended consequences from bools.
                                                    net.WriteBool(gtnEnableHintsIsActive)
                                                net.SendToServer()
                                                gtnCreateGame:Close()
                                                gtnMenu:Close()
                                                gtnIsCreateGameOpen = false
                                            elseif gtnIsRewardWeapon == true and gtnIsWeaponValueCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGameWeaponTextEntry:RequestFocus()
                                                chat.AddText("[GTN] You must enter a valid weapon value.")
                                            elseif gtnIsRewardWeapon == true and gtnIsRandomNumberRangeCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 9,000.")

                                            elseif gtnIsRewardPSPoints == true and gtnIsRandomNumberRangeCorrect == true then
                                                if gtnIsPSPointsValueCorrect == true then
                                                    net.Start("gtnStartGameRequest")
                                                        net.WriteBool(gtnIsRewardMoney)
                                                        net.WriteBool(gtnIsRewardWeapon)
                                                        net.WriteBool(gtnIsRewardPSPoints)
                                                        net.WriteBool(gtnIsRewardPS2Points)
                                                        net.WriteInt(gtnPSPointsReward, 32)
                                                        net.WriteInt(gtnRandomNumberRange, 32)
                                                    net.SendToServer()
                                                    net.Start("gtnSendEnableHintsIsActive") -- We need a separate network string for this due to unintended consequences from bools.
                                                        net.WriteBool(gtnEnableHintsIsActive)
                                                    net.SendToServer()
                                                    gtnCreateGame:Close()
                                                    gtnMenu:Close()
                                                    gtnIsCreateGameOpen = false
                                                end
                                            elseif gtnIsRewardPSPoints == true and gtnIsPSPointsValueCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGamePSPointsTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                            elseif gtnIsRewardPSPoints == true and gtnIsRandomNumberRangeCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 9,000.")

                                            elseif gtnIsRewardPS2Points == true and gtnIsRandomNumberRangeCorrect == true then
                                                if gtnIsPS2PointsValueCorrect == true then
                                                    net.Start("gtnStartGameRequest")
                                                        net.WriteBool(gtnIsRewardMoney)
                                                        net.WriteBool(gtnIsRewardWeapon)
                                                        net.WriteBool(gtnIsRewardPSPoints)
                                                        net.WriteBool(gtnIsRewardPS2Points)
                                                        net.WriteInt(gtnPS2PointsReward, 32)
                                                        net.WriteInt(gtnRandomNumberRange, 32)
                                                    net.SendToServer()
                                                    net.Start("gtnSendEnableHintsIsActive") -- We need a separate network string for this due to unintended consequences from bools.
                                                        net.WriteBool(gtnEnableHintsIsActive)
                                                    net.SendToServer()
                                                    gtnCreateGame:Close()
                                                    gtnMenu:Close()
                                                    gtnIsCreateGameOpen = false
                                                end
                                            elseif gtnIsRewardPS2Points == true and gtnIsPS2PointsValueCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGamePS2PointsTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 4,000,000,000.")
                                            elseif gtnIsRewardPS2Points == true and gtnIsRandomNumberRangeCorrect == false then
                                                surface.PlaySound("resource/warning.wav")
                                                gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                                chat.AddText("[GTN] The specified value must be between 1 and 9,000.")
                                            end
                                        else
                                            surface.PlaySound("resource/warning.wav")
                                            gtnCreateGameRandomNumberTextEntry:RequestFocus()
                                            chat.AddText("[GTN] Please wait until the current game has finished.")
                                        end
                                    end)
                                end
                    else
                        surface.PlaySound("resource/warning.wav")
                        chat.AddText("[GTN] Please exit the window before opening another.")
                    end
                else
                    surface.PlaySound("common/wpn_denyselect.wav")
                    chat.AddText("[GTN] You must be in a whitelisted group to create a game.")
                end
            end

        local gtnHelpPageButton = vgui.Create("DButton", gtnMenu)
            gtnHelpPageButton:SetSize(170, 50)
            gtnHelpPageButton:Center()
            gtnHelpPageButton:SetFont("gtnMenuFont")
            gtnHelpPageButton:SetColor(gtnDefaultColourMenu)
            gtnHelpPageButton:SetText("Help page")
            gtnHelpPageButton:SetPos(gtnHelpPageButton:GetPos() + 90, 107)
            gtnHelpPageButton.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnHelpPageButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                else
                    if gtnHelpPageButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                end
            end

            function gtnHelpPageButton:OnMousePressed()
                gtnMenu:SetVisible(false)
                if gtnIsHelpPageOpen == false then
                    surface.PlaySound("garrysmod/ui_click.wav")
                    gtnHelpPage = vgui.Create("DFrame")
                        gtnIsHelpPageOpen = true
                        gtnHelpPage:SetSize(300, 400)
                        gtnHelpPage:Center()
                        gtnHelpPage:MakePopup()
                        gtnHelpPage:SetDraggable(false)
                        gtnHelpPage:ShowCloseButton(false)
                        gtnHelpPage:SetTitle("")
                        gtnHelpPage.Paint = function(s, w, h)
                            if gtnDarkModeIsActive == true then
                                draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                draw.NoTexture()
                                surface.SetDrawColor(gtnDarkColourHeader)
                                surface.DrawTexturedRect(0, 0, 300, 35)

                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                surface.DrawTexturedRect(0, 35, 300, 2)
                            else
                                draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                draw.NoTexture()
                                surface.SetDrawColor(gtnNormalColourHeader)
                                surface.DrawTexturedRect(0, 0, 300, 35)

                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                surface.DrawTexturedRect(0, 35, 300, 2)
                            end

                            surface.SetDrawColor(gtnDefaultColourMenu)
                            surface.SetMaterial(GTN_ICON_HELP)
                            surface.DrawTexturedRect(3, 2, 32, 32)
                            draw.NoTexture()
                        end

                        local gtnHelpPageTitle = vgui.Create("DLabel", gtnHelpPage)
                            gtnHelpPageTitle:SetSize(200, 30)
                            gtnHelpPageTitle:SetPos(40, 4)
                            gtnHelpPageTitle:SetText("Help page")
                            gtnHelpPageTitle:SetFont("gtnMenuFont")
                            gtnHelpPageTitle:SetColor(gtnDefaultColourMenu)

                        local gtnHelpPageScrollPanel = vgui.Create("DScrollPanel", gtnHelpPage)
                            gtnHelpPageScrollPanel:SetPos(15, 60)
                            gtnHelpPageScrollPanel:SetSize(270, 265)

                            local gtnHelpPageText1Title = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText1Title:SetSize(250, 30)
                                gtnHelpPageText1Title:SetPos(0, 0)
                                gtnHelpPageText1Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText1Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText1Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText1Title:SetText("Creating a game")
                                gtnHelpPageText1Title:SetFont("gtnHelpFontBold")
                                gtnHelpPageText1Title:SizeToContentsY()

                            local gtnHelpPageText1 = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText1:SetSize(250, 30)
                                gtnHelpPageText1:SetPos(0, 30)
                                gtnHelpPageText1.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText1:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText1:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText1:SetText("To be able to create a game\nyou must be part of a user\ngroup that is whitelisted\n('superadmin' and 'owner'\ngain access by default).\n\nWhen on the Main menu,\npress 'Enter' on the keyboard\nto gain easier access to the\nCreate game window.")
                                gtnHelpPageText1:SetFont("gtnHelpFont")
                                gtnHelpPageText1:SizeToContentsY()

                            local gtnHelpPageText2Title = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText2Title:SetSize(250, 30)
                                gtnHelpPageText2Title:SetPos(0, 250)
                                gtnHelpPageText2Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText2Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText2Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText2Title:SetText("Help buttons")
                                gtnHelpPageText2Title:SetFont("gtnHelpFontBold")
                                gtnHelpPageText2Title:SizeToContentsY()

                            local gtnHelpPageText2 = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText2:SetSize(250, 30)
                                gtnHelpPageText2:SetPos(0, 280)
                                gtnHelpPageText2.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText2:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText2:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText2:SetText("Don't understand what to\ndo? Help buttons have been\nplaced on the interface to\nprovide an explanation of\nwhat each feature does and\nhow to use it.")
                                gtnHelpPageText2:SetFont("gtnHelpFont")
                                gtnHelpPageText2:SizeToContentsY()

                            local gtnHelpPageText3Title = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText3Title:SetSize(250, 30)
                                gtnHelpPageText3Title:SetPos(0, 420)
                                gtnHelpPageText3Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText3Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText3Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText3Title:SetText("Cancelling a game")
                                gtnHelpPageText3Title:SetFont("gtnHelpFontBold")
                                gtnHelpPageText3Title:SizeToContentsY()

                            local gtnHelpPageText3 = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText3:SetSize(250, 30)
                                gtnHelpPageText3:SetPos(0, 450)
                                gtnHelpPageText3.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText3:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText3:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText3:SetText("To cancel an ongoing game,\nsimply open the chatbox,\ntype in the command\n!gtnstop and then send\nthe message.")
                                gtnHelpPageText3:SetFont("gtnHelpFont")
                                gtnHelpPageText3:SizeToContentsY()

                            local gtnHelpPageText4Title = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText4Title:SetSize(250, 30)
                                gtnHelpPageText4Title:SetPos(0, 570)
                                gtnHelpPageText4Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText4Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText4Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText4Title:SetText("Admin settings")
                                gtnHelpPageText4Title:SetFont("gtnHelpFontBold")
                                gtnHelpPageText4Title:SizeToContentsY()

                            local gtnHelpPageText4 = vgui.Create("DLabel", gtnHelpPageScrollPanel)
                                gtnHelpPageText4:SetSize(250, 30)
                                gtnHelpPageText4:SetPos(0, 600)
                                gtnHelpPageText4.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnHelpPageText4:SetColor(gtnDarkColourText)
                                    else
                                        gtnHelpPageText4:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnHelpPageText4:SetText("The Admin settings contain\nimportant configurations\nrelated to the game. These\nsettings are only viewable\nby Superadmins and Owners.\nTo view the Admin settings,\npress the Settings button on\nthe Main menu, and then\npress the Admin button at\nthe top of the window.")
                                gtnHelpPageText4:SetFont("gtnHelpFont")
                                gtnHelpPageText4:SizeToContentsY()

                        local gtnExitHelpPage = vgui.Create("DImageButton", gtnHelpPage)
                            gtnExitHelpPage:SetSize(36, 36)
                            gtnExitHelpPage:SetText("")
                            gtnExitHelpPage:Center()
                            gtnExitHelpPage:SetPos(gtnExitHelpPage:GetPos() - 53, 355)
                            gtnExitHelpPage.Paint = function(s, w, h)
                                if gtnDarkModeIsActive == true then
                                    if gtnExitHelpPage:IsHovered() == true then
                                        surface.SetDrawColor(gtnDarkColourTextHovered)
                                    else
                                        surface.SetDrawColor(gtnDarkColourText)
                                    end
                                else
                                    if gtnExitHelpPage:IsHovered() == true then
                                        surface.SetDrawColor(gtnNormalColourTextHovered)
                                    else
                                        surface.SetDrawColor(gtnNormalColourText)
                                    end
                                end
                                surface.SetMaterial(GTN_ICON_BACK)
                                surface.DrawTexturedRect(0, 0, 36, 36)
                                draw.NoTexture()
                            end

                            function gtnExitHelpPage:OnMousePressed()
                                gtnMenu:SetVisible(true)
                                surface.PlaySound("garrysmod/ui_click.wav")
                                gtnHelpPage:Close()
                                gtnIsHelpPageOpen = false
                            end
                else
                    surface.PlaySound("resource/warning.wav")
                    chat.AddText("[GTN] Please exit the window before opening another.")
                end
            end

            local gtnSettingsButton = vgui.Create("DButton", gtnMenu)
                gtnSettingsButton:SetSize(170, 50)
                gtnSettingsButton:Center()
                gtnSettingsButton:SetFont("gtnMenuFont")
                gtnSettingsButton:SetColor(gtnDefaultColourMenu)
                gtnSettingsButton:SetText("Settings")
                gtnSettingsButton:SetPos(gtnSettingsButton:GetPos() + 90, 164)
                gtnSettingsButton.Paint = function(s, w, h)

                    if gtnDarkModeIsActive == true then
                        if gtnSettingsButton:IsHovered() == true then
                            draw.NoTexture()
                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                            surface.DrawTexturedRect(0, 0, 170, 50)

                            surface.SetDrawColor(gtnDarkColourHeaderHovered)
                            surface.DrawTexturedRect(1, 1, 168, 48)
                        else
                            draw.NoTexture()
                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                            surface.DrawTexturedRect(0, 0, 170, 50)

                            surface.SetDrawColor(gtnDarkColourHeader)
                            surface.DrawTexturedRect(1, 1, 168, 48)
                        end
                    else
                        if gtnSettingsButton:IsHovered() == true then
                            draw.NoTexture()
                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                            surface.DrawTexturedRect(0, 0, 170, 50)

                            surface.SetDrawColor(gtnNormalColourHeaderHovered)
                            surface.DrawTexturedRect(1, 1, 168, 48)
                        else
                            draw.NoTexture()
                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                            surface.DrawTexturedRect(0, 0, 170, 50)

                            surface.SetDrawColor(gtnNormalColourHeader)
                            surface.DrawTexturedRect(1, 1, 168, 48)
                        end
                    end
                end

                function gtnSettingsButton:OnMousePressed()
                    gtnMenu:SetVisible(false)
                    if gtnIsSettingsOpen == false then
                        surface.PlaySound("garrysmod/ui_click.wav")
                        gtnSettings = vgui.Create("DFrame")
                            gtnIsSettingsOpen = true
                            gtnSettings:SetSize(300, 400)
                            gtnSettings:Center()
                            gtnSettings:MakePopup()
                            gtnSettings:SetDraggable(false)
                            gtnSettings:ShowCloseButton(false)
                            gtnSettings:SetTitle("")
                            gtnSettings.Paint = function(s, w, h)
                                if gtnDarkModeIsActive == true then
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnDarkColourHeader)
                                    surface.DrawTexturedRect(0, 0, 300, 35)

                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 300, 2)
                                else
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnNormalColourHeader)
                                    surface.DrawTexturedRect(0, 0, 300, 35)

                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 300, 2)
                                end

                                surface.SetDrawColor(gtnDefaultColourMenu)
                                surface.SetMaterial(GTN_ICON_SETTINGS)
                                surface.DrawTexturedRect(8, 8, 22, 22)
                                draw.NoTexture()
                            end

                            local gtnSettingsTitle = vgui.Create("DLabel", gtnSettings)
                                gtnSettingsTitle:SetSize(200, 30)
                                gtnSettingsTitle:SetPos(40, 4)
                                gtnSettingsTitle:SetText("Settings")
                                gtnSettingsTitle:SetFont("gtnMenuFont")
                                gtnSettingsTitle:SetColor(gtnDefaultColourMenu)

                            local gtnSettingsGUILabelBox = vgui.Create("DFrame", gtnSettings)
                                gtnSettingsGUILabelBox:SetSize(270, 35)
                                gtnSettingsGUILabelBox:Center()
                                gtnSettingsGUILabelBox:SetPos(15, 54)
                                gtnSettingsGUILabelBox:SetDraggable(false)
                                gtnSettingsGUILabelBox:ShowCloseButton(false)
                                gtnSettingsGUILabelBox:SetTitle("")
                                gtnSettingsGUILabelBox.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnDarkColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    else
                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnNormalColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    end
                                end

                            local gtnSettingsGUILabel = vgui.Create("DLabel", gtnSettingsGUILabelBox)
                                gtnSettingsGUILabel:SetPos(8, 2)
                                gtnSettingsGUILabel:SetSize(180, 30)
                                gtnSettingsGUILabel:SetText("GUI options")
                                gtnSettingsGUILabel:SetFont("gtnMenuFont")
                                gtnSettingsGUILabel:SetColor(gtnDefaultColourMenu)

                            local gtnExitSettings = vgui.Create("DImageButton", gtnSettings)
                                gtnExitSettings:SetSize(36, 36)
                                gtnExitSettings:SetText("")
                                gtnExitSettings:Center()
                                gtnExitSettings:SetPos(gtnExitSettings:GetPos() - 53, 355)
                                gtnExitSettings.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        if gtnExitSettings:IsHovered() == true then
                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnDarkColourText)
                                        end
                                    else
                                        if gtnExitSettings:IsHovered() == true then
                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnNormalColourText)
                                        end
                                    end
                                    surface.SetMaterial(GTN_ICON_BACK)
                                    surface.DrawTexturedRect(0, 0, 36, 36)
                                end

                                local gtnSettingsDarkMode = vgui.Create("DCheckBoxLabel", gtnSettings)
                                    gtnSettingsDarkMode:SetParent(gtnSettings)
                                    gtnSettingsDarkMode:Center()
                                    gtnSettingsDarkMode:SetPos(17, 110)
                                    gtnSettingsDarkMode:SetFont("gtnMenuFontSmall")
                                    gtnSettingsDarkMode:SetText("Dark Mode")
                                    gtnSettingsDarkMode.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnSettingsDarkMode:SetTextColor(gtnDarkColourText)
                                        else
                                            gtnSettingsDarkMode:SetTextColor(gtnNormalColourText)
                                        end
                                    end

                                    gtnSettingsDarkMode:SetValue(gtnDarkModeSavedValue)

                                    function gtnSettingsDarkMode:OnChange(bVal)
                                        if bVal == true then
                                            surface.PlaySound("garrysmod/ui_click.wav")
                                            chat.AddText("[GTN] Dark Mode set to enabled.")
                                            gtnDarkModeIsActive = true
                                            file.Write("gtn/gtn_darkmode.txt", tostring(gtnDarkModeIsActive))
                                            gtnDarkModeSavedValue = tobool(file.Read("gtn/gtn_darkmode.txt", "DATA"))
                                        elseif bVal == false then
                                            surface.PlaySound("garrysmod/ui_click.wav")
                                            chat.AddText("[GTN] Dark Mode set to disabled.")
                                            gtnDarkModeIsActive = false
                                            file.Write("gtn/gtn_darkmode.txt", tostring(gtnDarkModeIsActive))
                                            gtnDarkModeSavedValue = tobool(file.Read("gtn/gtn_darkmode.txt", "DATA"))
                                        end
                                    end

                            local gtnSettingsAudioLabelBox = vgui.Create("DFrame", gtnSettings)
                                gtnSettingsAudioLabelBox:SetSize(270, 35)
                                gtnSettingsAudioLabelBox:Center()
                                gtnSettingsAudioLabelBox:SetPos(15, 154)
                                gtnSettingsAudioLabelBox:SetDraggable(false)
                                gtnSettingsAudioLabelBox:ShowCloseButton(false)
                                gtnSettingsAudioLabelBox:SetTitle("")
                                gtnSettingsAudioLabelBox.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnDarkColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    else
                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                        surface.DrawOutlinedRect(0, 0, 270, 35)

                                        draw.NoTexture()
                                        surface.SetDrawColor(gtnNormalColourHeader)
                                        surface.DrawTexturedRect(1, 1, 268, 33)
                                    end
                                end

                            local gtnSettingsAudioLabel = vgui.Create("DLabel", gtnSettingsAudioLabelBox)
                                gtnSettingsAudioLabel:SetPos(8, 2)
                                gtnSettingsAudioLabel:SetSize(180, 30)
                                gtnSettingsAudioLabel:SetText("Audio options")
                                gtnSettingsAudioLabel:SetFont("gtnMenuFont")
                                gtnSettingsAudioLabel:SetColor(gtnDefaultColourMenu)

                                local gtnSettingsDisableSound = vgui.Create("DCheckBoxLabel", gtnSettings)
                                    gtnSettingsDisableSound:SetParent(gtnSettings)
                                    gtnSettingsDisableSound:Center()
                                    gtnSettingsDisableSound:SetPos(17, 210)
                                    gtnSettingsDisableSound:SetFont("gtnMenuFontSmall")
                                    gtnSettingsDisableSound:SetText("Disable Sound")
                                    gtnSettingsDisableSound.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnSettingsDisableSound:SetTextColor(gtnDarkColourText)
                                        else
                                            gtnSettingsDisableSound:SetTextColor(gtnNormalColourText)
                                        end
                                    end

                                    gtnSettingsDisableSound:SetValue(gtnDisableSoundSavedValue)

                                    function gtnSettingsDisableSound:OnChange(bVal)
                                        if bVal == true then
                                            surface.PlaySound("garrysmod/ui_click.wav")
                                            chat.AddText("[GTN] Disable Sound set to enabled.")
                                            gtnDisableSoundIsActive = true
                                            file.Write("gtn/gtn_disablesound.txt", tostring(gtnDisableSoundIsActive))
                                            gtnDisableSoundSavedValue = tobool(file.Read("gtn/gtn_disablesound.txt", "DATA"))
                                        elseif bVal == false then
                                            surface.PlaySound("garrysmod/ui_click.wav")
                                            chat.AddText("[GTN] Disable Sound set to disabled.")
                                            gtnDisableSoundIsActive = false
                                            file.Write("gtn/gtn_disablesound.txt", tostring(gtnDisableSoundIsActive))
                                            gtnDisableSoundSavedValue = tobool(file.Read("gtn/gtn_disablesound.txt", "DATA"))
                                        end
                                    end

                                if gtnUserOwnerAccess == true then
                                    net.Start("gtnCheckPlayersRequired")
                                    net.SendToServer()
                                    local gtnAdminSettingsButton = vgui.Create("DImageButton", gtnSettings)
                                        gtnAdminSettingsButton:SetSize(100, 22)
                                        gtnAdminSettingsButton:SetFont("gtnMenuFontSmall")
                                        gtnAdminSettingsButton:SetText("Admin")
                                        gtnAdminSettingsButton:SetTextColor(gtnDefaultColourMenu)
                                        gtnAdminSettingsButton:Center()
                                        gtnAdminSettingsButton:SetPos(gtnAdminSettingsButton:GetPos() + 85, 14)
                                        gtnAdminSettingsButton.Paint = function(s, w, h)
                                            if gtnDarkModeIsActive == true then
                                                if gtnAdminSettingsButton:IsHovered() == true then
                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnDarkColourHeaderHovered)
                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                else
                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnDarkColourHeaderDarker)
                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                end
                                            else
                                                if gtnAdminSettingsButton:IsHovered() == true then
                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnNormalColourHeaderHovered)
                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                else
                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                    draw.NoTexture()
                                                    surface.SetDrawColor(gtnNormalColourHeaderDarker)
                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                end
                                            end
                                            surface.SetDrawColor(255, 255, 255)
                                            surface.SetMaterial(ICON16_USER_SUIT)
                                            surface.DrawTexturedRect(4, 4, 16, 16)
                                        end

                                        function gtnAdminSettingsButton:OnMousePressed()
                                            if gtnIsAdminSettingsOpen == false then
                                                net.Start("gtnCheckPermissionsTable")
                                                net.SendToServer()
                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                gtnAdminSettings = vgui.Create("DFrame")
                                                    gtnIsAdminSettingsOpen = true
                                                    gtnAdminSettings:SetSize(300, 400)
                                                    gtnAdminSettings:Center()
                                                    gtnAdminSettings:MakePopup()
                                                    gtnAdminSettings:SetDraggable(false)
                                                    gtnAdminSettings:ShowCloseButton(false)
                                                    gtnAdminSettings:SetTitle("")
                                                    gtnAdminSettings.Paint = function(s, w, h)
                                                        if gtnDarkModeIsActive == true then
                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                            draw.NoTexture()
                                                            surface.SetDrawColor(gtnDarkColourHeader)
                                                            surface.DrawTexturedRect(0, 0, 300, 35)

                                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                            surface.DrawTexturedRect(0, 35, 300, 2)
                                                        else
                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                            draw.NoTexture()
                                                            surface.SetDrawColor(gtnNormalColourHeader)
                                                            surface.DrawTexturedRect(0, 0, 300, 35)

                                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                            surface.DrawTexturedRect(0, 35, 300, 2)
                                                        end

                                                        surface.SetDrawColor(gtnDefaultColourMenu)
                                                        surface.SetMaterial(GTN_ICON_BUILD)
                                                        surface.DrawTexturedRect(9, 9, 20, 20)
                                                        draw.NoTexture()
                                                    end

                                                    local gtnAdminSettingsTitle = vgui.Create("DLabel", gtnAdminSettings)
                                                        gtnAdminSettingsTitle:SetSize(200, 30)
                                                        gtnAdminSettingsTitle:SetPos(40, 4)
                                                        gtnAdminSettingsTitle:SetText("Admin settings (1/2)")
                                                        gtnAdminSettingsTitle:SetFont("gtnMenuFont")
                                                        gtnAdminSettingsTitle:SetColor(gtnDefaultColourMenu)

                                                    local gtnAdminSettingsPlayersRequiredLabelBox = vgui.Create("DFrame", gtnAdminSettings)
                                                        gtnAdminSettingsPlayersRequiredLabelBox:SetSize(270, 35)
                                                        gtnAdminSettingsPlayersRequiredLabelBox:Center()
                                                        gtnAdminSettingsPlayersRequiredLabelBox:SetPos(15, 54)
                                                        gtnAdminSettingsPlayersRequiredLabelBox:SetDraggable(false)
                                                        gtnAdminSettingsPlayersRequiredLabelBox:ShowCloseButton(false)
                                                        gtnAdminSettingsPlayersRequiredLabelBox:SetTitle("")
                                                        gtnAdminSettingsPlayersRequiredLabelBox.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                draw.NoTexture()
                                                                surface.SetDrawColor(gtnDarkColourHeader)
                                                                surface.DrawTexturedRect(1, 1, 268, 33)
                                                            else
                                                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                draw.NoTexture()
                                                                surface.SetDrawColor(gtnNormalColourHeader)
                                                                surface.DrawTexturedRect(1, 1, 268, 33)
                                                            end
                                                        end

                                                    local gtnAdminSettingsPlayersRequiredLabel = vgui.Create("DLabel", gtnAdminSettingsPlayersRequiredLabelBox)
                                                        gtnAdminSettingsPlayersRequiredLabel:SetPos(8, 2)
                                                        gtnAdminSettingsPlayersRequiredLabel:SetSize(180, 30)
                                                        gtnAdminSettingsPlayersRequiredLabel:SetText("Players required")
                                                        gtnAdminSettingsPlayersRequiredLabel:SetFont("gtnMenuFont")
                                                        gtnAdminSettingsPlayersRequiredLabel:SetColor(gtnDefaultColourMenu)

                                                    gtnAdminSettingsPlayersRequiredTextEntry = vgui.Create("DTextEntry", gtnAdminSettings)
                                                        gtnAdminSettingsPlayersRequiredTextEntry:SetPos(17, 110)
                                                        gtnAdminSettingsPlayersRequiredTextEntry:SetSize(100, 20)
                                                        gtnAdminSettingsPlayersRequiredTextEntry:SetText(gtnServerDataPlayersRequired)
                                                        gtnAdminSettingsPlayersRequiredTextEntry:SetUpdateOnType(true)
                                                        gtnAdminSettingsPlayersRequiredTextEntry.OnEnter = function(self)
                                                            local gtnEnteredPlayersRequired = tonumber(self:GetValue())
                                                            if isnumber(gtnEnteredPlayersRequired) and gtnEnteredPlayersRequired >= 0 and gtnEnteredPlayersRequired <= 255 then
                                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                                gtnPlayersRequired = gtnEnteredPlayersRequired
                                                                net.Start("gtnSendPlayersRequired")
                                                                    net.WriteInt(gtnPlayersRequired, 8)
                                                                net.SendToServer()
                                                            else
                                                                surface.PlaySound("resource/warning.wav")
                                                                gtnAdminSettingsPlayersRequiredTextEntry:RequestFocus()
                                                                chat.AddText("[GTN] You must enter a number between 0 and 255.")
                                                            end
                                                        end

                                                    gtnAdminSettingsPlayersRequiredHelpButton = vgui.Create("DImageButton", gtnAdminSettings)
                                                        gtnAdminSettingsPlayersRequiredHelpButton:SetSize(36, 36)
                                                        gtnAdminSettingsPlayersRequiredHelpButton:SetText("")
                                                        gtnAdminSettingsPlayersRequiredHelpButton:Center()
                                                        gtnAdminSettingsPlayersRequiredHelpButton:RequestFocus()
                                                        gtnAdminSettingsPlayersRequiredHelpButton:SetVisible(true)
                                                        gtnAdminSettingsPlayersRequiredHelpButton:SetPos(gtnAdminSettingsPlayersRequiredHelpButton:GetPos(), 104)
                                                        gtnAdminSettingsPlayersRequiredHelpButton:SetTooltip("Players required\n\nThe required amount of\nplayers connected to the\nserver before someone\nis able to start a Guess\nthe Number game.\n\nThis requires you to enter\na number value and then\npress 'Enter' on the\nkeyboard to save.")
                                                        gtnAdminSettingsPlayersRequiredHelpButton.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                if gtnAdminSettingsPlayersRequiredHelpButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnDarkColourText)
                                                                end
                                                            else
                                                                if gtnAdminSettingsPlayersRequiredHelpButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnNormalColourText)
                                                                end
                                                            end
                                                            surface.SetMaterial(GTN_ICON_HELP)
                                                            surface.DrawTexturedRect(0, 0, 32, 32)
                                                            draw.NoTexture()
                                                        end

                                                        --[[gtnAdminSettingsPlayersRequiredHelpButton.DoClick = function() -- Commented because we use Tooltips now.
                                                            if gtnIsAdminSettingsPlayersRequiredHelpOpen == false then
                                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                                gtnAdminSettingsPlayersRequiredHelp = vgui.Create("DFrame")
                                                                    gtnAdminSettingsPlayersRequiredHelp:SetSize(270, 300)
                                                                    gtnIsAdminSettingsPlayersRequiredHelpOpen = true
                                                                    gtnAdminSettingsPlayersRequiredHelp:Center()
                                                                    gtnAdminSettingsPlayersRequiredHelp:SetPos(gtnAdminSettingsPlayersRequiredHelp:GetPos() + 150, 135)
                                                                    gtnAdminSettingsPlayersRequiredHelp:MakePopup()
                                                                    gtnAdminSettingsPlayersRequiredHelp:SetDraggable(true)
                                                                    gtnAdminSettingsPlayersRequiredHelp:ShowCloseButton(false)
                                                                    gtnAdminSettingsPlayersRequiredHelp:SetTitle("")
                                                                    gtnAdminSettingsPlayersRequiredHelp:RequestFocus()
                                                                    gtnAdminSettingsPlayersRequiredHelp.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnDarkColourHeader)
                                                                        surface.DrawTexturedRect(0, 0, 270, 35)

                                                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 33, 270, 2)
                                                                        else
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnNormalColourHeader)
                                                                            surface.DrawTexturedRect(0, 0, 270, 35)

                                                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 33, 270, 2)
                                                                        end

                                                                        surface.SetDrawColor(gtnDefaultColourMenu)
                                                                        surface.SetMaterial(GTN_ICON_HELP)
                                                                        surface.DrawTexturedRect(2, 1, 32, 32)
                                                                        draw.NoTexture()
                                                                    end

                                                                    local gtnAdminSettingsPlayersRequiredHelpScrollPanel = vgui.Create("DScrollPanel", gtnAdminSettingsPlayersRequiredHelp)
                                                                        gtnAdminSettingsPlayersRequiredHelpScrollPanel:SetPos(15, 50)
                                                                        gtnAdminSettingsPlayersRequiredHelpScrollPanel:SetSize(243, 175)

                                                                        local gtnAdminSettingsPlayersRequiredHelpText1Title = vgui.Create("DLabel", gtnAdminSettingsPlayersRequiredHelpScrollPanel)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title:SetSize(250, 30)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title:SetPos(0, 0)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    gtnAdminSettingsPlayersRequiredHelpText1Title:SetColor(gtnDarkColourText)
                                                                                else
                                                                                    gtnAdminSettingsPlayersRequiredHelpText1Title:SetColor(gtnNormalColourText)
                                                                                end
                                                                            end
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title:SetText("Players required")
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title:SetFont("gtnHelpFontBold")
                                                                            gtnAdminSettingsPlayersRequiredHelpText1Title:SizeToContentsY()

                                                                        local gtnAdminSettingsPlayersRequiredHelpText1 = vgui.Create("DLabel", gtnAdminSettingsPlayersRequiredHelpScrollPanel)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1:SetSize(225, 30)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1:SetPos(0, 30)
                                                                            gtnAdminSettingsPlayersRequiredHelpText1.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    gtnAdminSettingsPlayersRequiredHelpText1:SetColor(gtnDarkColourText)
                                                                                else
                                                                                    gtnAdminSettingsPlayersRequiredHelpText1:SetColor(gtnNormalColourText)
                                                                                end
                                                                            end
                                                                            gtnAdminSettingsPlayersRequiredHelpText1:SetText("The required amount of\nplayers connected to the\nserver before someone\nis able to start a Guess\nthe Number game.\n\nThis requires you to enter\na number value and then\npress 'Enter' on the\nkeyboard to save.")
                                                                            gtnAdminSettingsPlayersRequiredHelpText1:SetFont("gtnHelpFont")
                                                                            gtnAdminSettingsPlayersRequiredHelpText1:SizeToContentsY()

                                                                        local gtnExitAdminSettingsPlayersRequiredHelp = vgui.Create("DImageButton", gtnAdminSettingsPlayersRequiredHelp)
                                                                            gtnExitAdminSettingsPlayersRequiredHelp:SetSize(36, 36)
                                                                            gtnExitAdminSettingsPlayersRequiredHelp:SetText("")
                                                                            gtnExitAdminSettingsPlayersRequiredHelp:Center()
                                                                            gtnExitAdminSettingsPlayersRequiredHelp:SetPos(gtnExitAdminSettingsPlayersRequiredHelp:GetPos() - 47, 255)
                                                                            gtnExitAdminSettingsPlayersRequiredHelp.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    if gtnExitAdminSettingsPlayersRequiredHelp:IsHovered() == true then
                                                                                        surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                                    else
                                                                                        surface.SetDrawColor(gtnDarkColourText)
                                                                                    end
                                                                                else
                                                                                    if gtnExitAdminSettingsPlayersRequiredHelp:IsHovered() == true then
                                                                                        surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                                    else
                                                                                        surface.SetDrawColor(gtnNormalColourText)
                                                                                    end
                                                                                end
                                                                                surface.SetMaterial(GTN_ICON_BACK)
                                                                                surface.DrawTexturedRect(0, 0, 36, 36)
                                                                                draw.NoTexture()
                                                                            end

                                                                        gtnExitAdminSettingsPlayersRequiredHelp.DoClick = function()
                                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                                            gtnAdminSettingsPlayersRequiredHelp:Close()
                                                                            gtnIsAdminSettingsPlayersRequiredHelpOpen = false
                                                                        end

                                                                        local gtnAdminSettingsPlayersRequiredHelpTitle = vgui.Create("DLabel", gtnAdminSettingsPlayersRequiredHelp)
                                                                            gtnAdminSettingsPlayersRequiredHelpTitle:SetSize(200, 30)
                                                                            gtnAdminSettingsPlayersRequiredHelpTitle:SetPos(40, 4)
                                                                            gtnAdminSettingsPlayersRequiredHelpTitle:SetText("Help")
                                                                            gtnAdminSettingsPlayersRequiredHelpTitle:SetFont("gtnMenuFont")
                                                                            gtnAdminSettingsPlayersRequiredHelpTitle:SetColor(gtnDefaultColourMenu)
                                                                else
                                                                    surface.PlaySound("resource/warning.wav")
                                                                    chat.AddText("[GTN] Please exit the window before opening another.")
                                                                end
                                                            end]]

                                                    local gtnAdminSettingsPermissionsLabelBox = vgui.Create("DFrame", gtnAdminSettings)
                                                        gtnAdminSettingsPermissionsLabelBox:SetSize(270, 35)
                                                        gtnAdminSettingsPermissionsLabelBox:Center()
                                                        gtnAdminSettingsPermissionsLabelBox:SetPos(15, 154)
                                                        gtnAdminSettingsPermissionsLabelBox:SetDraggable(false)
                                                        gtnAdminSettingsPermissionsLabelBox:ShowCloseButton(false)
                                                        gtnAdminSettingsPermissionsLabelBox:SetTitle("")
                                                        gtnAdminSettingsPermissionsLabelBox.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                draw.NoTexture()
                                                                surface.SetDrawColor(gtnDarkColourHeader)
                                                                surface.DrawTexturedRect(1, 1, 268, 33)
                                                            else
                                                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                draw.NoTexture()
                                                                surface.SetDrawColor(gtnNormalColourHeader)
                                                                surface.DrawTexturedRect(1, 1, 268, 33)
                                                            end
                                                        end

                                                    local gtnAdminSettingsPermissionsLabel = vgui.Create("DLabel", gtnAdminSettingsPermissionsLabelBox)
                                                        gtnAdminSettingsPermissionsLabel:SetPos(8, 2)
                                                        gtnAdminSettingsPermissionsLabel:SetSize(180, 30)
                                                        gtnAdminSettingsPermissionsLabel:SetText("Group whitelist")
                                                        gtnAdminSettingsPermissionsLabel:SetFont("gtnMenuFont")
                                                        gtnAdminSettingsPermissionsLabel:SetColor(gtnDefaultColourMenu)

                                                    local gtnAdminSettingsPermissionsTextEntry = vgui.Create("DTextEntry", gtnAdminSettings)
                                                        gtnAdminSettingsPermissionsTextEntry:SetPos(17, 210)
                                                        gtnAdminSettingsPermissionsTextEntry:SetSize(100, 20)
                                                        gtnAdminSettingsPermissionsTextEntry:RequestFocus()
                                                        gtnAdminSettingsPermissionsTextEntry:SetUpdateOnType(true)
                                                        gtnAdminSettingsPermissionsTextEntry.OnEnter = function(self)
                                                            if self:GetValue() ~= "" then
                                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                                local gtnEnteredGroup = self:GetValue()
                                                                net.Start("gtnSendEnteredGroup")
                                                                    net.WriteString(gtnEnteredGroup)
                                                                net.SendToServer()
                                                                gtnAdminSettingsPermissionsTextEntry:SetText("")
                                                                gtnAdminSettingsPermissionsTextEntry:RequestFocus()
                                                            else
                                                                surface.PlaySound("resource/warning.wav")
                                                                gtnAdminSettingsPermissionsTextEntry:RequestFocus()
                                                                chat.AddText("[GTN] You must enter a user group value.")
                                                            end
                                                        end

                                                    local gtnAdminSettingsWhitelistButton = vgui.Create("DImageButton", gtnAdminSettings)
                                                        gtnAdminSettingsWhitelistButton:SetSize(100, 22)
                                                        gtnAdminSettingsWhitelistButton:SetFont("gtnMenuFontSmall")
                                                        gtnAdminSettingsWhitelistButton:SetText("Whitelist")
                                                        gtnAdminSettingsWhitelistButton:SetTextColor(gtnDefaultColourMenu)
                                                        gtnAdminSettingsWhitelistButton:Center()
                                                        gtnAdminSettingsWhitelistButton:SetPos(gtnAdminSettingsWhitelistButton:GetPos() - 83, 250)
                                                        gtnAdminSettingsWhitelistButton.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                if gtnAdminSettingsWhitelistButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                                    draw.NoTexture()
                                                                    surface.SetDrawColor(gtnDarkColourHeaderHovered)
                                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                                else
                                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                                    draw.NoTexture()
                                                                    surface.SetDrawColor(gtnDarkColourHeader)
                                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                                end
                                                            else
                                                                if gtnAdminSettingsWhitelistButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                                    draw.NoTexture()
                                                                    surface.SetDrawColor(gtnNormalColourHeaderHovered)
                                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                                else
                                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                    surface.DrawOutlinedRect(0, 0, 100, 22)

                                                                    draw.NoTexture()
                                                                    surface.SetDrawColor(gtnNormalColourHeader)
                                                                    surface.DrawTexturedRect(1, 1, 98, 20)
                                                                end
                                                            end
                                                                surface.SetDrawColor(255, 255, 255)
                                                                surface.SetMaterial(ICON16_PAGE_WHITE)
                                                                surface.DrawTexturedRect(4, 3, 16, 16)
                                                        end

                                                    function gtnAdminSettingsWhitelistButton:OnMousePressed()
                                                        surface.PlaySound("garrysmod/ui_click.wav")
                                                        if gtnIsAdminSettingsWhitelistOpen == false then
                                                            net.Start("gtnCheckOwnerGroup")
                                                            net.SendToServer()
                                                            if gtnUserOwnerAccess == true then
                                                                net.Start("gtnCheckPermissionsTable")
                                                                net.SendToServer()
                                                                gtnAdminSettingsWhitelist = vgui.Create("DFrame")
                                                                    gtnIsAdminSettingsWhitelistOpen = true
                                                                    gtnAdminSettingsWhitelist:SetSize(300, 400)
                                                                    gtnAdminSettingsWhitelist:Center()
                                                                    gtnAdminSettingsWhitelist:MakePopup()
                                                                    gtnAdminSettingsWhitelist:SetDraggable(false)
                                                                    gtnAdminSettingsWhitelist:ShowCloseButton(false)
                                                                    gtnAdminSettingsWhitelist:SetTitle("")
                                                                    gtnAdminSettingsWhitelist.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnDarkColourHeader)
                                                                            surface.DrawTexturedRect(0, 0, 300, 35)

                                                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 35, 300, 2)
                                                                        else
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnNormalColourHeader)
                                                                            surface.DrawTexturedRect(0, 0, 300, 35)

                                                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 35, 300, 2)
                                                                        end

                                                                        surface.SetDrawColor(gtnDefaultColourMenu)
                                                                        surface.SetMaterial(GTN_ICON_LIST)
                                                                        surface.DrawTexturedRect(5, 4, 30, 30)
                                                                        draw.NoTexture()
                                                                    end

                                                                    local gtnAdminSettingsWhitelistTitle = vgui.Create("DLabel", gtnAdminSettingsWhitelist)
                                                                        gtnAdminSettingsWhitelistTitle:SetSize(200, 30)
                                                                        gtnAdminSettingsWhitelistTitle:SetPos(40, 4)
                                                                        gtnAdminSettingsWhitelistTitle:SetText("Whitelist")
                                                                        gtnAdminSettingsWhitelistTitle:SetFont("gtnMenuFont")
                                                                        gtnAdminSettingsWhitelistTitle:SetColor(gtnDefaultColourMenu)

                                                                local gtnAdminSettingsWhitelistScrollPanel = vgui.Create("DScrollPanel", gtnAdminSettingsWhitelist)
                                                                    gtnAdminSettingsWhitelistScrollPanel:SetPos(15, 85)
                                                                    gtnAdminSettingsWhitelistScrollPanel:SetSize(270, 200)

                                                                    local gtnPermissionsCount = 0
                                                                    for k, v in pairs(gtnPermissions) do
                                                                        local gtnAdminSettingsWhitelistGroups = vgui.Create("DLabel", gtnAdminSettingsWhitelistScrollPanel)
                                                                            gtnAdminSettingsWhitelistGroups.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    gtnAdminSettingsWhitelistGroups:SetTextColor(gtnDarkColourText)
                                                                                else
                                                                                    gtnAdminSettingsWhitelistGroups:SetTextColor(gtnNormalColourText)
                                                                                end
                                                                            end

                                                                        gtnPermissionsCount = gtnPermissionsCount + 15
                                                                        gtnAdminSettingsWhitelistGroups:SetSize(150, 15)
                                                                        gtnAdminSettingsWhitelistGroups:SetFont("gtnMenuFontSmall")
                                                                        gtnAdminSettingsWhitelistGroups:SetText(k)
                                                                        gtnAdminSettingsWhitelistGroups:SetPos(0, gtnPermissionsCount)
                                                                    end

                                                                    local gtnAdminSettingsWhitelistResetButton = vgui.Create("DImageButton", gtnAdminSettingsWhitelist)
                                                                        gtnAdminSettingsWhitelistResetButton:SetSize(130, 22)
                                                                        gtnAdminSettingsWhitelistResetButton:SetFont("gtnMenuFontSmall")
                                                                        gtnAdminSettingsWhitelistResetButton:SetText("Reset Groups")
                                                                        gtnAdminSettingsWhitelistResetButton:SetTextColor(gtnDefaultColourMenu)
                                                                        gtnAdminSettingsWhitelistResetButton:Center()
                                                                        --gtnAdminSettingsWhitelistResetButton:SetPos(gtnAdminSettingsWhitelistResetButton:GetPos() - 71, 275)
                                                                        gtnAdminSettingsWhitelistResetButton:SetPos(gtnAdminSettingsWhitelistResetButton:GetPos() - 71, 54)
                                                                        gtnAdminSettingsWhitelistResetButton.Paint = function(s, w, h)
                                                                            if gtnDarkModeIsActive == true then
                                                                                if gtnAdminSettingsWhitelistResetButton:IsHovered() == true then
                                                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                                    surface.DrawOutlinedRect(0, 0, 130, 22)

                                                                                    draw.NoTexture()
                                                                                    surface.SetDrawColor(gtnDarkColourHeaderHovered)
                                                                                    surface.DrawTexturedRect(1, 1, 128, 20)
                                                                                else
                                                                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                                    surface.DrawOutlinedRect(0, 0, 130, 22)

                                                                                    draw.NoTexture()
                                                                                    surface.SetDrawColor(gtnDarkColourHeader)
                                                                                    surface.DrawTexturedRect(1, 1, 128, 20)
                                                                                end
                                                                            else
                                                                                if gtnAdminSettingsWhitelistResetButton:IsHovered() == true then
                                                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                                    surface.DrawOutlinedRect(0, 0, 130, 22)

                                                                                    draw.NoTexture()
                                                                                    surface.SetDrawColor(gtnNormalColourHeaderHovered)
                                                                                    surface.DrawTexturedRect(1, 1, 128, 20)
                                                                                else
                                                                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                                    surface.DrawOutlinedRect(0, 0, 130, 22)

                                                                                    draw.NoTexture()
                                                                                    surface.SetDrawColor(gtnNormalColourHeader)
                                                                                    surface.DrawTexturedRect(1, 1, 128, 20)
                                                                                end
                                                                            end
                                                                            surface.SetDrawColor(255, 255, 255)
                                                                            surface.SetMaterial(ICON16_DATABASE_DELETE)
                                                                            surface.DrawTexturedRect(4, 3, 16, 16)
                                                                        end

                                                                        local gtnResetWhitelistCurTime = CurTime()
                                                                        local gtnResetWhitelistWaitTime = 0 -- We need a way to circumvent the wait time for the first whitelist reset.

                                                                        function gtnAdminSettingsWhitelistResetButton:OnMousePressed()
                                                                            if CurTime() >= gtnResetWhitelistCurTime + gtnResetWhitelistWaitTime then
                                                                                gtnResetWhitelistCurTime = CurTime()
                                                                                gtnResetWhitelistWaitTime = 5
                                                                                net.Start("gtnWhitelistReset")
                                                                                net.SendToServer()
                                                                            else
                                                                                surface.PlaySound("resource/warning.wav")
                                                                                chat.AddText("[GTN] You must wait "..gtnResetWhitelistWaitTime.." seconds before resetting again.")
                                                                            end
                                                                        end

                                                                    local gtnExitAdminSettingsWhitelist = vgui.Create("DImageButton", gtnAdminSettingsWhitelist)
                                                                        gtnExitAdminSettingsWhitelist:SetSize(36, 36)
                                                                        gtnExitAdminSettingsWhitelist:SetText("")
                                                                        gtnExitAdminSettingsWhitelist:Center()
                                                                        gtnExitAdminSettingsWhitelist:SetPos(gtnExitAdminSettingsWhitelist:GetPos() - 53, 355)
                                                                        gtnExitAdminSettingsWhitelist.Paint = function(s, w, h)
                                                                            if gtnDarkModeIsActive == true then
                                                                                if gtnExitAdminSettingsWhitelist:IsHovered() == true then
                                                                                    surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                                else
                                                                                    surface.SetDrawColor(gtnDarkColourText)
                                                                                end
                                                                            else
                                                                                if gtnExitAdminSettingsWhitelist:IsHovered() == true then
                                                                                    surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                                else
                                                                                    surface.SetDrawColor(gtnNormalColourText)
                                                                                end
                                                                            end
                                                                            surface.SetMaterial(GTN_ICON_BACK)
                                                                            surface.DrawTexturedRect(0, 0, 36, 36)
                                                                        end

                                                                        function gtnExitAdminSettingsWhitelist:OnMousePressed()
                                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                                            gtnAdminSettingsWhitelist:Close()
                                                                            gtnIsAdminSettingsWhitelistOpen = false
                                                                            gtnAdminSettingsPermissionsTextEntry:RequestFocus()
                                                                            gtnAdminSettingsPermissionsTextEntry:SetText("")
                                                                        end
                                                            end
                                                        else
                                                            surface.PlaySound("resource/warning.wav")
                                                            chat.AddText("[GTN] Please exit the window before opening another.")
                                                        end
                                                    end

                                                    gtnAdminSettingsWhitelistHelpButton = vgui.Create("DImageButton", gtnAdminSettings)
                                                        gtnAdminSettingsWhitelistHelpButton:SetSize(36, 36)
                                                        gtnAdminSettingsWhitelistHelpButton:SetText("")
                                                        gtnAdminSettingsWhitelistHelpButton:Center()
                                                        gtnAdminSettingsWhitelistHelpButton:RequestFocus()
                                                        gtnAdminSettingsWhitelistHelpButton:SetVisible(true)
                                                        gtnAdminSettingsWhitelistHelpButton:SetPos(gtnAdminSettingsWhitelistHelpButton:GetPos(), 204)
                                                        gtnAdminSettingsWhitelistHelpButton:SetTooltip("Group whitelist\n\nThe Group whitelist is a\nlist of user groups that\nare allowed to create a\ngame.\n\nYou can add user groups\nto the whitelist by entering\nthem in the entry bar and\nthen pressing 'Enter' on\nthe keyboard.\n\nThis does not grant the\nuser groups permission\nto view the Admin settings.\nThese are only viewable for\nSuperadmins and Owners.\n\nYou can view the currently\nwhitelisted groups at any\ntime by pressing the\nWhitelist button.\n\nSimply press the Reset\nGroups button to reset the\nwhitelist to its default state,\nshould it be required.")
                                                        gtnAdminSettingsWhitelistHelpButton.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                if gtnAdminSettingsWhitelistHelpButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnDarkColourText)
                                                                end
                                                            else
                                                                if gtnAdminSettingsWhitelistHelpButton:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnNormalColourText)
                                                                end
                                                            end
                                                            surface.SetMaterial(GTN_ICON_HELP)
                                                            surface.DrawTexturedRect(0, 0, 32, 32)
                                                            draw.NoTexture()
                                                        end

                                                        --[[gtnAdminSettingsWhitelistHelpButton.DoClick = function() -- Commented because we use Tooltips now.
                                                            if gtnIsAdminSettingsWhitelistHelpOpen == false then
                                                                surface.PlaySound("garrysmod/ui_click.wav")
                                                                gtnAdminSettingsWhitelistHelp = vgui.Create("DFrame")
                                                                    gtnAdminSettingsWhitelistHelp:SetSize(270, 300)
                                                                    gtnIsAdminSettingsWhitelistHelpOpen = true
                                                                    gtnAdminSettingsWhitelistHelp:Center()
                                                                    gtnAdminSettingsWhitelistHelp:SetPos(gtnAdminSettingsWhitelistHelp:GetPos() + 150, 135)
                                                                    gtnAdminSettingsWhitelistHelp:MakePopup()
                                                                    gtnAdminSettingsWhitelistHelp:SetDraggable(true)
                                                                    gtnAdminSettingsWhitelistHelp:ShowCloseButton(false)
                                                                    gtnAdminSettingsWhitelistHelp:SetTitle("")
                                                                    gtnAdminSettingsWhitelistHelp:RequestFocus()
                                                                    gtnAdminSettingsWhitelistHelp.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnDarkColourHeader)
                                                                        surface.DrawTexturedRect(0, 0, 270, 35)

                                                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 33, 270, 2)
                                                                        else
                                                                            draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnNormalColourHeader)
                                                                            surface.DrawTexturedRect(0, 0, 270, 35)

                                                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                            surface.DrawTexturedRect(0, 33, 270, 2)
                                                                        end

                                                                        surface.SetDrawColor(gtnDefaultColourMenu)
                                                                        surface.SetMaterial(GTN_ICON_HELP)
                                                                        surface.DrawTexturedRect(2, 1, 32, 32)
                                                                        draw.NoTexture()
                                                                    end

                                                                    local gtnAdminSettingsWhitelistHelpScrollPanel = vgui.Create("DScrollPanel", gtnAdminSettingsWhitelistHelp)
                                                                        gtnAdminSettingsWhitelistHelpScrollPanel:SetPos(15, 50)
                                                                        gtnAdminSettingsWhitelistHelpScrollPanel:SetSize(243, 175)

                                                                        local gtnAdminSettingsWhitelistHelpText1Title = vgui.Create("DLabel", gtnAdminSettingsWhitelistHelpScrollPanel)
                                                                            gtnAdminSettingsWhitelistHelpText1Title:SetSize(250, 30)
                                                                            gtnAdminSettingsWhitelistHelpText1Title:SetPos(0, 0)
                                                                            gtnAdminSettingsWhitelistHelpText1Title.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    gtnAdminSettingsWhitelistHelpText1Title:SetColor(gtnDarkColourText)
                                                                                else
                                                                                    gtnAdminSettingsWhitelistHelpText1Title:SetColor(gtnNormalColourText)
                                                                                end
                                                                            end
                                                                            gtnAdminSettingsWhitelistHelpText1Title:SetText("Group whitelist")
                                                                            gtnAdminSettingsWhitelistHelpText1Title:SetFont("gtnHelpFontBold")
                                                                            gtnAdminSettingsWhitelistHelpText1Title:SizeToContentsY()

                                                                        local gtnAdminSettingsWhitelistHelpText1 = vgui.Create("DLabel", gtnAdminSettingsWhitelistHelpScrollPanel)
                                                                            gtnAdminSettingsWhitelistHelpText1:SetSize(225, 30)
                                                                            gtnAdminSettingsWhitelistHelpText1:SetPos(0, 30)
                                                                            gtnAdminSettingsWhitelistHelpText1.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    gtnAdminSettingsWhitelistHelpText1:SetColor(gtnDarkColourText)
                                                                                else
                                                                                    gtnAdminSettingsWhitelistHelpText1:SetColor(gtnNormalColourText)
                                                                                end
                                                                            end
                                                                            gtnAdminSettingsWhitelistHelpText1:SetText("The Group whitelist is a\nlist of user groups that\nare allowed to create a\ngame.\n\nYou can add user groups\nto the whitelist by entering\nthem in the entry bar and\nthen pressing 'Enter' on\nthe keyboard.\n\nThis does not grant the\nuser groups permission\nto view the Admin settings.\nThese are only viewable for\nSuperadmins and Owners.\n\nYou can view the currently\nwhitelisted groups at any\ntime by pressing the\nWhitelist button.\n\nSimply press the Reset\nGroups button to reset the\nwhitelist to its default state,\nshould it be required.")
                                                                            gtnAdminSettingsWhitelistHelpText1:SetFont("gtnHelpFont")
                                                                            gtnAdminSettingsWhitelistHelpText1:SizeToContentsY()

                                                                        local gtnExitAdminSettingsWhitelistHelp = vgui.Create("DImageButton", gtnAdminSettingsWhitelistHelp)
                                                                            gtnExitAdminSettingsWhitelistHelp:SetSize(36, 36)
                                                                            gtnExitAdminSettingsWhitelistHelp:SetText("")
                                                                            gtnExitAdminSettingsWhitelistHelp:Center()
                                                                            gtnExitAdminSettingsWhitelistHelp:SetPos(gtnExitAdminSettingsWhitelistHelp:GetPos() - 47, 255)
                                                                            gtnExitAdminSettingsWhitelistHelp.Paint = function(s, w, h)
                                                                                if gtnDarkModeIsActive == true then
                                                                                    if gtnExitAdminSettingsWhitelistHelp:IsHovered() == true then
                                                                                        surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                                    else
                                                                                        surface.SetDrawColor(gtnDarkColourText)
                                                                                    end
                                                                                else
                                                                                    if gtnExitAdminSettingsWhitelistHelp:IsHovered() == true then
                                                                                        surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                                    else
                                                                                        surface.SetDrawColor(gtnNormalColourText)
                                                                                    end
                                                                                end
                                                                                surface.SetMaterial(GTN_ICON_BACK)
                                                                                surface.DrawTexturedRect(0, 0, 36, 36)
                                                                                draw.NoTexture()
                                                                            end

                                                                        gtnExitAdminSettingsWhitelistHelp.DoClick = function()
                                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                                            gtnAdminSettingsWhitelistHelp:Close()
                                                                            gtnIsAdminSettingsWhitelistHelpOpen = false
                                                                        end

                                                                        local gtnAdminSettingsWhitelistHelpTitle = vgui.Create("DLabel", gtnAdminSettingsWhitelistHelp)
                                                                            gtnAdminSettingsWhitelistHelpTitle:SetSize(200, 30)
                                                                            gtnAdminSettingsWhitelistHelpTitle:SetPos(40, 4)
                                                                            gtnAdminSettingsWhitelistHelpTitle:SetText("Help")
                                                                            gtnAdminSettingsWhitelistHelpTitle:SetFont("gtnMenuFont")
                                                                            gtnAdminSettingsWhitelistHelpTitle:SetColor(gtnDefaultColourMenu)
                                                                else
                                                                    surface.PlaySound("resource/warning.wav")
                                                                    chat.AddText("[GTN] Please exit the window before opening another.")
                                                                end
                                                            end]]

                                                    gtnAdminSettings2Button = vgui.Create("DImageButton", gtnAdminSettings)
                                                        gtnAdminSettings2Button:SetSize(36, 36)
                                                        gtnAdminSettings2Button:SetText("")
                                                        gtnAdminSettings2Button:Center()
                                                        gtnAdminSettings2Button:SetPos(gtnAdminSettings2Button:GetPos() + 53, 355)
                                                        gtnAdminSettings2Button.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                if gtnAdminSettings2Button:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnDarkColourText)
                                                                end
                                                            else
                                                                if gtnAdminSettings2Button:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnNormalColourText)
                                                                end
                                                            end
                                                            surface.SetMaterial(GTN_ICON_FORWARD)
                                                            surface.DrawTexturedRect(0, 0, 36, 36)
                                                            draw.NoTexture()
                                                        end

                                                        function gtnAdminSettings2Button:OnMousePressed()
                                                            net.Start("gtnCheckLeaderboard")
                                                            net.SendToServer()
                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                            local gtnAdminSettings2 = vgui.Create("DFrame")
                                                                gtnAdminSettings2:SetSize(300, 400)
                                                                gtnAdminSettings2:Center()
                                                                gtnAdminSettings2:MakePopup()
                                                                gtnAdminSettings2:SetDraggable(false)
                                                                gtnAdminSettings2:ShowCloseButton(false)
                                                                gtnAdminSettings2:SetTitle("")
                                                                gtnAdminSettings2.Paint = function(s, w, h)
                                                                    if gtnDarkModeIsActive == true then
                                                                        draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                                                        draw.NoTexture()
                                                                        surface.SetDrawColor(gtnDarkColourHeader)
                                                                        surface.DrawTexturedRect(0, 0, 300, 35)

                                                                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                        surface.DrawTexturedRect(0, 35, 300, 2)
                                                                    else
                                                                        draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                                                        draw.NoTexture()
                                                                        surface.SetDrawColor(gtnNormalColourHeader)
                                                                        surface.DrawTexturedRect(0, 0, 300, 35)

                                                                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                        surface.DrawTexturedRect(0, 35, 300, 2)
                                                                    end

                                                                    surface.SetDrawColor(gtnDefaultColourMenu)
                                                                    surface.SetMaterial(GTN_ICON_BUILD)
                                                                    surface.DrawTexturedRect(9, 9, 20, 20)
                                                                    draw.NoTexture()
                                                                end

                                                                local gtnAdminSettings2Title = vgui.Create("DLabel", gtnAdminSettings2)
                                                                    gtnAdminSettings2Title:SetSize(200, 30)
                                                                    gtnAdminSettings2Title:SetPos(40, 4)
                                                                    gtnAdminSettings2Title:SetText("Admin settings (2/2)")
                                                                    gtnAdminSettings2Title:SetFont("gtnMenuFont")
                                                                    gtnAdminSettings2Title:SetColor(gtnDefaultColourMenu)

                                                                local gtnAdminSettings2LeaderboardLabelBox = vgui.Create("DFrame", gtnAdminSettings2)
                                                                    gtnAdminSettings2LeaderboardLabelBox:SetSize(270, 35)
                                                                    gtnAdminSettings2LeaderboardLabelBox:Center()
                                                                    gtnAdminSettings2LeaderboardLabelBox:SetPos(15, 54)
                                                                    gtnAdminSettings2LeaderboardLabelBox:SetDraggable(false)
                                                                    gtnAdminSettings2LeaderboardLabelBox:ShowCloseButton(false)
                                                                    gtnAdminSettings2LeaderboardLabelBox:SetTitle("")
                                                                    gtnAdminSettings2LeaderboardLabelBox.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                            surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnDarkColourHeader)
                                                                            surface.DrawTexturedRect(1, 1, 268, 33)
                                                                        else
                                                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                            surface.DrawOutlinedRect(0, 0, 270, 35)

                                                                            draw.NoTexture()
                                                                            surface.SetDrawColor(gtnNormalColourHeader)
                                                                            surface.DrawTexturedRect(1, 1, 268, 33)
                                                                        end
                                                                    end

                                                                local gtnAdminSettings2LeaderboardLabel = vgui.Create("DLabel", gtnAdminSettings2LeaderboardLabelBox)
                                                                    gtnAdminSettings2LeaderboardLabel:SetPos(8, 2)
                                                                    gtnAdminSettings2LeaderboardLabel:SetSize(180, 30)
                                                                    gtnAdminSettings2LeaderboardLabel:SetText("Leaderboard")
                                                                    gtnAdminSettings2LeaderboardLabel:SetFont("gtnMenuFont")
                                                                    gtnAdminSettings2LeaderboardLabel:SetColor(gtnDefaultColourMenu)

                                                                local gtnAdminSettings2LeaderboardResetButton = vgui.Create("DImageButton", gtnAdminSettings2)
                                                                    gtnAdminSettings2LeaderboardResetButton:SetSize(110, 22)
                                                                    gtnAdminSettings2LeaderboardResetButton:SetFont("gtnMenuFontSmall")
                                                                    gtnAdminSettings2LeaderboardResetButton:SetText("Wipe Data")
                                                                    gtnAdminSettings2LeaderboardResetButton:SetTextColor(gtnDefaultColourMenu)
                                                                    gtnAdminSettings2LeaderboardResetButton:Center()
                                                                    gtnAdminSettings2LeaderboardResetButton:SetPos(gtnAdminSettings2LeaderboardResetButton:GetPos() - 78, 150)
                                                                    gtnAdminSettings2LeaderboardResetButton.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            if gtnAdminSettings2LeaderboardResetButton:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                                surface.DrawOutlinedRect(0, 0, 110, 22)

                                                                                draw.NoTexture()
                                                                                surface.SetDrawColor(gtnDarkColourHeaderHovered)
                                                                                surface.DrawTexturedRect(1, 1, 108, 20)
                                                                            else
                                                                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                                                                surface.DrawOutlinedRect(0, 0, 110, 22)

                                                                                draw.NoTexture()
                                                                                surface.SetDrawColor(gtnDarkColourHeader)
                                                                                surface.DrawTexturedRect(1, 1, 108, 20)
                                                                            end
                                                                        else
                                                                            if gtnAdminSettings2LeaderboardResetButton:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                                surface.DrawOutlinedRect(0, 0, 110, 22)

                                                                                draw.NoTexture()
                                                                                surface.SetDrawColor(gtnNormalColourHeaderHovered)
                                                                                surface.DrawTexturedRect(1, 1, 108, 20)
                                                                            else
                                                                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                                                                surface.DrawOutlinedRect(0, 0, 110, 22)

                                                                                draw.NoTexture()
                                                                                surface.SetDrawColor(gtnNormalColourHeader)
                                                                                surface.DrawTexturedRect(1, 1, 108, 20)
                                                                            end
                                                                        end
                                                                            surface.SetDrawColor(255, 255, 255)
                                                                            surface.SetMaterial(ICON16_DATABASE_DELETE)
                                                                            surface.DrawTexturedRect(4, 3, 16, 16)
                                                                    end

                                                                    local gtnResetLeaderboardCurTime = CurTime()
                                                                    local gtnResetLeaderboardWaitTime = 0 -- We need a way to circumvent the wait time for the first Leaderboard reset.

                                                                    function gtnAdminSettings2LeaderboardResetButton:OnMousePressed()
                                                                        if CurTime() >= gtnResetLeaderboardCurTime + gtnResetLeaderboardWaitTime then
                                                                            gtnResetLeaderboardCurTime = CurTime()
                                                                            gtnResetLeaderboardWaitTime = 5
                                                                            net.Start("gtnResetLeaderboard")
                                                                            net.SendToServer()
                                                                            surface.PlaySound("buttons/combine_button5.wav")
                                                                        else
                                                                            surface.PlaySound("resource/warning.wav")
                                                                            chat.AddText("[GTN] You must wait "..gtnResetLeaderboardWaitTime.." seconds before resetting again.")
                                                                        end
                                                                    end

                                                                local gtnSettingsDisableLeaderboard = vgui.Create("DCheckBoxLabel", gtnAdminSettings2)
                                                                    gtnSettingsDisableLeaderboard:SetParent(gtnAdminSettings2)
                                                                    gtnSettingsDisableLeaderboard:Center()
                                                                    gtnSettingsDisableLeaderboard:SetPos(17, 110)
                                                                    gtnSettingsDisableLeaderboard:SetFont("gtnMenuFontSmall")
                                                                    gtnSettingsDisableLeaderboard:SetText("Disable Leaderboard")
                                                                    gtnSettingsDisableLeaderboard.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            gtnSettingsDisableLeaderboard:SetTextColor(gtnDarkColourText)
                                                                        else
                                                                            gtnSettingsDisableLeaderboard:SetTextColor(gtnNormalColourText)
                                                                        end
                                                                    end

                                                                    gtnSettingsDisableLeaderboard:SetValue(gtnDisableLeaderboard)

                                                                    function gtnSettingsDisableLeaderboard:OnChange(bVal)
                                                                        if bVal == true then
                                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                                            local gtnDisableLeaderboardVal = true
                                                                            net.Start("gtnDisableLeaderboardVal")
                                                                                net.WriteBool(gtnDisableLeaderboardVal)
                                                                            net.SendToServer()
                                                                        elseif bVal == false then
                                                                            surface.PlaySound("garrysmod/ui_click.wav")
                                                                            local gtnDisableLeaderboardVal = false
                                                                            net.Start("gtnDisableLeaderboardVal")
                                                                                net.WriteBool(gtnDisableLeaderboardVal)
                                                                            net.SendToServer()
                                                                        end
                                                                    end

                                                                gtnAdminSettings2DisableLeaderboardHelpButton = vgui.Create("DImageButton", gtnAdminSettings2)
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:SetSize(36, 36)
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:SetText("")
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:Center()
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:RequestFocus()
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:SetVisible(true)
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:SetPos(gtnAdminSettings2DisableLeaderboardHelpButton:GetPos() + 40, 104)
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton:SetTooltip("Disable Leaderboard\n\nDisabling the Leaderboard\nstops the saving of player\ndata on the server and\nreduces some of the network\nactivity related to it.\n\nTry enabling this feature if\nyour server is having network\nor storage space issues.\n\nPlease note that doing so\nwill restrict access to the\nLeaderboard and !gtwins\ncommand.")
                                                                    gtnAdminSettings2DisableLeaderboardHelpButton.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            if gtnAdminSettings2DisableLeaderboardHelpButton:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                            else
                                                                                surface.SetDrawColor(gtnDarkColourText)
                                                                            end
                                                                        else
                                                                            if gtnAdminSettings2DisableLeaderboardHelpButton:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                            else
                                                                                surface.SetDrawColor(gtnNormalColourText)
                                                                            end
                                                                        end
                                                                        surface.SetMaterial(GTN_ICON_HELP)
                                                                        surface.DrawTexturedRect(0, 0, 32, 32)
                                                                        draw.NoTexture()
                                                                    end

                                                                local gtnExitAdminSettings2 = vgui.Create("DImageButton", gtnAdminSettings2)
                                                                    gtnExitAdminSettings2:SetSize(36, 36)
                                                                    gtnExitAdminSettings2:SetText("")
                                                                    gtnExitAdminSettings2:Center()
                                                                    gtnExitAdminSettings2:SetPos(gtnExitAdminSettings2:GetPos() - 53, 355)
                                                                    gtnExitAdminSettings2.Paint = function(s, w, h)
                                                                        if gtnDarkModeIsActive == true then
                                                                            if gtnExitAdminSettings2:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                            else
                                                                                surface.SetDrawColor(gtnDarkColourText)
                                                                            end
                                                                        else
                                                                            if gtnExitAdminSettings2:IsHovered() == true then
                                                                                surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                            else
                                                                                surface.SetDrawColor(gtnNormalColourText)
                                                                            end
                                                                        end
                                                                        surface.SetMaterial(GTN_ICON_BACK)
                                                                        surface.DrawTexturedRect(0, 0, 36, 36)
                                                                    end

                                                                    function gtnExitAdminSettings2:OnMousePressed()
                                                                        net.Start("gtnCheckLeaderboard")
                                                                        net.SendToServer()
                                                                        surface.PlaySound("garrysmod/ui_click.wav")
                                                                        gtnAdminSettings2:Close()
                                                                    end
                                                        end

                                                    local gtnExitAdminSettings = vgui.Create("DImageButton", gtnAdminSettings)
                                                        gtnExitAdminSettings:SetSize(36, 36)
                                                        gtnExitAdminSettings:SetText("")
                                                        gtnExitAdminSettings:Center()
                                                        gtnExitAdminSettings:SetPos(gtnExitAdminSettings:GetPos() - 53, 355)
                                                        gtnExitAdminSettings.Paint = function(s, w, h)
                                                            if gtnDarkModeIsActive == true then
                                                                if gtnExitAdminSettings:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnDarkColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnDarkColourText)
                                                                end
                                                            else
                                                                if gtnExitAdminSettings:IsHovered() == true then
                                                                    surface.SetDrawColor(gtnNormalColourTextHovered)
                                                                else
                                                                    surface.SetDrawColor(gtnNormalColourText)
                                                                end
                                                            end
                                                            surface.SetMaterial(GTN_ICON_BACK)
                                                            surface.DrawTexturedRect(0, 0, 36, 36)
                                                        end

                                                    function gtnExitAdminSettings:OnMousePressed()
                                                        net.Start("gtnCheckPlayersRequired")
                                                        net.SendToServer()
                                                        surface.PlaySound("garrysmod/ui_click.wav")
                                                        gtnAdminSettings:Close()
                                                        gtnIsAdminSettingsOpen = false
                                                    end
                                            else
                                                surface.PlaySound("resource/warning.wav")
                                                chat.AddText("[GTN] Please exit the window before opening another.")
                                            end
                                        end
                                end

                                function gtnExitSettings:OnMousePressed()
                                    gtnMenu:SetVisible(true)
                                    surface.PlaySound("garrysmod/ui_click.wav")
                                    gtnSettings:Close()
                                    gtnIsSettingsOpen = false
                                end
                    else
                        surface.PlaySound("resource/warning.wav")
                        chat.AddText("[GTN] Please exit the window before opening another.")
                    end
                end

        gtnNewsButton = vgui.Create("DButton", gtnMenu)
            gtnNewsButton:SetSize(170, 50)
            gtnNewsButton:Center()
            gtnNewsButton:SetFont("gtnMenuFont")
            gtnNewsButton:SetColor(gtnDefaultColourMenu)
            gtnNewsButton:SetText("News")
            gtnNewsButton:SetPos(gtnNewsButton:GetPos() - 90, 164)
            gtnNewsButton.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnNewsButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                else
                    if gtnNewsButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                end
            end

            function gtnNewsButton:OnMousePressed()
                surface.PlaySound("garrysmod/ui_click.wav")
                local gtnNews = vgui.Create("DFrame")
                    gtnNews:SetSize(450, 400)
                    gtnNews:SetTitle("News & updates")
                    gtnNews:SetDraggable(true)
                    gtnNews:MakePopup()
                    gtnNews:Center()

                    local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ News ]\n\nA leaderboard feature has been on the to-do list for a\nwhile now, but now it is finally released!\n\nPlease keep in mind that it's a new feature and that it\nmay contain bugs. In which case you may use the\nnewly added 'Report Bug' button on the Main menu. :)\n\nI have noticed that there is a lack of feedback\nand bug reports from subscribers. I hope to improve\nthis by making bug reports more accessible.\n\nI try my best to find all existing bugs and come up\nwith cool new ideas, but this task is not exclusive to\ndeveloper only. Know that you as a subscriber also\nget to have a say in how the addon develops.\n\nWith that being said, enjoy the new updates!"

                    local gtnNewsCredits = vgui.Create("DLabel", gtnNews)
                        gtnNewsCredits:SetPos(149, 340)
                        gtnNewsCredits:SetText("Guess the Number is an addon created by            .".."\nFor the latest updates please Subscribe to the official\n                                   .")
                        gtnNewsCredits:SizeToContents()

                        local gtnNewsAuthorLabel = vgui.Create("DLabelURL", gtnNews)
                            gtnNewsAuthorLabel:SetPos(354, 321)
                            gtnNewsAuthorLabel:SetSize(100, 50)
                            gtnNewsAuthorLabel:SetColor(Color(255, 255, 255, 255))
                            gtnNewsAuthorLabel:SetText("Author")
                            gtnNewsAuthorLabel:SetURL( "http://steamcommunity.com/profiles/76561198089349272" )

                        local gtnNewsWorkshopLabel = vgui.Create("DLabelURL", gtnNews)
                            gtnNewsWorkshopLabel:SetPos(149, 367)
                            gtnNewsWorkshopLabel:SetSize(100, 50)
                            gtnNewsWorkshopLabel:SetColor(Color(255, 255, 255, 255))
                            gtnNewsWorkshopLabel:SetText("Steam Workshop page")
                            gtnNewsWorkshopLabel:SetURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=1181687249" )
                            gtnNewsWorkshopLabel:SizeToContents()

                    local gtnNewsButtonScrollPanel = vgui.Create("DScrollPanel", gtnNews)
                        gtnNewsButtonScrollPanel:SetSize(137, 300)
                        gtnNewsButtonScrollPanel:SetPos(13, 32)

                        local gtnNewsButton5N = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton5N:SetText("27 Dec 2017 (N)")
                            gtnNewsButton5N:SetPos(0, 0)
                            gtnNewsButton5N:SetSize(122, 25)
                            gtnNewsButton5N.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ News ]\n\nA leaderboard feature has been on the to-do list for a\nwhile now, but now it is finally released!\n\nPlease keep in mind that it's a new feature and that it\nmay contain bugs. In which case you may use the\nnewly added 'Report Bug' button on the Main menu. :)\n\nI have noticed that there is a lack of feedback\nand bug reports from subscribers. I hope to improve\nthis by making bug reports more accessible.\n\nI try my best to find all existing bugs and come up\nwith cool new ideas, but this task is not exclusive to\ndeveloper only. Know that you as a subscriber also\nget to have a say in how the addon develops.\n\nWith that being said, enjoy the new updates!"
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(300, 274)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton5U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton5U:SetText("27 Dec 2017 (U)")
                            gtnNewsButton5U:SetPos(0, 30)
                            gtnNewsButton5U:SetSize(122, 25)
                            gtnNewsButton5U.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ Updates ]\n\n- Added Pointshop 2 support to Create game (test).\n- Replaced help button pop-ups with tooltips.\n- Added Leaderboard to Main menu.\n- Added Bug Report to Main menu.\n- Number range limit increased to 100,000 (from 9,000).\n- Added second page to Admin settings.\n- Added Disable Leaderboard to Admin settings.\n- Added Wipe Data to Admin settings.\n- Resetting own game wins is no longer possible.\n- Command timer reduced to 5 seconds (from 30).\n- All addon data is now stored in garrysmod/data/gtn.\n\n[ Bug fixes ]\n\n- Non-number inputs with !guess are disallowed.\n- Fixed a bug that caused wins to display multiple times\nin the chat when using !gtnwins."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(300, 274)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton4N = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton4N:SetText("26 Nov 2017 (N)")
                            gtnNewsButton4N:SetPos(0, 60)
                            gtnNewsButton4N:SetSize(122, 25)
                            gtnNewsButton4N.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "26 Nov 2017 - 3:21 AM\n\n[ News ]\n\nIn the short amount of time after Guess the Number\ngot published on the Steam Workshop and garrysmods,\nit has gained the attention of more than 800 unique\nvisitors and over 300 active Subscribers.\n\nI want to personally thank everyone who has taken\ntheir time to try out this new addon I've been working\non during my spare time.\n\nDon't hesitate to let me know if you encounter any\nissues or if you would like to suggest an idea or new\nfeatures to improve the usability of the addon."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(300, 208)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton4U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton4U:SetText("26 Nov 2017 (U)")
                            gtnNewsButton4U:SetPos(0, 90)
                            gtnNewsButton4U:SetSize(122, 25)
                            gtnNewsButton4U.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "26 Nov 2017 - 3:21 AM\n\n[ Updates ]\n\n- Number comparisons are now done server-side to\nprevent cheats.\n- Added an Enable Hints option to Create game.\n- Added Commands to Main menu.\n- Added News to Main menu."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(300, 118)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton3U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton3U:SetText("5 Nov 2017 (U)")
                            gtnNewsButton3U:SetPos(0, 120)
                            gtnNewsButton3U:SetSize(122, 25)
                            gtnNewsButton3U.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "5 Nov 2017 - 1:36 AM\n\n[ Updates ]\n\n- Added !gtnwins chat command.\n- Added !gtnreset chat command."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(295, 79)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton2U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton2U:SetText("29 Oct 2017 (U)")
                            gtnNewsButton2U:SetPos(0, 150)
                            gtnNewsButton2U:SetSize(122, 25)
                            gtnNewsButton2U.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "29 Oct 2017 - 1:01 AM\n\n[ Updates ]\n\n- Small optimizations."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(295, 65)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                        local gtnNewsButton1U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                            gtnNewsButton1U:SetText("28 Oct 2017 (U)")
                            gtnNewsButton1U:SetPos(0, 180)
                            gtnNewsButton1U:SetSize(122, 25)
                            gtnNewsButton1U.DoClick = function()
                                surface.PlaySound("garrysmod/ui_click.wav")
                                local gtnNewsText = "28 Oct 2017 - 2:48 AM\n\n[ Updates ]\n\n- Added a Disable Sound option to Settings."
                                gtnNewsTextPanelLabel:SetText(gtnNewsText)
                                gtnNewsTextPanelLabel:SetSize(295, 65)
                                gtnNewsTextPanel:SetSize(295, 300)
                            end

                    local gtnNewsTextScrollPanel = vgui.Create("DScrollPanel", gtnNews)
                        gtnNewsTextScrollPanel:SetSize(295, 300)
                        gtnNewsTextScrollPanel:SetPos(149, 32)

                    gtnNewsTextPanel = vgui.Create("DPanel", gtnNewsTextScrollPanel)
                        gtnNewsTextPanel:SetPos(0, 0)
                        gtnNewsTextPanel:SetSize(295, 300)

                        gtnNewsTextPanelLabel = vgui.Create("DLabel", gtnNewsTextPanel)
                            gtnNewsTextPanelLabel:SetPos(10, 10)
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SizeToContents()
                            gtnNewsTextPanelLabel:SetDark(1)
            end

        gtnCommandsButton = vgui.Create("DButton", gtnMenu)
            gtnCommandsButton:SetSize(170, 50)
            gtnCommandsButton:Center()
            gtnCommandsButton:SetFont("gtnMenuFont")
            gtnCommandsButton:SetColor(gtnDefaultColourMenu)
            gtnCommandsButton:SetText("Commands")
            gtnCommandsButton:SetPos(gtnCommandsButton:GetPos() - 90, 107)
            gtnCommandsButton.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnCommandsButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                else
                    if gtnCommandsButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                end
            end

            function gtnCommandsButton:OnMousePressed()
                gtnMenu:SetVisible(false)
                if gtnIsCommandsOpen == false then
                    surface.PlaySound("garrysmod/ui_click.wav")
                    gtnCommands = vgui.Create("DFrame")
                        gtnIsCommandsOpen = true
                        gtnCommands:SetSize(300, 400)
                        gtnCommands:Center()
                        gtnCommands:MakePopup()
                        gtnCommands:SetDraggable(false)
                        gtnCommands:ShowCloseButton(false)
                        gtnCommands:SetTitle("")
                        gtnCommands.Paint = function(s, w, h)
                            if gtnDarkModeIsActive == true then
                                draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                draw.NoTexture()
                                surface.SetDrawColor(gtnDarkColourHeader)
                                surface.DrawTexturedRect(0, 0, 300, 35)

                                surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                surface.DrawTexturedRect(0, 35, 300, 2)
                            else
                                draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                draw.NoTexture()
                                surface.SetDrawColor(gtnNormalColourHeader)
                                surface.DrawTexturedRect(0, 0, 300, 35)

                                surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                surface.DrawTexturedRect(0, 35, 300, 2)
                            end

                            surface.SetDrawColor(gtnDefaultColourMenu)
                            surface.SetMaterial(GTN_ICON_HELP)
                            surface.DrawTexturedRect(3, 2, 32, 32)
                            draw.NoTexture()
                        end

                        local gtnCommandsTitle = vgui.Create("DLabel", gtnCommands)
                            gtnCommandsTitle:SetSize(200, 30)
                            gtnCommandsTitle:SetPos(40, 4)
                            gtnCommandsTitle:SetText("Commands")
                            gtnCommandsTitle:SetFont("gtnMenuFont")
                            gtnCommandsTitle:SetColor(gtnDefaultColourMenu)

                        local gtnCommandsScrollPanel = vgui.Create("DScrollPanel", gtnCommands)
                            gtnCommandsScrollPanel:SetPos(15, 60)
                            gtnCommandsScrollPanel:SetSize(270, 265)

                            local gtnCommands1Title = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                gtnCommands1Title:SetSize(250, 30)
                                gtnCommands1Title:SetPos(0, 0)
                                gtnCommands1Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnCommands1Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnCommands1Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnCommands1Title:SetText("!gtnstop")
                                gtnCommands1Title:SetFont("gtnHelpFontBold")
                                gtnCommands1Title:SizeToContentsY()

                            local gtnCommandsText1 = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                gtnCommandsText1:SetSize(250, 30)
                                gtnCommandsText1:SetPos(0, 30)
                                gtnCommandsText1.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnCommandsText1:SetColor(gtnDarkColourText)
                                    else
                                        gtnCommandsText1:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnCommandsText1:SetText("Cancels an ongoing game.")
                                gtnCommandsText1:SetFont("gtnHelpFont")
                                gtnCommandsText1:SizeToContentsY()

                            local gtnCommands2Title = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                gtnCommands2Title:SetSize(250, 30)
                                gtnCommands2Title:SetPos(0, 70)
                                gtnCommands2Title.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnCommands2Title:SetColor(gtnDarkColourText)
                                    else
                                        gtnCommands2Title:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnCommands2Title:SetText("!gtnwins")
                                gtnCommands2Title:SetFont("gtnHelpFontBold")
                                gtnCommands2Title:SizeToContentsY()

                            local gtnCommandsText2 = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                gtnCommandsText2:SetSize(250, 30)
                                gtnCommandsText2:SetPos(0, 100)
                                gtnCommandsText2.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        gtnCommandsText2:SetColor(gtnDarkColourText)
                                    else
                                        gtnCommandsText2:SetColor(gtnNormalColourText)
                                    end
                                end
                                gtnCommandsText2:SetText("Displays your total amount\nof game wins to all players in\nthe chatbox.")
                                gtnCommandsText2:SetFont("gtnHelpFont")
                                gtnCommandsText2:SizeToContentsY()

                            --local gtnCommands3Title = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                --gtnCommands3Title:SetSize(250, 30)
                                --gtnCommands3Title:SetPos(0, 180)
                                --gtnCommands3Title.Paint = function(s, w, h)
                                    --if gtnDarkModeIsActive == true then
                                        --gtnCommands3Title:SetColor(gtnDarkColourText)
                                    --else
                                        --gtnCommands3Title:SetColor(gtnNormalColourText)
                                    --end
                                --end
                                --gtnCommands3Title:SetText("!gtnreset")
                                --gtnCommands3Title:SetFont("gtnHelpFontBold")
                                --gtnCommands3Title:SizeToContentsY()

                            --local gtnCommandsText3 = vgui.Create("DLabel", gtnCommandsScrollPanel)
                                --gtnCommandsText3:SetSize(250, 30)
                                --gtnCommandsText3:SetPos(0, 210)
                                --gtnCommandsText3.Paint = function(s, w, h)
                                    --if gtnDarkModeIsActive == true then
                                        --gtnCommandsText3:SetColor(gtnDarkColourText)
                                    --else
                                        --gtnCommandsText3:SetColor(gtnNormalColourText)
                                    --end
                                --end
                                --gtnCommandsText3:SetText("Resets your total amount of\ngame wins.")
                                --gtnCommandsText3:SetFont("gtnHelpFont")
                                --gtnCommandsText3:SizeToContentsY()

                        local gtnExitCommands = vgui.Create("DImageButton", gtnCommands)
                            gtnExitCommands:SetSize(36, 36)
                            gtnExitCommands:SetText("")
                            gtnExitCommands:Center()
                            gtnExitCommands:SetPos(gtnExitCommands:GetPos() - 53, 355)
                            gtnExitCommands.Paint = function(s, w, h)
                                if gtnDarkModeIsActive == true then
                                    if gtnExitCommands:IsHovered() == true then
                                        surface.SetDrawColor(gtnDarkColourTextHovered)
                                    else
                                        surface.SetDrawColor(gtnDarkColourText)
                                    end
                                else
                                    if gtnExitCommands:IsHovered() == true then
                                        surface.SetDrawColor(gtnNormalColourTextHovered)
                                    else
                                        surface.SetDrawColor(gtnNormalColourText)
                                    end
                                end
                                surface.SetMaterial(GTN_ICON_BACK)
                                surface.DrawTexturedRect(0, 0, 36, 36)
                                draw.NoTexture()
                            end

                            function gtnExitCommands:OnMousePressed()
                                gtnMenu:SetVisible(true)
                                surface.PlaySound("garrysmod/ui_click.wav")
                                gtnCommands:Close()
                                gtnIsCommandsOpen = false
                            end
                end
            end

        gtnLeaderboardButton = vgui.Create("DButton", gtnMenu)
            gtnLeaderboardButton:SetSize(170, 50)
            gtnLeaderboardButton:Center()
            gtnLeaderboardButton:SetFont("gtnMenuFont")
            gtnLeaderboardButton:SetColor(gtnDefaultColourMenu)
            gtnLeaderboardButton:SetText("Leaderboard")
            gtnLeaderboardButton:SetPos(gtnLeaderboardButton:GetPos() - 90, 50)
            gtnLeaderboardButton.Paint = function(s, w, h)
                if gtnDarkModeIsActive == true then
                    if gtnLeaderboardButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnDarkColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnDarkColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                else
                    if gtnLeaderboardButton:IsHovered() == true then
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeaderHovered)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    else
                        draw.NoTexture()
                        surface.SetDrawColor(gtnNormalColourHeaderShadow)
                        surface.DrawTexturedRect(0, 0, 170, 50)

                        surface.SetDrawColor(gtnNormalColourHeader)
                        surface.DrawTexturedRect(1, 1, 168, 48)
                    end
                end
            end

            function gtnLeaderboardButton:OnMousePressed()
                --chat.AddText("[GTN] This feature will be available in future updates.")
                --surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                if gtnDisableLeaderboard == false then
                    gtnMenu:SetVisible(false)
                    if gtnIsLeaderboardOpen == false then
                        surface.PlaySound("garrysmod/ui_click.wav")
                        gtnLeaderboard = vgui.Create("DFrame")
                            gtnIsLeaderboardOpen = true
                            gtnLeaderboard:SetSize(500, 400)
                            gtnLeaderboard:Center()
                            gtnLeaderboard:MakePopup()
                            gtnLeaderboard:SetDraggable(false)
                            gtnLeaderboard:ShowCloseButton(false)
                            gtnLeaderboard:SetTitle("")
                            gtnLeaderboard.Paint = function(s, w, h)
                                if gtnDarkModeIsActive == true then
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnDarkColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnDarkColourHeader)
                                    surface.DrawTexturedRect(0, 0, 500, 35)

                                    surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 500, 2)
                                else
                                    draw.RoundedBox(4, 0, 32, w, h - 32, gtnNormalColourBox)

                                    draw.NoTexture()
                                    surface.SetDrawColor(gtnNormalColourHeader)
                                    surface.DrawTexturedRect(0, 0, 500, 35)

                                    surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                    surface.DrawTexturedRect(0, 35, 500, 2)
                                end

                                surface.SetDrawColor(gtnDefaultColourMenu)
                                surface.SetMaterial(GTN_ICON_LIST)
                                surface.DrawTexturedRect(5, 4, 30, 30)
                                draw.NoTexture()
                            end

                            local gtnLeaderboardTitle = vgui.Create("DLabel", gtnLeaderboard)
                                gtnLeaderboardTitle:SetSize(200, 30)
                                gtnLeaderboardTitle:SetPos(40, 4)
                                gtnLeaderboardTitle:SetText("Leaderboard")
                                gtnLeaderboardTitle:SetFont("gtnMenuFont")
                                gtnLeaderboardTitle:SetColor(gtnDefaultColourMenu)

                            local gtnLeaderboardScrollPanel = vgui.Create("DScrollPanel", gtnLeaderboard)
                                gtnLeaderboardScrollPanel:SetPos(15, 85)
                                gtnLeaderboardScrollPanel:SetSize(470, 245)

                                local gtnLeaderboardLabelBox = vgui.Create("DFrame", gtnLeaderboard)
                                    gtnLeaderboardLabelBox:SetSize(470, 35)
                                    gtnLeaderboardLabelBox:Center()
                                    gtnLeaderboardLabelBox:SetPos(15, 54)
                                    gtnLeaderboardLabelBox:SetDraggable(false)
                                    gtnLeaderboardLabelBox:ShowCloseButton(false)
                                    gtnLeaderboardLabelBox:SetTitle("")
                                    gtnLeaderboardLabelBox.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            surface.SetDrawColor(gtnDarkColourHeaderShadow)
                                            surface.DrawOutlinedRect(0, 0, 470, 25)

                                            draw.NoTexture()
                                            surface.SetDrawColor(gtnDarkColourHeader)
                                            surface.DrawTexturedRect(1, 1, 468, 23)
                                        else
                                            surface.SetDrawColor(gtnNormalColourHeaderShadow)
                                            surface.DrawOutlinedRect(0, 0, 470, 25)

                                            draw.NoTexture()
                                            surface.SetDrawColor(gtnNormalColourHeader)
                                            surface.DrawTexturedRect(1, 1, 468, 23)
                                        end
                                    end

                                local gtnLeaderboardRankLabel = vgui.Create("DLabel", gtnLeaderboardLabelBox)
                                    gtnLeaderboardRankLabel:SetPos(8, 1)
                                    gtnLeaderboardRankLabel:SetSize(50, 25)
                                    gtnLeaderboardRankLabel:SetText("Rank")
                                    gtnLeaderboardRankLabel:SetFont("gtnHelpFont")
                                    gtnLeaderboardRankLabel:SetColor(gtnDefaultColourMenu)

                                local gtnLeaderboardNameLabel = vgui.Create("DLabel", gtnLeaderboardLabelBox)
                                    gtnLeaderboardNameLabel:SetPos(58, 1)
                                    gtnLeaderboardNameLabel:SetSize(50, 25)
                                    gtnLeaderboardNameLabel:SetText("Name")
                                    gtnLeaderboardNameLabel:SetFont("gtnHelpFont")
                                    gtnLeaderboardNameLabel:SetColor(gtnDefaultColourMenu)

                                local gtnLeaderboardWinsLabel = vgui.Create("DLabel", gtnLeaderboardLabelBox)
                                    gtnLeaderboardWinsLabel:SetPos(358, 1)
                                    gtnLeaderboardWinsLabel:SetSize(50, 25)
                                    gtnLeaderboardWinsLabel:SetText("Wins")
                                    gtnLeaderboardWinsLabel:SetFont("gtnHelpFont")
                                    gtnLeaderboardWinsLabel:SetColor(gtnDefaultColourMenu)

                                local gtnLeaderboardRanksText = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRanksText:SetSize(250, 30)
                                    gtnLeaderboardRanksText:SetPos(7, 0)
                                    gtnLeaderboardRanksText.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRanksText:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRanksText:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRanksText:SetText("1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n10.")
                                    gtnLeaderboardRanksText:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRanksText:SizeToContentsY()

                                gtnLeaderboardRank1SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank1SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank1SteamID:SetPos(57, 0)
                                    gtnLeaderboardRank1SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank1SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank1SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank1SteamID) ~= false then
                                        gtnLeaderboardRank1SteamID:SetText(player.GetBySteamID(gtnRank1SteamID):Nick())
                                    else
                                        gtnLeaderboardRank1SteamID:SetText(gtnRank1SteamID)
                                    end

                                    gtnLeaderboardRank1SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank1SteamID:SizeToContentsY()

                                gtnLeaderboardRank2SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank2SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank2SteamID:SetPos(57, 24)
                                    gtnLeaderboardRank2SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank2SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank2SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank2SteamID) ~= false then
                                        gtnLeaderboardRank2SteamID:SetText(player.GetBySteamID(gtnRank2SteamID):Nick())
                                    else
                                        gtnLeaderboardRank2SteamID:SetText(gtnRank2SteamID)
                                    end

                                    gtnLeaderboardRank2SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank2SteamID:SizeToContentsY()

                                gtnLeaderboardRank3SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank3SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank3SteamID:SetPos(57, 48)
                                    gtnLeaderboardRank3SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank3SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank3SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank3SteamID) ~= false then
                                        gtnLeaderboardRank3SteamID:SetText(player.GetBySteamID(gtnRank3SteamID):Nick())
                                    else
                                        gtnLeaderboardRank3SteamID:SetText(gtnRank3SteamID)
                                    end

                                    gtnLeaderboardRank3SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank3SteamID:SizeToContentsY()

                                gtnLeaderboardRank4SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank4SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank4SteamID:SetPos(57, 72)
                                    gtnLeaderboardRank4SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank4SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank4SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank4SteamID) ~= false then
                                        gtnLeaderboardRank4SteamID:SetText(player.GetBySteamID(gtnRank4SteamID):Nick())
                                    else
                                        gtnLeaderboardRank4SteamID:SetText(gtnRank4SteamID)
                                    end

                                    gtnLeaderboardRank4SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank4SteamID:SizeToContentsY()

                                gtnLeaderboardRank5SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank5SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank5SteamID:SetPos(57, 96)
                                    gtnLeaderboardRank5SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank5SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank5SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank5SteamID) ~= false then
                                        gtnLeaderboardRank5SteamID:SetText(player.GetBySteamID(gtnRank5SteamID):Nick())
                                    else
                                        gtnLeaderboardRank5SteamID:SetText(gtnRank5SteamID)
                                    end

                                    gtnLeaderboardRank5SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank5SteamID:SizeToContentsY()

                                gtnLeaderboardRank6SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank6SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank6SteamID:SetPos(57, 120)
                                    gtnLeaderboardRank6SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank6SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank6SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank6SteamID) ~= false then
                                        gtnLeaderboardRank6SteamID:SetText(player.GetBySteamID(gtnRank6SteamID):Nick())
                                    else
                                        gtnLeaderboardRank6SteamID:SetText(gtnRank6SteamID)
                                    end

                                    gtnLeaderboardRank6SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank6SteamID:SizeToContentsY()

                                gtnLeaderboardRank7SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank7SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank7SteamID:SetPos(57, 144)
                                    gtnLeaderboardRank7SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank7SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank7SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank7SteamID) ~= false then
                                        gtnLeaderboardRank7SteamID:SetText(player.GetBySteamID(gtnRank7SteamID):Nick())
                                    else
                                        gtnLeaderboardRank7SteamID:SetText(gtnRank7SteamID)
                                    end

                                    gtnLeaderboardRank7SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank7SteamID:SizeToContentsY()

                                gtnLeaderboardRank8SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank8SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank8SteamID:SetPos(57, 168)
                                    gtnLeaderboardRank8SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank8SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank8SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank8SteamID) ~= false then
                                        gtnLeaderboardRank8SteamID:SetText(player.GetBySteamID(gtnRank8SteamID):Nick())
                                    else
                                        gtnLeaderboardRank8SteamID:SetText(gtnRank8SteamID)
                                    end

                                    gtnLeaderboardRank8SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank8SteamID:SizeToContentsY()

                                gtnLeaderboardRank9SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank9SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank9SteamID:SetPos(57, 192)
                                    gtnLeaderboardRank9SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank9SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank9SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank9SteamID) ~= false then
                                        gtnLeaderboardRank9SteamID:SetText(player.GetBySteamID(gtnRank9SteamID):Nick())
                                    else
                                        gtnLeaderboardRank9SteamID:SetText(gtnRank9SteamID)
                                    end

                                    gtnLeaderboardRank9SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank9SteamID:SizeToContentsY()

                                gtnLeaderboardRank10SteamID = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank10SteamID:SetSize(260, 30)
                                    gtnLeaderboardRank10SteamID:SetPos(57, 216)
                                    gtnLeaderboardRank10SteamID.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank10SteamID:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank10SteamID:SetColor(gtnNormalColourText)
                                        end
                                    end

                                    if player.GetBySteamID(gtnRank10SteamID) ~= false then
                                        gtnLeaderboardRank10SteamID:SetText(player.GetBySteamID(gtnRank10SteamID):Nick())
                                    else
                                        gtnLeaderboardRank10SteamID:SetText(gtnRank10SteamID)
                                    end

                                    gtnLeaderboardRank10SteamID:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank10SteamID:SizeToContentsY()

                                local gtnLeaderboardRank1Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank1Wins:SetSize(110, 30)
                                    gtnLeaderboardRank1Wins:SetPos(357, 0)
                                    gtnLeaderboardRank1Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank1Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank1Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank1Wins:SetText(gtnRank1Wins)
                                    gtnLeaderboardRank1Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank1Wins:SizeToContentsY()

                                local gtnLeaderboardRank2Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank2Wins:SetSize(110, 30)
                                    gtnLeaderboardRank2Wins:SetPos(357, 24)
                                    gtnLeaderboardRank2Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank2Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank2Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank2Wins:SetText(gtnRank2Wins)
                                    gtnLeaderboardRank2Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank2Wins:SizeToContentsY()

                                local gtnLeaderboardRank3Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank3Wins:SetSize(110, 30)
                                    gtnLeaderboardRank3Wins:SetPos(357, 48)
                                    gtnLeaderboardRank3Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank3Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank3Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank3Wins:SetText(gtnRank3Wins)
                                    gtnLeaderboardRank3Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank3Wins:SizeToContentsY()

                                local gtnLeaderboardRank4Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank4Wins:SetSize(110, 30)
                                    gtnLeaderboardRank4Wins:SetPos(357, 72)
                                    gtnLeaderboardRank4Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank4Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank4Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank4Wins:SetText(gtnRank4Wins)
                                    gtnLeaderboardRank4Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank4Wins:SizeToContentsY()

                                local gtnLeaderboardRank5Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank5Wins:SetSize(110, 30)
                                    gtnLeaderboardRank5Wins:SetPos(357, 96)
                                    gtnLeaderboardRank5Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank5Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank5Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank5Wins:SetText(gtnRank5Wins)
                                    gtnLeaderboardRank5Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank5Wins:SizeToContentsY()

                                local gtnLeaderboardRank6Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank6Wins:SetSize(110, 30)
                                    gtnLeaderboardRank6Wins:SetPos(357, 120)
                                    gtnLeaderboardRank6Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank6Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank6Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank6Wins:SetText(gtnRank6Wins)
                                    gtnLeaderboardRank6Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank6Wins:SizeToContentsY()

                                local gtnLeaderboardRank7Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank7Wins:SetSize(110, 30)
                                    gtnLeaderboardRank7Wins:SetPos(357, 144)
                                    gtnLeaderboardRank7Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank7Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank7Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank7Wins:SetText(gtnRank7Wins)
                                    gtnLeaderboardRank7Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank7Wins:SizeToContentsY()

                                local gtnLeaderboardRank8Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank8Wins:SetSize(110, 30)
                                    gtnLeaderboardRank8Wins:SetPos(357, 168)
                                    gtnLeaderboardRank8Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank8Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank8Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank8Wins:SetText(gtnRank8Wins)
                                    gtnLeaderboardRank8Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank8Wins:SizeToContentsY()

                                local gtnLeaderboardRank9Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank9Wins:SetSize(110, 30)
                                    gtnLeaderboardRank9Wins:SetPos(357, 192)
                                    gtnLeaderboardRank9Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank9Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank9Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank9Wins:SetText(gtnRank9Wins)
                                    gtnLeaderboardRank9Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank9Wins:SizeToContentsY()

                                local gtnLeaderboardRank10Wins = vgui.Create("DLabel", gtnLeaderboardScrollPanel)
                                    gtnLeaderboardRank10Wins:SetSize(110, 30)
                                    gtnLeaderboardRank10Wins:SetPos(357, 216)
                                    gtnLeaderboardRank10Wins.Paint = function(s, w, h)
                                        if gtnDarkModeIsActive == true then
                                            gtnLeaderboardRank10Wins:SetColor(gtnDarkColourText)
                                        else
                                            gtnLeaderboardRank10Wins:SetColor(gtnNormalColourText)
                                        end
                                    end
                                    gtnLeaderboardRank10Wins:SetText(gtnRank10Wins)
                                    gtnLeaderboardRank10Wins:SetFont("gtnHelpFontBold")
                                    gtnLeaderboardRank10Wins:SizeToContentsY()

                            local gtnExitLeaderboard = vgui.Create("DImageButton", gtnLeaderboard)
                                gtnExitLeaderboard:SetSize(36, 36)
                                gtnExitLeaderboard:SetText("")
                                gtnExitLeaderboard:Center()
                                gtnExitLeaderboard:SetPos(gtnExitLeaderboard:GetPos() - 53, 355)
                                gtnExitLeaderboard.Paint = function(s, w, h)
                                    if gtnDarkModeIsActive == true then
                                        if gtnExitLeaderboard:IsHovered() == true then
                                            surface.SetDrawColor(gtnDarkColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnDarkColourText)
                                        end
                                    else
                                        if gtnExitLeaderboard:IsHovered() == true then
                                            surface.SetDrawColor(gtnNormalColourTextHovered)
                                        else
                                            surface.SetDrawColor(gtnNormalColourText)
                                        end
                                    end
                                    surface.SetMaterial(GTN_ICON_BACK)
                                    surface.DrawTexturedRect(0, 0, 36, 36)
                                    draw.NoTexture()
                                end

                                function gtnExitLeaderboard:OnMousePressed()
                                    net.Start("gtnCheckLeaderboard")
                                    net.SendToServer()
                                    gtnMenu:SetVisible(true)
                                    surface.PlaySound("garrysmod/ui_click.wav")
                                    gtnLeaderboard:Close()
                                    gtnIsLeaderboardOpen = false
                                end
                    end
                else
                    chat.AddText("[GTN] This feature has been disabled by the server admin.")
                    surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                end
            end
end

net.Receive("gtnReturnGameRequest", function()
    if gtnDisableSoundIsActive == false then
        surface.PlaySound("friends/message.wav")
    end
    gtnIsActive = net.ReadBool()
    gtnRandomNumber = net.ReadString()
    gtnServerDataPlayersRequired = net.ReadInt(8)
end)

net.Receive("gtnReturnInvalidGameRequest", function()
    surface.PlaySound("resource/warning.wav")
    chat.AddText("[GTN] There are not enough players to start a game.".."\nMinimum players required: "..gtnServerDataPlayersRequired)
end)

net.Receive("gtnReturnGameEnd", function()
    if gtnDisableSoundIsActive == false then
        surface.PlaySound("friends/friend_online.wav")
    end
    gtnIsActive = net.ReadBool()
    gtnIsRewardMoney = net.ReadBool()
    gtnIsRewardNothing = net.ReadBool()
    gtnIsRewardWeapon = net.ReadBool()
    gtnIsRewardPSPoints = net.ReadBool() -- TESING
    gtnIsRewardPS2Points = net.ReadBool() -- TESTING
    gtnRandomNumberRange = net.ReadInt(32)
end)

net.Receive("gtnReturnWinnerReward", function()
    gtnWinnerReward = net.ReadString()
    gtnWinnerRewardValue = net.ReadString()

    if gtnWinnerReward ~= "None" then
        notification.AddLegacy("Reward: "..gtnWinnerReward.." "..gtnWinnerRewardValue, NOTIFY_GENERIC, 8)
        notification.AddLegacy("You've won the game!", NOTIFY_GENERIC, 7)
    else
        notification.AddLegacy("You've won the game!", NOTIFY_GENERIC, 7)
    end
end)

net.Receive("gtnReturnStopGame", function()
    if gtnDisableSoundIsActive == false then
        surface.PlaySound("friends/friend_join.wav")
    end
    gtnIsActive = net.ReadBool()
    gtnIsRewardMoney = net.ReadBool()
    gtnIsRewardNothing = net.ReadBool()
    gtnRandomNumberRange = net.ReadInt(32)
end)

net.Receive("gtnReturnCheckOwnerGroup", function()
    gtnUserOwnerAccess = net.ReadBool()
end)

net.Receive("gtnReturnCheckPlayersRequired", function()
    gtnServerDataPlayersRequired = net.ReadString()
end)

net.Receive("gtnReturnSendEnteredGroup", function()
    gtnPermissions = net.ReadTable()
end)
net.Receive("gtnReturnCheckPermissionsTable", function()
    gtnPermissions = net.ReadTable()
end)

net.Receive("gtnReturnCheckAccess", function()
    gtnIsGroupInTable = net.ReadBool()
end)

net.Receive("gtnReturnWhitelistReset", function()
    surface.PlaySound("buttons/combine_button5.wav")
    gtnPermissions = net.ReadTable()
end)

net.Receive("gtnReturnCheckPointShopInstalled", function()
    gtnIsPointShopInstalled = net.ReadBool()
end)

net.Receive("gtnReturnCheckPointShop2Installed", function()
    gtnIsPointShop2Installed = net.ReadBool()
end)

net.Receive("gtnReturnCheckLeaderboard", function()
    gtnDisableLeaderboard = net.ReadBool()
    gtnRank1SteamID = net.ReadString()
    gtnRank2SteamID = net.ReadString()
    gtnRank3SteamID = net.ReadString()
    gtnRank4SteamID = net.ReadString()
    gtnRank5SteamID = net.ReadString()
    gtnRank6SteamID = net.ReadString()
    gtnRank7SteamID = net.ReadString()
    gtnRank8SteamID = net.ReadString()
    gtnRank9SteamID = net.ReadString()
    gtnRank10SteamID = net.ReadString()
    gtnRank1Wins = net.ReadInt(32)
    gtnRank2Wins = net.ReadInt(32)
    gtnRank3Wins = net.ReadInt(32)
    gtnRank4Wins = net.ReadInt(32)
    gtnRank5Wins = net.ReadInt(32)
    gtnRank6Wins = net.ReadInt(32)
    gtnRank7Wins = net.ReadInt(32)
    gtnRank8Wins = net.ReadInt(32)
    gtnRank9Wins = net.ReadInt(32)
    gtnRank10Wins = net.ReadInt(32)
    --gtnRank1Player = net.ReadString()
    --gtnRank2Player = net.ReadString()
    --gtnRank3Player = net.ReadString()
    --gtnRank4Player = net.ReadString()
    --gtnRank5Player = net.ReadString()
    --gtnRank6Player = net.ReadString()
    --gtnRank7Player = net.ReadString()
    --gtnRank8Player = net.ReadString()
    --gtnRank9Player = net.ReadString()
    --gtnRank10Player = net.ReadString()
end)

net.Receive("gtnReturnCheckLeaderboardDisabled", function()
    gtnDisableLeaderboard = net.ReadBool()
end)

net.Receive("gtnReturnWrongGuess", function()
    if gtnDisableSoundIsActive == false then
        surface.PlaySound("buttons/combine_button7.wav")
    end
end)

hook.Add("OnPlayerChat", "gtnMenuOpen", function(ply, text)
    if ply == LocalPlayer() and string.lower(text) == "!gtn" then
        local gtnPlayerHasOpenedNews = ply:GetPData("gtnHasOpenedNews5", false) -- Change gtnHasOpenedNews to a higher number each update for a News pop-up.

        ply:RemovePData("gtnHasOpenedNews") -- Change this to the previous update number after each update.
        ply:RemovePData("gtnHasOpenedNews0")
        ply:RemovePData("gtnHasOpenedNews1")
        ply:RemovePData("gtnHasOpenedNews2")
        ply:RemovePData("gtnHasOpenedNews3")
        ply:RemovePData("gtnHasOpenedNews4")

        if gtnPlayerHasOpenedNews ~= false then
            gtnOpenMenu()
        else
            ply:SetPData("gtnHasOpenedNews5", true) -- Change gtnHasOpenedNews to a higher number each update for a News pop-up.
            gtnOpenMenu()
            surface.PlaySound("garrysmod/ui_click.wav")
            local gtnNews = vgui.Create("DFrame")
                gtnNews:SetSize(450, 400)
                gtnNews:SetTitle("News & updates")
                gtnNews:SetDraggable(true)
                gtnNews:MakePopup()
                gtnNews:Center()

                local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ News ]\n\nA leaderboard feature has been on the to-do list for a\nwhile now, but now it is finally released!\n\nPlease keep in mind that it's a new feature and that it\nmay contain bugs. In which case you may use the\nnewly added 'Report Bug' button on the Main menu. :)\n\nI have noticed that there is a lack of feedback\nand bug reports from subscribers. I hope to improve\nthis by making bug reports more accessible.\n\nI try my best to find all existing bugs and come up\nwith cool new ideas, but this task is not exclusive to\ndeveloper only. Know that you as a subscriber also\nget to have a say in how the addon develops.\n\nWith that being said, enjoy the new updates!"

                local gtnNewsCredits = vgui.Create("DLabel", gtnNews)
                    gtnNewsCredits:SetPos(149, 340)
                    gtnNewsCredits:SetText("Guess the Number is an addon created by            .".."\nFor the latest updates please Subscribe to the official\n                                   .")
                    gtnNewsCredits:SizeToContents()

                    local gtnNewsAuthorLabel = vgui.Create("DLabelURL", gtnNews)
                        gtnNewsAuthorLabel:SetPos(354, 321)
                        gtnNewsAuthorLabel:SetSize(100, 50)
                        gtnNewsAuthorLabel:SetColor(Color(255, 255, 255, 255))
                        gtnNewsAuthorLabel:SetText("Author")
                        gtnNewsAuthorLabel:SetURL( "http://steamcommunity.com/profiles/76561198089349272" )

                    local gtnNewsWorkshopLabel = vgui.Create("DLabelURL", gtnNews)
                        gtnNewsWorkshopLabel:SetPos(149, 367)
                        gtnNewsWorkshopLabel:SetSize(100, 50)
                        gtnNewsWorkshopLabel:SetColor(Color(255, 255, 255, 255))
                        gtnNewsWorkshopLabel:SetText("Steam Workshop page")
                        gtnNewsWorkshopLabel:SetURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=1181687249" )
                        gtnNewsWorkshopLabel:SizeToContents()

                local gtnNewsButtonScrollPanel = vgui.Create("DScrollPanel", gtnNews)
                    gtnNewsButtonScrollPanel:SetSize(137, 300)
                    gtnNewsButtonScrollPanel:SetPos(13, 32)

                    local gtnNewsButton5N = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton5N:SetText("27 Dec 2017 (N)")
                        gtnNewsButton5N:SetPos(0, 0)
                        gtnNewsButton5N:SetSize(122, 25)
                        gtnNewsButton5N.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ News ]\n\nA leaderboard feature has been on the to-do list for a\nwhile now, but now it is finally released!\n\nPlease keep in mind that it's a new feature and that it\nmay contain bugs. In which case you may use the\nnewly added 'Report Bug' button on the Main menu. :)\n\nI have noticed that there is a lack of feedback\nand bug reports from subscribers. I hope to improve\nthis by making bug reports more accessible.\n\nI try my best to find all existing bugs and come up\nwith cool new ideas, but this task is not exclusive to\ndeveloper only. Know that you as a subscriber also\nget to have a say in how the addon develops.\n\nWith that being said, enjoy the new updates!"
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(300, 274)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton5U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton5U:SetText("27 Dec 2017 (U)")
                        gtnNewsButton5U:SetPos(0, 30)
                        gtnNewsButton5U:SetSize(122, 25)
                        gtnNewsButton5U.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "27 Dec 2017 - 00:51 AM\n\n[ Updates ]\n\n- Added Pointshop 2 support to Create game (test).\n- Replaced help button pop-ups with tooltips.\n- Added Leaderboard to Main menu.\n- Added Bug Report to Main menu.\n- Number range limit increased to 100,000 (from 9,000).\n- Added second page to Admin settings.\n- Added Disable Leaderboard to Admin settings.\n- Added Wipe Data to Admin settings.\n- Resetting own game wins is no longer possible.\n- Command timer reduced to 5 seconds (from 30).\n- All addon data is now stored in garrysmod/data/gtn.\n\n[ Bug fixes ]\n\n- Non-number inputs with !guess are disallowed.\n- Fixed a bug that caused wins to display multiple times\nin the chat when using !gtnwins."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(300, 274)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton4N = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton4N:SetText("26 Nov 2017 (N)")
                        gtnNewsButton4N:SetPos(0, 60)
                        gtnNewsButton4N:SetSize(122, 25)
                        gtnNewsButton4N.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "26 Nov 2017 - 3:21 AM\n\n[ News ]\n\nIn the short amount of time after Guess the Number\ngot published on the Steam Workshop and garrysmods,\nit has gained the attention of more than 800 unique\nvisitors and over 300 active Subscribers.\n\nI want to personally thank everyone who has taken\ntheir time to try out this new addon I've been working\non during my spare time.\n\nDon't hesitate to let me know if you encounter any\nissues or if you would like to suggest an idea or new\nfeatures to improve the usability of the addon."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(300, 208)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton4U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton4U:SetText("26 Nov 2017 (U)")
                        gtnNewsButton4U:SetPos(0, 90)
                        gtnNewsButton4U:SetSize(122, 25)
                        gtnNewsButton4U.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "26 Nov 2017 - 3:21 AM\n\n[ Updates ]\n\n- Number comparisons are now done server-side to\nprevent cheats.\n- Added an Enable Hints option to Create game.\n- Added Commands to Main menu.\n- Added News to Main menu."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(300, 118)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton3U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton3U:SetText("5 Nov 2017 (U)")
                        gtnNewsButton3U:SetPos(0, 120)
                        gtnNewsButton3U:SetSize(122, 25)
                        gtnNewsButton3U.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "5 Nov 2017 - 1:36 AM\n\n[ Updates ]\n\n- Added !gtnwins chat command.\n- Added !gtnreset chat command."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(295, 79)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton2U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton2U:SetText("29 Oct 2017 (U)")
                        gtnNewsButton2U:SetPos(0, 150)
                        gtnNewsButton2U:SetSize(122, 25)
                        gtnNewsButton2U.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "29 Oct 2017 - 1:01 AM\n\n[ Updates ]\n\n- Small optimizations."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(295, 65)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                    local gtnNewsButton1U = vgui.Create("DButton", gtnNewsButtonScrollPanel)
                        gtnNewsButton1U:SetText("28 Oct 2017 (U)")
                        gtnNewsButton1U:SetPos(0, 180)
                        gtnNewsButton1U:SetSize(122, 25)
                        gtnNewsButton1U.DoClick = function()
                            surface.PlaySound("garrysmod/ui_click.wav")
                            local gtnNewsText = "28 Oct 2017 - 2:48 AM\n\n[ Updates ]\n\n- Added a Disable Sound option to Settings."
                            gtnNewsTextPanelLabel:SetText(gtnNewsText)
                            gtnNewsTextPanelLabel:SetSize(295, 65)
                            gtnNewsTextPanel:SetSize(295, 300)
                        end

                local gtnNewsTextScrollPanel = vgui.Create("DScrollPanel", gtnNews)
                    gtnNewsTextScrollPanel:SetSize(295, 300)
                    gtnNewsTextScrollPanel:SetPos(149, 32)

                gtnNewsTextPanel = vgui.Create("DPanel", gtnNewsTextScrollPanel)
                    gtnNewsTextPanel:SetPos(0, 0)
                    gtnNewsTextPanel:SetSize(295, 300)

                    gtnNewsTextPanelLabel = vgui.Create("DLabel", gtnNewsTextPanel)
                        gtnNewsTextPanelLabel:SetPos(10, 10)
                        gtnNewsTextPanelLabel:SetText(gtnNewsText)
                        gtnNewsTextPanelLabel:SizeToContents()
                        gtnNewsTextPanelLabel:SetDark(1)
        end
    end
end)

hook.Add("OnPlayerChat", "gtnGameStop", function(ply, text)
    if gtnIsActive == true and ply == LocalPlayer() and string.lower(text) == "!gtnstop" then
        net.Start("gtnStopGame")
        net.SendToServer()
    elseif gtnIsActive == false and ply == LocalPlayer() and string.lower(text) == "!gtnstop" then
        if gtnDisableSoundIsActive == false then
            surface.PlaySound("resource/warning.wav")
        end
        chat.AddText("[GTN] There are no active games.")
    end
end)

local gtnDisplayWinsCurTime = CurTime()
local gtnDisplayWinsWaitTime = 0 -- We need a way to circumvent the wait time for the first wins display.

hook.Add("OnPlayerChat", "gtnDisplayPlayerWins", function(ply, text)
    if ply == LocalPlayer() and string.lower(text) == "!gtnwins" then
        net.Start("gtnCheckLeaderboard")
        net.SendToServer()
        if gtnDisableLeaderboard == false then
            if CurTime() >= gtnDisplayWinsCurTime + gtnDisplayWinsWaitTime then
                gtnDisplayWinsCurTime = CurTime()
                gtnDisplayWinsWaitTime = 5
                if gtnDisableSoundIsActive == false then
                    surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                end
                net.Start("gtnDisplayWinsRequest")
                net.SendToServer()
            else
                if gtnDisableSoundIsActive == false then
                    surface.PlaySound("resource/warning.wav")
                end
                chat.AddText("[GTN] You must wait "..gtnDisplayWinsWaitTime.." seconds to use this command.")
            end
        else
            if gtnDisableSoundIsActive == false then
                surface.PlaySound("garrysmod/balloon_pop_cute.wav")
            end
            chat.AddText("[GTN] This feature has been disabled by the server admin.")
        end
    end
end)

--local gtnResetWinsCurTime = CurTime()
--local gtnResetWinsWaitTime = 0 -- We need a way to circumvent the wait time for the first wins display.

--hook.Add("OnPlayerChat", "gtnResetPlayerWins", function(ply, text)
    --if ply == LocalPlayer() and string.lower(text) == "!gtnreset" then
        --if CurTime() >= gtnResetWinsCurTime + gtnResetWinsWaitTime then
            --gtnResetWinsCurTime = CurTime()
            --gtnResetWinsWaitTime = 5
            --if gtnDisableSoundIsActive == false then
                --surface.PlaySound("buttons/combine_button5.wav")
            --end
            --net.Start("gtnResetWinsRequest")
            --net.SendToServer()
        --else
            --if gtnDisableSoundIsActive == false then
                --surface.PlaySound("resource/warning.wav")
            --end
            --chat.AddText("[GTN] You must wait "..gtnResetWinsWaitTime.." seconds to use this command.")
        --end
    --end
--end)

local gtnGuessCurTime = CurTime()
local gtnGuessWaitTime = 0 -- We need a way to circumvent the wait time for the first guess.

hook.Add("OnPlayerChat", "gtnNumberGuess", function(ply, text)
    if ply == LocalPlayer() then
        local playerInput = string.Explode(" ", text)
        if playerInput[1] == "!guess" then
                net.Start("gtnIsActiveCheck2")
                net.SendToServer()
                net.Receive("gtnReturnIsActiveCheck2", function()
                    gtnIsActive = net.ReadBool()
                    if gtnIsActive == true then
                        --[[net.Start("gtnRandomNumberCheck") -- Synchronizes the random number with each guess.
                        net.SendToServer()
                        net.Receive("gtnReturnRandomNumberCheck", function()
                            gtnRandomNumber = net.ReadString()
                        end)]]

                        if CurTime() >= gtnGuessCurTime + gtnGuessWaitTime then
                            if isstring(playerInput[2]) then
                                local playerInputInt = tonumber(playerInput[2])
                                if isnumber(playerInputInt) then
                                    gtnGuessCurTime = CurTime()
                                    gtnGuessWaitTime = 1.2 -- We need a way to stop people from guessing too quickly with binds.

                                    net.Start("gtnSendPlayerGuess")
                                        net.WriteString(playerInput[2])
                                    net.SendToServer()

                                    --[[if playerInput[2] ~= gtnRandomNumber then
                                        net.Start("gtnSendGuess")
                                            net.WriteString(playerInput[2])
                                        net.SendToServer()

                                        if gtnEnableHintsIsActive == true then
                                            if playerInput[2] > gtnRandomNumber then
                                                surface.PlaySound("buttons/combine_button7.wav")
                                                chat.AddText("Wrong number, guess lower!")
                                            end

                                            if playerInput[2] < gtnRandomNumber then
                                                surface.PlaySound("buttons/combine_button7.wav")
                                                chat.AddText("Wrong number, guess higher!")
                                            end
                                        else
                                            surface.PlaySound("buttons/combine_button7.wav")
                                            chat.AddText("Wrong number, guess again!")
                                        end
                                    end]]
                                else
                                    if gtnDisableSoundIsActive == false then
                                        surface.PlaySound("resource/warning.wav")
                                    end
                                    chat.AddText("[GTN] The entered command is invalid.\nType !guess <number> to guess a number.")
                                end
                            else
                                if gtnDisableSoundIsActive == false then
                                    surface.PlaySound("resource/warning.wav")
                                end
                                chat.AddText("[GTN] The entered command is invalid.\nType !guess <number> to guess a number.")
                            end
                        else
                            if gtnDisableSoundIsActive == false then
                                surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                            end
                            chat.AddText("You must wait "..gtnGuessWaitTime.." seconds before guessing again.")
                        end
                    end
                end)

            if gtnIsActive == false then
                if gtnDisableSoundIsActive == false then
                    surface.PlaySound("garrysmod/balloon_pop_cute.wav")
                end
                chat.AddText("[GTN] Please wait until a new game has started.")
            end
        end
    end
end)

end -- CLIENT
