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
-- Инициализация
-- ==========================
local function AucScanner_OnLoad()
    -- slash-команда
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:SetScript("OnEvent", AucScanner_OnLoad)
