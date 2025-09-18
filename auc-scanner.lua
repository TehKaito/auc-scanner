-- Создаём простое окно
local f = CreateFrame("Frame", "AucScannerFrame", UIParent, "BasicFrameTemplateWithInset")
f:SetSize(300, 200)
f:SetPoint("CENTER")
f:Hide()

-- Заголовок окна
f.title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
f.title:SetPoint("CENTER", f.TitleBg, "CENTER", 0, 0)
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
