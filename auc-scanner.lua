-- auc-scanner.lua
AucScanner = AucScanner or {}

-------------------------------------------------
-- Ленивое создание UI (без зависимостей)
-------------------------------------------------
function AucScanner:EnsureUI()
  if self.UI then return end

  local f = CreateFrame("Frame", "AucScannerUI", UIParent)
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
  title:SetText("Auc Scanner")

  -- Кнопка закрытия
  local close = CreateFrame("Button", nil, f)
  close:SetSize(24, 24)
  close:SetPoint("TOPRIGHT", -6, -6)
  local closeText = close:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  closeText:SetAllPoints()
  closeText:SetText("x")
  close:SetScript("OnClick", function() f:Hide() end)

  -- Скролл
  local scroll = CreateFrame("ScrollFrame", "AucScannerScroll", f, "UIPanelScrollFrameTemplate")
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
function AucScanner:ToggleUI()
  if not self.UI then self:EnsureUI() end
  if self.UI:IsShown() then self.UI:Hide() else self.UI:Show() end
end

-------------------------------------------------
-- Команда чата
-------------------------------------------------
SLASH_AUC_SCANNER1 = "/alchemy"
SlashCmdList["AUC_SCANNER"] = function() AucScanner:ToggleUI() end
