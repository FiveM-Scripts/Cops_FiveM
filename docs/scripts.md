# Supported scripts
* [fs_freemode](https://github.com/FiveM-Scripts/fs_freemode)
* [ghmattimysql](https://github.com/GHMatti/ghmattimysql)
* [Simple Banking](https://forum.fivem.net/t/release-simple-banking-2-0-now-with-gui/13896) (legacy script)

If you are using Simple Banking, add this piece of code in **server.lua**


```lua
RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        withdraw(player, rounded)
        local new_balance = bankBalance(player)
        TriggerClientEvent("police:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Withdrew: ~g~$".. rounded .." ~n~~s~New Balance: ~g~$" .. new_balance)
        TriggerClientEvent("banking:updateBalance", source, new_balance)
        TriggerClientEvent("banking:removeBalance", source, rounded)
        CancelEvent()
      end
  end)
end)
```
* [Venomous Freemode](https://github.com/FiveM-Scripts/venomous-freemode)
* [Skin Customization](https://forum.fivem.net/t/release-skin-customization-v1-0/16491) (legacy script)
* [Player in db](https://forum.fivem.net/t/release-nameofplayers-v-1-get-name-of-players-in-database/17983) (legacy script)