print("UI.lua загружен!")

AlchemyHelper = AlchemyHelper or {}

AlchemyHelper.UI = CreateFrame("Frame", "AlchemyHelperUI", UIParent, "BasicFrameTemplate")
AlchemyHelper.UI:SetSize(300, 200)
AlchemyHelper.UI:SetPoint("CENTER")
AlchemyHelper.UI:Hide()

local text = AlchemyHelper.UI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetText("Alchemy UI работает!")
