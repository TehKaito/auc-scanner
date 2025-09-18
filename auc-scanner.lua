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
end

-- Ждём пока игрок войдёт в игру
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
