-- =========================================================
-- auc-scanner-ui.lua — отрисовка содержимого
-- =========================================================

local nameFont

local function CreatePeacebloomText()
    if not AucScannerFrame then return end
    if nameFont then return end -- уже создано

    nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameFont:SetPoint("TOPLEFT", 20, -40)
    nameFont:SetText("Peacebloom")
end

-- при первом показе окна создаём текст
AucScannerFrame:SetScript("OnShow", CreatePeacebloomText)
