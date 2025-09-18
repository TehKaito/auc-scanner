-- =========================================================
-- auc-scanner.lua — тестовое окно с иконкой Peacebloom
-- /aucs — показать/скрыть окно
-- =========================================================

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

-- ---------- Одна иконка + название ----------
local ITEM_ID = 2447 -- Peacebloom

local iconTex, nameFont
local cacheTip = CreateFrame("GameTooltip", "AucScanner_CacheTip", UIParent, "GameTooltipTemplate")
cacheTip:SetOwner(UIParent, "ANCHOR_NONE")

-- в 1.12 GetItemInfo возвращает 10 значений, нам нужны name и texture
local function TryGetItemInfo(id)
    local name, link, quality, ilevel, reqLevel, class, subclass, stack, equipSlot, texture = GetItemInfo(id)
    return name, texture
end

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

local function UpdateIconAndName()
    local name, texture = TryGetItemInfo(ITEM_ID)
    if texture and name then
        iconTex:SetTexture(texture)
        nameFont:SetText(name)
        return true
    end
    return false
end

-- ---------- Пуллинг (Vanilla: нет GET_ITEM_INFO_RECEIVED) ----------
local pollingElapsed, pollingTries = 0, 0
local function OnUpdatePoll(elapsed)
    pollingElapsed = pollingElapsed + elapsed
    if pollingElapsed < 0.25 then return end
    pollingElapsed = 0

    if UpdateIconAndName() then
        AucScannerFrame:SetScript("OnUpdate", nil)
        return
    end

    pollingTries = pollingTries + 1
    if pollingTries > 40 then
        AucScannerFrame:SetScript("OnUpdate", nil)
    end
end

-- ---------- Когда окно показывается ----------
local function OnShow()
    EnsureLineCreated()

    if not UpdateIconAndName() then
        cacheTip:ClearLines()
        cacheTip:SetHyperlink("item:" .. ITEM_ID .. ":0:0:0:0:0:0:0")
        pollingElapsed, pollingTries = 0, 0
        AucScannerFrame:SetScript("OnUpdate", OnUpdatePoll)
    end
end

-- ---------- Инициализация ----------
local function OnVarsLoaded()
    if not AucScannerFrame then return end
    AucScannerFrame:SetScript("OnShow", OnShow)
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:SetScript("OnEvent", OnVarsLoaded)
