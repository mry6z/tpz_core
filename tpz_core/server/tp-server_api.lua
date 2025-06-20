exports('getCoreAPI', function()
    local self = {}

    self.addNewCallBack = function(name, cb) TriggerEvent("tpz_core:addNewCallBack", name, cb) end

    self.GetConfig = function()
        return Config
    end
        
    self.GetLocales = function(string)
        
        local str = Locales[string]

        if Locales[string] == nil then 
            str = "Locale `" .. string .. "` does not seem to exist." 
        end

        return str
    end

    self.StartsWith = function(inputString, findString)
        return string.sub(inputString, 1, string.len(findString)) == findString
    end

    self.Round = function(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    self.GetTableLength = function(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    
    self.Split = function(inputstr, sep)
        if sep == nil then
            sep = "%s"
        end

        local t = {}

        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
        end

        return t

    end

    -- Notifications
    self.NotifyLeft = function(source, firsttext, secondtext, dict, icon, duration, color)
        TriggerClientEvent('tpz_core:sendLeftNotification', source, firsttext, secondtext, dict, icon, duration, color)
    end

    self.NotifyTip = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendTipNotification', source, text, duration)
    end

    self.NotifyTop = function(source, text, location, duration)
        TriggerClientEvent('tpz_core:sendTopNotification', source, text, location, duration)
    end

    self.NotifyRightTip = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, text, duration)
    end

    self.NotifyObjective = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, text, duration)
    end

    self.NotifySimpleTop = function(source, title, subtitle, duration)
        TriggerClientEvent('tpz_core:sendSimpleTopNotification', source, title, subtitle, duration)
    end

    self.NotifyAvanced = function(source, text, dict, icon, text_color, duration, quality)
        TriggerClientEvent('tpz_core:sendAdvancedRightNotification', source, text, dict, icon, text_color, duration, quality)
    end

    self.NotifyBasicTop = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBasicTopNotification', source, text, duration)
    end

    self.NotifyCenter = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendSimpleCenterNotification', source, text, duration)
    end

    self.NotifyBottomRight = function(source, text, duration)
        TriggerClientEvent('tpz_core:sendBottomRightNotification', source, text, duration)
    end

    self.NotifyFail = function(source, title, subtitle, duration)
        TriggerClientEvent('tpz_core:sendFailMissionNotification', source, title, subtitle, duration)
    end

    self.NotifyDead = function(source, title, audioRef, audioName, duration)
        TriggerClientEvent('tpz_core:sendDeadPlayerNotification', source, title, audioRef, audioName, duration)
    end

    self.NotifyUpdate = function(source, utitle, umsg, duration)
        TriggerClientEvent('tpz_core:sendMissionUpdateNotification', source, utitle, umsg, duration)
    end

    self.NotifyWarning = function(source, title, msg, audioRef, audioName, duration)
        TriggerClientEvent('tpz_core:sendWarningNotification', source, title, msg, audioRef, audioName, duration)
    end

    self.NotifyLeftRank = function(source, title, subtitle, dict, icon, duration, color)
        TriggerClientEvent('tpz_core:sendLeftRankNotification', source, title, subtitle, dict, icon, duration, color)
    end -- End of notifications

    -- Character API Directly by getting the Player Object.

    self.GetPlayer = function(source) 

        local _source   = source
        local functions = {}

        functions.loaded = function()
            return PlayerData[_source] ~= nil
        end
    
        functions.getTotalCharactersNum = function()

            local await = true
            local currentChars = 0

            exports["ghmattimysql"]:execute("SELECT * FROM characters WHERE identifier = @identifier", { ["@identifier"] = PlayerData[_source].identifier }, function(result)

                for index, results in pairs (result) do
                    currentChars = currentChars + 1
                end

                await = false

            end)

            while await do 
                Wait(50)
            end

            return currentChars

        end

        functions.getIdentifier = function()
            return PlayerData[_source].identifier
        end
    
        functions.getCharacterIdentifier = function()
            return PlayerData[_source].charIdentifier
        end
    
        functions.getGender = function()
            return PlayerData[_source].gender
        end
    
        functions.getDob = function()
            return PlayerData[_source].dob
        end
    
        functions.setDob = function(day, month, year)
            PlayerData[_source].dob = tostring(day) .. '/' ..  tostring(month) .. '/' ..  tostring(year)
        end

        functions.isDead = function()
            return PlayerData[_source].isDead
        end
    
        functions.getDefaultUsedWeaponId = function()
            return PlayerData[_source].default_weapon
        end
    
        functions.setDefaultUsedWeapon = function(weaponId)
            PlayerData[_source].default_weapon = weaponId
        end
    
        functions.getIdentityId = function()
            return PlayerData[_source].identity_id
        end
    
        functions.changeIdentityId = function()
    
            math.randomseed(os.time())
    
            local generatedIdentityId = ""
    
            for i = 1, Config.IdentityIdGeneratedData.numbers do 
                local randomIdentityNumber = math.random(0, 9)
                generatedIdentityId = tostring(generatedIdentityId) .. tostring(randomIdentityNumber)
            end
        
            generatedIdentityId = Config.IdentityIdGeneratedData.first_letters .. os.date('%M') .. os.date('%S') .. generatedIdentityId
    
            PlayerData[_source].identity_id = generatedIdentityId
        end
    
        functions.getGroup = function()
            return PlayerData[_source].group
        end
    
        functions.setGroup = function(group)
            PlayerData[_source].group = group
            TriggerClientEvent("tpz_core:getPlayerGroup", tonumber(target), PlayerData[_source].group )
        end
    
        functions.getFirstName = function()
            return PlayerData[_source].firstname
        end
    
        functions.setFirstName = function(firstname)
            PlayerData[_source].firstname = firstname
        end
    
        functions.getLastName = function()
            return PlayerData[_source].lastname
        end
    
        functions.setLastName = function(lastname)
            PlayerData[_source].lastname = lastname
        end
    
        functions.getJob = function()
            return PlayerData[_source].job
        end
    
        functions.setJob = function(job)
            PlayerData[_source].job = job
            TriggerClientEvent("tpz_core:getPlayerJob", _source, { job = PlayerData[_source].job, jobGrade = PlayerData[_source].jobGrade })
        end
    
        functions.getJobGrade = function()
            return PlayerData[_source].jobGrade
        end
    
        functions.setJobGrade = function(grade)
            PlayerData[_source].jobGrade = grade
            TriggerClientEvent("tpz_core:getPlayerJob", _source, { job = PlayerData[_source].job, jobGrade = PlayerData[_source].jobGrade })
        end
    
        functions.getOutfitComponents = function()
            return PlayerData[_source].skinComp
        end
    
        functions.getAccount = function(currency_type)
    
            if (PlayerData[_source].account[currency_type]) then
                return tonumber(PlayerData[_source].account[currency_type])
            else 
                print("Error: This currency type (" .. currency_type .. ") does not exist.")
                return 0
            end
    
        end
    
        functions.addAccount = function(currency_type, quantity) 
    
            if (PlayerData[_source].account[currency_type]) then
                PlayerData[_source].account[currency_type] = PlayerData[_source].account[currency_type] + quantity
            else
                print("Error: This currency type (" .. currency_type .. ") does not exist.")
            end
        end
    
        functions.removeAccount = function(currency_type, quantity) 
    
            if (PlayerData[_source].account[currency_type]) then
    
                local success = true
    
                if Config.NegativeValueOnAccounts then
                    PlayerData[_source].account[currency_type] = PlayerData[_source].account[currency_type] - quantity
    
                else
                    
                    PlayerData[_source].account[currency_type] = PlayerData[_source].account[currency_type] - quantity
    
                    if PlayerData[_source].account[currency_type] <= 0 then
    
                        PlayerData[_source].account[currency_type] = 0
    
                    end
    
                end
    
                return success
    
            else 
                print("Error: This currency type (" .. currency_type .. ") does not exist.")
                return false
            end
        end
    
        functions.getLastSavedLocation = function()
            return json.decode(PlayerData[_source].coords)
        end
    
        functions.saveLocation = function(coords, heading)

            local newCoords = nil
    
            if coords then
    
                newCoords                  = { x = coords.x, y = coords.y, z = coords.z, heading = heading }
                PlayerData[_source].coords = { x = coords.x, y = coords.y, z = coords.z, heading = heading }
    
            else
                local playerPed            = GetPlayerPed(_source)
                local _coords, _heading    = GetEntityCoords(playerPed), GetEntityHeading(playerPed)
    
                newCoords                  = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
                PlayerData[_source].coords = {x = _coords.x, y = _coords.y, z = _coords.z, heading = _heading }
            end
    
            while newCoords == nil do
                Wait(100)
            end
    
            SavePlayerLocationInDatabase(_source, newCoords)
        end
    
        functions.teleportToCoords = function(coords)
            TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(coords.x), tonumber(coords.y), tonumber(coords.z), tonumber(coords.h))
        end
        
        functions.teleportTo = function(targetSource)
            local _tsource = targetSource
    
            if PlayerData[_tsource] then
    
                local coords = GetEntityCoords(GetPlayerPed(_tsource))
                TriggerClientEvent('tpz_core:teleportToCoords', _source, tonumber(coords.x), tonumber(coords.y), tonumber(coords.z), tonumber(coords.h))
    
            else
                print('Teleport (GoTo) attempt to a player who is still in session')
            end
        end
    
        functions.bring = function(targetSource)
            local _tsource = targetSource
    
            if PlayerData[_tsource] then
    
                local coords = GetEntityCoords(GetPlayerPed(_source))
                TriggerClientEvent('tpz_core:teleportToCoords', _tsource, tonumber(coords.x), tonumber(coords.y), tonumber(coords.z), tonumber(coords.h))
    
            else
                print('Teleport (Bring) attempt to a player who is still in session')
            end
        end
    
        functions.getDiscordRoles = function()
    
            local userRoles  = GetUserDiscordRoles(_source, Config.DiscordServerID)
        
            if not userRoles or userRoles == nil then
                userRoles = {}
            end
        
            return userRoles
        
        end
    
        functions.hasPermissionsByAce = function(ace)
            return HasPermissionsByAce(ace, _source)
        end

        functions.hasAdministratorPermissions = function(groups, discordRoles)
    
            if GetTableLength(groups) > 0 and PlayerData[_source] then
    
                for _, group in pairs (groups) do
                
                    if group == PlayerData[_source].group then
                        return true
                    end
              
                end
        
            end
    
            
            local userRoles  = GetUserDiscordRoles(_source, Config.DiscordServerID)
        
            if not userRoles or userRoles == nil then
                userRoles = {}
            end
    
            if GetTableLength(userRoles) > 0 and GetTableLength(discordRoles) > 0 then
    
                for _, role in pairs (discordRoles) do
      
                    for _, userRole in pairs (userRoles) do
                      
                      if tonumber(userRole) == tonumber(role) then
                        return true
                      end
                
                    end
        
                end
    
            end
    
            return false
    
        end
    
        functions.saveCharacter = function()
            SaveCharacter(_source)
        end
    
        functions.suicide = function()
            TriggerClientEvent('tpz_core:applyLethalDamage', _source)
        end
    
        functions.disconnect = function(reason)
            DropPlayer(_source, reason)
        end
			
        functions.ban = function(reason, duration)
            BanPlayerBySource(_source, reason, duration)
        end

        functions.addWarning = function()
            return AddPlayerWarning(_source) -- returns a boolean, if true the player is banned for reaching the maximum warnings.
        end

        functions.setWarnings = function(warnings)
            return SetPlayerWarnings(_source, warnings) -- returns a boolean, if true the player is banned for reaching the maximum warnings.
        end

        functions.clearPlayerWarnings = function()
            ClearPlayerWarnings(_source)
        end    
    
        functions.deleteCharacter = function(reason)
    
            local Parameters = { 
                ['identifier']     = PlayerData[_source].identifier, 
                ['charidentifier'] = PlayerData[_source].charIdentifier, 
            }
    
            exports.ghmattimysql:execute("DELETE FROM `characters` WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier", Parameters)
            
            PlayerData[_source] = nil
            DropPlayer(_source, reason)
    
        end

        -- Inventory API functions combined with xPlayer Object.

        functions.getInventoryContents = function()
            return exports['tpz_inventory']:getInventoryAPI().getInventoryContents(_source)
        end
    
        functions.removeItem = function(item, quantity, itemId)
            exports['tpz_inventory']:getInventoryAPI().removeItem(_source, item, quantity, itemId)
        end

        functions.removeItemById = function(itemId)
            exports['tpz_inventory']:getInventoryAPI().removeItemById(_source, itemId)
        end
    
        functions.removeWeapon = function(weapon, weaponId)
            exports['tpz_inventory']:getInventoryAPI().removeWeapon(_source, weapon, weaponId)
        end

        functions.removeWeaponById = function(weaponId)
            exports['tpz_inventory']:getInventoryAPI().removeWeaponById(_source, weaponId)
        end

        functions.addItem = function(item, quantity, metadata)
            exports['tpz_inventory']:getInventoryAPI().addItem(_source, item, quantity, metadata)
        end
    
        functions.canCarryWeight = function(totalWeight)
            return exports['tpz_inventory']:getInventoryAPI().canCarryWeight(_source, totalWeight)
        end
    
        functions.canCarryItem = function(item, quantity)
            return exports['tpz_inventory']:getInventoryAPI().canCarryItem(_source, item, quantity)
        end
    
        functions.canCarryWeapon = function(weaponName)
            return exports['tpz_inventory']:getInventoryAPI().canCarryWeapon(_source, weaponName)
        end
    
        functions.doesPlayerHaveWeapon = function(item, itemId)
            return exports['tpz_inventory']:getInventoryAPI().doesPlayerHaveWeapon(_source, item, itemId)
        end
    
        functions.getItemQuantity = function(item)
            return exports['tpz_inventory']:getInventoryAPI().getItemQuantity(_source, item)
        end
    
        functions.getInventoryTotalWeight = function()
            return exports['tpz_inventory']:getInventoryAPI().getInventoryTotalWeight(_source)
        end
    
        functions.addItemDurability = function(item, durability, itemId)
            exports['tpz_inventory']:getInventoryAPI().addItemDurability(_source, item, durability, itemId)
        end

        functions.addWeaponDurability = function(weaponName, value, weaponId)
            exports['tpz_inventory']:getInventoryAPI().addWeaponDurability(_source, weaponName, value, weaponId)
        end
    
        functions.removeWeaponDurability = function(weaponName, value, weaponId)
            exports['tpz_inventory']:getInventoryAPI().removeWeaponDurability(_source, weaponName, value, weaponId)
        end

        functions.removeItemDurability = function(item, durability, itemId, remove)
            exports['tpz_inventory']:getInventoryAPI().removeItemDurability(_source, item, durability, itemId, remove)
        end
    
        functions.getItemDurability = function(item, itemId)
            return exports['tpz_inventory']:getInventoryAPI().getItemDurability(_source, item, itemId)
        end
    
        functions.getItemMetadata = function(item, itemId)
            return exports['tpz_inventory']:getInventoryAPI().getItemMetadata(_source, item, itemId)
        end
    
        functions.addItemMetadata = function(item, itemId, metadata)
            exports['tpz_inventory']:getInventoryAPI().addItemMetadata(_source, item, itemId, metadata)
        end
        
        functions.saveInventoryContents = function()
            exports['tpz_inventory']:getInventoryAPI().saveInventoryContents(_source)
        end
    
        functions.clearInventoryContents = function()
            exports['tpz_inventory']:getInventoryAPI().clearInventoryContents(_source)
        end
    
        functions.addWeapon = function(weaponName, weaponItemId, metadata)
            exports['tpz_inventory']:getInventoryAPI().addWeapon(_source, weaponName, weaponItemId, metadata)
        end

        functions.closeInventory = function()
            TriggerClientEvent('tpz_inventory:closePlayerInventory', _source)
        end

        return functions

    end

    self.GetPlayerByIdentifier = function(identifier)

        local playerList   = GetPlayers()
        
        local playerObject = nil
        local wait         = true

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] then

                if tostring(PlayerData[player].identifier) == tostring(identifier) then

                    playerObject = exports.tpz_core:getCoreAPI().GetPlayer(player)
                    wait = false
                    break
                end

            end

            if next(playerList, index) == nil then
                wait = false
            end

        end

        while wait do
            Wait(25)
        end

        return playerObject
        
    end
		
    self.BanPlayerBySteamIdentifier = function(steamIdentifier, reason, duration)
        BanPlayerBySteamIdentifier(steamIdentifier, reason, duration)
    end

    self.ResetBanBySteamIdentifier = function(steamIdentifier)
        ResetBanBySteamIdentifier(steamIdentifier)
    end

    self.GetUserData = function(source)
        return GetUserData(source)
    end

    self.SetUserMaxCharacters = function(source, chars)
        if (chars == nil or chars <= 1) then
            chars = 1
        end

        SetUserMaxCharacters(source, chars)
    end
		
    -- returns a table with all online players who are NOT in a session (character select).
    -- @param data.players
    -- @param data.count
    self.GetPlayers = function()
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] then

                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    -- returns a table with all online players who ARE in a session.
    -- @param data.players
    -- @param data.count
    self.GetPlayersInSession = function()
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] == nil then

                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    -- returns a table with all the online players who are NOT in a session based on the input job.
    -- @param data.players
    -- @param data.count
    self.GetJobPlayers = function(job)
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] and PlayerData[player].job == job then

                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    -- returns a table with all the online players who are NOT in a session based on the input group.
    -- @param data.players
    -- @param data.count
    self.GetGroupPlayers = function(group)
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] and PlayerData[player].group == group then

                data.count = data.count + 1
                table.insert(data.players, { source = player } )
            end

        end

        return data

    end

    -- returns a table with all the online players who are NOT in a session based on their group and discord role permissions.
    -- @param data.players
    -- @param data.count
    self.GetPlayersByAdministratorPermissions = function()
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)
            
            if PlayerData[player] then

                local hasAdministratorPermissions = false

                if GetTableLength(Config.AdministratorGroups) > 0 then

                    for _, group in pairs (Config.AdministratorGroups) do
                    
                        if group == PlayerData[player].group then
                            hasAdministratorPermissions = true
                        end
                  
                    end
            
                end
    
                local userRoles  = GetUserDiscordRoles(player, Config.DiscordServerID)
        
                if not userRoles or userRoles == nil then
                    userRoles = {}
                end
        
                if GetTableLength(userRoles) > 0 and GetTableLength(Config.DiscordAdministratorRoles) > 0 then
        
                    for _, role in pairs (Config.DiscordAdministratorRoles) do
          
                        for _, userRole in pairs (userRoles) do
                          
                          if tonumber(userRole) == tonumber(role) then
                            hasAdministratorPermissions = true
                          end
                    
                        end
            
                    end
        
                end
    
                if hasAdministratorPermissions then
                    data.count = data.count + 1
                    table.insert(data.players, { source = player } )
                end

            end

        end

        return data

    end

    -- Disconnect (Kick) ALL the online players BUT, by checking if you want the administrators to be kicked / not.
    -- @param reason (string): the reason for kicking the players of the server.
    -- @param kickAdministrators (boolean): a boolean if you want to kick administrators / not
    self.DisconnectAll = function(reason, kickAdmins)
        local data       = { players = {}, count = 0 }
        local playerList = GetPlayers()

		for index, player in pairs(playerList) do

            player = tonumber(player)

            local hasAdministratorPermissions = false
        
            -- Checking for group a null check is required for the Player Object.
            if GetTableLength(Config.AdministratorGroups) > 0 and PlayerData[player] ~= nil then

                for _, group in pairs (Config.AdministratorGroups) do
                
                    if group == PlayerData[player].group then
                        hasAdministratorPermissions = true
                    end
              
                end
        
            end
    
            local userRoles  = GetUserDiscordRoles(player, Config.DiscordServerID)
        
            if not userRoles or userRoles == nil then
                userRoles = {}
            end
    
            if GetTableLength(userRoles) > 0 and GetTableLength(Config.DiscordAdministratorRoles) > 0 then
    
                for _, role in pairs (Config.DiscordAdministratorRoles) do
      
                    for _, userRole in pairs (userRoles) do
                      
                      if tonumber(userRole) == tonumber(role) then
                        hasAdministratorPermissions = true
                      end
                
                    end
        
                end
    
            end

        end

        if (not hasAdministratorPermissions) or (kickAdmins) then
            DropPlayer(player, reason)
        end

    end

    self.GetSeparatedPlayersByDistance = function(coords, radius)
        local nearbyPlayers, farPlayers = {}, {}

        local players = GetPlayers()

        for _, playerId in ipairs(players) do

            playerId = tonumber(playerId)

            local playerCoords = GetEntityCoords(GetPlayerPed(playerId)) -- Get the player's coordinates
    
            -- Calculate the distance between the player and the center
            local distance = #(coords - playerCoords)
    
            -- Categorize players based on their distance
            if distance <= radius then
                table.insert(nearbyPlayers, playerId)
            else
                table.insert(farPlayers, playerId)
            end
        end
    
        return nearbyPlayers, farPlayers
    end

    self.TriggerClientEventAsyncByCoords = function(eventName, data, coords, radius, delay, multiplyDelay, multiplyMinPlayers)
        -- Separate players into nearby and far based on the radius
        local nearbyPlayers, farPlayers = self.GetSeparatedPlayersByDistance(coords, radius)

        -- Update nearby players immediately
        for _, playerId in ipairs(nearbyPlayers) do
            TriggerClientEvent(eventName, playerId, data)
        end

        -- An extra option to multiply the delay if the far players are less than the minimum input.
        -- Example: If multiplyMinPlayers input is 40, it will multiply the update delay but if the players
        -- are more than 40, it will not multiply but use the default delay input.
        -- The multiply feature is for the 40 players to take the same time to be updated as it should in 80 players.
        -- If delay is 200 (WITHOUT MULTIPLY), it would take with 80 players 16 seconds to be updated, but in 40 players, it would take 8 seconds
        -- but this if option is multiplying, it will take 16 seconds to be updated for 40 players and not 8 seconds, we prefer that for better performance.
        if multiplyDelay and GetTableLength(farPlayers) <= multiplyMinPlayers then
            delay = delay * 2
        end

        -- Update far players in batches with a delay
        Citizen.CreateThread(function()
    
            -- Send the event to each player in the batch
            for _, playerId in ipairs(farPlayers) do
                TriggerClientEvent(eventName, playerId, data)
                -- Wait for the specified delay before the next update loop.
                Citizen.Wait(delay)
            end

        end)

    end

    self.SendToDiscord = function(webhook, title, description, color)
        SendToDiscordWebhook(webhook, title, description, color)
    end

    self.SendImageUrlToDiscord = function(webhook, title, description, url, color)
        SendImageUrlToDiscordWebhook(webhook, title, description, url, color)
    end

    self.SendToDiscordWithPlayerParameters = function(webhook, title, source, steamName, username, identifier, charidentifier, description, color)
        local message = string.format("**Online Player ID:** `%s`\n**Steam Name:** `%s`\n**First & Last Name**: `%s`\n**Steam Identifier:** `%s`\n**Character Id:** `%s`\n\n**Description:**\n" .. description, source, steamName, username, identifier, charidentifier)
        SendToDiscordWebhook(webhook, title, message, color)
    end

    -- Required when player is joining for first time, those API Functions are used on inventory > tp-server_inventory.lua
    self.HasStartItems = function() 
        return Config.NewCharacter.StartItems.Enabled
    end

    self.GetStartItemsList = function()
        return Config.NewCharacter.StartItems.Items
    end

    self.HasStartWeapons = function()
        return Config.NewCharacter.StartWeapons.Enabled
    end

    self.GetStartWeaponsList = function()
        return Config.NewCharacter.StartWeapons.Weapons
    end

    return self
end)
