-- AlchemyHelper.lua

-- Глобальная таблица для аддона
AlchemyHelper = {}

-------------------------------------------------
-- Функция переключения окна
-------------------------------------------------
function AlchemyHelper:ToggleUI()
    if AlchemyUI then
        if AlchemyUI:IsShown() then
            AlchemyUI:Hide()
        else
            AlchemyUI:Show()
        end
    else
        print("|cffff0000AlchemyHelper: UI не загружен.|r")
    end
end

-------------------------------------------------
-- Команда чата
-------------------------------------------------
SLASH_ALCHEMY1 = "/alchemy"
SlashCmdList["ALCHEMY"] = function()
    AlchemyHelper:ToggleUI()
end

-------------------------------------------------
-- Кнопка у миникарты (для стандартного UI)
-------------------------------------------------
local button = CreateFrame("Button", "AlchemyHelperMinimapButton", Minimap)
button:SetSize(32, 32)
button:SetFrameStrata("MEDIUM")
button:SetFrameLevel(8)

-- Иконка на кнопке
local icon = button:CreateTexture(nil, "BACKGROUND")
icon:SetTexture("Interface\\Icons\\inv_potion_01") -- можно заменить на любую
icon:SetSize(20, 20)
icon:SetPoint("CENTER")

-- Позиция у миникарты
button:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

-- Скрипты
button:SetScript("OnClick", function()
    AlchemyHelper:ToggleUI()
end)

button:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Alchemy Helper")
    GameTooltip:AddLine("Клик: открыть/закрыть окно", 1, 1, 1)
    GameTooltip:AddLine("/alchemy - открыть из чата", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)

button:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-------------------------------------------------
-- Сообщение при загрузке
-------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    print("|cff00ff00AlchemyHelper загружен.|r Напиши |cffffff00/alchemy|r чтобы открыть окно.")
end)
