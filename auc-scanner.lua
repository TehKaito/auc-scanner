-- Создаём простое окно
local f = CreateFrame("Frame", "AucScannerFrame", UIParent, "BasicFrameTemplate")
f:SetSize(300, 200)
f:SetPoint("CENTER")
f:Hide()

-- Заголовок окна
f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
f.title:SetPoint("TOP", f, "TOP", 0, -10)
f.title:SetText("Auc Scanner")

-- Регистрируем slash-команду /aucs
SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = function()
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end
