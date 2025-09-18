-- UI.lua
AlchemyHelper.UI = CreateFrame("Frame", "AlchemyHelperUI", UIParent, "BasicFrameTemplate")
AlchemyHelper.UI:SetSize(400, 300)
AlchemyHelper.UI:SetPoint("CENTER")
AlchemyHelper.UI:Hide()

AlchemyHelper.UI.title = AlchemyHelper.UI:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
AlchemyHelper.UI.title:SetPoint("TOP", 0, -10)
AlchemyHelper.UI.title:SetText("Alchemy Helper UI работает!")
