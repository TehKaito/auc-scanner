-- =========================================================
-- Auc Scanner — простое окно + поиск Peacebloom по имени
-- /aucs — показать/скрыть окно
-- Vanilla/Turtle (1.12): без select(), SetSize(), elapsed в arg1
-- =========================================================

local SEARCH_NAME = "Peacebloom"   -- ruRU: "Мироцвет"

-- UI элементы
local iconTex, nameFont

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

-- ---------- Гарантированно создать строку UI ----------
local function EnsureLineCreated()
    if not AucScannerFrame then return end
    if iconTex and nameFont then return end

    iconTex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetWidth(32)
    iconTex:SetHeight(32)
    iconTex:SetPoint("TOPLEFT", 20, -50)
    iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameFont:SetPoint("LEFT", iconTex, "RIGHT", 6, 0)
    nameFont:SetText("Loading…")
end

-- ---------- Переключатель окна (/aucs) ----------
local function AucScanner_Toggle()
    if not AucScannerFrame then return end
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
        -- ВАЖНО: рисуем плейсхолдер СРАЗУ (не ждём событий)
        EnsureLineCreated()
        iconTex:SetTexture("Interface\\Icons\\INV_Misc_Herb_Peacebloom")
        nameFont:SetText("Peacebloom")
    end
end

SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Поиск по аукциону ----------
local function QueryOnce()
    -- name, minLvl, maxLvl, invType, class, subclass, page, usable, quality
    QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, 0, 0, 0)
end

local function TryFillFromAuction()
    local numBatch = GetNumAuctionItems("list")
    if not numBatch or numBatch == 0 then return false end

    for i = 1, numBatch do
        local name, _, _, _, _, _, _, _, _, texture = GetAuctionItemInfo("list", i)
        if name and string.lower(name) == string.lower(SEARCH_NAME) then
            EnsureLineCreated()
            iconTex:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
            nameFont:SetText(name)
            return true
        end
    end
    return false
end

-- ---------- События ----------
local function OnEvent(self, event, ...)
    if event == "VARIABLES_LOADED" then
        -- на всякий случай подстрахуем: если окно покажут — создадим строку
        if AucScannerFrame then
            AucScannerFrame:SetScript("OnShow", function()
                EnsureLineCreated()
                -- оставляем "Loading…" как плейсхолдер
            end)
        end

    elseif event == "AUCTION_SHOW" or event == "AUCTION_HOUSE_SHOW" then
        -- открылся аукцион — отправляем ОДИН запрос по имени
        QueryOnce()

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        -- пришли результаты — пробуем найти нужное имя и обновить UI
        if TryFillFromAuction() then
            -- нашли — больше ничего не делаем; если хочешь, можно тут же закрыть окно аукциона
        end

    elseif event == "AUCTION_CLOSED" or event == "AUCTION_HOUSE_CLOSED" then
        -- ничего особенного; плейсхолдер остаётся
    end
end

-- ---------- Инициализация ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_HOUSE_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:RegisterEvent("AUCTION_CLOSED")
loader:RegisterEvent("AUCTION_HOUSE_CLOSED")
loader:SetScript("OnEvent", OnEvent)
