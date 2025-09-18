-- =========================================================
-- Auc Scanner — поиск Peacebloom
-- /aucs — показать/скрыть окно
-- =========================================================

local SEARCH_NAME = "Peacebloom"

-- UI
local iconTex, nameFont

-- ---------- Переключатель ----------
local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Перетаскивание ----------
function AucScanner_OnDragStart()
    if AucScannerFrame:IsMovable() then
        AucScannerFrame:StartMoving()
    end
end

function AucScanner_OnDragStop()
    AucScannerFrame:StopMovingOrSizing()
end

-- ---------- Создание строки ----------
local function EnsureLineCreated()
    if iconTex and nameFont then return end

    iconTex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetWidth(32)
    iconTex:SetHeight(32)
    iconTex:SetPoint("TOPLEFT", 20, -50)
    iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameFont:SetPoint("LEFT", iconTex, "RIGHT", 6, 0)
    nameFont:SetText("Loading...")
end

-- ---------- События ----------
local function OnEvent(self, event, ...)
    if event == "VARIABLES_LOADED" then
        AucScannerFrame:SetScript("OnShow", EnsureLineCreated)

    elseif event == "AUCTION_SHOW" then
        -- Открыли аукцион → запускаем поиск Peacebloom
        QueryAuctionItems(SEARCH_NAME, 0, 0, 0, 0, 0, 0, 0, 0)

    elseif event == "AUCTION_ITEM_LIST_UPDATE" then
        -- Пришли результаты запроса
        local numBatch = GetNumAuctionItems("list")
        for i = 1, numBatch do
            local name, _, _, _, _, _, _, _, _, texture = GetAuctionItemInfo("list", i)
            if name and string.lower(name) == string.lower(SEARCH_NAME) then
                iconTex:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
                nameFont:SetText(name)
                return
            end
        end
        nameFont:SetText("Not found")
    end
end

-- ---------- Инициализация ----------
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:RegisterEvent("AUCTION_SHOW")
loader:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
loader:SetScript("OnEvent", OnEvent)
