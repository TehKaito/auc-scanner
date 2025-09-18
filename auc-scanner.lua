-- /aucs показать/скрыть окно
local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

-- перетаскивание
function AucScanner_OnDragStart() AucScannerFrame:StartMoving() end
function AucScanner_OnDragStop()  AucScannerFrame:StopMovingOrSizing() end

-- один элемент (твой формат: [id] = { name = ... })
local line

local function DrawOnce()
    if line then return end

    local itemID = 2447
    local data   = AlchemyIngredients and AlchemyIngredients[itemID]
    local name   = (data and data.name) or ("Item "..itemID)

    -- иконка: сначала ставим вопросик, потом обновим, когда клиент подгрузит информацию
    local icon = select(10, GetItemInfo(itemID)) or "Interface\\Icons\\INV_Misc_QuestionMark"

    line = {}
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
    local icon = select(10, GetItemInfo(2447))
    if icon then line.icon:SetTexture(icon) end
end

local function OnEvent(self, event, ...)
    if event == "GET_ITEM_INFO_RECEIVED" then
        RefreshIconIfReady()
    end
end

local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    -- перерисовка, когда окно показывают
    AucScannerFrame:SetScript("OnShow", DrawOnce)

    -- когда иконка подгрузится из кеша клиента
    AucScannerFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    AucScannerFrame:SetScript("OnEvent", OnEvent)
end

-- ждём логина
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
