local AucScannerUI = CreateFrame("Frame", "AucScannerMainFrame", UIParent, "BasicFrameTemplateWithInset")
AucScannerUI:SetSize(300, 200)
AucScannerUI:SetPoint("CENTER")
AucScannerUI:SetMovable(true)
AucScannerUI:EnableMouse(true)
AucScannerUI:RegisterForDrag("LeftButton")
AucScannerUI:SetScript("OnDragStart", AucScannerUI.StartMoving)
AucScannerUI:SetScript("OnDragStop", AucScannerUI.StopMovingOrSizing)
AucScannerUI:Hide()

-- Заголовок
AucScannerUI.title = AucScannerUI:CreateFontString(nil, "OVERLAY")
AucScannerUI.title:SetFontObject("GameFontHighlight")
AucScannerUI.title:SetPoint("LEFT", AucScannerUI.TitleBg, "LEFT", 5, 0)
AucScannerUI.title:SetText("Auc Scanner")

-- Слеш-команда
SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = function()
    if AucScannerUI:IsShown() then
        AucScannerUI:Hide()
    else
        AucScannerUI:Show()
    end
end
