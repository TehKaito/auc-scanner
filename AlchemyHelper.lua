-- AlchemyHelper.lua
AlchemyHelper = AlchemyHelper or {}

-------------------------------------------------
-- Ленивое создание UI (без зависимостей)
-------------------------------------------------
function AlchemyHelper:EnsureUI()
  if self.UI then return end

  local f = CreateFrame("Frame", "AlchemyHelperUI", UIParent)
  f:SetWidth(420); f:SetHeight(480)
  f:SetPoint("CENTER")
  f:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 32, edgeSize = 16,
    insets = { left=5, right=5, top=5, bottom=5 }
  })
  f:Hide()
  self.UI = f

  local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  title:SetPoint("TOP", 0, -10)
  title:SetText("Alchemy Helper")

  -- Кнопка закрытия (простая, без шаблонов)
  local close = CreateFrame("Button", nil, f)
  close:SetSize(24, 24)
  close:SetPoint("TOPRIGHT", -6, -6)
  local closeText = close:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  closeText:SetAllPoints()
  closeText:SetText("x")
  close:SetScript("OnClick", function() f:Hide() end)

  -- Скролл
  local scroll = CreateFrame("ScrollFrame", "AlchemyHelperScroll", f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", 10, -40)
  scroll:SetPoint("BOTTOMRIGHT", -28, 10)

  local content = CreateFrame("Frame", nil, scroll)
  content:SetWidth(370); content:SetHeight(1)
  scroll:SetScrollChild(content)

  -- Соберём и отсортируем ингредиенты
  local items = {}
  for id, data in pairs(AlchemyIngredients or {}) do
    table.insert(items, { id = id, name = data.name or ("Item "..id) })
  end
  table.sort(items, function(a,b) return a.name < b.name end)

  -- Рисуем строки
  local ROW_H = 22
  for i, it in ipairs(items) do
    local row = CreateFrame("Frame", nil, content)
    row:SetHeight(ROW_H)
    row:SetPoint("TOPLEFT", 0, -(i-1)*ROW_H)
    row:SetPoint("TOPRIGHT", 0, -(i-1)*ROW_H)

    local tex = row:CreateTexture(nil, "ARTWORK")
    tex:SetSize(18, 18)
    tex:SetPoint("LEFT", 0, 0)
    local icon = GetItemIcon and GetItemIcon(it.id) or nil
    tex:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")

    local fs = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("LEFT", tex, "RIGHT", 8, 0)
    fs:SetText(it.name .. " (" .. it.id .. ")")
  end
  content:SetHeight(#items * ROW_H)
end

-------------------------------------------------
-- Тоггл окна
-------------------------------------------------
function AlchemyHelper:ToggleUI()
  if not self.UI then self:EnsureUI() end
  if self.UI:IsShown() then self.UI:Hide() else self.UI:Show() end
end

-------------------------------------------------
-- Команда чата
-------------------------------------------------
SLASH_ALCHEMY1 = "/alchemy"
SlashCmdList["ALCHEMY"] = function() AlchemyHelper:ToggleUI() end

-------------------------------------------------
-- Кнопка у миникарты (если её не скрывает pfUI)
-------------------------------------------------
do
  if Minimap then
    local btn = CreateFrame("Button", "AlchemyHelperMinimapButton", Minimap)
    btn:SetSize(32, 32)
    btn:SetPoint("TOPLEFT", Minimap, "TOPLEFT")
    local ic = btn:CreateTexture(nil, "BACKGROUND")
    ic:SetTexture("Interface\\Icons\\inv_potion_01")
    ic:SetSize(20, 20)
    ic:SetPoint("CENTER")
    btn:SetScript("OnClick", function() AlchemyHelper:ToggleUI() end)
    btn:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_LEFT")
      GameTooltip:AddLine("Alchemy Helper")
      GameTooltip:AddLine("Клик — открыть/закрыть", 1,1,1)
      GameTooltip:AddLine("/alchemy", .8,.8,.8)
      GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
  end
end

-------------------------------------------------
-- Сообщение при входе
-------------------------------------------------
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LOGIN")
ev:SetScript("OnEvent", function()
  DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00auc-scanner загружен|r — введите |cffffff00/alchemy|r")
end)
