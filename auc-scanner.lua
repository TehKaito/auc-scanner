-- =========================================================
-- Auc Scanner — Peacebloom: минимальная цена и топ-5
-- /aucs — показать/скрыть окно
-- Vanilla/Turtle (1.12)
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
    if event == "VARIABLES_LOADED" then
        -- регистрируем /aucs
        SLASH_AUCSCANNER1 = "/aucs"
        SlashCmdList["AUCSCANNER"] = function()
            if not AucScannerFrame then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff5555[auc-scanner]|r Frame not loaded (check .toc order).")
                return
            end
            if AucScannerFrame:IsShown() then
                AucScannerFrame:Hide()
            else
                AucScannerFrame:Show()
                EnsureTitle()
                ClearPriceLines()
                AddPriceLine("Откройте аукцион и нажмите Search…", 20)
            end
        end
        DEFAULT_CHAT_FRAME:AddMessage("|cff88ff88[auc-scanner]|r команда /aucs готова")

    elseif event == "AUCTION_SHOW" then
        -- один запрос по названию
        QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, 0, 0, 0)

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        if not EnsureTitle() then return end
        ClearPriceLines()
        local prices = CollectPrices()
        if #prices == 0 then
            AddPriceLine("Нет лотов", 20)
        else
            AddPriceLine("Мин. цена: " .. FormatMoney(prices[1]), 20)
            local n = math.min(5, #prices)
            for i = 1, n do
                AddPriceLine(i .. ") " .. FormatMoney(prices[i]), 20 + i * 15)
            end
        end
    end
end

-- ---------- Инициализация слушателя событий ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:SetScript("OnEvent", OnEvent)
