-- =========================================================
-- Auc Scanner — Peacebloom: минимальная цена и топ-5
-- /aucs — показать/скрыть окно
-- =========================================================

local SEARCH_NAME = "Peacebloom"

-- UI
local nameFont
local priceLines = {}

-- ---------- Перетаскивание (дергается из XML) ----------
function AucScanner_OnDragStart()
    if AucScannerFrame and AucScannerFrame:IsMovable() then
        AucScannerFrame:StartMoving()
    end
end
function AucScanner_OnDragStop()
    if AucScannerFrame then
        AucScannerFrame:StopMovingOrSizing()
    end
end

-- ---------- UI helpers ----------
local function EnsureTitle()
    if not AucScannerFrame then return false end
    if not nameFont then
        nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFont:SetPoint("TOPLEFT", 20, -40)
        nameFont:SetText("Peacebloom")
    end
    return true
end

local function ClearPriceLines()
    for _, fs in ipairs(priceLines) do fs:Hide() end
    priceLines = {}
end

local function AddPriceLine(text, yOffset)
    local fs = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("TOPLEFT", 20, -40 - yOffset)
    fs:SetText(text)
    table.insert(priceLines, fs)
end

-- ---------- Форматирование цены ----------
local function FormatMoney(copper)
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local c = copper % 100
    return string.format("%dg %ds %dc", g, s, c)
end

-- ---------- Парсинг результатов аука ----------
local function CollectPrices()
    local num = GetNumAuctionItems("list")
    local prices = {}
    for i = 1, num do
        local name, _, count, _, _, _, _, buyout = GetAuctionItemInfo("list", i)
        if name and string.lower(name) == string.lower(SEARCH_NAME) and buyout and buyout > 0 and count and count > 0 then
            local unit = math.floor(buyout / count)
            table.insert(prices, unit)
        end
    end
    table.sort(prices)
    return prices
end

-- ---------- События ----------
local function OnEvent(self, event, ...)
    if event == "AUCTION_SHOW" then
        -- делаем запрос при открытии аука
        QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, 0, 0, 0)

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        EnsureTitle()
        ClearPriceLines()
        local prices = CollectPrices()
        if #prices == 0 then
            AddPriceLine("Нет лотов", 20)
        else
            AddPriceLine("Мин. цена: " .. FormatMoney(prices[1]), 20)
            for i = 1, math.min(5, #prices) do
                AddPriceLine(i .. ") " .. FormatMoney(prices[i]), 20 + i * 15)
            end
        end
    end
end

-- ---------- Переключатель ----------
local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
        EnsureTitle()
        ClearPriceLines()
        AddPriceLine("Откройте аукцион и нажмите Search…", 20)
    end
end

-- регистрируем slash-команду СРАЗУ
SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Инициализация ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:SetScript("OnEvent", OnEvent)
