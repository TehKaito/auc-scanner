-- Главное окно
local frame = CreateFrame("Frame", "AlchemyUI", UIParent, "BasicFrameTemplate")
frame:SetSize(400, 400)
frame:SetPoint("CENTER")
frame:Hide()

frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame.title:SetPoint("TOP", 0, -10)
frame.title:SetText("Alchemy Ingredients")

-- Скроллируемый контейнер
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(360, 1)
scrollFrame:SetScrollChild(content)

-- Отображаем ингредиенты табличкой
local rowHeight = 24
local index = 0
for id, data in pairs(AlchemyIngredients) do
    local row = CreateFrame("Frame", nil, content)
    row:SetSize(340, rowHeight)
    row:SetPoint("TOPLEFT", 0, -index * rowHeight)

    local icon = row:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT")
    icon:SetTexture(GetItemIcon(id))

    local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    text:SetText(data.name)

    index = index + 1
end
content:SetHeight(index * rowHeight)
