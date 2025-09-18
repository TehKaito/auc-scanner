-- Создаем глобальную таблицу аддона
AlchemyHelper = {}

-- Функция переключения окна
function AlchemyHelper:ToggleUI()
    if AlchemyUI:IsShown() then
        AlchemyUI:Hide()
    else
        AlchemyUI:Show()
    end
end

-- Создание кнопки у миникарты
local button = CreateFrame("Button", "AlchemyHelperMinimapButton", Minimap)
button:SetSize(32, 32)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)
button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- Иконка
local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\inv_potion_01")
icon:SetSize(20, 20)
icon:SetPoint("CENTER")

-- Позиция кнопки (рядом с миникартой)
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

-- Скрипты
button:SetScript("OnClick", function() AlchemyHelper:ToggleUI() end)
button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Alchemy Helper")
    GameTooltip:AddLine("Кликните, чтобы открыть/закрыть окно", 1, 1, 1)
    GameTooltip:Show()
end)
button:SetScript("OnLeave", function() GameTooltip:Hide() end)
