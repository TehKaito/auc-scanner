local function AucScanner_Toggle()
    if AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        AucScannerFrame:Show()
    end
end

local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

    -- Делаем окно перетаскиваемым
    AucScannerFrame:SetMovable(true)
    AucScannerFrame:EnableMouse(true)
    AucScannerFrame:RegisterForDrag("LeftButton")

    AucScannerFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    AucScannerFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
end

-- Ждём пока игрок войдёт в игру
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
