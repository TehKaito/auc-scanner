-- Функция переключения окна
local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

-- Обработчики перетаскивания (аналогично Accountant)
function AucScanner_OnDragStart()
    AucScannerFrame:StartMoving()
    AucScannerFrame.isMoving = true
end

function AucScanner_OnDragStop()
    AucScannerFrame:StopMovingOrSizing()
    AucScannerFrame.isMoving = false
end

-- Регистрация slash-команды
local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle
end

-- Запускаем после логина
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
