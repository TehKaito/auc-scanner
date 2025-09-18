-- =========================================================
-- auc-scanner.lua — окно с иконкой Peacebloom
-- /aucs — показать/скрыть окно
-- =========================================================

local ITEM_ID = 2447 -- Peacebloom

-- ---------- Переключатель окна ----------
local function AucScanner_Toggle()
    if AucScannerFrame and AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        if AucScannerFrame then AucScannerFrame:Show() end
    end
end

-- Слэш-команда
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

-- ---------- Элементы интерфейса ----------
local iconTex, nameFont

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

-- ---------- Обновление данных ----------
local function UpdateIconAndName()
    local name, _, _, _, _, _, _, _, _, texture = GetItemInfo(ITEM_ID)
    if name and texture then
        iconTex:SetTexture(texture)
        nameFont:SetText(name)
        return true
    end
    return false
end

-- ---------- Обработчик событий ----------
local function OnEvent(self, event, ...)
    if event == "AUCTION_ITEM_LIST_UPDATE" then
        -- пробуем снова взять данные
        if UpdateIconAndName() then
            -- успешно обновили — можно отписаться, если нужно
            -- self:UnregisterEvent("AUCTION_ITEM_LIST_UPDATE")
        end
    end
end

-- ---------- При показе окна ----------
local function OnShow()
    EnsureLineCreated()
    UpdateIconAndName()
end

-- ---------- Инициализация ----------
local function OnVarsLoaded()
    if not AucScannerFrame then return end
    AucScannerFrame:SetScript("OnShow", OnShow)
    AucScannerFrame:RegisterEvent("AUCTION_ITEM_LIST_UPDATE")
    AucScannerFrame:SetScript("OnEvent", OnEvent)
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:SetScript("OnEvent", OnVarsLoaded)
