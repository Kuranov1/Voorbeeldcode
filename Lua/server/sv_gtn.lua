if SERVER then

resource.AddWorkshop("1181687249") -- Forces clients to download the addon if they haven't already.

util.AddNetworkString("gtnIsActiveCheck")
util.AddNetworkString("gtnReturnIsActiveCheck")
util.AddNetworkString("gtnIsActiveCheck2")
util.AddNetworkString("gtnReturnIsActiveCheck2")

util.AddNetworkString("gtnRandomNumberCheck")
util.AddNetworkString("gtnReturnRandomNumberCheck")

util.AddNetworkString("gtnStartGameRequest")
util.AddNetworkString("gtnReturnGameRequest")
util.AddNetworkString("gtnReturnInvalidGameRequest")

util.AddNetworkString("gtnSendPlayerGuess")
util.AddNetworkString("gtnReturnGameEnd")
util.AddNetworkString("gtnReturnWrongGuess")

util.AddNetworkString("gtnStopGame")
util.AddNetworkString("gtnReturnStopGame")

util.AddNetworkString("gtnCheckOwnerGroup")
util.AddNetworkString("gtnReturnCheckOwnerGroup")

util.AddNetworkString("gtnSendPlayersRequired")

util.AddNetworkString("gtnCheckPlayersRequired")
util.AddNetworkString("gtnReturnCheckPlayersRequired")

util.AddNetworkString("gtnSendEnteredGroup")
util.AddNetworkString("gtnReturnSendEnteredGroup")

util.AddNetworkString("gtnCheckAccess")
util.AddNetworkString("gtnReturnCheckAccess")

util.AddNetworkString("gtnCheckPermissionsTable")
util.AddNetworkString("gtnReturnCheckPermissionsTable")

util.AddNetworkString("gtnWhitelistReset")
util.AddNetworkString("gtnReturnWhitelistReset")

--util.AddNetworkString("gtnSendGuess") -- -- Used for showing the player's guess to all players.

util.AddNetworkString("gtnCheckPointShopInstalled")
util.AddNetworkString("gtnReturnCheckPointShopInstalled")

util.AddNetworkString("gtnCheckPointShop2Installed")
util.AddNetworkString("gtnReturnCheckPointShop2Installed")

util.AddNetworkString("gtnReturnWinnerReward")

util.AddNetworkString("gtnDisplayWinsRequest")

--util.AddNetworkString("gtnResetWinsRequest") -- Resetting personal wins is disabled for now.

util.AddNetworkString("gtnSendEnableHintsIsActive")

util.AddNetworkString("gtnCheckLeaderboard")
util.AddNetworkString("gtnReturnCheckLeaderboard")
util.AddNetworkString("gtnReturnCheckLeaderboardDisabled")

util.AddNetworkString("gtnResetLeaderboard")

util.AddNetworkString("gtnDisableLeaderboardVal")

-- Reset all values.

local gtnIsActive = false
local gtnRandomNumberRange = 50
local gtnMoneyReward = 0
local gtnPSPointsReward = 0
local gtnPS2PointsReward = 0
local gtnIsRewardMoney = false
local gtnIsRewardNothing = true
local gtnIsRewardWeapon = false

-- Create folders if they don't exist.

if file.IsDir("gtn", "DATA") == false then
    file.CreateDir("gtn")
end

if file.IsDir("gtn/leaderboard", "DATA") == false then
    file.CreateDir("gtn/leaderboard")
end

if file.IsDir("gtn/leaderboard/steamids", "DATA") == false then
    file.CreateDir("gtn/leaderboard/steamids")
end

if file.IsDir("gtn/leaderboard/wins", "DATA") == false then
    file.CreateDir("gtn/leaderboard/wins")
end

-- Load registered players.

if file.Exists("gtn/leaderboard/gtn_registeredplayers.txt", "DATA") == false then
    gtnRegisteredPlayers = {} -- Table to store all registered players in (people who have at least 1 win).
    table.insert(gtnRegisteredPlayers, "STEAM_0:1:7099")
    local gtnRegisteredPlayersToJSON = util.TableToJSON(gtnRegisteredPlayers)
    file.Write("gtn/leaderboard/gtn_registeredplayers.txt", gtnRegisteredPlayersToJSON)
else
    local gtnRegisteredPlayersJSON = file.Read("gtn/leaderboard/gtn_registeredplayers.txt", "DATA")
    gtnRegisteredPlayers = util.JSONToTable(gtnRegisteredPlayersJSON)
end

net.Receive("gtnDisableLeaderboardVal", function(len, ply)
    gtnValSender = ply:Nick()

    local gtnPlayersTable = player.GetAll()

    gtnDisableLeaderboard = net.ReadBool()
    file.Write("gtn/leaderboard/gtn_disableleaderboard.txt", tostring(gtnDisableLeaderboard))
    if gtnDisableLeaderboard == false then
        for k, ply in pairs(gtnPlayersTable) do
            ply:ChatPrint("[GTN] "..gtnValSender.." has enabled the Leaderboard.")
        end
    else
        for k, ply in pairs(gtnPlayersTable) do
            ply:ChatPrint("[GTN] "..gtnValSender.." has disabled the Leaderboard.")
        end
    end
end)

-- Check if disable leaderboard bVal file exists.

if file.Exists("gtn/leaderboard/gtn_disableleaderboard.txt", "DATA") == true then
    gtnDisableLeaderboard = tobool(file.Read("gtn/leaderboard/gtn_disableleaderboard.txt", "DATA"))
else
    gtnDisableLeaderboard = false
    file.Write("gtn/leaderboard/gtn_disableleaderboard.txt", gtnDisableLeaderboard)
end

-- Load Leaderboard SteamID variables.

local gtnRank1SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank1steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank1steamid.txt", gtnRank1SteamID)
end

local gtnRank1SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank1steamid.txt", "DATA")

local gtnRank2SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank2steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank2steamid.txt", gtnRank2SteamID)
end

local gtnRank2SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank2steamid.txt", "DATA")

local gtnRank3SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank3steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
end

local gtnRank3SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank3steamid.txt", "DATA")

local gtnRank4SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank4steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
end

local gtnRank4SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank4steamid.txt", "DATA")

local gtnRank5SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank5steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
end

local gtnRank5SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank5steamid.txt", "DATA")

local gtnRank6SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank6steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
end

local gtnRank6SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank6steamid.txt", "DATA")

local gtnRank7SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank7steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
end

local gtnRank7SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank7steamid.txt", "DATA")

local gtnRank8SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank8steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
end

local gtnRank8SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank8steamid.txt", "DATA")

local gtnRank9SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank9steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
end

local gtnRank9SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank9steamid.txt", "DATA")

local gtnRank10SteamID = "None"

if file.Exists("gtn/leaderboard/steamids/gtn_rank10steamid.txt", "DATA") == false then
    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
end

local gtnRank10SteamID = file.Read("gtn/leaderboard/steamids/gtn_rank10steamid.txt", "DATA")

-- Load Leaderboard Wins variables.

local gtnRank1Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank1wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank1wins.txt", gtnRank1Wins)
end

local gtnRank1Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank1wins.txt", "DATA"))

local gtnRank2Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank2wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
end

local gtnRank2Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank2wins.txt", "DATA"))

local gtnRank3Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank3wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
end

local gtnRank3Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank3wins.txt", "DATA"))

local gtnRank4Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank4wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
end

local gtnRank4Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank4wins.txt", "DATA"))

local gtnRank5Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank5wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
end

local gtnRank5Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank5wins.txt", "DATA"))

local gtnRank6Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank6wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
end

local gtnRank6Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank6wins.txt", "DATA"))

local gtnRank7Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank7wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
end

local gtnRank7Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank7wins.txt", "DATA"))

local gtnRank8Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank8wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
end

local gtnRank8Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank8wins.txt", "DATA"))

local gtnRank9Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank9wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
end

local gtnRank9Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank9wins.txt", "DATA"))

local gtnRank10Wins = 0

if file.Exists("gtn/leaderboard/wins/gtn_rank10wins.txt", "DATA") == false then
    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
end

local gtnRank10Wins = tonumber(file.Read("gtn/leaderboard/wins/gtn_rank10wins.txt", "DATA"))

-- No use yet.

local gtnRank1Player = "None"
local gtnRank2Player = "None"
local gtnRank3Player = "None"
local gtnRank4Player = "None"
local gtnRank5Player = "None"
local gtnRank6Player = "None"
local gtnRank7Player = "None"
local gtnRank8Player = "None"
local gtnRank1Player = "None"
local gtnRank9Player = "None"
local gtnRank10Player = "None"

net.Receive("gtnCheckLeaderboard", function(len, ply)
    if gtnDisableLeaderboard == false then
        net.Start("gtnReturnCheckLeaderboard")
            net.WriteBool(gtnDisableLeaderboard)
            net.WriteString(gtnRank1SteamID)
            net.WriteString(gtnRank2SteamID)
            net.WriteString(gtnRank3SteamID)
            net.WriteString(gtnRank4SteamID)
            net.WriteString(gtnRank5SteamID)
            net.WriteString(gtnRank6SteamID)
            net.WriteString(gtnRank7SteamID)
            net.WriteString(gtnRank8SteamID)
            net.WriteString(gtnRank9SteamID)
            net.WriteString(gtnRank10SteamID)
            net.WriteInt(gtnRank1Wins, 32)
            net.WriteInt(gtnRank2Wins, 32)
            net.WriteInt(gtnRank3Wins, 32)
            net.WriteInt(gtnRank4Wins, 32)
            net.WriteInt(gtnRank5Wins, 32)
            net.WriteInt(gtnRank6Wins, 32)
            net.WriteInt(gtnRank7Wins, 32)
            net.WriteInt(gtnRank8Wins, 32)
            net.WriteInt(gtnRank9Wins, 32)
            net.WriteInt(gtnRank10Wins, 32)
            --net.WriteString(gtnRank1Player)
            --net.WriteString(gtnRank2Player)
            --net.WriteString(gtnRank3Player)
            --net.WriteString(gtnRank4Player)
            --net.WriteString(gtnRank5Player)
            --net.WriteString(gtnRank6Player)
            --net.WriteString(gtnRank7Player)
            --net.WriteString(gtnRank8Player)
            --net.WriteString(gtnRank9Player)
            --net.WriteString(gtnRank10Player)
        net.Send(ply)
    end
    if gtnDisableLeaderboard == true then
        net.Start("gtnReturnCheckLeaderboardDisabled")
            net.WriteBool(gtnDisableLeaderboard)
        net.Send(ply)
    end
end)

net.Receive("gtnIsActiveCheck", function(len, ply)
        net.Start("gtnReturnIsActiveCheck")
            net.WriteBool(gtnIsActive)
        net.Send(ply)
end)

net.Receive("gtnIsActiveCheck2", function(len, ply)
        net.Start("gtnReturnIsActiveCheck2")
            net.WriteBool(gtnIsActive)
        net.Send(ply)
end)

net.Receive("gtnRandomNumberCheck", function(len, ply)
        net.Start("gtnReturnRandomNumberCheck")
            net.WriteString(gtnRandomNumber)
        net.Send(ply)
end)

net.Receive("gtnStartGameRequest", function(len, ply)
    local gtnServerDataPlayersRequired = file.Read("gtn/gtn_playersrequired.txt", "DATA")
    if player.GetCount() >= tonumber(gtnServerDataPlayersRequired) then
        local gtnGameStarter = ply:Nick()
        gtnIsRewardMoney = net.ReadBool()
        gtnIsRewardWeapon = net.ReadBool()
        gtnIsRewardPSPoints = net.ReadBool()
        gtnIsRewardPS2Points = net.ReadBool()

        gtnRewardTypeString = "None"
        gtnRewardValueString = ""

        if gtnIsRewardMoney == true then
            gtnMoneyReward = net.ReadInt(32)
            gtnRewardTypeString = "[Money]"
            gtnRewardValueString = "("..gtnMoneyReward..")"
        else
            gtnMoneyReward = nil
        end

        if gtnIsRewardWeapon == true then
            gtnWeaponReward = net.ReadString()
            gtnRewardTypeString = "[Weapon]"
            gtnRewardValueString = "("..gtnWeaponReward..")"
        end

        if gtnIsRewardPSPoints == true then
            gtnPSPointsReward = net.ReadInt(32)
            gtnRewardTypeString = "[PointShop Points]"
            gtnRewardValueString = "("..gtnPSPointsReward..")"
        else
            gtnPSPointsReward = nil
        end

        if gtnIsRewardPS2Points == true then
            gtnPS2PointsReward = net.ReadInt(32)
            gtnRewardTypeString = "[Pointshop 2 Points]"
            gtnRewardValueString = "("..gtnPS2PointsReward..")"
        else
            gtnPSPointsReward = nil
        end

        local gtnRandomNumberRange = net.ReadInt(32)
        local gtnRandomNumberRangeString = tostring(gtnRandomNumberRange)

        net.Start("gtnReturnGameRequest")
            gtnIsActive = true
            net.WriteBool(gtnIsActive)
            gtnRandomNumber = math.random(1, gtnRandomNumberRange)
            net.WriteString(gtnRandomNumber)
            local gtnServerDataPlayersRequired = file.Read("gtn/gtn_playersrequired.txt", "DATA")
            net.WriteInt(gtnServerDataPlayersRequired, 8)
        net.Broadcast()

        local gtnPlayersTable = player.GetAll()

        for k, ply in pairs(gtnPlayersTable) do
            if gtnRewardTypeString == "None" then
                --ply:ChatPrint("[GTN] "..gtnGameStarter.." has started a game!\n[GTN] Type !guess <number> to guess a number between 1 and "..gtnRandomNumberRangeString..".")
                ply:ChatPrint("[GTN] "..gtnGameStarter.." has started a game!\n[GTN] Type !guess <1 to "..gtnRandomNumberRangeString.."> to guess a number.")
            else
                ply:ChatPrint("[GTN] "..gtnGameStarter.." has started a game!\n[GTN] Reward: "..gtnRewardTypeString.." "..gtnRewardValueString.."\n[GTN] Type !guess <1 to "..gtnRandomNumberRangeString.."> to guess a number.")
            end
        end

    else
        net.Start("gtnReturnInvalidGameRequest")
        net.Send(ply)
    end
end)

net.Receive("gtnSendEnableHintsIsActive", function(len, ply)
    gtnEnableHintsIsActive = net.ReadBool()
end)

local function gtnCheckDuplicateRank(gtnLeaderboardSteamID) -- Check for duplicate ranks, remove them, and then re-order the Leaderboard.
    if gtnLeaderboardSteamID == gtnRank1SteamID then
        if gtnLeaderboardSteamID == gtnRank2SteamID then
            gtnRank2Wins = gtnRank3Wins
            file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
            gtnRank2SteamID = gtnRank3SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank2steamid.txt", gtnRank2SteamID)
            gtnRank2Player = "None"

            gtnRank3Wins = gtnRank4Wins
            file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
            gtnRank3SteamID = gtnRank4SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
            gtnRank3Player = "None"

            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank3SteamID then
            gtnRank3Wins = gtnRank4Wins
            file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
            gtnRank3SteamID = gtnRank4SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
            gtnRank3Player = "None"

            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank4SteamID then
            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank5SteamID then
            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank6SteamID then
            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank2SteamID then
        if gtnLeaderboardSteamID == gtnRank3SteamID then
            gtnRank3Wins = gtnRank4Wins
            file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
            gtnRank3SteamID = gtnRank4SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
            gtnRank3Player = "None"

            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank4SteamID then
            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank5SteamID then
            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank6SteamID then
            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank3SteamID then
        if gtnLeaderboardSteamID == gtnRank4SteamID then
            gtnRank4Wins = gtnRank5Wins
            file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
            gtnRank4SteamID = gtnRank5SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
            gtnRank4Player = "None"

            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank5SteamID then
            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank6SteamID then
            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank4SteamID then
        if gtnLeaderboardSteamID == gtnRank5SteamID then
            gtnRank5Wins = gtnRank6Wins
            file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
            gtnRank5SteamID = gtnRank6SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
            gtnRank5Player = "None"

            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank6SteamID then
            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank5SteamID then
        if gtnLeaderboardSteamID == gtnRank6SteamID then
            gtnRank6Wins = gtnRank7Wins
            file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
            gtnRank6SteamID = gtnRank7SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
            gtnRank6Player = "None"

            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank6SteamID then
        if gtnLeaderboardSteamID == gtnRank7SteamID then
            gtnRank7Wins = gtnRank8Wins
            file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
            gtnRank7SteamID = gtnRank8SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
            gtnRank7Player = "None"

            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank7SteamID then
        if gtnLeaderboardSteamID == gtnRank8SteamID then
            gtnRank8Wins = gtnRank9Wins
            file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
            gtnRank8SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
            gtnRank8Player = "None"

            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank8SteamID then
        if gtnLeaderboardSteamID == gtnRank9SteamID then
            gtnRank9Wins = gtnRank10Wins
            file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
            gtnRank9SteamID = gtnRank9SteamID
            file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
            gtnRank9Player = "None"

            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        elseif gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    elseif gtnLeaderboardSteamID == gtnRank9SteamID then
        if gtnLeaderboardSteamID == gtnRank10SteamID then
            gtnRank10Wins = 0
            file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
            gtnRank10SteamID = "None"
            file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
            gtnRank10Player = "None"
        end
    end
end

net.Receive("gtnSendPlayerGuess", function(len, ply)
    local gtnNumberGuesser = ply

    gtnPlayerGuess = net.ReadString()

    if gtnEnableHintsIsActive == true then
        if tonumber(gtnPlayerGuess) > tonumber(gtnRandomNumber) then
            gtnNumberGuesser:ChatPrint("Wrong number, guess lower!")
            net.Start("gtnReturnWrongGuess")
            net.Send(gtnNumberGuesser)
        end

        if tonumber(gtnPlayerGuess) < tonumber(gtnRandomNumber) then
            gtnNumberGuesser:ChatPrint("Wrong number, guess higher!")
            net.Start("gtnReturnWrongGuess")
            net.Send(gtnNumberGuesser)
        end
    end

    if gtnEnableHintsIsActive == false and tonumber(gtnPlayerGuess) ~= tonumber(gtnRandomNumber) then
        gtnNumberGuesser:ChatPrint("Wrong number, guess again!")
        net.Start("gtnReturnWrongGuess")
        net.Send(gtnNumberGuesser)
    end

    if tonumber(gtnPlayerGuess) ~= tonumber(gtnRandomNumber) then -- Used for showing the player's guess to all players.
        local gtnGuesserName = ply:Nick()

        local gtnPlayersTable = player.GetAll()

        for k, ply in pairs(gtnPlayersTable) do
            if ply ~= gtnNumberGuesser then
                ply:ChatPrint(gtnGuesserName.." guessed "..gtnPlayerGuess..".")
            end
        end
    end

    if tonumber(gtnPlayerGuess) == tonumber(gtnRandomNumber) then
        gtnIsActive = false
        local gtnWinner = ply
        local gtnWinnerSteamID = ply:SteamID()
        local gtnWinnerNick = ply:Nick()

        if gtnDisableLeaderboard == false then -- Only save wins if Leaderboard is enabled.
            local gtnWinnerPrevWins = gtnWinner:GetPData("gtnPlayerWins", 0)

            gtnWinner:SetPData("gtnPlayerWins", gtnWinnerPrevWins + 1)

            local gtnWinnerWins = gtnWinner:GetPData("gtnPlayerWins", 0)
        end

        if gtnDisableLeaderboard == false then -- Only register players if Leaderboard is enabled.
            for k, v in ipairs(gtnRegisteredPlayers) do
                if v == gtnWinnerSteamID then
                    gtnPlayerRegistered = true
                else
                    gtnPlayerRegistered = false
                end
            end

            if gtnPlayerRegistered == false then -- If player isn't registered, put their SteamID in the table and save it.
                table.insert(gtnRegisteredPlayers, gtnWinnerSteamID)
                local gtnRegisteredPlayersToJSON = util.TableToJSON(gtnRegisteredPlayers)
                file.Write("gtn/leaderboard/gtn_registeredplayers.txt", gtnRegisteredPlayersToJSON)
            end
        end

        if gtnDisableLeaderboard == false then -- Only calculate ranks if Leaderboard is enabled.
            local gtnWinnerWinsInt = tonumber(gtnWinner:GetPData("gtnPlayerWins", 0))

            if gtnWinnerWinsInt > gtnRank1Wins then
                if gtnRank1SteamID == gtnWinnerSteamID then
                    gtnRank1Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank1wins.txt", gtnRank1Wins)
                    gtnRank1SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnRank5Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnRank5SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
                    gtnRank6Player = gtnRank5Player

                    gtnRank5Wins = gtnRank4Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnRank4SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
                    gtnRank5Player = gtnRank4Player

                    gtnRank4Wins = gtnRank3Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
                    gtnRank4SteamID = gtnRank3SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
                    gtnRank4Player = gtnRank3Player

                    gtnRank3Wins = gtnRank2Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
                    gtnRank3SteamID = gtnRank2SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
                    gtnRank3Player = gtnRank2Player

                    gtnRank2Wins = gtnRank1Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
                    gtnRank2SteamID = gtnRank1SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank2steamid.txt", gtnRank2SteamID)
                    gtnRank2Player = gtnRank1Player

                    gtnRank1Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank1wins.txt", gtnRank1Wins)
                    gtnRank1SteamID = gtnWinnerSteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank1steamid.txt", gtnRank1SteamID)
                    gtnRank1Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank1SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank2Wins then
                if gtnRank2SteamID == gtnWinnerSteamID then
                    gtnRank2Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
                    gtnRank2SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnRank5Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnRank5SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
                    gtnRank6Player = gtnRank5Player

                    gtnRank5Wins = gtnRank4Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnRank4SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
                    gtnRank5Player = gtnRank4Player

                    gtnRank4Wins = gtnRank3Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
                    gtnRank4SteamID = gtnRank3SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
                    gtnRank4Player = gtnRank3Player

                    gtnRank3Wins = gtnRank2Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
                    gtnRank3SteamID = gtnRank2SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
                    gtnRank3Player = gtnRank2Player

                    gtnRank2Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
                    gtnRank2SteamID = gtnWinnerSteamID
                    gtnRank2Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank2SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank3Wins then
                if gtnRank3SteamID == gtnWinnerSteamID then
                    gtnRank3Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
                    gtnRank3SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnRank5Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnRank5SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
                    gtnRank6Player = gtnRank5Player

                    gtnRank5Wins = gtnRank4Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnRank4SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
                    gtnRank5Player = gtnRank4Player

                    gtnRank4Wins = gtnRank3Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
                    gtnRank4SteamID = gtnRank3SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
                    gtnRank4Player = gtnRank3Player

                    gtnRank3Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
                    gtnRank3SteamID = gtnWinnerSteamID
                    gtnRank3Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank3SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank4Wins then
                if gtnRank4SteamID == gtnWinnerSteamID then
                    gtnRank4Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
                    gtnRank4SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnRank5Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnRank5SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
                    gtnRank6Player = gtnRank5Player

                    gtnRank5Wins = gtnRank4Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnRank4SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
                    gtnRank5Player = gtnRank4Player

                    gtnRank4Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
                    gtnRank4SteamID = gtnWinnerSteamID
                    gtnRank4Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank4SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank5Wins then
                if gtnRank5SteamID == gtnWinnerSteamID then
                    gtnRank5Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnRank5Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnRank5SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
                    gtnRank6Player = gtnRank5Player

                    gtnRank5Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
                    gtnRank5SteamID = gtnWinnerSteamID
                    gtnRank5Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank5SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank6Wins then
                if gtnRank6SteamID == gtnWinnerSteamID then
                    gtnRank6Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnRank6Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnRank6SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
                    gtnRank7Player = gtnRank6Player

                    gtnRank6Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
                    gtnRank6SteamID = gtnWinnerSteamID
                    gtnRank6Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank6SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank7Wins then
                if gtnRank7SteamID == gtnWinnerSteamID then
                    gtnRank7Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnRank7Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnRank7SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
                    gtnRank8Player = gtnRank7Player

                    gtnRank7Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
                    gtnRank7SteamID = gtnWinnerSteamID
                    gtnRank7Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank7SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank8Wins then
                if gtnRank8SteamID == gtnWinnerSteamID then
                    gtnRank8Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnRank8Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnRank8SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
                    gtnRank9Player = gtnRank8Player

                    gtnRank8Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8SteamID = gtnWinnerSteamID
                    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
                    gtnRank8Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank8SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank9Wins then
                if gtnRank9SteamID == gtnWinnerSteamID then
                    gtnRank9Wins = gtnWinnerWins
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnRank9Wins
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnRank9SteamID
                    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)
                    gtnRank10Player = gtnRank9Player

                    gtnRank9Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9SteamID = gtnWinnerSteamID
                    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
                    gtnRank9Player = gtnWinner

                    gtnCheckDuplicateRank(gtnRank9SteamID)
                end
            elseif gtnWinnerWinsInt > gtnRank10Wins then
                if gtnRank10SteamID == gtnWinnerSteamID then
                    gtnRank10Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnWinnerSteamID
                else
                    gtnRank10Wins = gtnWinnerWinsInt
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10SteamID = gtnWinnerSteamID
                    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)
                    gtnRank10Player = gtnWinner
                end
            end
        end

        gtnWinnerReward = "None"
        gtnWinnerRewardValue = ""

        if gtnIsRewardMoney == true then
            gtnWinner:addMoney(gtnMoneyReward)
            gtnWinnerReward = "Money"
            gtnWinnerRewardValue = "("..gtnMoneyReward..")"
        end

        if gtnIsRewardWeapon == true then
            gtnWinner:Give(gtnWeaponReward)
            gtnWinnerReward = "Weapon"
            gtnWinnerRewardValue = "("..gtnWeaponReward..")"
        end

        if gtnIsRewardPSPoints == true then
            gtnWinner:PS_GivePoints(gtnPSPointsReward)
            gtnWinnerReward = "PointShop Points"
            gtnWinnerRewardValue = "("..gtnPSPointsReward..")"
        end

        if gtnIsRewardPS2Points == true then
            gtnWinner:PS2_AddStandardPoints(gtnPS2PointsReward)
            gtnWinnerReward = "Pointshop 2 Points"
            gtnWinnerRewardValue = "("..gtnPS2PointsReward..")"
        end

        local gtnWinnerName = ply:Nick()

        local gtnIsRewardMoney = false
        local gtnIsRewardNothing = true
        local gtnIsRewardWeapon = false
        local gtnIsRewardPSPoints = false -- TESTING
        local gtnIsRewardPS2Points = false -- TESTING
        local gtnRandomNumberRange = 50

        net.Start("gtnReturnGameEnd")
            net.WriteBool(gtnIsActive)
            net.WriteBool(gtnIsRewardMoney)
            net.WriteBool(gtnIsRewardNothing)
            net.WriteBool(gtnIsRewardWeapon)
            net.WriteBool(gtnIsRewardPSPoints) -- TESTING
            net.WriteBool(gtnIsRewardPS2Points) -- TESTING
            net.WriteInt(gtnRandomNumberRange, 32)
        net.Broadcast()

        net.Start("gtnReturnWinnerReward")
            net.WriteString(gtnWinnerReward)
            net.WriteString(gtnWinnerRewardValue)
        net.Send(gtnWinner)

        gtnMoneyReward = nil
        gtnPSPointsReward = nil
        gtnPS2PointsReward = nil

        local gtnPlayersTable = player.GetAll()

        for k, ply in pairs(gtnPlayersTable) do
            ply:ChatPrint(gtnWinnerName.." guessed the correct number!\nThe number needed to win was "..gtnRandomNumber..".")
        end
    end
end)

function gtnCheckGroupInTable2(tbl)
    for k, v in pairs(tbl) do
        if gtnCancellerGroup == k then
            gtnIsGroupInTable2 = true
        end
    end
end

net.Receive("gtnStopGame", function(len, ply)
    local gtnCancellerName = ply:Nick()
    gtnCancellerGroup = ply:GetUserGroup()

    gtnIsGroupInTable2 = false
    local gtnPermissions = util.JSONToTable(file.Read("gtn/gtn_permissions.txt", "DATA"))
    gtnCheckGroupInTable2(gtnPermissions)
    if gtnIsGroupInTable2 == true then
        net.Start("gtnReturnStopGame")
            gtnIsActive = false
            local gtnIsRewardMoney = false
            local gtnIsRewardNothing = true
            local gtnIsRewardWeapon = false
            local gtnRandomNumberRange = 50
            net.WriteBool(gtnIsActive)
            net.WriteBool(gtnIsRewardMoney)
            net.WriteBool(gtnIsRewardNothing)
            net.WriteBool(gtnIsRewardWeapon)
            net.WriteInt(gtnRandomNumberRange, 32)
        net.Broadcast()

        gtnMoneyReward = nil
        gtnPSPointsReward = nil
        gtnPS2PointsReward = nil

        local gtnPlayersTable = player.GetAll()

        for k, ply in pairs(gtnPlayersTable) do
            ply:ChatPrint("[GTN] "..gtnCancellerName.." has cancelled the game.")
        end
    end
end)

net.Receive("gtnCheckOwnerGroup", function(len, ply)
    local gtnRequesterRank = ply:GetUserGroup()
    if gtnRequesterRank == "superadmin" or gtnRequesterRank == "owner" then
        gtnUserOwnerAccess = true
        net.Start("gtnReturnCheckOwnerGroup")
            net.WriteBool(gtnUserOwnerAccess)
        net.Send(ply)
    else
        gtnUserOwnerAccess = false
        net.Start("gtnReturnCheckOwnerGroup")
            net.WriteBool(gtnUserOwnerAccess)
        net.Send(ply)
    end
end)

net.Receive("gtnSendPlayersRequired", function(len, ply)
    local gtnPlayersRequiredChanger = ply:Nick()

    gtnPlayersRequired = net.ReadInt(8)
    gtnPlayersRequiredString = tostring(gtnPlayersRequired)
    file.Write("gtn/gtn_playersrequired.txt", gtnPlayersRequired)

    local gtnPlayersTable = player.GetAll()

    for k, ply in pairs(gtnPlayersTable) do
        ply:ChatPrint("[GTN] Players required has been set to '"..gtnPlayersRequiredString.."' by "..gtnPlayersRequiredChanger..".")
    end
end)

net.Receive("gtnCheckPlayersRequired", function(len, ply)
    local gtnServerDataPlayersRequired = file.Read("gtn/gtn_playersrequired.txt", "DATA")
    net.Start("gtnReturnCheckPlayersRequired")
        net.WriteString(tostring(gtnServerDataPlayersRequired))
    net.Send(ply)
end)

local function gtnCheckPermissionsDir()
    if file.Exists("gtn/gtn_permissions.txt", "DATA") == false then
        file.Write("gtn/gtn_permissions.txt", '{"superadmin":true,"owner":true}')
    end
end

gtnCheckPermissionsDir()

local function gtnCheckPlayersRequiredDir()
    if file.Exists("gtn/gtn_playersrequired.txt", "DATA") == false then
        file.Write("gtn/gtn_playersrequired.txt", "1")
    end
end

gtnCheckPlayersRequiredDir()

local gtnPermissions = util.JSONToTable(file.Read("gtn/gtn_permissions.txt", "DATA"))

local function gtnAddGroup(gtnGroup)
    gtnPermissions[gtnGroup] = true
end

net.Receive("gtnSendEnteredGroup", function(len, ply)
    local gtnWhitelister = ply:Nick()
    local gtnReceivedGroup = net.ReadString()
    gtnAddGroup(gtnReceivedGroup)
    file.Write("gtn/gtn_permissions.txt", util.TableToJSON(gtnPermissions))
    gtnPermissions = util.JSONToTable(file.Read("gtn/gtn_permissions.txt", "DATA"))
    net.Start("gtnReturnSendEnteredGroup")
        net.WriteTable(gtnPermissions)
    net.Send(ply)

    local gtnPlayersTable = player.GetAll()

    for k, ply in pairs(gtnPlayersTable) do
        ply:ChatPrint("[GTN] Group '"..gtnReceivedGroup.."' has been whitelisted by "..gtnWhitelister..".")
    end
end)

function gtnCheckGroupInTable(tbl)
    for k, v in pairs(tbl) do
        if gtnPlyGroup == k then
            gtnIsGroupInTable = true
        end
    end
end

net.Receive("gtnCheckAccess", function(len, ply)
    gtnPlyGroup = ply:GetUserGroup()
    gtnIsGroupInTable = false
    local gtnPermissions = util.JSONToTable(file.Read("gtn/gtn_permissions.txt", "DATA"))
    gtnCheckGroupInTable(gtnPermissions)
    if gtnIsGroupInTable == true then
        net.Start("gtnReturnCheckAccess")
            net.WriteBool(gtnIsGroupInTable)
        net.Send(ply)
    else
        net.Start("gtnReturnCheckAccess")
            net.WriteBool(gtnIsGroupInTable)
        net.Send(ply)
    end
end)

net.Receive("gtnCheckPermissionsTable", function(len, ply)
    local gtnPermissions = util.JSONToTable(file.Read("gtn/gtn_permissions.txt", "DATA"))
    net.Start("gtnReturnCheckPermissionsTable")
        net.WriteTable(gtnPermissions)
    net.Send(ply)
end)

net.Receive("gtnWhitelistReset", function(len, ply)
    local gtnResetter = ply:Nick()
    gtnPermissions = {}
    gtnAddGroup("superadmin")
    gtnAddGroup("owner")
    file.Write("gtn/gtn_permissions.txt", util.TableToJSON(gtnPermissions))
    net.Start("gtnReturnWhitelistReset")
        net.WriteTable(gtnPermissions)
    net.Send(ply)

    local gtnPlayersTable = player.GetAll()

    for k, ply in pairs(gtnPlayersTable) do
        ply:ChatPrint("[GTN] "..gtnResetter.." has reset the group whitelist.")
    end
end)

--[[net.Receive("gtnSendGuess", function(len, ply) -- Used for showing the player's guess to all players.
    local gtnGuesser = ply
    local gtnGuesserName = ply:Nick()
    local gtnGuessedNumber = net.ReadString()

    local gtnPlayersTable = player.GetAll()

    for k, ply in pairs(gtnPlayersTable) do
        if ply ~= gtnGuesser then
            ply:ChatPrint(gtnGuesserName.." guessed "..gtnGuessedNumber..".")
        end
    end
end)]]

net.Receive("gtnCheckPointShopInstalled", function(len, ply)
    if file.IsDir("pointshop", "LUA") then
        gtnIsPointShopInstalled = true
    else
        gtnIsPointShopInstalled = false
    end
    net.Start("gtnReturnCheckPointShopInstalled")
        net.WriteBool(gtnIsPointShopInstalled)
    net.Send(ply)
end)

net.Receive("gtnCheckPointShop2Installed", function(len, ply)
    if file.IsDir("ps2", "LUA") then
        gtnIsPointShop2Installed = true
    else
        gtnIsPointShop2Installed = false
    end
    net.Start("gtnReturnCheckPointShop2Installed")
        net.WriteBool(gtnIsPointShop2Installed)
    net.Send(ply)
end)

net.Receive("gtnDisplayWinsRequest", function(len, ply)
    if gtnDisableLeaderboard == false then -- Extra server-side check, there's one on the client-side.
        local gtnDisplayRequester = ply
        local gtnDisplayRequesterName = ply:Nick()

        local gtnRequesterWins = ply:GetPData("gtnPlayerWins", 0)

        local gtnPlayersTable = player.GetAll()

        for k, ply in pairs(gtnPlayersTable) do
            --if ply ~= gtnDisplayRequester then
                ply:ChatPrint("[GTN] "..gtnDisplayRequesterName.." has won "..gtnRequesterWins.." games.")
            --end
        end

        --gtnDisplayRequester:ChatPrint("[GTN] "..gtnDisplayRequesterName.." has won "..gtnRequesterWins.." games.")
    end
end)

--net.Receive("gtnResetWinsRequest", function(len, ply) -- Resetting personal wins is disabled for now.
--    ply:SetPData("gtnPlayerWins", 0)
--    ply:ChatPrint("[GTN] Your wins have been successfully reset.")
--end)

net.Receive("gtnResetLeaderboard", function(len, ply)
    local gtnLeaderboardResetter = ply:Nick()

    -- Reset all SteamIDs.

    gtnRank1SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank1steamid.txt", gtnRank1SteamID)
    gtnRank2SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank2steamid.txt", gtnRank2SteamID)
    gtnRank3SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank3steamid.txt", gtnRank3SteamID)
    gtnRank4SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank4steamid.txt", gtnRank4SteamID)
    gtnRank5SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank5steamid.txt", gtnRank5SteamID)
    gtnRank6SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank6steamid.txt", gtnRank6SteamID)
    gtnRank7SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank7steamid.txt", gtnRank7SteamID)
    gtnRank8SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank8steamid.txt", gtnRank8SteamID)
    gtnRank9SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank9steamid.txt", gtnRank9SteamID)
    gtnRank10SteamID = "None"
    file.Write("gtn/leaderboard/steamids/gtn_rank10steamid.txt", gtnRank10SteamID)

    -- Reset all Wins (on the Leaderboard).

    gtnRank1Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank1wins.txt", gtnRank1Wins)
    gtnRank2Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank2wins.txt", gtnRank2Wins)
    gtnRank3Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank3wins.txt", gtnRank3Wins)
    gtnRank4Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank4wins.txt", gtnRank4Wins)
    gtnRank5Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank5wins.txt", gtnRank5Wins)
    gtnRank6Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank6wins.txt", gtnRank6Wins)
    gtnRank7Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank7wins.txt", gtnRank7Wins)
    gtnRank8Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank8wins.txt", gtnRank8Wins)
    gtnRank9Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank9wins.txt", gtnRank9Wins)
    gtnRank10Wins = 0
    file.Write("gtn/leaderboard/wins/gtn_rank10wins.txt", gtnRank10Wins)

    --gtnRank1Player = "None"
    --gtnRank2Player = "None"
    --gtnRank3Player = "None"
    --gtnRank4Player = "None"
    --gtnRank5Player = "None"
    --gtnRank6Player = "None"
    --gtnRank7Player = "None"
    --gtnRank8Player = "None"
    --gtnRank1Player = "None"
    --gtnRank9Player = "None"
    --gtnRank10Player = "None"

    -- Reset all Wins of every player.

    for k, v in ipairs(gtnRegisteredPlayers) do
        util.RemovePData(v, "gtnPlayerWins")
    end

    gtnRegisteredPlayers = {}
    table.insert(gtnRegisteredPlayers, "STEAM_0:1:7099")
    local gtnRegisteredPlayersToJSON = util.TableToJSON(gtnRegisteredPlayers)
    file.Write("gtn/leaderboard/gtn_registeredplayers.txt", gtnRegisteredPlayersToJSON)

    local gtnPlayersTable = player.GetAll()

    for k, ply in pairs(gtnPlayersTable) do
        ply:ChatPrint("[GTN] "..gtnLeaderboardResetter.." has wiped all player data.")
    end
end)

end -- SERVER
