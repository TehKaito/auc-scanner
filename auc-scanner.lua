-- Будем хранить объекты UI, чтобы обновить, если надо
local ingredientLines = {}

local function UpdateIngredientLine(line, data)
    local itemID = data.id
    local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
    if not name then
        name = data.name  -- fallback заранее заданного
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    line.icon:SetTexture(icon)
    line.label:SetText(name)
end

local function AucScanner_DrawIngredients()
    -- Очистка предыдущих, если есть
    for _, line in ipairs(ingredientLines) do
        line.icon:Hide()
        line.label:Hide()
    end
    wipe(ingredientLines)

    local col, row = 0, 0
    local maxCols = 2
    local startX, startY = 20, -40
    local colWidth = 220
    local rowHeight = 40

    for i, data in ipairs(AlchemyIngredients) do
        local line = {}
        -- текстура
        line.icon = AucScannerFrame:CreateTexture(nil, "ARTWORK")
        line.icon:SetSize(32, 32)
        line.icon:SetPoint("TOPLEFT", AucScannerFrame, "TOPLEFT",
            startX + col * colWidth, startY + (row * -rowHeight))
        -- лейбл
        line.label = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        line.label:SetPoint("LEFT", line.icon, "RIGHT", 5, 0)

        -- сразу обновляем
        UpdateIngredientLine(line, data)

        table.insert(ingredientLines, line)

        col = col + 1
        if col >= maxCols then
            col = 0
            row = row + 1
        end
    end
end

-- Обработчик события, когда данные о предмете приходят
local function OnEvent(self, event, ...)
    if event == "GET_ITEM_INFO_RECEIVED" then
        -- обновляем все линии
        for _, line in ipairs(ingredientLines) do
            -- найдём data для этой линии
            -- можно хранить data вместе с line
            UpdateIngredientLine(line, line.data)
        end
    end
end

-- В OnLoad регистрируем событие
local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    AucScannerFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    AucScannerFrame:SetScript("OnEvent", OnEvent)

    AucScanner_DrawIngredients()
end
