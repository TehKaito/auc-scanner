local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

function AucScanner_OnDragStart()
    AucScannerFrame:StartMoving()
end

function AucScanner_OnDragStop()
    AucScannerFrame:StopMovingOrSizing()
end

-- рисуем сетку
local function AucScanner_DrawIngredients()
    local col, row = 0, 0
    local maxCols = 2
    local startX, startY = 20, -40
    local colWidth = 220
    local rowHeight = 40

    for i, data in ipairs(AlchemyIngredients) do
        local itemID = data.id
        local icon = GetItemIcon(itemID)

        if not icon then
            icon = "Interface\\Icons\\INV_Misc_QuestionMark"
            DEFAULT_CHAT_FRAME:AddMessage("No icon for ID "..itemID)
        end

        -- иконка
        local tex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
        tex:SetSize(32, 32)
        tex:SetPoint("TOPLEFT", AucScannerFrame, "TOPLEFT",
            startX + col * colWidth, startY + (row * -rowHeight))
        tex:SetTexture(icon)

        -- название
        local label = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("LEFT", tex, "RIGHT", 5, 0)
        label:SetText(data.name)

        -- перенос
        col = col + 1
        if col >= maxCols then
            col = 0
            row = row + 1
        end
    end
end

local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    AucScanner_DrawIngredients()
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
