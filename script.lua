local city = get("cityname")
local err = get("err")
local weather = get("weather")
city.on_submit(function(content)
    -- print(content)

    local cords = fetch({
        url = "https://geocoding-api.open-meteo.com/v1/search?name=" .. content,
        method = "GET",
        headers = { ["Content-Type"] = "application/json" },
    })
    -- print(cords)

    if cords["results"] ~= nil then
        err.set_content("")
        weather.set_content("")
        local res = fetch({
            url = "https://api.open-meteo.com/v1/forecast?latitude=" .. cords["results"][1]["latitude"] .. "&longitude=" .. cords["results"][1]["longitude"] .. "&current=temperature_2m,is_day,precipitation,rain,snowfall,cloud_cover&timezone=auto&forecast_days=1",
            method = "GET",
            headers = { ["Content-Type"] = "application/json" },
        })
        -- print(res)
        local cur = res["current"]

        local str = ""

        if cur["is_day"] == 1 then
            str = str .. "☀"
        else
            str = str .. "🌙"
        end

        if cur["rain"] > 0 then
            str = str .. "rain"
        end

        if cur["snowfall"] > 0 then
            str = str .. "❄"
        end
        if cur["cloud_cover"] >= 20 then 
            if cur["precipitation"] > 0 and cur["cloud_cover"] == 100 then
                str = str .. "⛈"
            elseif cur["cloud_cover"] < 50 then
                str = str .. "⛅"
            else
                str = str .. "☁"
            end
        end
        
        
        str = str .. cur["temperature_2m"] .. " °C"
        weather.set_content(str)


        
    else 
        err.set_content("City not found")
    end
end)



