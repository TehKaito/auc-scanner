-- /aucs показать/скрыть окно
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
-- Отрисовка одного элемента
-- ==========================
local line

local function DrawOnce()
    if line then return end

    local itemID = 2447 -- Peacebloom
    local data   = AlchemyIngredients and AlchemyIngredients[itemID]
    local name   = (data and data.name) or ("Item "..itemID)

    -- иконка: пока ставим "?", потом обновим, когда GetItemInfo вернёт данные
    local icon = select(10, GetItemInfo(itemID)) or "Interface\\Icons\\INV_Misc_QuestionMark"

    line = {}
    line.id = itemID

    line.icon = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    line.icon:SetSize(32, 32)
    line.icon:SetPoint("TOPLEFT", 20, -40)
    line.icon:SetTexture(icon)

    line.label = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    line.label:SetPoint("LEFT", line.icon, "RIGHT", 5, 0)
    line.label:SetText(name)
end

local function RefreshIconIfReady()
    if not line then return end
    local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(line.id)
    if name and icon then
        line.icon:SetTexture(icon)
        line.label:SetText(name)
    end
end

-- ==========================
-- События
-- ==========================
local function OnEvent(self, event, ...)
    if event == "GET_ITEM_INFO_RECEIVED" then
        RefreshIconIfReady()
    end
end

local function AucScanner_OnLoad()
    -- slash-команда
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    -- когда окно показывают — отрисовываем
    AucScannerFrame:SetScript("OnShow", DrawOnce)

    -- слушаем событие подгрузки предметов
    AucScannerFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    AucScannerFrame:SetScript("OnEvent", OnEvent)
end

-- ==========================
-- Инициализация при входе
-- ==========================
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
