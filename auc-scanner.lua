local function DrawPeacebloom()
    local itemID = 2447 -- Peacebloom
    local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)

    if not name then
        name = "Loading..."
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    end

    local tex = AucScannerFrame:CreateTexture(nil, "ARTWORK")
    tex:SetSize(32, 32)
    tex:SetPoint("TOPLEFT", 20, -40)
    tex:SetTexture(icon)

    local label = AucScannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", tex, "RIGHT", 5, 0)
    label:SetText(name)

    -- сохраним, чтобы обновить позже
    AucScannerFrame._peacebloom = { tex = tex, label = label, id = itemID }
end

local function RefreshIcons()
    if not AucScannerFrame._peacebloom then return end
    local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(AucScannerFrame._peacebloom.id)
    if name and icon then
        AucScannerFrame._peacebloom.tex:SetTexture(icon)
        AucScannerFrame._peacebloom.label:SetText(name)
    end
end

local function OnEvent(self, event, ...)
    if event == "GET_ITEM_INFO_RECEIVED" then
        RefreshIcons()
    end
end

local function AucScanner_OnLoad()
    SLASH_AUCSCANNER1 = "/aucs"
    SlashCmdList["AUCSCANNER"] = function()
        if AucScannerFrame:IsShown() then
            AucScannerFrame:Hide()
        else
            AucScannerFrame:Show()
            DrawPeacebloom()
        end
    end

    AucScannerFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    AucScannerFrame:SetScript("OnEvent", OnEvent)
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", AucScanner_OnLoad)
