-- =========================================================
-- Auc Scanner — авто-поиск Peacebloom на аукционе
-- /aucs — показать/скрыть окно
-- =========================================================

local SEARCH_NAME = "Peacebloom"   -- название для поиска на аукционе

-- UI элементы
local iconTex, nameFont

-- Скан состояния
local scanning      = false
local currentPage   = 0
local nextQueryAt   = 0
local timeAcc       = 0
local QUERY_INTERVAL = 1.0
local NUM_PER_PAGE   = 50

-- ---------- Переключатель окна (/aucs) ----------
local function AucScanner_Toggle()
    if AucScannerFrame and AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        if AucScannerFrame then
            AucScannerFrame:Show()
        end
    end
end

SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Перетаскивание ----------
function AucScanner_OnDragStart()
    if AucScannerFrame and AucScannerFrame:IsMovable() then
        AucScannerFrame:StartMoving()
        AucScannerFrame.isMoving = true
    end
end

function AucScanner_OnDragStop()
    if AucScannerFrame then
        AucScannerFrame:StopMovingOrSizing()
        AucScannerFrame.isMoving = false
    end
end

-- ---------- UI ----------
local function EnsureLineCreated()
    if iconTex and nameFont then return end

    iconTex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetWidth(32)
    iconTex:SetHeight(32)
    iconTex:SetPoint("TOPLEFT", 20, -50)
    iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameFont:SetPoint("LEFT", iconTex, "RIGHT", 6, 0)
    nameFont:SetText("Loading… (open AH)")
end

-- ---------- Запрос к аукциону ----------
local function DoAuctionQuery()
    QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, currentPage, 0, 0)
end

local function OnUpdateQuery()
    local elapsed = arg1 or 0
    timeAcc = timeAcc + elapsed
    if not scanning then return end
    if not (AuctionFrame and AuctionFrame:IsShown()) then return end
    if timeAcc < 0.05 then return end

    if GetTime() >= nextQueryAt then
        timeAcc = 0
        DoAuctionQuery()
        nextQueryAt = GetTime() + QUERY_INTERVAL
    end
end

-- ---------- Проверка страницы ----------
local function ProcessAuctionPage()
    local numBatch, total = GetNumAuctionItems("list")
    if not numBatch or numBatch == 0 then
        return false, true
    end

    for i = 1, numBatch do
        local name, _, _, _, _, _, _, _, _, texture = GetAuctionItemInfo("list", i)
        if name and string.lower(name) == string.lower(SEARCH_NAME) then
            iconTex:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
            nameFont:SetText(name)
            return true, true
        end
    end

    local morePages = false
    if total and total > numBatch then
        local totalPages = math.floor((total + NUM_PER_PAGE - 1) / NUM_PER_PAGE)
        if currentPage + 1 < totalPages then
            morePages = true
        end
    elseif numBatch >= NUM_PER_PAGE then
        morePages = true
    end

    return false, not morePages
end

-- ---------- События ----------
local function OnEvent(self, event, ...)
    if event == "VARIABLES_LOADED" then
        if AucScannerFrame then
            AucScannerFrame:SetScript("OnShow", function()
                EnsureLineCreated()
                if AuctionFrame and AuctionFrame:IsShown() then
                    scanning    = true
                    currentPage = 0
                    nextQueryAt = 0
                    AucScannerFrame:SetScript("OnUpdate", OnUpdateQuery)
                    nameFont:SetText("Searching AH…")
                else
                    nameFont:SetText("Open Auction House to start…")
                end
            end)
        end

    elseif event == "AUCTION_HOUSE_SHOW" or event == "AUCTION_SHOW" then
        if AucScannerFrame and AucScannerFrame:IsShown() then
            scanning    = true
            currentPage = 0
            nextQueryAt = 0
            AucScannerFrame:SetScript("OnUpdate", OnUpdateQuery)
            EnsureLineCreated()
            nameFont:SetText("Searching AH…")
        end

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        if not scanning then return end
        local found, finished = ProcessAuctionPage()
        if found or finished then
            scanning = false
            if AucScannerFrame then
                AucScannerFrame:SetScript("OnUpdate", nil)
            end
        else
            currentPage = currentPage + 1
        end

    elseif event == "AUCTION_HOUSE_CLOSED" or event == "AUCTION_CLOSED" then
        scanning = false
        if AucScannerFrame then
            AucScannerFrame:SetScript("OnUpdate", nil)
        end
    end
end

-- ---------- Инициализация ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:RegisterEvent("AUCTION_HOUSE_SHOW")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:RegisterEvent("AUCTION_HOUSE_CLOSED")
loader:RegisterEvent("AUCTION_CLOSED")
loader:SetScript("OnEvent", OnEvent)
