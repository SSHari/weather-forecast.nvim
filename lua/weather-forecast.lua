--[[
    Gets weather information from open-meteo.com

    Don't expect too much since this is free and you don't need an API key...
    ...also the api might change later, so you do you.

    Pass whatever query params you want from those found here: https://open-meteo.com/en/docs#api_form

    This bad boy relies on that plenary.nvim
]] --
local curl = require('plenary.curl')
local M = {}

local function clone_table(table)
    local clone = {}
    for k, v in pairs(table) do clone[k] = v end
    return clone
end

M.get_raw_weather = function(query)
    local success, result = pcall(curl.get,
                                  {url = 'https://api.open-meteo.com/v1/forecast', query = query})

    if success then return vim.fn.json_decode(result.body) end

    print("Sorry. We couldn't get that weather for you :shrug:")
    return nil
end

M.get_weather = function(external_query)
    local query = clone_table(external_query)
    query['current_weather'] = "true"

    local result = M.get_raw_weather(query)

    if result then
        local temp = result.current_weather.temperature
        print("It's " .. temp .. " outside...")
    end
end

return M
