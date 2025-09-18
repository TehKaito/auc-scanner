-- =========================================================
-- auc-scanner.lua — одна иконка Peacebloom + название
-- /aucs — показать/скрыть окно
-- Перетаскивание — через функции OnDragStart/OnDragStop
-- =========================================================

-- ---------- Переключатель окна ----------
local function AucScanner_Toggle()
    if AucScannerFrame and AucScannerFrame:IsShown() then
        AucScannerFrame:Hide()
    else
        if AucScannerFrame then AucScannerFrame:Show() end
    end
end

-- Слэш-команда (регистрируем рано, без ожидания событий)
SLASH_AUCSCANNER1 = "/aucs"
SlashCmdList["AUCSCANNER"] = AucScanner_Toggle

-- ---------- Перетаскивание ----------
function AucScanner_OnDragStart()
    if AucScannerFrame and AucScannerFrame:IsMovable() then
        AucScannerFrame:StartMoving()
        AucScannerFrame.isMoving = true
    end
end

function AucScanner_OnDragStop()
    if AucScannerFrame then
        AucScannerFrame:StopMovingOrSizing()
        AucScannerFrame.isMoving = false
    end
end

-- ---------- Одна иконка + название ----------
local ITEM_ID = 2447 -- Peacebloom

-- элементы строки (кэшируем, чтобы не создавать повторно)
local iconTex, nameFont

-- скрытый тултип, чтобы форсировать подкачку данных об итеме
local cacheTip = CreateFrame("GameTooltip", "AucScanner_CacheTip", UIParent, "GameTooltipTemplate")
cacheTip:SetOwner(UIParent, "ANCHOR_NONE")

-- безопасная попытка получить имя/текстуру (Lua 5.0: НЕТ select())
local function TryGetItemInfo(id)
    local name, link, quality, ilevel, reqLevel, class, subclass, stack, equipSlot, texture = GetItemInfo(id)
    return name, texture
end

-- один раз создаём виджеты
local function EnsureLineCreated()
    if iconTex and nameFont then return end

    -- Иконка (пока вопросик — заменим, когда появится реальная текстура)
    iconTex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    iconTex:SetSize(32, 32)
    iconTex:SetPoint("TOPLEFT", 20, -50)
    iconTex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    -- Текст
    nameFont = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameFont:SetPoint("LEFT", iconTex, "RIGHT", 6, 0)
    nameFont:SetText("Loading...")
end

-- попытка обновить иконку/название; true если удалось
local function UpdateIconAndName()
    local name, texture = TryGetItemInfo(ITEM_ID)
    if texture and name then
        iconTex:SetTexture(texture)
        nameFont:SetText(name)
        return true
    end
    return false
end

-- таймерный пуллинг (Vanilla 1.12: не рассчитываем на GET_ITEM_INFO_RECEIVED)
local pollingElapsed, pollingTries = 0, 0
local function OnUpdatePoll(self, elapsed)
    pollingElapsed = pollingElapsed + elapsed
    if pollingElapsed < 0.25 then return end
    pollingElapsed = 0

    if UpdateIconAndName() then
        self:SetScript("OnUpdate", nil) -- готово, выключаем пуллер
        return
    end

    pollingTries = pollingTries + 1
    if pollingTries > 40 then
        -- сдаёмся через ~10 секунд: оставляем вопросик и "Loading..."
        self:SetScript("OnUpdate", nil)
    end
end

-- Когда окно показывают — создаём линию и пытаемся подгрузить данные
local function OnShow()
    EnsureLineCreated()

    -- первая попытка, вдруг уже в кеше
    if not UpdateIconAndName() then
        -- форсируем подкачку предмета через тултип
        cacheTip:ClearLines()
        cacheTip:SetHyperlink("item:"..ITEM_ID..":0:0:0:0:0:0:0")
        pollingElapsed, pollingTries = 0, 0
        AucScannerFrame:SetScript("OnUpdate", OnUpdatePoll)
    end
end

-- навешиваем обработчик показа один раз, когда всё загрузилось
local function OnVarsLoaded()
    if not AucScannerFrame then return end
    AucScannerFrame:SetScript("OnShow", OnShow)
end

-- В 1.12 надёжно ловить VARIABLES_LOADED
local loader = CreateFrame("Frame")
loader:RegisterEvent("VARIABLES_LOADED")
loader:SetScript("OnEvent", OnVarsLoaded)
