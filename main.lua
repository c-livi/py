local function generateIdenitfier(n)
    local ID_Cache = {}
    return function()
        for i = 1, #ID_Cache do
            if ID_Cache[i][1] == n then
                return ID_Cache[i][2]
            end
        end
        local insert = table.insert
        local mInt = n + (5000 / 2465) + 245
        local Identifier = ""

        for i = 1, mInt do
            local c = 0
            for number = 2, math.floor(i / 2 + 1) do
                if (i % number == 0) then
                    c = c + 1
                    break
                end
            end
            if c == 0 and i ~= 1 then
                Identifier = Identifier .. tostring(i)
            end
        end

        ID_Cache[#ID_Cache + 1] = Indentifier
        return Identifier
    end
end

local function sleep(t)
    if not t then
        return
    end
    local start = os.time()
    while os.time() - start < 5 do
    end
end

local function multiThreadGenerate(max_generations)
    local ct = {}
    return function()
        local completions = {["f1"] = false, ["f2"] = false, ["f3"] = false}
        local f1 = function()
            for i = 1, max_generations / 4 do
                generateIdentifier(i)
            end
            completions["f1"] = true
        end
        local f2 = function()
            for i = max_generations / 4 + 1, max_generations / 2 do
                generateIdentifier(i)
            end
            completions["f2"] = true
        end
        local f3 = function()
            for i = max_generations / 2 + 1, max_generations do
                generateIdentifier(i)
            end
            completions["f3"] = true
        end
        f1, f2, f3 = coroutine.create(f1), coroutine.create(f2), coroutine.create(f3)
        local corcont = {f1, f2, f3}
        for i = 1, 3 do
            ct[#ct + 1] = corcont[i]
        end
        for i = 1, 3 do
            coroutine.resume(corcont[i])
            local index = #ct + 1
            ct[#ct + 1] = corcont[i]
            repeat
                sleep(.01)
            until completions["f" .. i] == true
            coroutine.yield(ct[index])
        end
    end
end
