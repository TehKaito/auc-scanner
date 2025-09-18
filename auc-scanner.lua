local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

-- обработчики для перетаскивания
function AucScanner_OnDragStart()
    AucScannerFrame:StartMoving()
end

function AucScanner_OnDragStop()
    AucScannerFrame:StopMovingOrSizing()
end

-- рисуем сетку с иконками и названиями
local function AucScanner_DrawIngredients()
    local col, row = 0, 0
    local maxCols = 2
    local startX, startY = 20, -40
    local colWidth = 220
    local rowHeight = 40

    for itemID, data in pairs(AlchemyIngredients) do
        local icon = GetItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark"

        -- иконка
        local tex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
        tex:SetSize(32, 32)
        tex:SetPoint("TOPLEFT", AucScannerFrame, "TOPLEFT", startX + col * colWidth, startY + (row * -rowHeight))
        tex:SetTexture(icon)

        -- название
        local label = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("LEFT", tex, "RIGHT", 5, 0)
        label:SetText(data.name)

        -- перенос на следующую колонку/строку
        col = col + 1
        if col >= maxCols then
            col = 0
            row = row + 1
        end
    end
end

-- загрузка
local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    AucScanner_DrawIngredients()
end

-- ждём логина
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
