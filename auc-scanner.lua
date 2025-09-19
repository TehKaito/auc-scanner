-- =========================================================
-- Auc Scanner — Peacebloom: минимальная цена и топ-5
-- /aucs — показать/скрыть окно
-- =========================================================

local SEARCH_NAME = "Peacebloom"

-- UI элементы
local nameFont
local priceLines = {}

-- ---------- Перетаскивание ----------
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

-- ---------- UI ----------
local function EnsureLineCreated()
    if not AucScannerFrame then return end
    if not nameFont then
        nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameFont:SetPoint("TOPLEFT", 20, -40)
        nameFont:SetText("Peacebloom")
    end
end

local function ClearPriceLines()
    for _, f in ipairs(priceLines) do f:Hide() end
    priceLines = {}
end

local function AddPriceLine(text, offset)
    local line = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    line:SetPoint("TOPLEFT", 20, -40 - offset)
    line:SetText(text)
    table.insert(priceLines, line)
end

-- ---------- Форматирование цены ----------
local function FormatMoney(copper)
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local c = copper % 100
    return string.format("%dg %ds %dc", g, s, c)
end

-- ---------- Сбор цен с аука ----------
local function CollectPrices()
    local numBatch = GetNumAuctionItems("list")
    local prices = {}

    for i = 1, numBatch do
        local name, _, count, _, _, _, _, buyout = GetAuctionItemInfo("list", i)
        if name and string.lower(name) == string.lower(SEARCH_NAME) and buyout and buyout > 0 then
            local unitPrice = math.floor(buyout / count)
            table.insert(prices, unitPrice)
        end
    end

    table.sort(prices)
    return prices
end

-- ---------- События ----------
local function OnEvent(self, event, ...)
    if event == "VARIABLES_LOADED" then
        AucScannerFrame:SetScript("OnShow", EnsureLineCreated)

    elseif event == "AUCTION_SHOW" then
        -- запрашиваем Peacebloom при открытии аука
        QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, 0, 0, 0)

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        EnsureLineCreated()
        ClearPriceLines()

        local prices = CollectPrices()
        if #prices == 0 then
            AddPriceLine("Нет лотов", 20)
        else
            AddPriceLine("Мин. цена: " .. FormatMoney(prices[1]), 20)
            for i = 1, math.min(5, #prices) do
                AddPriceLine(i .. ") " .. FormatMoney(prices[i]), 20 + i*15)
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
        EnsureLineCreated()
        ClearPriceLines()
        AddPriceLine("Откройте аукцион…", 20)
    end
end
SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Инициализация ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:SetScript("OnEvent", OnEvent)
