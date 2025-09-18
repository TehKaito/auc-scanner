-- ==========================
-- Переключение окна (/aucs)
-- ==========================
local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

-- ==========================
-- Перетаскивание (для XML)
-- ==========================
function AucScanner_OnDragStart()
    AucScannerFrame:StartMoving()
    AucScannerFrame.isMoving = true
end

function AucScanner_OnDragStop()
    AucScannerFrame:StopMovingOrSizing()
    AucScannerFrame.isMoving = false
end

-- ==========================
-- Отрисовка предметов
-- ==========================
local ingredientLines = {}

local function CreateIngredientLine(parent, itemID, row, col)
    local line = {}
    line.id = itemID

    local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
    if not icon then
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    end
    if not name then
        name = "Loading..."
    end

    local startX, startY = 20, -40
    local colWidth, rowHeight = 220, 40

    -- Иконка
    line.icon = parent:CreateTexture(nil, "ARTWORK")
    line.icon:SetSize(32, 32)
    line.icon:SetPoint("TOPLEFT", startX + col * colWidth, startY - row * rowHeight)
    line.icon:SetTexture(icon)

    -- Текст
    line.label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    line.label:SetPoint("LEFT", line.icon, "RIGHT", 5, 0)
    line.label:SetText(name)

    return line
end

local function DrawIngredients()
    if #ingredientLines > 0 then return end -- уже нарисовали

    local col, row = 0, 0
    local maxCols = 2

    for itemID, data in pairs(AlchemyIngredients) do
        local line = CreateIngredientLine(AucScannerFrame, itemID, row, col)
        table.insert(ingredientLines, line)

        col = col + 1
        if col >= maxCols then
            col = 0
            row = row + 1
        end
    end
end

local function RefreshIcons()
    for _, line in ipairs(ingredientLines) do
        local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(line.id)
        if name and icon then
            line.icon:SetTexture(icon)
            line.label:SetText(name)
        end
    end
end

-- ==========================
-- События
-- ==========================
local function OnEvent(self, event, ...)
    if event == "GET_ITEM_INFO_RECEIVED" then
        RefreshIcons()
    end
end

local function AucScanner_OnLoad()
    -- slash-команда
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    -- рисуем при открытии окна
    AucScannerFrame:SetScript("OnShow", DrawIngredients)

    -- слушаем событие подгрузки иконок
    AucScannerFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    AucScannerFrame:SetScript("OnEvent", OnEvent)
end

-- ==========================
-- Инициализация при входе
-- ==========================
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
