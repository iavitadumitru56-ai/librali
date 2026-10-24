local PolarLib = (function()
    local function R(_)
        return cloneref and cloneref(game:GetService(_)) or game:GetService(_);
    end;
    local _, N = R("Players"), R("RunService");
    local h = R("UserInputService");
    local F = R("TweenService");
    local t = R("HttpService");
    local f = R("GuiService");
    local l = R("ReplicatedStorage");
    local g = R("Lighting");
    local u = R("Stats");
    local s, C, z, q, r, x, G, a, m = _.LocalPlayer, N, h, F, t, f, l, g, u;
    local N = s;
    local h = Color3.fromRGB;
    local F = Color3.fromHSV;
    local t = Color3.new;
    local f = UDim2.new;
    local l = UDim2.fromOffset;
    local g = UDim2.fromScale;
    local u = UDim.new;
    local s = Vector2.new;
    local c = ColorSequence.new;
    local n = ColorSequenceKeypoint.new;
    local O = NumberSequence.new;
    local j = NumberSequenceKeypoint.new;
    local E = math.clamp;
    local P = math.floor;
    local T = math.max;
    local Y = math.min;
    local v = math.abs;
    local Z = string.format;
    local L = string.sub;
    local o = string.upper;
    local X = string.lower;
    local Q = string.gsub;
    local S = string.match;
    local A = string.find;
    local J = table.find;
    local y = table.remove;
    local e = table.clear;
    local M = table.concat;
    local I = table.sort;
    local i = table.clone;
    local k = task.spawn;
    local B = task.delay;
    local d = task.defer;
    local b = Enum.TextXAlignment;
    local p = Enum.AutomaticSize.X;
    local D = Enum.AutomaticSize.Y;
    local V = Enum.AutomaticSize.XY;
    local W = Enum.AutomaticSize.None;
    local H = Enum.HorizontalAlignment;
    local w = Enum.VerticalAlignment;
    local UQ = Enum.TextTruncate.AtEnd;
    local KQ = Enum.UserInputType.MouseButton1;
    local RQ = Enum.UserInputType.MouseButton2;
    local _Q = Enum.UserInputType.MouseButton3;
    local NQ = Enum.UserInputType.MouseMovement;
    local hQ = Enum.UserInputType.Touch;
    local FQ = Enum.UserInputState.End;
    local tQ = Enum.KeyCode.Unknown;
    local fQ = Enum.PlaybackState.Completed;
    local lQ = Enum.EasingStyle.Quint;
    local gQ = Enum.EasingStyle.Quad;
    local uQ = Enum.EasingStyle.Sine;
    local sQ = t(1, 1, 1);
    local CQ = t(0, 0, 0);
    local zQ, qQ, rQ, xQ = getgenv(), base64encode, base64decode, {};
    xQ.__index = xQ;
    xQ.new = function()
        return setmetatable({}, xQ);
    end;
    xQ.add = function(GQ, aQ)
        GQ[#GQ + 1] = aQ;
        return aQ;
    end;
    xQ.clean = function(GQ)
        for aQ = #GQ, 1, -1 do
            local mQ = GQ[aQ];
            GQ[aQ] = nil;
            aQ = typeof(mQ);
            if aQ == "RBXScriptConnection" then
                mQ:Disconnect();
            elseif aQ == "Instance" then
                mQ:Destroy();
            elseif aQ == "function" then
                pcall(mQ);
            elseif aQ == "thread" then
                pcall(task.cancel, mQ);
            elseif aQ == "table" then
                if type(mQ.destroy) == "function" then
                    mQ:destroy();
                elseif type(mQ.clean) == "function" then
                    mQ:clean();
                end;
            end;
        end;
    end;

    local function GQ(aQ, mQ, cQ)
        local nQ = aQ:Connect(mQ);
        if cQ then
            cQ[#cQ + 1] = nQ;
        end;
        return nQ;
    end;

    local function aQ(mQ)
        local cQ, nQ = pcall(r.JSONEncode, r, mQ);
        return cQ and nQ or nil;
    end;

    local function mQ(cQ)
        if type(cQ) ~= "string" or cQ == "" then
            return nil;
        end;
        local nQ, OQ = pcall(r.JSONDecode, r, cQ);
        if nQ and type(OQ) == "table" then
            return OQ;
        end;
        return nil;
    end;

    local cQ;
    local function cQ_has(nQ)
        local OQ, jQ = pcall(isfile, nQ);
        return OQ and jQ == true;
    end;
    local function cQ_dir(nQ)
        local OQ, jQ = pcall(isfolder, nQ);
        if OQ and not jQ then
            pcall(makefolder, nQ);
        end;
    end;
    local function cQ_read(nQ)
        if cQ_has(nQ) then
            local OQ, jQ = pcall(readfile, nQ);
            if OQ then
                return jQ;
            end;
        end;
        return nil;
    end;
    local function cQ_write(nQ, OQ)
        return pcall(writefile, nQ, OQ);
    end;
    local function cQ_del(nQ)
        if cQ_has(nQ) then
            pcall(delfile, nQ);
        end;
    end;
    local function cQ_list(nQ)
        local OQ, jQ = pcall(isfolder, nQ);
        if OQ and jQ then
            local OQ, jQ = pcall(listfiles, nQ);
            if OQ and type(jQ) == "table" then
                return jQ;
            end;
        end;
        return {};
    end;

    cQ = {
        dir = cQ_dir,
        has = cQ_has,
        read = cQ_read,
        write = cQ_write,
        del = cQ_del,
        list = cQ_list
    };

    local nQ, OQ;
    do
        local function jQ(EQ)
            local PQ, TQ = pcall(request or http_request or (syn and syn.request), {Url = EQ, Method = "GET"});
            if PQ and type(TQ) == "table" and TQ.StatusCode == 200 and type(TQ.Body) == "string" then
                return TQ.Body;
            end;
            return nil;
        end;
        nQ = function(EQ)
            local PQ, TQ = pcall(getcustomasset, EQ);
            if PQ and type(TQ) == "string" then
                return TQ;
            end;
            return nil;
        end;
        local function EQ(PQ, TQ, YQ)
            if not cQ.has(PQ) then
                local vQ = jQ(TQ);
                if vQ then
                    if #vQ < (YQ or 1) or not cQ.write(PQ, vQ) then
                        return nil;
                    end;
                else
                    return nil;
                end;
            end;
            return nQ(PQ);
        end;
        OQ = EQ;
    end;

    local jQ, EQ = {};
    do
        local PQ = bit32.band;
        local TQ = bit32.bxor;
        local YQ = bit32.rshift;
        local vQ = buffer.create;
        local ZQ = buffer.writeu8;
        local LQ = buffer.readu8;
        local oQ = buffer.copy;
        local XQ = buffer.tostring;
        local QQ = math.exp;
        local SQ = math.sqrt;
        local AQ, JQ = string.byte, {};
        for yQ = 0, 255, 1 do
            local R = yQ;
            for eQ = 1, 8, 1 do
                R = if PQ(R, 1) == 1 then TQ(3988292384, YQ(R, 1)) else YQ(R, 1);
            end;
            JQ[yQ] = R;
        end;
        local function yQ(eQ, MQ, IQ)
            local iQ = 4294967295;
            for kQ = MQ, MQ + IQ - 1, 1 do
                iQ = TQ(JQ[PQ(TQ(iQ, LQ(eQ, kQ)), 255)], YQ(iQ, 8));
            end;
            return TQ(iQ, 4294967295);
        end;
        local function JQ_w(eQ, MQ, IQ)
            ZQ(eQ, MQ, PQ(YQ(IQ, 24), 255));
            ZQ(eQ, MQ + 1, PQ(YQ(IQ, 16), 255));
            ZQ(eQ, MQ + 2, PQ(YQ(IQ, 8), 255));
            ZQ(eQ, MQ + 3, PQ(IQ, 255));
        end;
        local eQ = {137, 80, 78, 71, 13, 10, 26, 10};
        local function MQ(IQ, iQ, kQ)
            local BQ = IQ * 4 + 1;
            local dQ = BQ * iQ;
            local bQ = vQ(dQ);
            for pQ = 0, iQ - 1, 1 do
                local DQ = pQ * BQ;
                ZQ(bQ, DQ, 0);
                for BQ = 0, IQ - 1, 1 do
                    local VQ, WQ, HQ, wQ = kQ(BQ, pQ);
                    local pQ = DQ + 1 + BQ * 4;
                    ZQ(bQ, pQ, VQ);
                    ZQ(bQ, pQ + 1, WQ);
                    ZQ(bQ, pQ + 2, HQ);
                    ZQ(bQ, pQ + 3, wQ);
                end;
            end;
            local BQ = math.ceil(dQ / 65535);
            kQ = 2 + dQ + BQ * 5 + 4;
            local pQ = vQ(45 + kQ + 12);
            for vQ = 1, 8, 1 do
                ZQ(pQ, vQ - 1, eQ[vQ]);
            end;
            local vQ = 8;
            local function eQ(DQ, VQ, WQ)
                JQ_w(pQ, vQ, VQ);
                for HQ = 1, 4, 1 do
                    ZQ(pQ, vQ + 3 + HQ, AQ(DQ, HQ));
                end;
                WQ(vQ + 8);
                JQ_w(pQ, vQ + 8 + VQ, yQ(pQ, vQ + 4, VQ + 4));
                DQ = vQ;
                vQ = DQ + (12 + VQ);
            end;
            eQ("IHDR", 13, function(vQ)
                JQ_w(pQ, vQ, IQ);
                JQ_w(pQ, vQ + 4, iQ);
                ZQ(pQ, vQ + 8, 8);
                ZQ(pQ, vQ + 9, 6);
                ZQ(pQ, vQ + 10, 0);
                ZQ(pQ, vQ + 11, 0);
                ZQ(pQ, vQ + 12, 0);
            end);
            eQ("IDAT", kQ, function(vQ)
                ZQ(pQ, vQ, 120);
                ZQ(pQ, vQ + 1, 1);
                local AQ, yQ, IQ = vQ + 2, 1, 0;
                for iQ = 0, BQ - 1, 1 do
                    vQ = iQ * 65535;
                    local kQ = Y(65535, dQ - vQ);
                    local dQ = TQ(kQ, 65535);
                    ZQ(pQ, AQ, iQ == BQ - 1 and 1 or 0);
                    ZQ(pQ, AQ + 1, PQ(kQ, 255));
                    ZQ(pQ, AQ + 2, YQ(kQ, 8));
                    ZQ(pQ, AQ + 3, PQ(dQ, 255));
                    ZQ(pQ, AQ + 4, YQ(dQ, 8));
                    oQ(pQ, AQ + 5, bQ, vQ, kQ);
                    for PQ = vQ, vQ + kQ - 1, 1 do
                        yQ = (yQ + LQ(bQ, PQ)) % 65521;
                        IQ = (IQ + yQ) % 65521;
                    end;
                    AQ = AQ + (5 + kQ);
                end;
                JQ_w(pQ, AQ, IQ * 65536 + yQ);
            end);
            eQ("IEND", 0, function() end);
            return XQ(pQ);
        end;

        local function PQ(TQ, YQ, vQ, ZQ, LQ)
            local oQ, XQ = v(TQ) - vQ + LQ, v(YQ) - ZQ + LQ;
            TQ, ZQ = T(oQ, 0), T(XQ, 0);
            return SQ(TQ * TQ + ZQ * ZQ) + Y(T(oQ, XQ), 0) - LQ;
        end;
        local function TQ(YQ, vQ, ZQ, LQ, oQ, XQ, SQ)
            return {
                w = YQ, h = vQ, v = 2,
                px = function(AQ, JQ)
                    local yQ = PQ(AQ + 0.5 - YQ / 2, JQ + 0.5 - vQ / 2, ZQ, LQ, oQ);
                    if yQ <= -1.25 or yQ >= XQ then
                        return 0, 0, 0, 0;
                    end;
                    AQ, JQ = 1 - T(yQ, 0) / XQ, yQ < 0 and (yQ + 1.25) / 1.25 or 1;
                    return 0, 0, 0, P(255 * SQ * AQ * AQ * JQ + 0.5);
                end
            };
        end;

        local YQ = {
            pshadow = TQ(63, 61, 17.5, 16.5, 16.5, 14, 0.42),
            bshadow = TQ(52, 52, 12, 12, 10, 14, 0.42),
            shadow = {
                w = 96, h = 96,
                px = function(TQ, vQ)
                    local ZQ = PQ(TQ + 0.5 - 48, vQ + 0.5 - 48, 20, 20, 12);
                    if ZQ <= 0 then
                        return 0, 0, 0, 0;
                    end;
                    return 0, 0, 0, P(127.5 * QQ(-3.4 * ZQ / 28) + 0.5);
                end
            },
            checker = {
                w = 2, h = 2,
                px = function(PQ, TQ)
                    local vQ = (PQ + TQ) % 2 == 0 and 206 or 146;
                    return vQ, vQ, vQ, 255;
                end
            }
        };

        local function PQ_gen(TQ)
            for vQ, ZQ in next, YQ, nil do
                local YQ_path = TQ .. "/" .. vQ .. "_v" .. (ZQ.v or 1) .. ".png";
                if not cQ.has(YQ_path) then
                    local TQ_ok, LQ_data = pcall(MQ, ZQ.w, ZQ.h, ZQ.px);
                    if TQ_ok then
                        cQ.write(YQ_path, LQ_data);
                    end;
                end;
                jQ[vQ] = nQ(YQ_path);
            end;
        end;
        EQ = PQ_gen;
    end;

    local function PQ(TQ, YQ)
        local vQ = Z("#%02x%02x%02x", P(TQ.R * 255 + 0.5), P(TQ.G * 255 + 0.5), P(TQ.B * 255 + 0.5));
        return if YQ then vQ .. Z("%02x", P(YQ * 255 + 0.5)) else vQ;
    end;

    local function TQ(YQ)
        if type(YQ) ~= "string" then
            return nil;
        end;
        YQ = Q(YQ, "[^%x]", "");
        local vQ = #YQ;
        if vQ ~= 6 and vQ ~= 8 then
            return nil;
        end;
        return h(tonumber(L(YQ, 1, 2), 16), tonumber(L(YQ, 3, 4), 16), tonumber(L(YQ, 5, 6), 16)), vQ == 8 and tonumber(L(YQ, 7, 8), 16) / 255 or 1;
    end;

    local YQ, vQ;
    do
        local function ZQ(LQ)
            return Q(Q(Q(tostring(LQ), "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
        end;
        local function LQ(oQ, XQ)
            return Q(ZQ(oQ), "{(.-)}", function(ZQ_c)
                return Z("<font color=\"%s\">%s</font>", PQ(XQ), ZQ_c);
            end);
        end;
        local ZQ_map = {
            Insert = "INS", Delete = "DEL", Home = "HOME", End = "END", PageUp = "PGUP", PageDown = "PGDN",
            LeftShift = "LSHIFT", RightShift = "RSHIFT", LeftControl = "LCTRL", RightControl = "RCTRL",
            LeftAlt = "LALT", RightAlt = "RALT", LeftSuper = "LWIN", RightSuper = "RWIN", CapsLock = "CAPS",
            Backspace = "BKSP", Return = "ENTER", Space = "SPACE", Tab = "TAB", Escape = "ESC",
            MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3", Zero = "0", One = "1", Two = "2",
            Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
            Backquote = "`", Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]", BackSlash = "\\",
            Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/", Up = "UP", Down = "DOWN",
            Left = "LEFT", Right = "RIGHT"
        };
        local function oQ(XQ)
            if not XQ then
                return nil;
            end;
            local QQ = ZQ_map[XQ];
            if QQ then
                return QQ;
            end;
            QQ = S(XQ, "^Keypad(.+)$");
            if QQ then
                return "NUM" .. (ZQ_map[QQ] or o(QQ));
            end;
            return o(XQ);
        end;
        YQ, vQ = LQ, oQ;
    end;

    local function o(ZQ)
        if ZQ.KeyCode ~= tQ then
            return ZQ.KeyCode.Name;
        end;
        local tQ_it = ZQ.UserInputType;
        if tQ_it == KQ or tQ_it == RQ or tQ_it == _Q then
            return tQ_it.Name;
        end;
        return nil;
    end;

    local tQ = {
        win = h(12, 12, 14), bg = h(7, 7, 9), pop = h(19, 19, 23), hud = h(12, 12, 15),
        txt = h(230, 230, 236), sub = h(170, 170, 178), dim = h(112, 112, 122), faint = h(68, 68, 76),
        knob = h(146, 146, 154), acc = h(200, 148, 232), ink = h(22, 14, 28), ok = h(128, 214, 156),
        bad = h(255, 112, 118), warn = h(255, 198, 96)
    };

    local ZQ = {
        card = 0.958, edge = 0.935, sep = 0.955, hov = 0.972, ctl = 0.952, ctle = 0.925,
        ctlh = 0.932, trk = 0.885, line = 0.94, tab = 0.925, sel = 0.952, phov = 0.962,
        psel = 0.945, pfil = 0.955
    };

    local LQ, oQ;
    do
        local XQ = Enum.FontWeight;
        LQ = {
            r = Font.new("rbxasset://fonts/families/BuilderSans.json", XQ.Regular),
            m = Font.new("rbxasset://fonts/families/BuilderSans.json", XQ.Medium),
            s = Font.new("rbxasset://fonts/families/BuilderSans.json", XQ.SemiBold),
            b = Font.new("rbxasset://fonts/families/BuilderSans.json", XQ.Bold),
            h = Font.new("rbxasset://fonts/families/Montserrat.json", XQ.Bold)
        };
        local QQ, SQ_f = {
            geist = {"geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RnOM4nQ.ttf", "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RruM4nQ.ttf", "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RQuQ4nQ.ttf", "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_Re-Q4nQ.ttf"},
            onest = {"onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPh9R-Zsg.ttf", "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhxx-Zsg.ttf", "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhKxiZsg.ttf", "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhEhiZsg.ttf"},
            inter = {"inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuLyfMZg.ttf", "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuI6fMZg.ttf", "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYMZg.ttf", "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuFuYMZg.ttf"}
        }, {{400, "Regular"}, {500, "Medium"}, {600, "SemiBold"}, {700, "Bold"}};
        local function AQ_f(JQ_p, yQ_n)
            yQ_n = QQ[yQ_n] and yQ_n or "geist";
            local eQ_f, MQ_f = QQ[yQ_n], table.create(4);
            for QQ_i = 1, 4, 1 do
                local IQ_w = SQ_f[QQ_i];
                local SQ_res = OQ(JQ_p .. "/" .. yQ_n .. "-" .. IQ_w[1] .. ".ttf", "https://fonts.gstatic.com/s/" .. eQ_f[QQ_i], 20000);
                if not SQ_res then
                    return false;
                end;
                MQ_f[QQ_i] = {name = IQ_w[2], weight = IQ_w[1], style = "normal", assetId = SQ_res};
            end;
            local QQ_json, SQ_json = JQ_p .. "/" .. yQ_n .. ".json", aQ({name = yQ_n, faces = MQ_f});
            if not SQ_json or not cQ.write(QQ_json, SQ_json) then
                return false;
            end;
            SQ_json = nQ(QQ_json);
            if not SQ_json then
                return false;
            end;
            LQ.r, LQ.m, LQ.s, LQ.b = Font.new(SQ_json, XQ.Regular), Font.new(SQ_json, XQ.Medium), Font.new(SQ_json, XQ.SemiBold), Font.new(SQ_json, XQ.Bold);
            return true;
        end;
        oQ = AQ_f;
    end;

    local nQ_ico = {
        logo = 106124864132557, code = 106124864132557, aim = 80648116191645, crosshair = 83752373575368,
        target = 121091323240554, dot = 122878673716704, trigger = 81854854241463, zap = 109718589733073,
        eye = 127234874352422, view = 127234874352422, players = 119713822992150, users = 85332511060401,
        user = 114567720540659, chams = 132705178126217, world = 75025349205767, globe = 125685532120024,
        move = 80792036653047, misc = 133109875194066, skins = 127369887384101, spray = 97652569554326,
        bug = 75649814233484, map = 131325044235094, configs = 97828544806816, folder = 77937190465422,
        settings = 106205298246017, cog = 123222732420633, sliders = 125396339381135, gear = 109485777305919,
        save = 122894934359450, chevron = 71457658246709, right = 101007429951147, dots = 95127553964880,
        check = 86817768619372, x = 116396312853810, keyboard = 121978468376124, plus = 101123124881873,
        pencil = 113132794872298, trash = 126010725826757, refresh = 106497040962250, load = 109698732019071,
        copy = 116378866141355, import = 87776530532335, clock = 136533241128438, wifi = 104941258142372,
        layers = 114499998778667, grip = 128492050787735, bomb = 85112456002145, shield = 106509993556171,
        sparkles = 105634041692696, sun = 139232691165198, bell = 84691420588185, gamepad = 99293705721130,
        flag = 121835250831612, feather = 103991922506350, ram = 82464660673318, cpu = 105237370909681,
        skull = 101060850237115, camera = 114084146151777, volume = 129861259578431, message = 86432989388834,
        power = 89331085993646
    };
    local function XQ(QQ_n)
        if QQ_n == nil then
            return "";
        end;
        local SQ_i = nQ_ico[QQ_n];
        if SQ_i then
            return "rbxassetid://" .. SQ_i;
        end;
        if type(QQ_n) == "number" then
            return "rbxassetid://" .. QQ_n;
        end;
        return tostring(QQ_n);
    end;

    local QQ;
    do
        local SQ_defs = {
            Frame = {BorderSizePixel = 0, BackgroundTransparency = 1},
            CanvasGroup = {BorderSizePixel = 0, BackgroundTransparency = 1},
            ScrollingFrame = {BorderSizePixel = 0, BackgroundTransparency = 1, ScrollBarThickness = 0, ScrollBarImageColor3 = sQ, ScrollBarImageTransparency = 1, CanvasSize = f(0, 0, 0, 0), AutomaticCanvasSize = D, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never},
            TextLabel = {BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = b.Left, TextSize = 14, Text = "", AutoLocalize = false},
            TextButton = {BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, Text = "", TextSize = 14, AutoLocalize = false},
            TextBox = {BorderSizePixel = 0, BackgroundTransparency = 1, ClearTextOnFocus = false, TextXAlignment = b.Left, TextSize = 14, Text = "", AutoLocalize = false},
            ImageLabel = {BorderSizePixel = 0, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit},
            ImageButton = {BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, ScaleType = Enum.ScaleType.Fit}
        };
        local AQ_txt = {TextLabel = true, TextButton = true, TextBox = true};
        local function JQ_inst(yQ_t, eQ_p, MQ_thm)
            local IQ_el, iQ_d = Instance.new(yQ_t), SQ_defs[yQ_t];
            if iQ_d then
                for k_p, v_p in next, iQ_d, nil do
                    IQ_el[k_p] = v_p;
                end;
            end;
            if AQ_txt[yQ_t] then
                IQ_el.FontFace = LQ.s;
                IQ_el.TextColor3 = tQ.txt;
            end;
            local iQ_par = nil;
            if eQ_p then
                for k_p, v_p in next, eQ_p, nil do
                    if k_p == "Parent" then
                        iQ_par = v_p;
                    else
                        IQ_el[k_p] = v_p;
                    end;
                end;
            end;
            if MQ_thm then
                for k_p, v_p in next, MQ_thm, nil do
                    IQ_el[k_p] = tQ[v_p];
                    IQ_el:SetAttribute("t_" .. k_p, v_p);
                end;
            end;
            if iQ_par then
                IQ_el.Parent = iQ_par;
            end;
            return IQ_el;
        end;
        QQ = JQ_inst;
    end;

    local function SQ(AQ_c, JQ_r)
        return QQ("UICorner", {CornerRadius = u(0, JQ_r or 6), Parent = AQ_c});
    end;
    local function AQ(JQ_c)
        return QQ("UICorner", {CornerRadius = u(1, 0), Parent = JQ_c});
    end;

    local JQ, yQ;
    do
        local eQ_stk, MQ_thk = setmetatable({}, {__mode = "k"}), 1;
        local function IQ_s(iQ_p, kQ_t, BQ_c)
            local dQ = QQ("UIStroke", {Color = BQ_c or sQ, Transparency = kQ_t or ZQ.edge, Thickness = MQ_thk, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = iQ_p});
            eQ_stk[dQ] = true;
            return dQ;
        end;
        local function iQ_s(kQ_sc, BQ_p)
            MQ_thk = kQ_sc < 1 and 1 / kQ_sc or 1;
            for s_el in next, eQ_stk, nil do
                if s_el.Parent then
                    s_el.Thickness = BQ_p and s_el:IsDescendantOf(BQ_p) and MQ_thk or 1;
                else
                    eQ_stk[s_el] = nil;
                end;
            end;
        end;
        JQ, yQ = IQ_s, iQ_s;
    end;

    local function eQ(MQ_p, IQ_l, iQ_r, kQ_t, BQ_b)
        return QQ("UIPadding", {PaddingLeft = u(0, IQ_l or 0), PaddingRight = u(0, iQ_r or 0), PaddingTop = u(0, kQ_t or 0), PaddingBottom = u(0, BQ_b or 0), Parent = MQ_p});
    end;
    local function MQ_lay(IQ_p, iQ_pad, kQ_al)
        return QQ("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = u(0, iQ_pad or 0), HorizontalAlignment = kQ_al or H.Left, Parent = IQ_p});
    end;
    local function IQ_lay(iQ_p, kQ_pad, BQ_al)
        return QQ("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal, Padding = u(0, kQ_pad or 0), HorizontalAlignment = BQ_al or H.Left, VerticalAlignment = w.Center, Parent = iQ_p});
    end;

    local w;
    do
        local iQ_tw = {};
        local function kQ_tw(BQ_i, dQ_g, bQ_t, pQ_s, DQ_d)
            bQ_t, pQ_s, DQ_d = bQ_t or 0.16, pQ_s or lQ, DQ_d or 0;
            local lQ_k = pQ_s.Name .. bQ_t .. ":" .. DQ_d;
            local VQ = iQ_tw[lQ_k];
            if not VQ then
                VQ = TweenInfo.new(bQ_t, pQ_s, Enum.EasingDirection.Out, 0, false, DQ_d);
                iQ_tw[lQ_k] = VQ;
            end;
            local tw = q:Create(BQ_i, VQ, dQ_g);
            tw:Play();
            return tw;
        end;
        w = kQ_tw;
    end;

    local function lQ(iQ_e, kQ_p)
        local BQ, dQ = iQ_e.AbsolutePosition, iQ_e.AbsoluteSize;
        return kQ_p.X >= BQ.X and kQ_p.Y >= BQ.Y and kQ_p.X <= BQ.X + dQ.X and kQ_p.Y <= BQ.Y + dQ.Y;
    end;

    local iQ = {flags = {}, els = {}, fl = {}, profs = {}, dir = "polar", thm = tQ, fnt = LQ, ico = nQ_ico, ver = "1.0.0"};
    local kQ = {
        md = xQ.new(), pops = {}, bmap = {}, drag = {}, open = false, dead = false,
        live = false, fn = 0, unl = {}, bgt = 0.08, blur = true,
        hbg = setmetatable({}, {__mode = "k"})
    };

    local function nQ()
        local BQ = kQ.us;
        return BQ and BQ.Scale or 1;
    end;
    local function BQ()
        if kQ.tp then
            return kQ.tp;
        end;
        local dQ, bQ = z:GetMouseLocation(), kQ.probe;
        if bQ then
            return dQ + bQ.AbsolutePosition;
        end;
        return dQ;
    end;
    local function dQ(bQ)
        local pQ = bQ.Position;
        return s(pQ.X, pQ.Y);
    end;
    local function bQ(pQ)
        return pQ == KQ or pQ == hQ;
    end;

    local pQ, DQ, VQ, WQ;
    local function HQ(wQ, Ui, Ki, Ri)
        local _i = kQ.drag;
        _i.mv = wQ;
        _i.up = Ui;
        _i.own = Ki;
        _i.ti = Ri and Ri.UserInputType == hQ and Ri or nil;
    end;
    local function wQ(Ui)
        local Ki = kQ.drag;
        local Ri = Ki.up;
        Ki.mv = nil;
        Ki.up = nil;
        Ki.own = nil;
        Ki.ti = nil;
        if Ri then
            Ri(Ui);
        end;
    end;

    local Ui = setmetatable({}, {__mode = "k"});
    local Ki, Ri;
    do
        local function _i(Ni, hi)
            local Fi = kQ.pops;
            local ti = Ni and J(Fi, Ni) or 0;
            for idx = #Fi, ti + 1, -1 do
                if lQ(Fi[idx].frame, hi) then
                    return true;
                end;
            end;
            return false;
        end;
        local function Ni(hi, Fi)
            local ti, fi = hi.o, hi.p;
            if ti.Parent == nil then
                hi.i = false;
                Ui[hi] = nil;
            end;
            local li = hi.i and kQ.open and (fi == nil or fi.isopen == true) and lQ(ti, Fi) and not _i(fi, Fi);
            if li ~= hi.s then
                hi.s = li;
                if li then
                    hi.on();
                else
                    hi.off();
                end;
            end;
        end;
        local function _i_all()
            if next(Ui) == nil then
                return;
            end;
            local hi = BQ();
            for Fi in next, Ui, nil do
                Ni(Fi, hi);
            end;
        end;
        local function hi_reg(Fi, ti, fi, li)
            local gi = {o = Fi, p = ti, on = fi, off = li, i = false, s = false};
            GQ(Fi.MouseEnter, function()
                gi.i = true;
                Ui[gi] = true;
                Ni(gi, BQ());
            end);
            GQ(Fi.MouseLeave, function()
                gi.i = false;
                Ui[gi] = nil;
                Ni(gi, BQ());
            end);
            return gi;
        end;
        Ki, Ri = _i_all, hi_reg;
    end;

    local function _i(Ni, hi, Fi, ti, fi, li)
        return Ri(Ni, hi, function()
            w(Ni, {[Fi] = fi}, li or 0.12);
        end, function()
            w(Ni, {[Fi] = ti}, li or 0.12);
        end);
    end;

    local function Ni(hi, Fi)
        GQ(hi.InputBegan, function(inp)
            if inp.UserInputType ~= hQ then
                return;
            end;
            local ti = inp.Position;
            B(0.5, function()
                if inp.UserInputState ~= FQ and (inp.Position - ti).Magnitude < 10 and not kQ.dead then
                    Fi(inp);
                end;
            end);
        end);
    end;

    local function FQ_hit(hi)
        return QQ("TextButton", {Size = g(1, 1), ZIndex = 0, Parent = hi});
    end;

    local function hi_shd(Fi, ti, fi)
        if not jQ.shadow then
            return nil;
        end;
        local li = (ti or 12) / 12;
        ti = P(28 * li + 0.5);
        return QQ("ImageLabel", {Image = jQ.shadow, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(40, 40, 56, 56), SliceScale = li, ImageTransparency = fi or 0, Position = l(-ti, -ti), Size = f(1, ti * 2, 1, ti * 2), ZIndex = 0, Parent = Fi});
    end;

    local function Fi_live()
        return kQ.live == true and kQ.open and kQ.ft == nil and not kQ.dead;
    end;

    local ti_cgrp = setmetatable({}, {__mode = "k"});
    local fi_anim;
    do
        local li_ease = Enum.EasingStyle.Cubic;
        local function gi_c(ui, si, Ci, zi, qi, ri)
            local xi, Gi = ti_cgrp[ui];
            if not xi then
                if (qi and kQ.live and not kQ.dead or Fi_live()) and ui.Parent then
                    if not si and not ui.Visible then
                        if ri then ri(); end;
                        return;
                    end;
                    local ai, mi = ui.AutomaticSize, ui.Size;
                    local ci, ni, Oi, ji = ai == p or ai == V, ai == D or ai == V, qi and 20 or 0, ui.AnchorPoint;
                    xi = {
                        p = ui.Parent, pos = ui.Position, ap = ji, sz = mi, n = 0, m = Oi,
                        d = l(Oi * (2 * ji.X - 1), Oi * (2 * ji.Y - 1)),
                        g = QQ("CanvasGroup", {Position = ui.Position + l(Oi * (2 * ji.X - 1), Oi * (2 * ji.Y - 1)), AnchorPoint = ji, Size = mi + l(Oi * 2, Oi * 2), AutomaticSize = ai, LayoutOrder = ui.LayoutOrder, ZIndex = ui.ZIndex, GroupTransparency = si and 1 or 0, Parent = ui.Parent})
                    };
                    if Oi > 0 then
                        eQ(xi.g, Oi, Oi, Oi, Oi);
                    end;
                    ti_cgrp[ui] = xi;
                    ui.Parent = xi.g;
                    ui.AnchorPoint = s(0, 0);
                    ui.Position = l(0, 0);
                    ui.Size = f(ci and 0 or 1, ci and mi.X.Offset or 0, ni and 0 or 1, ni and mi.Y.Offset or 0);
                    Gi = xi;
                else
                    ui.Visible = si;
                    if ri then ri(); end;
                    return;
                end;
            else
                Gi = xi;
            end;
            Gi.n = Gi.n + 1;
            local qi_n = Gi.n;
            if si then
                ui.Visible = true;
            end;
            Gi.g.Interactable = si;
            local xi_g, ai_p, mi_t, ci_e, ni_cb = Gi.g, {GroupTransparency = si and 0 or 1}, Ci or 0.2, si and gQ or li_ease, function(fin)
                if fin ~= fQ or Gi.n ~= qi_n or ti_cgrp[ui] ~= Gi then
                    return;
                end;
                ti_cgrp[ui] = nil;
                if not si then
                    ui.Visible = false;
                end;
                pcall(function()
                    ui.Parent = Gi.p;
                    ui.Position, ui.AnchorPoint, ui.Size = Gi.pos, Gi.ap, Gi.sz;
                end);
                Gi.g:Destroy();
                if ri then ri(); end;
            end;
            w(xi_g, ai_p, mi_t, ci_e, si and zi or nil).Completed:Once(ni_cb);
        end;
        fi_anim = gi_c;
    end;

    local function li(gi)
        local ui = ti_cgrp[gi];
        if ui then
            ti_cgrp[gi] = nil;
            ui.g:Destroy();
        end;
        gi:Destroy();
    end;
    local function gi(ui)
        local si = ti_cgrp[ui];
        return si and si.pos or ui.Position;
    end;
    local function ui(si, Ci)
        local zi = ti_cgrp[si];
        if zi then
            zi.pos = Ci;
            zi.g.Position = Ci + zi.d;
        else
            si.Position = Ci;
        end;
    end;
    local function si_sz(Ci, zi)
        local qi = ti_cgrp[Ci];
        if qi then
            qi.sz = zi;
            qi.g.Size = zi + l(qi.m * 2, qi.m * 2);
        else
            Ci.Size = zi;
        end;
    end;

    local Ci_vis = setmetatable({}, {__mode = "k"});
    local function zi(qi, ri, xi)
        if Ci_vis[qi] == ri then
            return;
        end;
        Ci_vis[qi] = ri;
        fi_anim(qi, ri, xi or 0.2, nil, true);
    end;

    local qi_pop, ri_pop;
    do
        local xi_cls = {};
        xi_cls.__index = xi_cls;
        local function Gi_w(ai, mi, ci)
            local ni = kQ.mt;
            if not ni or not ni.Parent then
                ni = QQ("TextLabel", {Size = l(0, 0), TextTransparency = 1, Parent = kQ.gui});
                kQ.mt = ni;
            end;
            ni.FontFace = mi or LQ.s;
            ni.TextSize = ci or 13;
            ni.Text = X(tostring(ai or ""));
            return ni.TextBounds.X;
        end;
        local ai_low = setmetatable({}, {__mode = "k"});
        local function R_low(obj)
            GQ(obj.DescendantAdded, function(desc)
                if ai_low[desc] then return; end;
                local mi = desc:IsA("TextBox") and "PlaceholderText" or (desc:IsA("TextLabel") or desc:IsA("TextButton")) and "Text";
                if not mi then return; end;
                ai_low[desc] = true;
                local function ai_fn()
                    local ci = desc[mi];
                    local ni = X(ci);
                    if ci ~= ni then desc[mi] = ni; end;
                end;
                ai_fn();
                GQ(desc:GetPropertyChangedSignal(mi), ai_fn);
            end);
        end;

        local function _pop(ai)
            local mi = setmetatable({w = ai.w or 180, aw = ai.w == nil and not ai.raw, keep = ai.keep, par = ai.par, anchor = ai.anchor, md = xQ.new(), isopen = false, px = 0, py = 0, an = 0}, xi_cls);
            mi.box = QQ("Frame", {Size = l(mi.w, 0), Visible = false, Parent = kQ.pl});
            local xQ_r, ci = ai.rad or 10, QQ("Frame", {Size = g(1, 1), BackgroundTransparency = 0, Parent = mi.box}, {BackgroundColor3 = "pop"});
            mi.frame = ci;
            SQ(ci, xQ_r);
            QQ("UIGradient", {Rotation = 90, Color = c(sQ, t(0.84, 0.84, 0.86)), Parent = ci});
            QQ("UIGradient", {Rotation = 90, Transparency = O(0.1, 0.75), Parent = JQ(ci, 0.88)});
            hi_shd(ci, xQ_r, 0);
            FQ_hit(ci);
            local t_h = QQ("Frame", {Size = f(1, 0, 0, 46), BackgroundColor3 = sQ, BackgroundTransparency = 0, ZIndex = 1, Parent = ci});
            SQ(t_h, xQ_r);
            QQ("UIGradient", {Rotation = 90, Transparency = O({j(0, 0.962), j(0.7, 0.99), j(1, 1)}), Parent = t_h});
            local t_b = QQ("Frame", {Size = f(1, 0, 0, 0), AutomaticSize = D, ZIndex = 2, Parent = ci});
            mi.body = t_b;
            GQ(t_b:GetPropertyChangedSignal("AbsoluteSize"), function() mi:fit(); end);
            if not ai.raw then
                eQ(t_b, 6, 6, ai.title and 0 or 6, 6);
                MQ_lay(t_b, 6);
                if ai.title then mi:head(ai.title); end;
                mi.c = VQ(t_b, ai.tab, mi);
                mi.c.tmp = ai.tmp;
            end;
            return mi;
        end;

        xi_cls.head = function(t_self, xQ_t)
            local ai = QQ("Frame", {Size = f(1, 0, 0, 38), LayoutOrder = -1, Parent = t_self.body});
            t_self.ttl = X(tostring(xQ_t or ""));
            QQ("TextLabel", {Position = l(12, 1), Size = f(1, -48, 1, 0), Text = t_self.ttl, FontFace = LQ.h, TextSize = 14, TextTruncate = UQ, Parent = ai}, {TextColor3 = "txt"});
            local xQ_r = QQ("Frame", {AnchorPoint = s(1, 0.5), Position = f(1, -2, 0.5, 1), Size = l(0, 24), AutomaticSize = p, Parent = ai});
            IQ_lay(xQ_r, 2, H.Right);
            t_self.hd = ai;
            t_self.hr = xQ_r;
            return ai;
        end;

        xi_cls.fitw = function(t_self)
            local xQ_s = nQ();
            local ai, mi = if t_self.ttl then T(172, 12 + Gi_w(t_self.ttl, LQ.h, 14) + 16 + t_self.hr.AbsoluteSize.X / xQ_s + 14) else 172, t_self.rws;
            if mi then
                for ci = #mi, 1, -1 do
                    local ni = mi[ci];
                    if ni.r.Parent then
                        ai = if ni.r.Visible then T(ai, ni.x + (ni.n and Gi_w(X(ni.n)) + 8 or 0) + ni.af.AbsoluteSize.X / xQ_s + 26) else ai;
                    else
                        y(mi, ci);
                    end;
                end;
            end;
            t_self.w = P(Y(ai, 340) + 0.5);
        end;

        xi_cls.hbtn = function(t_self, xQ_i, Gi_c, ai_cb)
            local mi = QQ("ImageButton", {Size = l(24, 24), BackgroundColor3 = sQ, BackgroundTransparency = 1, Parent = t_self.hr});
            SQ(mi, 7);
            local ci = QQ("ImageLabel", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(13, 13), Image = XQ(xQ_i), Parent = mi}, {ImageColor3 = "dim"});
            Ri(mi, t_self, function()
                w(mi, {BackgroundTransparency = ZQ.pfil}, 0.12, gQ);
                w(ci, {ImageColor3 = tQ[Gi_c or "txt"]}, 0.12, gQ);
            end, function()
                w(mi, {BackgroundTransparency = 1}, 0.12, gQ);
                w(ci, {ImageColor3 = tQ.dim}, 0.12, gQ);
            end);
            GQ(mi.MouseButton1Click, ai_cb);
            return mi, ci;
        end;

        xi_cls.fit = function(t_self)
            local xQ_y = t_self.body.AbsoluteSize.Y / nQ();
            t_self.box.Size = l(t_self.w, P(xQ_y + 0.5));
        end;

        xi_cls.clampit = function(t_self)
            local xQ_b = t_self.box;
            if not xQ_b.Parent or not kQ.pl then return; end;
            local Gi, ai, mi, ci, ni = nQ(), kQ.pl.AbsolutePosition, kQ.probe.AbsolutePosition, kQ.gui.AbsoluteSize, t_self.frame.AbsoluteSize;
            local Oi, ji = E(ai.X + t_self.px * Gi, mi.X + 6, T(mi.X + 6, mi.X + ci.X - ni.X - 6)), E(ai.Y + t_self.py * Gi, mi.Y + 6, T(mi.Y + 6, mi.Y + ci.Y - ni.Y - 6));
            xQ_b.Position = l(P((Oi - ai.X) / Gi + 0.5), P((ji - ai.Y) / Gi + 0.5));
        end;

        xi_cls.place = function(t_self, xQ_x, Gi_y)
            local ai, mi = nQ(), kQ.pl.AbsolutePosition;
            t_self.px, t_self.py = (xQ_x - mi.X) / ai, (Gi_y - mi.Y) / ai;
            t_self.box.Position = l(t_self.px, t_self.py);
            t_self:clampit();
            t_self.md:add(t_self.frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() t_self:clampit(); end));
        end;

        local function t_cg_clean(xQ_p)
            local Gi = xQ_p.cg;
            if Gi then
                xQ_p.cg = nil;
                if xQ_p.frame.Parent == Gi then
                    xQ_p.frame.Parent = xQ_p.box;
                end;
                Gi:Destroy();
            end;
        end;

        xi_cls.settle = function(xQ_p)
            xQ_p.an = xQ_p.an + 1;
            t_cg_clean(xQ_p);
        end;

        xi_cls.anim = function(xQ_p, Gi, ai)
            xQ_p.an = xQ_p.an + 1;
            local mi = xQ_p.an;
            local ci = xQ_p.cg;
            if not ci then
                ci = QQ("CanvasGroup", {Position = l(-24, -24), Size = f(1, 48, 1, 48), GroupTransparency = Gi and 1 or 0, Parent = xQ_p.box});
                eQ(ci, 24, 24, 24, 24);
                xQ_p.cg = ci;
                xQ_p.frame.Parent = ci;
            end;
            ci.Interactable = Gi;
            local ni, Oi, ji = {GroupTransparency = Gi and 0 or 1}, Gi and 0.2 or 0.18, Gi and gQ or uQ;
            w(ci, ni, Oi, ji).Completed:Once(function(fin)
                if fin ~= fQ or xQ_p.an ~= mi then return; end;
                t_cg_clean(xQ_p);
                if ai then ai(); end;
            end);
        end;

        xi_cls.hide = function(t_self, uQ_f)
            if not t_self.isopen then return; end;
            t_self.isopen = false;
            t_self.md:clean();
            if kQ.drag.own == t_self then wQ(); end;
            local xQ_l = kQ.listen;
            if xQ_l and xQ_l.c and xQ_l.c.pop == t_self then
                kQ.listen = nil;
                xQ_l.lst = false;
                xQ_l:draw();
            end;
            local cb = t_self.onclose;
            if cb then
                t_self.onclose = nil;
                cb();
            end;
            local xQ_b, xi_fin = t_self.box;
            if t_self.keep then
                xi_fin = function() xQ_b.Visible = false; end;
            else
                t_self.dead = true;
                xi_fin = function() xQ_b:Destroy(); end;
            end;
            if uQ_f or not Fi_live() then
                t_self:settle();
                xi_fin();
            else
                t_self:anim(false, xi_fin);
            end;
        end;

        qi_pop, ri_pop = R_low, _pop;
    end;

    local function R_pop_close(from, immed)
        local uQ = kQ.pops;
        local xQ = #uQ;
        for idx = xQ, T(from, 1), -1 do
            local Gi = uQ[idx];
            uQ[idx] = nil;
            Gi:hide(immed);
        end;
        if xQ >= T(from, 1) then
            Ki();
        end;
    end;
    local function _pop_close_all(immed)
        R_pop_close(1, immed);
    end;
    local function t_pop_close_inst(uQ)
        local xQ = J(kQ.pops, uQ);
        if xQ then
            R_pop_close(xQ);
        end;
    end;
    local function uQ_pop_open(xQ, xi, Gi)
        local ai = kQ.pops;
        R_pop_close((xQ.par and J(ai, xQ.par) or 0) + 1);
        ai[#ai + 1] = xQ;
        xQ.isopen = true;
        xQ.box.ZIndex = 10 + #ai;
        xQ.box.Visible = true;
        if xQ.aw then xQ:fitw(); end;
        xQ:fit();
        xQ:place(xi, Gi);
        if Fi_live() then xQ:anim(true); else xQ:settle(); end;
        Ki();
    end;

    local function xQ_pop_hit(Fi)
        local xi = kQ.pops;
        for Gi = #xi, 1, -1 do
            local ai = xi[Gi];
            if lQ(ai.frame, Fi) then
                R_pop_close(Gi + 1);
                return;
            elseif ai.anchor and ai.anchor.Parent and lQ(ai.anchor, Fi) then
                R_pop_close(Gi + 1);
                return;
            end;
        end;
        _pop_close_all();
    end;

    local function Fi_bind_add(xi, Gi)
        local ai = kQ.bmap[Gi];
        if not ai then
            ai = {};
            kQ.bmap[Gi] = ai;
        end;
        if not J(ai, xi) then
            ai[#ai + 1] = xi;
        end;
    end;
    local function xi_bind_rem(Gi, ai)
        local mi = kQ.bmap[ai];
        if not mi then return; end;
        local ci = J(mi, Gi);
        if ci then y(mi, ci); end;
        if #mi == 0 then kQ.bmap[ai] = nil; end;
    end;

    local Gi_mouse = {MouseButton1 = true, MouseButton2 = true, MouseButton3 = true};
    local function ai_in_gui(mi)
        if not mi or not kQ.open or not kQ.root then return false; end;
        if lQ(kQ.root, mi) then return true; end;
        local ci = kQ.pops;
        for ni = 1, #ci, 1 do
            if lQ(ci[ni].frame, mi) then return true; end;
        end;
        return false;
    end;

    local function lQ_inp_beg(mi)
        if kQ.dead then return; end;
        local ci, ni = mi.UserInputType;
        if ci == hQ then
            ni = dQ(mi);
            kQ.tp = ni;
        elseif ci == KQ or ci == RQ or ci == _Q then
            kQ.tp = nil;
            ni = BQ();
        end;
        local RQ_ls = kQ.listen;
        if RQ_ls then
            local Oi = o(mi);
            if Oi then
                kQ.listen = nil;
                RQ_ls.lst = false;
                if Oi == "Escape" or Oi == "Backspace" then
                    RQ_ls:setkey(nil);
                elseif Gi_mouse[Oi] and RQ_ls.o.nomouse or Oi == "MouseButton1" and ai_in_gui(ni) then
                    RQ_ls:draw();
                else
                    if Gi_mouse[Oi] then
                        kQ.eat = RQ_ls;
                        B(0.35, function() if kQ.eat == RQ_ls then kQ.eat = nil; end; end);
                    end;
                    RQ_ls:setkey(Oi);
                end;
                return;
            end;
        end;
        if ni and ci ~= _Q and #kQ.pops > 0 then
            xQ_pop_hit(ni);
        end;
        if ci == hQ then return; end;
        ci = o(mi);
        if not ci or z:GetFocusedTextBox() or ai_in_gui(ni) then return; end;
        if ci == "Escape" and kQ.open and #kQ.pops > 0 then
            t_pop_close_inst(kQ.pops[#kQ.pops]);
            return;
        end;
        local map = kQ.bmap[ci];
        if map then
            for idx = #map, 1, -1 do
                local el = map[idx];
                if el then el:bdown(); end;
            end;
        end;
    end;

    local function RQ_inp_end(_Q_e)
        if kQ.dead then return; end;
        local xQ_t, ai_d = _Q_e.UserInputType, kQ.drag;
        if xQ_t == hQ and kQ.tg and kQ.tg.i == _Q_e then
            local tg = kQ.tg;
            kQ.tg = nil;
            tg.tap(dQ(_Q_e));
        end;
        if ai_d.mv then
            if xQ_t == KQ and not ai_d.ti then
                wQ(true);
            elseif xQ_t == hQ and ai_d.ti == _Q_e then
                wQ(true);
            end;
        end;
        local code = o(_Q_e);
        if not code then return; end;
        local map = kQ.bmap[code];
        if map then
            for idx = #map, 1, -1 do
                local el = map[idx];
                if el then el:bup(); end;
            end;
        end;
    end;

    local function o_inp_chg(_Q_e)
        if kQ.dead then return; end;
        local xQ_t, ai_d = _Q_e.UserInputType, kQ.drag;
        if xQ_t == NQ then
            kQ.tp = nil;
            if ai_d.mv and not ai_d.ti then
                ai_d.mv(BQ());
            end;
            Ki();
        elseif xQ_t == hQ then
            local pos = dQ(_Q_e);
            kQ.tp = pos;
            local tg = kQ.tg;
            if tg and tg.i == _Q_e then
                local dx, dy = v(pos.X - tg.p0.X), v(pos.Y - tg.p0.Y);
                if dx > 6 and dx >= dy then
                    kQ.tg = nil;
                    tg.drag(pos);
                elseif dy > 6 then
                    kQ.tg = nil;
                end;
            end;
            if ai_d.mv and ai_d.ti == _Q_e then
                ai_d.mv(pos);
            end;
        end;
    end;

    local function v_focus_rel()
        for _, NQ_l in next, kQ.bmap, nil do
            for idx = #NQ_l, 1, -1 do
                local el = NQ_l[idx];
                if el then el:bup(); end;
            end;
        end;
    end;

    local function _Q_pop_sub(NQ_p)
        local idx = NQ_p and J(kQ.pops, NQ_p);
        R_pop_close(idx and idx + 1 or 1);
    end;

    -- [Конец Части 1]

    -- [Начало Части 2]

    do 
        local R = {};
        R.__index = R;
        local NQ, xQ, ai = 0, setmetatable, {__mode = "k"};
        local mi = xQ({}, ai);
        local function xQ(ai, ci, ni, Oi)
            NQ += 1;
            local ji, Ei = setmetatable, {
                id = NQ, kind = Oi, c = ci, o = ni,
                name = ni.name or ni.text or "", flag = ni.flag,
                cb = ni.cb or ni.callback, dis = false, an = 0,
                tmp = ni.tmp or ci and ci.tmp or false
            };
            return ji(Ei, ai);
        end;

        local function NQ(ai)
            local ci = ai.h == true or (ai.o or 0) > 0;
            if ai.l == ci then 
                return;
            end;
            ai.l = ci;
            local ni, Oi, ji = ai.hl, {}, ci and (ai.b.soft and ZQ.phov or ZQ.hov);
            Oi.BackgroundTransparency = ji or 1;
            w(ni, Oi, 0.12, gQ);
        end;

        local function ai(ci, ni)
            local Oi = ci and mi[ci];
            if Oi then 
                if not Oi.hl then 
                    return;
                end;
            else 
                return;
            end;
            Oi.o = T(0, (Oi.o or 0) + (ni and 1 or -1));
            NQ(Oi);
        end;

        local ci = {};
        ci.__index = ci;
        local function ni(Oi, ji, Ei, Pi)
            local Ti = QQ("Frame", {
                Size = f(1, 0, 0, 0), AutomaticSize = D,
                BackgroundColor3 = sQ, BackgroundTransparency = Ei and ZQ.card or 1,
                LayoutOrder = ji, Parent = Oi
            });
            if Ei then 
                SQ(Ti, 7);
                JQ(Ti, ZQ.edge);
            end;
            MQ_lay(Ti, 0);
            return setmetatable({f = Ti, rows = {}, n = 0, rad = Ei and 7 or 0, pop = Pi, soft = not Ei}, ci);
        end;

        ci.fix = function(Oi)
            local ji, Ei, Pi = Oi.rows;
            for Ti = 1, #ji, 1 do 
                local Yi = ji[Ti];
                if Yi.r.Visible then 
                    Ei, Pi = Ei or Yi, Yi;
                end;
            end;
            local Ti = Oi.rad;
            for Yi = 1, #ji, 1 do 
                local vi = ji[Yi];
                if vi.sp then 
                    vi.sp.Visible = vi ~= Ei;
                end;
                local hl_c = vi.hc and vi.hl;
                if hl_c then 
                    local ji_is, Zi_is = Ti > 0 and vi == Ei, Ti > 0 and vi == Pi;
                    vi.hc.CornerRadius = u(0, (ji_is or Zi_is) and Ti or 0);
                    if ji_is and not Zi_is then 
                        vi.hl.Position, vi.hl.Size = l(0, 0), f(1, 0, 1, Ti);
                    elseif Zi_is and not ji_is then 
                        vi.hl.Position, vi.hl.Size = l(0, -Ti), f(1, 0, 1, Ti);
                    else 
                        vi.hl.Position, vi.hl.Size = l(0, 0), g(1, 1);
                    end;
                end;
            end;
            Oi.f.Visible = Ei ~= nil;
        end;

        ci.add = function(Oi, ji, Ei)
            Oi.n = Oi.n + 1;
            local Pi = QQ("Frame", {Size = f(1, 0, 0, ji), LayoutOrder = Oi.n, Parent = Oi.f});
            local Ti = {r = Pi, b = Oi};
            if not Oi.soft then 
                Ti.sp = QQ("Frame", {Size = f(1, 0, 0, 1), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.sep, ZIndex = 3, Parent = Pi});
            end;
            if if Ei then not Ei else Oi.soft then 
                Ti.hl = QQ("Frame", {Size = g(1, 1), BackgroundColor3 = sQ, BackgroundTransparency = 1, ZIndex = 0, Parent = Pi});
                SQ(Ti.hl, 7);
                Ri(Pi, Oi.pop, function()
                    Ti.h = true;
                    NQ(Ti);
                end, function()
                    Ti.h = false;
                    NQ(Ti);
                end);
            elseif not Ei then 
                local ji_f = QQ("Frame", {Size = g(1, 1), ClipsDescendants = true, ZIndex = 0, Parent = Pi});
                Ti.hl = QQ("Frame", {Size = g(1, 1), BackgroundColor3 = sQ, BackgroundTransparency = 1, ZIndex = 0, Parent = ji_f});
                Ti.hc = SQ(Ti.hl, 0);
                Ri(Pi, Oi.pop, function()
                    Ti.h = true;
                    NQ(Ti);
                end, function()
                    Ti.h = false;
                    NQ(Ti);
                end);
            end;
            mi[Pi] = Ti;
            local rows = Oi.rows;
            rows[#rows + 1] = Ti;
            Oi:fix();
            return Pi, Ti;
        end;

        ci.del = function(NQ, Oi)
            local ji = mi[Oi];
            if not ji then return; end;
            mi[Oi] = nil;
            local Ei = NQ.rows;
            local Pi = J(Ei, ji);
            if Pi then y(Ei, Pi); end;
            Oi:Destroy();
            NQ:fix();
        end;

        ci.clear = function(NQ)
            local ci_r = NQ.rows;
            for Oi = #ci_r, 1, -1 do 
                local ji = ci_r[Oi];
                mi[ji.r] = nil;
                ji.r:Destroy();
                ci_r[Oi] = nil;
            end;
            NQ.n = 0;
            NQ:fix();
        end;

        R.get = function(self) return self.val; end;
        R.eff = function(self) return self.val; end;
        R.ser = function(self) return self.val; end;
        R.unser = function(self, val) return val; end;
        R.load = function(self) end;
        R.draw = function(self) end;
        R.rw = function(self) return self.row or self.host and self.host.row; end;
        R.nexta = function(self) self.an = self.an + 1; return self.an * 2; end;
        R.hostof = function(self) if self.accf then return self; end; return self.host; end;

        local function NQ_acc(ci, Oi)
            local ji = ci.accs;
            if not ji then ji = {}; ci.accs = ji; end;
            ji[#ji + 1] = Oi;
            Oi.host = ci;
            if Oi.name == "" then Oi.name = ci.name; end;
        end;

        R.kbdraw = function(ci)
            local Oi = ci.bnd;
            if not Oi then return; end;
            local ji, Ei = Oi.key, ci.kt;
            if ji and not Ei then 
                local Pi = ci:hostof();
                if not Pi then return; end;
                local Ti = QQ("TextButton", {
                    Size = l(0, 18), AutomaticSize = p, TextSize = 11,
                    BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl,
                    LayoutOrder = (ci.lo or 1000000) - 1, Parent = Pi.accf
                }, {TextColor3 = "dim"});
                SQ(Ti, 4);
                JQ(Ti, ZQ.ctle);
                eQ(Ti, 6, 6, 0, 0);
                GQ(Ti.MouseButton1Click, function() DQ(ci); end);
                ci.kt = Ti;
                Ei = Ti;
            end;
            if Ei then 
                Ei.Visible = ji ~= nil;
                if ji then 
                    Ei.Text = vQ(ji);
                    w(Ei, {TextColor3 = Oi.act and tQ.acc or tQ.dim}, 0.12, gQ);
                end;
            end;
        end;

        R.bdown = function(ci)
            local Oi = ci.bnd;
            if not Oi or ci.dis or ci.dead then return; end;
            if Oi.mode == "hold" then 
                if not Oi.act then 
                    Oi.act = true;
                    ci:draw();
                    ci:fire();
                end;
            elseif ci.kind == "tgl" then 
                ci:set(not ci.val);
            else 
                Oi.act = not Oi.act;
                ci:draw();
                ci:fire();
            end;
        end;

        R.bup = function(ci)
            local Oi = ci.bnd;
            if Oi and Oi.mode == "hold" and Oi.act then 
                Oi.act = false;
                ci:draw();
                ci:fire();
            end;
        end;

        R.onchange = function(ci, Oi)
            local ji = ci.ucb;
            if not ji then ji = {}; ci.ucb = ji; end;
            ji[#ji + 1] = Oi;
            return ci;
        end;

        R.fire = function(ci, Oi)
            local ji = ci:eff();
            if ci.flag and not ci.tmp then 
                iQ.flags[ci.flag] = ji;
                if ci.a ~= nil then iQ.flags[ci.flag .. "_a"] = ci.a; end;
            end;
            local Ei = ci.prof;
            if Ei and not Ei.ld then 
                Ei.dirty = true;
                if tostring(Ei.cur) == Ei.g then Ei:spread(ci); end;
            end;
            if not Oi then 
                if ci.cb then k(ci.cb, ji, ci.a); end;
                local ucb = ci.ucb;
                if ucb then 
                    for idx = 1, #ucb, 1 do k(ucb[idx], ji, ci.a); end;
                end;
            end;
            local dnt = ci.dnt;
            if dnt then 
                for idx = 1, #dnt, 1 do dnt[idx]:chkdep(); end;
            end;
            if ci.ind and not ci.tmp then pQ(); end;
        end;

        R.dep = function(ci, Oi, ji)
            local Ei = ci.deps;
            if not Ei then Ei = {}; ci.deps = Ei; end;
            Ei[#Ei + 1] = {src = Oi, want = ji};
            local dnt = Oi.dnt;
            if not dnt then dnt = {}; Oi.dnt = dnt; end;
            if not J(dnt, ci) then dnt[#dnt + 1] = ci; end;
            ci:chkdep();
            return ci;
        end;

        R.chkdep = function(ci)
            local Oi, ji = true, ci.deps;
            if ji then 
                for Ei = 1, #ji, 1 do 
                    local Pi = ji[Ei];
                    local src_el, Ti = Pi.src, Pi.want;
                    local eff_v = src_el:eff();
                    local matched = if type(Ti) == "function" then Ti(eff_v)
                        elseif Ti == nil then eff_v == true
                        elseif type(eff_v) == "table" then J(eff_v, Ti) ~= nil
                        else eff_v == Ti;
                    if if matched then src_el.dis else not matched then 
                        Oi = false;
                        break;
                    end;
                end;
            end;
            ci:setdis(not Oi);
        end;

        R.setdis = function(ci, Oi)
            Oi = Oi == true;
            if ci.dis == Oi then return ci; end;
            ci.dis = Oi;
            ci:draw();
            if ci.ind and not ci.tmp then pQ(); end;
            local accs = ci.accs;
            if accs then 
                for idx = 1, #accs, 1 do accs[idx]:setdis(Oi); end;
            end;
            local dnt = ci.dnt;
            if dnt then 
                for idx = 1, #dnt, 1 do dnt[idx]:chkdep(); end;
            end;
            return ci;
        end;

        R.vis = function(ci, Oi)
            local ji = ci.row;
            if ji then 
                ji.Visible = Oi ~= false;
                local row_info = mi[ji];
                if row_info then row_info.b:fix(); end;
            end;
            return ci;
        end;

        R.setbind = function(ci, Oi, ji)
            local Ei = ci.bnd;
            if not Ei then return ci; end;
            if Ei.key then xi_bind_rem(ci, Ei.key); end;
            Ei.act = false;
            Ei.key = Oi;
            if ji then Ei.mode = ji; end;
            if Oi then Fi_bind_add(ci, Oi); end;
            ci:kbdraw();
            ci:draw();
            ci:fire();
            return ci;
        end;

        local function ci_destroy_pop(Oi)
            if Oi then 
                t_pop_close_inst(Oi);
                Oi.md:clean();
                Oi.box:Destroy();
            end;
        end;

        R.destroy = function(Oi)
            if Oi.dead then return; end;
            Oi.dead = true;
            local ji = Oi.bnd;
            if ji and ji.key then xi_bind_rem(Oi, ji.key); end;
            if Oi.kind == "kbd" and Oi.val then xi_bind_rem(Oi, Oi.val); end;
            if kQ.listen == Oi then kQ.listen = nil; end;
            local idx_el = J(iQ.els, Oi);
            if idx_el then y(iQ.els, idx_el); end;
            local pr = Oi.prof;
            if pr then 
                local idx_pr = J(pr.els, Oi);
                if idx_pr then y(pr.els, idx_pr); end;
            end;
            if Oi.flag and iQ.fl[Oi.flag] == Oi then 
                iQ.fl[Oi.flag] = nil;
                iQ.flags[Oi.flag] = nil;
            end;
            local accs = Oi.accs;
            if accs then 
                for idx = #accs, 1, -1 do accs[idx]:destroy(); end;
            end;
            local host = Oi.host;
            if host and host.accs then 
                local idx_h = J(host.accs, Oi);
                if idx_h then y(host.accs, idx_h); end;
            end;
            ci_destroy_pop(Oi.lp);
            ci_destroy_pop(Oi.pp);
            ci_destroy_pop(Oi.sp);
            local row = Oi.row;
            if row then 
                local r_inf = mi[row];
                if r_inf then 
                    r_inf.b:del(row);
                elseif row.Parent then 
                    row:Destroy();
                end;
            elseif Oi.ctl then 
                Oi.ctl:Destroy();
            end;
            if Oi.kt then Oi.kt:Destroy(); end;
            pQ();
        end;

        local function mi_register(ci)
            if ci.tmp then return; end;
            local els = iQ.els;
            els[#els + 1] = ci;
            local ser_v = ci:ser();
            ci.def = if type(ser_v) == "table" then i(ser_v) else ser_v;
            if ci.flag then 
                iQ.fl[ci.flag] = ci;
                iQ.flags[ci.flag] = ci:eff();
                if ci.a ~= nil then iQ.flags[ci.flag .. "_a"] = ci.a; end;
                local tab = ci.c and ci.c.tab;
                local pr = tab and tab.prof;
                if pr and not ci.o.noprof then 
                    ci.prof = pr;
                    pr.els[#pr.els + 1] = ci;
                end;
            end;
            if ci.ind then 
                if ci.ind.on or (ci.bnd and ci.bnd.key) then 
                    pQ();
                end;
            end;
        end;

        local ci_cnt = {};
        ci_cnt.__index = ci_cnt;
        VQ = function(Oi, ji, Ei)
            return setmetatable({frame = Oi, tab = ji, pop = Ei, n = 0}, ci_cnt);
        end;

        ci_cnt.blk = function(Oi)
            local ji = Oi.cb;
            if not ji then 
                Oi.n = Oi.n + 1;
                ji = ni(Oi.frame, Oi.n, true, Oi.pop);
                Oi.cb = ji;
            end;
            return ji;
        end;
        ci_cnt.brk = function(self) self.cb = nil; end;
        ci_cnt.row = function(self, Oi, ji) return self:blk():add(Oi or 30, ji); end;
        ci_cnt.free = function(self, Oi)
            self.cb = nil;
            self.n = self.n + 1;
            return QQ("Frame", {Size = f(1, 0, 0, Oi or 0), AutomaticSize = Oi and W or D, LayoutOrder = self.n, Parent = self.frame});
        end;
        ci_cnt.head = function(self, Oi)
            local ji = self:row(32, true);
            QQ("TextLabel", {Position = l(12, 0), Size = f(1, -24, 1, 0), Text = tostring(Oi or ""), FontFace = LQ.b, TextSize = 13, TextTruncate = UQ, Parent = ji});
            return ji;
        end;
        ci_cnt.space = function(self, Oi) return self:free(Oi or 6); end;
        ci_cnt.div = function(self)
            local Oi = self:free(1);
            QQ("Frame", {Position = l(6, 0), Size = f(1, -12, 0, 1), BackgroundColor3 = sQ, BackgroundTransparency = 0.955, Parent = Oi});
            return Oi;
        end;

        local function ni_row_item(Oi, ji)
            local Ei = ji.pop;
            local Pi = ji:row(Ei and 28 or 30);
            local Ti, Yi = QQ("TextButton", {Size = g(1, 1), ZIndex = 1, Parent = Pi}), QQ("Frame", {AnchorPoint = s(1, 0.5), Position = f(1, -10, 0.5, 0), Size = l(0, 22), AutomaticSize = p, ZIndex = 2, Parent = Pi});
            IQ_lay(Yi, 8, H.Right);
            local vi, Zi, Li, oi = 12;
            if Oi.o.icon then 
                Zi = QQ("ImageLabel", {AnchorPoint = s(0, 0.5), Position = f(0, 12, 0.5, 0), Size = l(13, 13), Image = XQ(Oi.o.icon), ZIndex = 2, Parent = Pi}, {ImageColor3 = "txt"});
                vi = 32;
                Li, oi = vi, Zi;
            else 
                Li, oi = vi, Zi;
            end;
            local lbl_obj;
            if Oi.name ~= "" then 
                lbl_obj = QQ("TextLabel", {Position = l(Li, 0), Size = f(1, -(Li + 12), 1, 0), Text = Oi.name, TextSize = 13, TextTruncate = UQ, ZIndex = 2, Parent = Pi}, {TextColor3 = "txt"});
                GQ(Yi:GetPropertyChangedSignal("AbsoluteSize"), function()
                    lbl_obj.Size = f(1, -(Li + 18 + Yi.AbsoluteSize.X / nQ()), 1, 0);
                end);
                if oi then 
                    GQ(lbl_obj:GetPropertyChangedSignal("TextColor3"), function()
                        oi.ImageColor3 = lbl_obj.TextColor3;
                    end);
                end;
            end;
            if Ei then 
                local rws = Ei.rws;
                if not rws then rws = {}; Ei.rws = rws; end;
                local r_entry = {r = Pi, n = lbl_obj and Oi.name, af = Yi, x = Li};
                rws[#rws + 1] = r_entry;
            end;
            Oi.row = Pi;
            Oi.hit = Ti;
            Oi.accf = Yi;
            Oi.lbl = lbl_obj;
            return Pi, Ti, Yi;
        end;

        local Oi_tgl = setmetatable({}, R);
        Oi_tgl.__index = Oi_tgl;
        ci_cnt.toggle = function(ji, Ei)
            Ei = Ei or {};
            local Pi = xQ(Oi_tgl, ji, Ei, "tgl");
            Pi.val = Ei.default == true;
            Pi.lo = 1000000;
            local _, Ti, Yi = ni_row_item(Pi, ji);
            local trk = QQ("Frame", {Size = l(26, 14), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.trk, LayoutOrder = Pi.lo, Parent = Yi});
            AQ(trk);
            local kn = QQ("Frame", {AnchorPoint = s(0, 0.5), Position = f(0, 2, 0.5, 0), Size = l(10, 10), BackgroundTransparency = 0, Parent = trk}, {BackgroundColor3 = "knob"});
            AQ(kn);
            Pi.trk = trk;
            Pi.kn = kn;
            Pi.bnd = {key = nil, mode = Ei.mode or "toggle", act = false};
            Pi.ind = {on = Ei.ind ~= nil and Ei.ind ~= false, name = type(Ei.ind) == "string" and Ei.ind or ""};
            GQ(Ti.MouseButton1Click, function()
                if Pi.lpd then Pi.lpd = false; return; end;
                if not Pi.dis then Pi:set(not Pi.val); end;
            end);
            GQ(Ti.MouseButton2Click, function() DQ(Pi); end);
            Ni(Ti, function()
                Pi.lpd = true;
                B(1, function() Pi.lpd = false; end);
                DQ(Pi);
            end);
            if Ei.bind then 
                Pi.bnd.key = Ei.bind;
                Fi_bind_add(Pi, Ei.bind);
            end;
            Pi:draw(true);
            mi_register(Pi);
            return Pi;
        end;

        Oi_tgl.eff = function(self)
            local bnd = self.bnd;
            if bnd.act and bnd.mode == "hold" then 
                return not self.val;
            end;
            return self.val;
        end;
        Oi_tgl.set = function(self, v_val, v_fire)
            v_val = v_val == true;
            if self.val == v_val then return self; end;
            self.val = v_val;
            self:draw();
            self:fire(v_fire);
            return self;
        end;
        Oi_tgl.load = function(self, v_val)
            if type(v_val) == "boolean" then self:set(v_val); end;
        end;
        Oi_tgl.draw = function(self, init)
            local eff_v, dis_s = self:eff(), self.dis;
            local txt_c = dis_s and tQ.faint or (eff_v and self.o.risky and tQ.bad or tQ.txt);
            local trk_c = eff_v and tQ.acc or sQ;
            local trk_t = eff_v and (dis_s and 0.6 or 0) or (dis_s and 0.95 or ZQ.trk);
            local kn_c = eff_v and sQ or tQ.knob;
            local kn_p = f(0, eff_v and 14 or 2, 0.5, 0);
            local kn_t = dis_s and 0.55 or 0;
            local lbl = self.lbl;
            if init then 
                if lbl then lbl.TextColor3 = txt_c; end;
                self.trk.BackgroundColor3, self.trk.BackgroundTransparency = trk_c, trk_t;
                self.kn.Position, self.kn.BackgroundColor3, self.kn.BackgroundTransparency = kn_p, kn_c, kn_t;
            else 
                if lbl then w(lbl, {TextColor3 = txt_c}, 0.14, gQ); end;
                w(self.trk, {BackgroundColor3 = trk_c, BackgroundTransparency = trk_t}, 0.16, gQ);
                w(self.kn, {Position = kn_p, BackgroundColor3 = kn_c, BackgroundTransparency = kn_t}, 0.2);
            end;
            self:kbdraw();
        end;

        R.settings = function(Oi, ji)
            ji = ji or {};
            local Ei = Oi:hostof();
            if not Ei then return nil; end;
            local Pi, Ti = Oi.c, QQ("ImageButton", {Size = l(14, 14), Image = XQ("dots"), LayoutOrder = -1, Parent = Ei.accf}, {ImageColor3 = "dim"});
            _i(Ti, Pi.pop, "ImageColor3", tQ.dim, tQ.txt);
            local Yi = ri_pop({w = ji.w, keep = true, anchor = Ti, par = Pi.pop, tab = Pi.tab, tmp = Oi.tmp, title = ji.title or Oi.name});
            Yi.owner = Oi;
            Yi.c.page, Yi.c.sec = Pi.page, Pi.sec;
            GQ(Ti.MouseButton1Click, function()
                if Ei.dis then return; end;
                if Yi.isopen then t_pop_close_inst(Yi); return; end;
                local row = Ei.row;
                ai(row, true);
                function Yi.onclose() ai(row, false); end;
                local abs_p, abs_s = Ti.AbsolutePosition, Ti.AbsoluteSize;
                uQ_pop_open(Yi, abs_p.X + abs_s.X + 12, abs_p.Y - 8);
            end);
            Oi.sp = Yi;
            return Yi.c;
        end;
        R.color = function(Oi, ji) local Ei = Oi:hostof(); return Ei and Oi.c:colorpicker(ji or {}, Ei); end;
        R.colorpicker = R.color;
        R.dropdown = function(Oi, ji) local Ei = Oi:hostof(); return Ei and Oi.c:dropdown(ji or {}, Ei); end;
        R.slider = function(Oi, ji) local Ei = Oi:hostof(); return Ei and Oi.c:slider(ji or {}, Ei); end;

        local Oi_sld = setmetatable({}, R);
        Oi_sld.__index = Oi_sld;
        local function ji_sld_build(Ei, Pi, Ti)
            local Yi = QQ("Frame", {Size = l(0, 22), AutomaticSize = p, LayoutOrder = Ei.lo, Parent = Pi});
            IQ_lay(Yi, 8);
            local vi = QQ("TextBox", {Size = l(0, 18), AutomaticSize = p, BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, TextSize = 11, TextXAlignment = b.Center, LayoutOrder = 1, Parent = Yi});
            SQ(vi, 4);
            JQ(vi, ZQ.ctle);
            eQ(vi, 7, 7, 0, 0);
            QQ("UISizeConstraint", {MinSize = s(40, 18), Parent = vi});
            local Pi_trk = QQ("TextButton", {Size = l(Ei.o.sw or 72, 18), LayoutOrder = 2, Parent = Yi});
            local Zi_bar = QQ("Frame", {AnchorPoint = s(0, 0.5), Position = g(0, 0.5), Size = f(1, 0, 0, 4), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.trk, Parent = Pi_trk});
            AQ(Zi_bar);
            local Li_fil = QQ("Frame", {Size = g(0, 1), BackgroundTransparency = 0, Parent = Zi_bar}, {BackgroundColor3 = "acc"});
            AQ(Li_fil);
            local oi_kn = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0, 0.5), Size = l(10, 10), BackgroundColor3 = sQ, BackgroundTransparency = 0, ZIndex = 3, Parent = Zi_bar});
            AQ(oi_kn);
            Ei.ctl = Yi;
            Ei.vl = vi;
            Ei.trk = Pi_trk;
            Ei.bar = Zi_bar;
            Ei.fil = Li_fil;
            Ei.kn = oi_kn;
            Ei.mv = function(Yi_pos)
                local Li_x, Xi_w = Zi_bar.AbsolutePosition.X, Zi_bar.AbsoluteSize.X;
                if Xi_w <= 0 then return; end;
                local val_n = Ei.min + E((Yi_pos.X - Li_x) / Xi_w, 0, 1) * (Ei.max - Ei.min);
                if Ei.bnd.act then Ei:setbv(val_n); else Ei:set(val_n); end;
            end;
            Ei.mu = function()
                Ei.drg = false;
                local sz_kn = Ei.hov and 12 or 10;
                w(oi_kn, {Size = l(sz_kn, sz_kn)}, 0.14);
                if Ei.pend then Ei.pend = false; Ei:fire(); end;
            end;
            local function Yi_drag_start(Zi_inp)
                Ei.drg = true;
                w(oi_kn, {Size = l(12, 12)}, 0.14);
                HQ(Ei.mv, Ei.mu, Ti, Zi_inp);
            end;
            GQ(Pi_trk.InputBegan, function(Zi_inp)
                if Ei.dis then return; end;
                local Li_t = Zi_inp.UserInputType;
                if Li_t == KQ then 
                    Ei.mv(BQ());
                    Yi_drag_start(Zi_inp);
                elseif Li_t == hQ then 
                    local tg_obj = {i = Zi_inp, p0 = dQ(Zi_inp)};
                    tg_obj.drag = function(Li_p) Ei.mv(Li_p); Yi_drag_start(Zi_inp); end;
                    tg_obj.tap = function(Yi_p) Ei.mv(Yi_p); Ei.mu(); end;
                    kQ.tg = tg_obj;
                    B(0.5, function() if kQ.tg == tg_obj then kQ.tg = nil; DQ(Ei); end; end);
                end;
            end);
            GQ(Pi_trk.MouseButton2Click, function() DQ(Ei); end);
            Ri(Pi_trk, Ti, function()
                Ei.hov = true;
                if not Ei.drg then w(oi_kn, {Size = l(12, 12)}, 0.14); end;
            end, function()
                Ei.hov = false;
                if not Ei.drg then w(oi_kn, {Size = l(10, 10)}, 0.14); end;
            end);
            GQ(vi.Focused, function()
                if Ei.dis then vi:ReleaseFocus(); return; end;
                Ei.foc = true;
                vi.Text = tostring(Ei:eff());
                vi.TextColor3 = tQ.acc;
                ai(Ei:rw(), true);
            end);
            GQ(vi.FocusLost, function()
                if Ei.foc then Ei.foc = false; ai(Ei:rw(), false); end;
                local KQ_num = tonumber(Q(vi.Text, "[^%d%.%-]", ""));
                if KQ_num then 
                    if Ei.bnd.act then Ei:setbv(KQ_num); else Ei:set(KQ_num); end;
                end;
                Ei:draw();
            end);
        end;

        ci_cnt.slider = function(KQ_c, Ei_opt, Pi_host)
            Ei_opt = Ei_opt or {};
            local Ti = xQ(Oi_sld, KQ_c, Ei_opt, "sld");
            Ti.min, Ti.max = Ei_opt.min or 0, Ei_opt.max or 100;
            Ti.dec = Ei_opt.dec or Ei_opt.decimals or 0;
            Ti.step = Ei_opt.step or 10^(-Ti.dec);
            Ti.pat = "%." .. Ti.dec .. "f";
            Ti.suf = Ei_opt.suffix or "";
            Ti.zero = Ei_opt.zero;
            Ti.val = Ti:rnd(Ei_opt.default or Ti.min);
            Ti.bnd = {key = nil, mode = Ei_opt.mode or "hold", act = false, v = Ti.val};
            Ti.ind = {on = Ei_opt.ind ~= nil and Ei_opt.ind ~= false, name = type(Ei_opt.ind) == "string" and Ei_opt.ind or ""};
            if Ei_opt.bindvalue ~= nil then Ti.bnd.v = Ti:rnd(Ei_opt.bindvalue); end;
            if Pi_host then 
                NQ_acc(Pi_host, Ti);
                Ti.lo = Pi_host:nexta();
                ji_sld_build(Ti, Pi_host.accf, KQ_c.pop);
            else 
                Ti.lo = 1000000;
                local _, Pi_hit = ni_row_item(Ti, KQ_c);
                ji_sld_build(Ti, Ti.accf, KQ_c.pop);
                GQ(Pi_hit.MouseButton2Click, function() DQ(Ti); end);
                Ni(Pi_hit, function() DQ(Ti); end);
            end;
            if Ei_opt.bind then 
                Ti.bnd.key = Ei_opt.bind;
                Fi_bind_add(Ti, Ei_opt.bind);
            end;
            Ti:draw();
            mi_register(Ti);
            return Ti;
        end;

        Oi_sld.rnd = function(self, val)
            local j_min, E_max = self.min, self.max;
            val = E(tonumber(val) or j_min, j_min, E_max);
            local st = self.step;
            val = if st > 0 then j_min + P((val - j_min) / st + 0.5) * st else val;
            return tonumber(Z(self.pat, E(val, j_min, E_max)));
        end;
        Oi_sld.eff = function(self)
            local bnd = self.bnd;
            if bnd and bnd.act then return bnd.v; end;
            return self.val;
        end;
        Oi_sld.set = function(self, val, no_fire)
            val = self:rnd(val);
            if val == self.val then return self; end;
            self.val = val;
            self:draw();
            if self.bnd.act then return self; end;
            if self.drg and self.o.release then 
                self.pend = true;
                return self;
            end;
            self:fire(no_fire);
            return self;
        end;
        Oi_sld.setbv = function(self, val)
            val = self:rnd(val);
            local bnd = self.bnd;
            if bnd.v == val then return self; end;
            bnd.v = val;
            if bnd.act then self:draw(); self:fire(); end;
            return self;
        end;
        Oi_sld.load = function(self, val)
            if type(val) == "number" then self:set(val); end;
        end;
        Oi_sld.fmtv = function(self, val)
            if self.o.fmt then return self.o.fmt(val); end;
            if self.zero and val <= self.min then return self.zero; end;
            return Z(self.pat, val) .. self.suf;
        end;
        Oi_sld.draw = function(self)
            local eff_v, dis_s, bnd = self:eff(), self.dis, self.bnd;
            local span = self.max - self.min;
            local frac = span > 0 and (eff_v - self.min) / span or 0;
            if self.drawn then 
                w(self.fil, {Size = g(frac, 1)}, 0.12);
                w(self.kn, {Position = g(frac, 0.5)}, 0.12);
            else 
                self.drawn = true;
                self.fil.Size = g(frac, 1);
                self.kn.Position = g(frac, 0.5);
            end;
            self.fil.BackgroundTransparency = dis_s and 0.6 or 0;
            self.kn.BackgroundTransparency = dis_s and 0.6 or 0;
            if self.lbl then self.lbl.TextColor3 = dis_s and tQ.faint or tQ.txt; end;
            if not self.vl:IsFocused() then 
                self.vl.Text = self:fmtv(eff_v);
                self.vl.TextColor3 = dis_s and tQ.faint or (bnd.act and tQ.acc or tQ.txt);
            end;
            self.vl.TextEditable = not dis_s;
            self:kbdraw();
        end;

        local Z_drp = setmetatable({}, R);
        Z_drp.__index = Z_drp;
        local function KQ_tw_p(Ni, Oi, ji, Ei)
            if ji then 
                for k_k, Pi in next, Oi, nil do Ni[k_k] = Pi; end;
            else 
                w(Ni, Oi, Ei or 0.12, gQ);
            end;
        end;

        local function Ni_grad_fade(Oi)
            local ji = QQ("UIGradient", {Enabled = false, Parent = Oi});
            local function Ei()
                local Pi = Oi.AbsoluteSize.X;
                local Ti = Pi > 1 and Oi.TextBounds.X > Pi + 1.5;
                ji.Enabled = Ti;
                if Ti then 
                    local cut = E(1 - 18 * nQ() / Pi, 0.05, 0.95);
                    ji.Transparency = O({j(0, 0), j(cut, 0), j(1, 1)});
                end;
            end;
            GQ(Oi:GetPropertyChangedSignal("TextBounds"), Ei);
            GQ(Oi:GetPropertyChangedSignal("AbsoluteSize"), Ei);
            Ei();
        end;

        local function j_drp_btn(Oi, ji, Ei, Pi, Ti)
            Ti = Ti or 22;
            local Yi = QQ("TextButton", {Size = l(Pi and 0 or ji, Ti), AutomaticSize = Pi and p or W, BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, LayoutOrder = Ei or 0, Parent = Oi});
            SQ(Yi, 6);
            local st = JQ(Yi, ZQ.ctle);
            eQ(Yi, 9, 8, 0, 0);
            IQ_lay(Yi, Pi and 2 or 6);
            local lbl = QQ("TextLabel", {Size = Pi and l(0, Ti) or f(1, -16, 1, 0), AutomaticSize = Pi and p or W, TextSize = 12, ClipsDescendants = true, LayoutOrder = 1, Parent = Yi}, {TextColor3 = "sub"});
            if Pi then 
                eQ(lbl, 0, 4, 0, 0);
                QQ("UISizeConstraint", {MaxSize = s(154, Ti), Parent = lbl});
            end;
            Ni_grad_fade(lbl);
            return Yi, lbl, QQ("ImageLabel", {Size = l(10, 10), Image = XQ("chevron"), LayoutOrder = 2, Parent = Yi}, {ImageColor3 = "dim"}), st;
        end;

        local function Oi_fly_btn(ji, Ei)
            local Pi = QQ("TextButton", {Size = l(0, 22), AutomaticSize = p, LayoutOrder = Ei or 0, Parent = ji});
            IQ_lay(Pi, 1);
            local lbl = QQ("TextLabel", {Size = l(0, 22), AutomaticSize = p, TextSize = 13, ClipsDescendants = true, LayoutOrder = 1, Parent = Pi}, {TextColor3 = "sub"});
            eQ(lbl, 0, 4, 0, 0);
            QQ("UISizeConstraint", {MaxSize = s(122, 22), Parent = lbl});
            Ni_grad_fade(lbl);
            return Pi, lbl, QQ("ImageLabel", {Size = l(12, 12), Image = XQ("right"), LayoutOrder = 2, Parent = Pi}, {ImageColor3 = "dim"});
        end;

        ci_cnt.dropdown = function(Ni, ji, Ei)
            ji = ji or {};
            local Pi = xQ(Z_drp, Ni, ji, "drp");
            Pi.multi = ji.multi == true;
            Pi.values = ji.values or ji.options or {};
            if Pi.multi then 
                Pi.val = {};
                local Ti = ji.default;
                if type(Ti) == "table" then 
                    for Yi = 1, #Ti, 1 do Pi.val[Yi] = Ti[Yi]; end;
                elseif Ti ~= nil then 
                    Pi.val[1] = Ti;
                end;
            else 
                Pi.val = ji.default;
                if Pi.val == nil and not ji.none then 
                    Pi.val = Pi.values[1];
                end;
            end;
            Pi.srt = function(Ti, Yi)
                return (J(Pi.values, Ti) or 0) < (J(Pi.values, Yi) or 0);
            end;
            Pi.ind = {on = ji.ind ~= nil and ji.ind ~= false, name = type(ji.ind) == "string" and ji.ind or ""};
            local Ti_pop = Ni.pop;
            Pi.fly = Ti_pop ~= nil and ji.par == nil and ji.box ~= true;
            local Yi_par, vi_w, Zi_lo = ji.par, ji.w or 112, ji.lo;
            if Ei then 
                NQ_acc(Ei, Pi);
                Pi.lo = Ei:nexta();
                Yi_par, vi_w, Zi_lo = Ei.accf, ji.w or 96, Pi.lo;
            else 
                if not Yi_par then 
                    Pi.lo = 1000000;
                    local Ei_r, Li_h = ni_row_item(Pi, Ni);
                    Yi_par, Zi_lo = Pi.accf, Pi.lo;
                    GQ(Li_h.MouseButton1Click, function() Pi:flip(); end);
                    GQ(Li_h.MouseButton2Click, function() DQ(Pi); end);
                    if Pi.fly then 
                        Ri(Ei_r, Ti_pop, function() Pi.rh = true; Pi:draw(); end, function() Pi.rh = false; Pi:draw(); end);
                    end;
                end;
            end;
            if Pi.fly then 
                Pi.btn, Pi.t, Pi.ch = Oi_fly_btn(Yi_par, Zi_lo);
            else 
                Pi.btn, Pi.t, Pi.ch, Pi.sk = j_drp_btn(Yi_par, vi_w, Zi_lo, ji.auto, ji.h);
            end;
            Pi.ctl = Pi.btn;
            Ri(Pi.btn, Ti_pop, function() Pi.bh = true; Pi:draw(); end, function() Pi.bh = false; Pi:draw(); end);
            GQ(Pi.btn.MouseButton1Click, function() Pi:flip(); end);
            Pi:draw(true);
            mi_register(Pi);
            return Pi;
        end;

        Z_drp.flip = function(self)
            if self.dis then return; end;
            if self.lp and self.lp.isopen then 
                t_pop_close_inst(self.lp);
            else 
                self:openlist();
            end;
        end;
        Z_drp.has = function(self, val)
            if self.multi then return J(self.val, val) ~= nil; end;
            return self.val == val;
        end;
        Z_drp.none = function(self)
            if self.multi then return #self.val == 0; end;
            return self.val == nil;
        end;
        Z_drp.text = function(self)
            if self:none() then 
                return self.o.empty or (self.multi and not self.fly and "None" or "Select");
            end;
            if self.multi then 
                local cnt = #self.val;
                local tbl = table.create(cnt);
                for idx = 1, cnt, 1 do tbl[idx] = tostring(self.val[idx]); end;
                return M(tbl, ", ");
            end;
            return tostring(self.val);
        end;
        Z_drp.draw = function(self, init)
            local dis_s = self.dis;
            if dis_s and self.lp then 
                t_pop_close_inst(self.lp);
                return;
            end;
            local is_open = self.lp ~= nil;
            local is_hov = if dis_s then false else (self.bh or self.rh);
            local is_none = self:none();
            self.t.Text = self:text();
            local t_col, ch_col;
            if dis_s then 
                t_col, ch_col = tQ.faint, tQ.faint;
            else 
                t_col = (is_open or is_hov) and tQ.txt or (is_none and tQ.dim or tQ.sub);
                ch_col = is_open and tQ.txt or (is_hov and tQ.sub or tQ.dim);
            end;
            KQ_tw_p(self.t, {TextColor3 = t_col}, init);
            if self.sk then 
                KQ_tw_p(self.btn, {BackgroundTransparency = (is_open or is_hov) and ZQ.ctlh or ZQ.ctl}, init);
                KQ_tw_p(self.sk, {Transparency = is_open and 0.88 or ZQ.ctle}, init);
                KQ_tw_p(self.ch, {ImageColor3 = ch_col, Rotation = is_open and 180 or 0}, init, 0.16);
            else 
                KQ_tw_p(self.ch, {ImageColor3 = ch_col}, init);
            end;
            if self.lbl then self.lbl.TextColor3 = dis_s and tQ.faint or tQ.txt; end;
            local items = self.items;
            if items then 
                local hv_item, is_mul = self.hv, self.multi;
                local sel_idx = nil;
                for idx = 1, #items, 1 do 
                    local item_obj = items[idx];
                    local has_v, is_hv = self:has(item_obj.v), hv_item == item_obj;
                    sel_idx = sel_idx or (has_v and not is_mul and idx or nil);
                    KQ_tw_p(item_obj.t, {TextColor3 = (has_v or is_hv) and tQ.txt or tQ.sub}, init, 0.1);
                    if is_mul then 
                        KQ_tw_p(item_obj.m, {BackgroundColor3 = has_v and tQ.acc or sQ, BackgroundTransparency = has_v and 0 or ZQ.trk}, init, 0.14);
                        KQ_tw_p(item_obj.k, {Position = f(0, has_v and 12 or 2, 0.5, 0), BackgroundColor3 = has_v and sQ or tQ.knob}, init, 0.18);
                    end;
                end;
                if self.cap then self.cap(hv_item and hv_item.i, sel_idx, init); end;
            end;
        end;

        Z_drp.set = function(self, val, no_fire)
            if self.multi then 
                local cur_val = self.val;
                val = if val == cur_val then i(val) else val;
                e(cur_val);
                if type(val) == "table" then 
                    for idx = 1, #val, 1 do 
                        local item = val[idx];
                        if J(self.values, item) and not J(cur_val, item) then 
                            cur_val[#cur_val + 1] = item;
                        end;
                    end;
                elseif val ~= nil and J(self.values, val) then 
                    cur_val[1] = val;
                end;
                I(cur_val, self.srt);
            else 
                if val ~= nil and not J(self.values, val) then return self; end;
                if self.val == val then return self; end;
                self.val = val;
            end;
            self:draw();
            self:fire(no_fire);
            return self;
        end;

        Z_drp.pick = function(self, val)
            local cur_val = self.val;
            local idx = J(cur_val, val);
            if idx then 
                if self.o.min1 and #cur_val == 1 then return; end;
                y(cur_val, idx);
            else 
                cur_val[#cur_val + 1] = val;
                I(cur_val, self.srt);
            end;
            self:draw();
            self:fire();
        end;

        Z_drp.setvalues = function(self, vals)
            self.values = vals or {};
            if self.multi then 
                local cur_val = self.val;
                for idx = #cur_val, 1, -1 do 
                    if not J(self.values, cur_val[idx]) then y(cur_val, idx); end;
                end;
            elseif self.val ~= nil and not J(self.values, self.val) then 
                self.val = self.values[1];
            end;
            if self.lp and self.lp.isopen then t_pop_close_inst(self.lp); end;
            self:draw();
            self:fire();
            return self;
        end;
        Z_drp.ser = function(self) return if self.multi then i(self.val) else self.val; end;
        Z_drp.load = function(self, val)
            if self.multi then 
                if type(val) == "table" then self:set(val); end;
            elseif val ~= nil then 
                self:set(val);
            end;
        end;

        Z_drp.openlist = function(self)
            local btn_obj, is_fly, par_pop, row_obj = self.btn, self.fly, self.c and self.c.pop, self:rw();
            local sc, vals = nQ(), self.values;
            local cnt, is_mul, h_it, gap, pad, max_vis = #vals, self.multi, 28, 2, 8, 5;
            local num_vis = T(1, Y(cnt, max_vis));
            local list_h = num_vis * h_it + (num_vis - 1) * gap + 10;
            local list_pop = ri_pop({w = 140, raw = true, rad = 8, anchor = row_obj or btn_obj, par = par_pop});
            local tot_h = T(cnt, 1) * h_it + T(cnt - 1, 0) * gap + 10;
            local scr = QQ("ScrollingFrame", {Size = f(1, 0, 0, list_h), CanvasSize = f(0, 0, 0, tot_h), AutomaticCanvasSize = W, ZIndex = 2, Parent = list_pop.body});
            local hl_ind = QQ("Frame", {Position = l(pad, pad), Size = f(1, -10, 0, h_it), BackgroundColor3 = sQ, BackgroundTransparency = 1, ZIndex = 2, Parent = scr});
            SQ(hl_ind, 6);
            local hl_stk = JQ(hl_ind, 1);
            local items_box = QQ("Frame", {Position = l(pad, pad), Size = f(1, -10, 0, 0), AutomaticSize = D, ZIndex = 3, Parent = scr});
            MQ_lay(items_box, gap);
            if cnt == 0 then 
                QQ("TextLabel", {Size = f(1, 0, 0, h_it), Text = "Nothing here", TextSize = 13, TextXAlignment = b.Center, ZIndex = 3, Parent = items_box}, {TextColor3 = "dim"});
            end;
            local last_cur_i;
            local cap_ver = 0;
            local function move_hl(idx_hl, immed)
                local has_sel = idx_hl ~= nil;
                if has_sel then 
                    local pos_v = l(pad, pad + (idx_hl - 1) * (h_it + gap));
                    if immed or last_cur_i == nil then 
                        hl_ind.Position = pos_v;
                    elseif last_cur_i ~= idx_hl then 
                        w(hl_ind, {Position = pos_v}, 0.22);
                    end;
                end;
                last_cur_i = idx_hl;
                KQ_tw_p(hl_ind, {BackgroundTransparency = has_sel and 0.955 or 1}, immed, 0.14);
                KQ_tw_p(hl_stk, {Transparency = has_sel and 0.93 or 1}, immed, 0.14);
            end;
            local function cap_handler(idx_hov, idx_sel, immed)
                cap_ver += 1;
                if idx_hov or immed then 
                    move_hl(idx_hov or idx_sel, immed);
                    return;
                end;
                local cur_v = cap_ver;
                B(0.08, function()
                    if cap_ver == cur_v and self.cap == cap_handler then 
                        move_hl(idx_sel);
                    end;
                end);
            end;
            self.cap = cap_handler;

            local items_arr = table.create(cnt);
            local r_pad = is_mul and 40 or 10;
            local init_sel = nil;
            local max_tw = 0;
            for idx = 1, cnt, 1 do 
                local item_v = vals[idx];
                local has_it = self:has(item_v);
                init_sel = init_sel or (has_it and idx or nil);
                local b_it = QQ("TextButton", {Size = f(1, 0, 0, h_it), LayoutOrder = idx, ZIndex = 3, Parent = items_box});
                local t_it = QQ("TextLabel", {Position = l(10, 0), Size = f(1, -(10 + r_pad), 1, 0), Text = tostring(item_v), TextSize = 13, TextColor3 = has_it and tQ.txt or tQ.sub, TextTruncate = UQ, ZIndex = 3, Parent = b_it});
                local m_chk, k_chk;
                if is_mul then 
                    m_chk = QQ("Frame", {AnchorPoint = s(1, 0.5), Position = f(1, -9, 0.5, 0), Size = l(22, 12), BackgroundColor3 = has_it and tQ.acc or sQ, BackgroundTransparency = has_it and 0 or ZQ.trk, ZIndex = 3, Parent = b_it});
                    AQ(m_chk);
                    k_chk = QQ("Frame", {AnchorPoint = s(0, 0.5), Position = f(0, has_it and 12 or 2, 0.5, 0), Size = l(8, 8), BackgroundColor3 = has_it and sQ or tQ.knob, BackgroundTransparency = 0, ZIndex = 3, Parent = m_chk});
                    AQ(k_chk);
                end;
                max_tw = T(max_tw, t_it.TextBounds.X);
                local it_obj = {b = b_it, t = t_it, m = m_chk, k = k_chk, v = item_v, i = idx};
                Ri(b_it, list_pop, function() self.hv = it_obj; self:draw(); end, function() if self.hv == it_obj then self.hv = nil; self:draw(); end; end);
                GQ(b_it.MouseButton1Click, function()
                    if self.multi then 
                        self:pick(item_v);
                    else 
                        t_pop_close_inst(list_pop);
                        self:set(item_v);
                    end;
                end);
                items_arr[idx] = it_obj;
            end;
            local w_base = is_fly and 0 or btn_obj.AbsoluteSize.X / sc;
            list_pop.w = P(E(T(max_tw + 10 + r_pad + 14, self.o.lw or 0, 132), w_base, T(w_base, 280)) + 0.5);
            self.items = items_arr;
            self.lp = list_pop;
            ai(row_obj, true);
            list_pop.onclose = function()
                self.items = nil;
                self.hv = nil;
                self.lp = nil;
                self.cap = nil;
                ai(row_obj, false);
                self:draw();
            end;
            if init_sel and cnt > max_vis then 
                scr.CanvasPosition = s(0, T(0, (init_sel - 1) * 30 - P((num_vis - 1) / 2) * 30));
            end;
            local pr_p, gui_sz = kQ.probe.AbsolutePosition, kQ.gui.AbsoluteSize;
            local pop_w_px, pop_h_px = list_pop.w * sc, list_h * sc;
            local px_final, py_final;
            if is_fly and par_pop then 
                local f_p, f_s = par_pop.frame.AbsolutePosition, par_pop.frame.AbsoluteSize;
                local anc_el = row_obj or btn_obj;
                px_final = f_p.X + f_s.X + 6 * sc;
                if px_final + pop_w_px > pr_p.X + gui_sz.X - 6 then 
                    px_final = f_p.X - 6 * sc - pop_w_px;
                end;
                py_final = anc_el.AbsolutePosition.Y + (anc_el.AbsoluteSize.Y - pop_h_px) / 2;
            else 
                local b_p, b_s = btn_obj.AbsolutePosition, btn_obj.AbsoluteSize;
                px_final = self.o.par and b_p.X or b_p.X + b_s.X - pop_w_px;
                py_final = b_p.Y + b_s.Y + 4 * sc;
                if py_final + pop_h_px > pr_p.Y + gui_sz.Y - 6 then 
                    if b_p.Y - 4 * sc - pop_h_px >= pr_p.Y + 6 then 
                        py_final = b_p.Y - 4 * sc - pop_h_px;
                    end;
                end;
            end;
            cap_handler(nil, (not is_mul and init_sel) or nil, true);
            uQ_pop_open(list_pop, px_final, py_final);
            self:draw();
        end;

        local j_cpk = setmetatable({}, R);
        j_cpk.__index = j_cpk;
        local function Z_chk_img(i_p, W_ts, KQ_rad)
            if not jQ.checker then return nil; end;
            local Ni = QQ("ImageLabel", {
                Size = g(1, 1), Image = jQ.checker, ScaleType = Enum.ScaleType.Tile,
                TileSize = l(W_ts or 8, W_ts or 8), ResampleMode = Enum.ResamplerMode.Pixelated,
                Parent = i_p
            });
            if KQ_rad == true then AQ(Ni); elseif KQ_rad then SQ(Ni, KQ_rad); end;
            return Ni;
        end;

        local function i_thumb_box(W_p, KQ_w, Ni_h, Oi_r)
            local ji = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0, 0.5), Size = l(KQ_w, Ni_h), BackgroundTransparency = 0, ZIndex = 5, Parent = W_p});
            SQ(ji, Oi_r);
            QQ("UIStroke", {Color = sQ, Thickness = 2, Parent = ji});
            local stk = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(KQ_w + 5, Ni_h + 5), ZIndex = 4, Parent = ji});
            SQ(stk, Oi_r + 2);
            QQ("UIStroke", {Color = CQ, Transparency = 0.72, Thickness = 1, Parent = stk});
            return ji;
        end;

        local W_cpk_modes = {"RGB", "HEX", "HSV"};
        ci_cnt.colorpicker = function(KQ_c, Ni_opt, Oi_host)
            Ni_opt = Ni_opt or {};
            local ji = xQ(j_cpk, KQ_c, Ni_opt, "cpk");
            local def_col = Ni_opt.default or Ni_opt.color or sQ;
            ji.val = def_col;
            ji.a = Ni_opt.alpha or 1;
            ji.h, ji.s, ji.v = def_col:ToHSV();
            local accf_p;
            if Oi_host then 
                NQ_acc(Oi_host, ji);
                ji.lo = Oi_host:nexta();
                accf_p = Oi_host.accf;
            else 
                ji.lo = 1000000;
                local _, hit_b = ni_row_item(ji, KQ_c);
                accf_p = ji.accf;
                GQ(hit_b.MouseButton1Click, function() ji:flip(); end);
            end;
            local sw_b = QQ("TextButton", {Size = l(16, 16), LayoutOrder = ji.lo, Parent = accf_p});
            SQ(sw_b, 5);
            Z_chk_img(sw_b, 4, 5);
            ji.swc = QQ("Frame", {Size = g(1, 1), BackgroundTransparency = 0, ZIndex = 2, Parent = sw_b});
            SQ(ji.swc, 5);
            JQ(sw_b, 0.86);
            ji.sw = sw_b;
            ji.ctl = sw_b;
            GQ(sw_b.MouseButton1Click, function() ji:flip(); end);
            ji:draw();
            mi_register(ji);
            return ji;
        end;

        j_cpk.flip = function(self)
            if self.dis then return; end;
            if self.pp and self.pp.isopen then 
                t_pop_close_inst(self.pp);
            else 
                self:openpick();
            end;
        end;
        j_cpk.ser = function(self) return PQ(self.val, self.a); end;
        j_cpk.unser = function(self, s_val) return TQ(s_val) or s_val; end;
        j_cpk.load = function(self, val)
            local col, alp = TQ(val);
            if col then self:set(col, alp); end;
        end;
        j_cpk.set = function(self, col, alp, no_fire)
            if typeof(col) ~= "Color3" then return self; end;
            alp = alp or self.a;
            if col == self.val and alp == self.a then return self; end;
            self.val = col;
            self.a = alp;
            local h_v, s_v, v_v = col:ToHSV();
            if s_v > 0 and v_v > 0 then self.h = h_v; end;
            self.s = s_v;
            self.v = v_v;
            self:draw();
            self:fire(no_fire);
            return self;
        end;
        j_cpk.sethsv = function(self, h_v, s_v, v_v, alp)
            self.h = h_v;
            self.s = s_v;
            self.v = v_v;
            if alp then self.a = alp; end;
            self.val = F(h_v, s_v, v_v);
            self:draw();
            self:fire();
        end;
        j_cpk.draw = function(self)
            self.swc.BackgroundColor3 = self.val;
            self.swc.BackgroundTransparency = self.dis and Y(1, 1.55 - self.a) or (1 - self.a);
            if self.lbl then self.lbl.TextColor3 = self.dis and tQ.faint or tQ.txt; end;
            if self.pu then self.pu(); end;
        end;

        j_cpk.openpick = function(self)
            local cpk_inst, pop_w, pad, inner_w = self, 196, 6, 184;
            local pick_pop = ri_pop({w = pop_w, raw = true, rad = 8, anchor = self.row or self.sw, par = self.c and self.c.pop});
            cpk_inst.pp = pick_pop;
            local main_box = QQ("Frame", {Size = l(pop_w, 170), ZIndex = 2, Parent = pick_pop.body});
            local sv_map = QQ("TextButton", {Position = l(pad, pad), Size = l(inner_w, 100), BackgroundTransparency = 0, Parent = main_box});
            SQ(sv_map, 5);
            local sv_w = QQ("Frame", {Size = g(1, 1), BackgroundColor3 = sQ, BackgroundTransparency = 0, Parent = sv_map});
            SQ(sv_w, 5);
            QQ("UIGradient", {Transparency = O(0, 1), Parent = sv_w});
            local sv_b = QQ("Frame", {Size = g(1, 1), BackgroundColor3 = CQ, BackgroundTransparency = 0, Parent = sv_map});
            SQ(sv_b, 5);
            QQ("UIGradient", {Rotation = 90, Transparency = O(1, 0), Parent = sv_b});
            local sv_ol = QQ("Frame", {Size = g(1, 1), ZIndex = 3, Parent = sv_map});
            SQ(sv_ol, 5);
            JQ(sv_ol, 0.92);
            local sv_cursor = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Size = l(9, 9), ZIndex = 5, Parent = sv_map});
            AQ(sv_cursor);
            QQ("UIStroke", {Color = sQ, Thickness = 2, Parent = sv_cursor});
            local sv_cursor_sh = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(14, 14), ZIndex = 4, Parent = sv_cursor});
            AQ(sv_cursor_sh);
            QQ("UIStroke", {Color = CQ, Transparency = 0.72, Thickness = 1, Parent = sv_cursor_sh});

            local function build_bar(y_pos)
                local bar_btn = QQ("TextButton", {Position = l(pad, y_pos - 8), Size = l(inner_w, 16), Parent = main_box});
                local bar_in = QQ("Frame", {AnchorPoint = s(0, 0.5), Position = g(0, 0.5), Size = f(1, 0, 0, 8), BackgroundColor3 = sQ, BackgroundTransparency = 1, Parent = bar_btn});
                SQ(bar_in, 3);
                return bar_btn, bar_in, i_thumb_box(bar_in, 6, 12, 2);
            end;

            local hue_btn, hue_bar, hue_thumb = build_bar(117);
            hue_bar.BackgroundTransparency = 0;
            local hue_grad_pts = table.create(7);
            for idx = 0, 6, 1 do 
                hue_grad_pts[idx + 1] = n(idx / 6, F(idx / 6 % 1, 1, 1));
            end;
            QQ("UIGradient", {Color = c(hue_grad_pts), Parent = hue_bar});

            local alp_btn, alp_bar, alp_thumb = build_bar(133);
            Z_chk_img(alp_bar, 4, 3);
            local alp_grad_f = QQ("Frame", {Size = g(1, 1), BackgroundTransparency = 0, ZIndex = 2, Parent = alp_bar});
            SQ(alp_grad_f, 3);
            QQ("UIGradient", {Transparency = O(1, 0), Parent = alp_grad_f});

            local bot_row = QQ("Frame", {Position = l(pad, 144), Size = l(inner_w, 20), Parent = main_box});
            IQ_lay(bot_row, 4);
            local mode_btn = QQ("TextButton", {Size = l(36, 20), LayoutOrder = 1, Parent = bot_row});
            local mode_chv = QQ("ImageLabel", {AnchorPoint = s(0, 0.5), Position = f(0, 1, 0.5, 0), Size = l(9, 9), Image = XQ("chevron"), Parent = mode_btn}, {ImageColor3 = "dim"});
            local mode_lbl = QQ("TextLabel", {Position = l(13, 0), Size = f(1, -13, 1, 0), TextSize = 11, Parent = mode_btn}, {TextColor3 = "sub"});
            Ri(mode_btn, pick_pop, function()
                w(mode_lbl, {TextColor3 = tQ.txt}, 0.12, gQ);
                w(mode_chv, {ImageColor3 = tQ.sub}, 0.12, gQ);
            end, function()
                w(mode_lbl, {TextColor3 = tQ.sub}, 0.12, gQ);
                w(mode_chv, {ImageColor3 = tQ.dim}, 0.12, gQ);
            end);

            local function make_cinput(lo, wid)
                local inp_tb = QQ("TextBox", {
                    Size = l(wid or 27, 20), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl,
                    TextSize = 11, TextXAlignment = b.Center, ClipsDescendants = true,
                    LayoutOrder = lo, Parent = bot_row
                });
                SQ(inp_tb, 4);
                local stk = JQ(inp_tb, ZQ.ctle);
                GQ(inp_tb.Focused, function() w(stk, {Color = tQ.acc, Transparency = 0.5}, 0.14, gQ); end);
                GQ(inp_tb.FocusLost, function() w(stk, {Color = sQ, Transparency = ZQ.ctle}, 0.14, gQ); end);
                return inp_tb;
            end;

            -- Стандартный Lua массив вместо U:ds
            local Ei_inputs = {make_cinput(2), make_cinput(3), make_cinput(4)};
            local hex_inp = make_cinput(5, 89);
            local alp_inp = make_cinput(6);

            local copy_btn = QQ("ImageButton", {Size = l(20, 20), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, LayoutOrder = 7, Parent = bot_row});
            SQ(copy_btn, 4);
            JQ(copy_btn, ZQ.ctle);
            local copy_ic = QQ("ImageLabel", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(11, 11), Image = XQ("copy"), Parent = copy_btn}, {ImageColor3 = "dim"});
            Ri(copy_btn, pick_pop, function()
                w(copy_btn, {BackgroundTransparency = ZQ.ctlh}, 0.12, gQ);
                w(copy_ic, {ImageColor3 = tQ.txt}, 0.12, gQ);
            end, function()
                w(copy_btn, {BackgroundTransparency = ZQ.ctl}, 0.12, gQ);
                w(copy_ic, {ImageColor3 = tQ.dim}, 0.12, gQ);
            end);

            local function sync_mode_ui()
                local cur_cm = cpk_inst.cm or "RGB";
                mode_lbl.Text = cur_cm;
                local is_hex = cur_cm == "HEX";
                for idx = 1, 3, 1 do Ei_inputs[idx].Visible = not is_hex; end;
                hex_inp.Visible = is_hex;
                return cur_cm;
            end;

            cpk_inst.pu = function()
                local pure_h, cur_col = F(cpk_inst.h, 1, 1), cpk_inst.val;
                sv_map.BackgroundColor3 = pure_h;
                sv_cursor.Position = g(cpk_inst.s, 1 - cpk_inst.v);
                hue_thumb.Position = g(cpk_inst.h, 0.5);
                hue_thumb.BackgroundColor3 = pure_h;
                alp_grad_f.BackgroundColor3 = cur_col;
                alp_thumb.Position = g(cpk_inst.a, 0.5);
                alp_thumb.BackgroundColor3 = cur_col;
                local vals_num = if (cpk_inst.cm or "RGB") == "HSV"
                    then {P(cpk_inst.h * 360 + 0.5), P(cpk_inst.s * 100 + 0.5), P(cpk_inst.v * 100 + 0.5)}
                    else {P(cur_col.R * 255 + 0.5), P(cur_col.G * 255 + 0.5), P(cur_col.B * 255 + 0.5)};
                for idx = 1, 3, 1 do 
                    if not Ei_inputs[idx]:IsFocused() then 
                        Ei_inputs[idx].Text = tostring(vals_num[idx]);
                    end;
                end;
                if not hex_inp:IsFocused() then hex_inp.Text = PQ(cur_col); end;
                if not alp_inp:IsFocused() then alp_inp.Text = tostring(P(cpk_inst.a * 255 + 0.5)); end;
            end;

            sync_mode_ui();
            GQ(mode_btn.MouseButton1Click, function()
                cpk_inst.cm = W_cpk_modes[(J(W_cpk_modes, cpk_inst.cm or "RGB") or 0) % #W_cpk_modes + 1];
                sync_mode_ui();
                cpk_inst.pu();
            end);

            for idx = 1, 3, 1 do 
                local inp_box = Ei_inputs[idx];
                GQ(inp_box.FocusLost, function()
                    local num_v = tonumber(Q(inp_box.Text, "[^%d%.]", ""));
                    if num_v then 
                        if (cpk_inst.cm or "RGB") == "HSV" then 
                            local h_v, s_v, v_v = cpk_inst.h, cpk_inst.s, cpk_inst.v;
                            if idx == 1 then h_v = E(num_v, 0, 359.9) / 360;
                            elseif idx == 2 then s_v = E(num_v, 0, 100) / 100;
                            else v_v = E(num_v, 0, 100) / 100; end;
                            cpk_inst:sethsv(h_v, s_v, v_v);
                        else 
                            local c_cur = cpk_inst.val;
                            local rgb_t = {c_cur.R * 255, c_cur.G * 255, c_cur.B * 255, [idx] = E(num_v, 0, 255)};
                            cpk_inst:set(h(rgb_t[1], rgb_t[2], rgb_t[3]));
                        end;
                    end;
                    if cpk_inst.pu then cpk_inst.pu(); end;
                end);
            end;

            GQ(hex_inp.FocusLost, function()
                local txt = hex_inp.Text;
                local col_res, alp_res = TQ(txt);
                if col_res then 
                    cpk_inst:set(col_res, #Q(txt, "[^%x]", "") == 8 and alp_res or cpk_inst.a);
                end;
                if cpk_inst.pu then cpk_inst.pu(); end;
            end);

            GQ(alp_inp.FocusLost, function()
                local num_v = tonumber(Q(alp_inp.Text, "[^%d%.]", ""));
                if num_v then cpk_inst:sethsv(cpk_inst.h, cpk_inst.s, cpk_inst.v, E(num_v, 0, 255) / 255); end;
                if cpk_inst.pu then cpk_inst.pu(); end;
            end);

            GQ(copy_btn.MouseButton1Click, function()
                local hex_val = PQ(cpk_inst.val, cpk_inst.a);
                if pcall(setclipboard, hex_val) then iQ:notify("Copied {" .. hex_val .. "}"); end;
            end);

            local function bind_drag_zone(zone_btn, update_cb)
                GQ(zone_btn.InputBegan, function(inp)
                    local ut = inp.UserInputType;
                    if bQ(ut) then 
                        update_cb(ut == hQ and dQ(inp) or BQ());
                        HQ(update_cb, nil, pick_pop, inp);
                    end;
                end);
            end;

            bind_drag_zone(sv_map, function(m_pos)
                local b_p, b_s = sv_map.AbsolutePosition, sv_map.AbsoluteSize;
                cpk_inst:sethsv(cpk_inst.h, E((m_pos.X - b_p.X) / b_s.X, 0, 1), 1 - E((m_pos.Y - b_p.Y) / b_s.Y, 0, 1));
            end);

            bind_drag_zone(hue_btn, function(m_pos)
                local b_p, b_s = hue_bar.AbsolutePosition, hue_bar.AbsoluteSize;
                cpk_inst:sethsv(E((m_pos.X - b_p.X) / b_s.X, 0, 0.9999), cpk_inst.s, cpk_inst.v);
            end);

            bind_drag_zone(alp_btn, function(m_pos)
                local b_p, b_s = alp_bar.AbsolutePosition, alp_bar.AbsoluteSize;
                cpk_inst:sethsv(cpk_inst.h, cpk_inst.s, cpk_inst.v, E((m_pos.X - b_p.X) / b_s.X, 0, 1));
            end);

            local host_rw = cpk_inst:rw();
            ai(host_rw, true);
            pick_pop.onclose = function()
                cpk_inst.pu = nil;
                cpk_inst.pp = nil;
                ai(host_rw, false);
            end;
            cpk_inst.pu();
            local sw_p, sw_s = self.sw.AbsolutePosition, self.sw.AbsoluteSize;
            uQ_pop_open(pick_pop, sw_p.X + sw_s.X + 10, sw_p.Y - 8);
        end;

        local F_kbd = setmetatable({}, R);
        F_kbd.__index = F_kbd;
        ci_cnt.keybind = function(c_cnt, n_opt)
            local O_opt = n_opt or {};
            local n_inst = xQ(F_kbd, c_cnt, O_opt, "kbd");
            local def_key = O_opt.default;
            def_key = if typeof(def_key) == "EnumItem" then def_key.Name else def_key;
            def_key = if def_key == "None" then nil else def_key;
            n_inst.val = def_key;
            n_inst.lo = 1000000;
            local _, hit_b, accf_p = ni_row_item(n_inst, c_cnt);
            local btn = QQ("TextButton", {Size = l(0, 20), AutomaticSize = p, TextSize = 11, BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, LayoutOrder = n_inst.lo, Parent = accf_p});
            SQ(btn, 5);
            eQ(btn, 8, 8, 0, 0);
            QQ("UISizeConstraint", {MinSize = s(44, 20), Parent = btn});
            n_inst.ks = JQ(btn, ZQ.ctle);
            n_inst.b = btn;
            n_inst.ctl = btn;
            _i(btn, c_cnt.pop, "BackgroundTransparency", ZQ.ctl, ZQ.ctlh);
            local function on_click()
                if kQ.eat ~= n_inst and not n_inst.dis then n_inst:listen(); end;
            end;
            GQ(btn.MouseButton1Click, on_click);
            GQ(hit_b.MouseButton1Click, on_click);
            GQ(btn.MouseButton2Click, function()
                if kQ.eat ~= n_inst and not n_inst.dis and not O_opt.nonone then 
                    n_inst:setkey(nil);
                end;
            end);
            if def_key and not n_inst.tmp then Fi_bind_add(n_inst, def_key); end;
            n_inst:draw();
            mi_register(n_inst);
            return n_inst;
        end;

        F_kbd.listen = function(self)
            local cur_ls = kQ.listen;
            if cur_ls and cur_ls ~= self then 
                cur_ls.lst = false;
                cur_ls:draw();
            end;
            kQ.listen = self;
            self.lst = true;
            self:draw();
        end;

        F_kbd.setkey = function(self, key_name, no_fire)
            self.lst = false;
            if kQ.listen == self then kQ.listen = nil; end;
            if key_name == nil and self.o.nonone then self:draw(); return self; end;
            if key_name == self.val then self:draw(); return self; end;
            if self.val and not self.tmp then xi_bind_rem(self, self.val); end;
            self.val = key_name;
            if key_name and not self.tmp then Fi_bind_add(self, key_name); end;
            self:draw();
            self:fire(no_fire);
            return self;
        end;
        F_kbd.set = function(self, key_n) return self:setkey(key_n); end;
        F_kbd.ser = function(self) return self.val or "None"; end;
        F_kbd.unser = function(self, s_val) if s_val == "None" then return nil; end; return s_val; end;
        F_kbd.load = function(self, val)
            if val == nil or val == "None" then self:setkey(nil);
            elseif type(val) == "string" then self:setkey(val); end;
        end;
        F_kbd.bdown = function(self)
            local cb = self.o.onpress;
            if cb and not self.dis then k(cb, self.val); end;
        end;
        F_kbd.bup = function(self)
            local cb = self.o.onrelease;
            if cb and not self.dis then k(cb, self.val); end;
        end;
        F_kbd.down = function(self)
            local k_n = self.val;
            if not k_n then return false; end;
            if Gi_mouse[k_n] then 
                return z:IsMouseButtonPressed(Enum.UserInputType[k_n]);
            end;
            local ok_e, kc_e = pcall(function() return Enum.KeyCode[k_n]; end);
            return ok_e and z:IsKeyDown(kc_e) or false;
        end;
        F_kbd.draw = function(self)
            local btn, is_listening = self.b, self.lst == true;
            btn.Text = is_listening and "..." or (vQ(self.val) or "none");
            w(btn, {TextColor3 = self.dis and tQ.faint or (is_listening and tQ.acc or (self.val and tQ.txt or tQ.dim))}, 0.12, gQ);
            w(self.ks, {Color = is_listening and tQ.acc or sQ, Transparency = is_listening and 0.5 or ZQ.ctle}, 0.14, gQ);
            if self.lbl then self.lbl.TextColor3 = self.dis and tQ.faint or tQ.txt; end;
            if self.lsh ~= is_listening then 
                self.lsh = is_listening;
                ai(self.row, is_listening);
            end;
        end;

        local F_inp = setmetatable({}, R);
        F_inp.__index = F_inp;
        ci_cnt.input = function(c_cnt, n_opt)
            local O_opt = n_opt or {};
            local n_inst = xQ(F_inp, c_cnt, O_opt, "inp");
            n_inst.val = tostring(O_opt.default or "");
            local tb_obj;
            if n_inst.name ~= "" then 
                n_inst.lo = 1000000;
                local _, hit_b, accf_p = ni_row_item(n_inst, c_cnt);
                tb_obj = QQ("TextBox", {
                    Size = l(O_opt.w or 140, 22), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl,
                    Text = n_inst.val, TextSize = 13, PlaceholderText = O_opt.placeholder or "",
                    TextTruncate = UQ, ClipsDescendants = true, LayoutOrder = n_inst.lo, Parent = accf_p
                }, {PlaceholderColor3 = "dim"});
                SQ(tb_obj, 5);
                eQ(tb_obj, 8, 8, 0, 0);
                n_inst.sk = JQ(tb_obj, ZQ.ctle);
                GQ(hit_b.MouseButton1Click, function() if not n_inst.dis then tb_obj:CaptureFocus(); end; end);
            else 
                local r_box = c_cnt:row(30);
                n_inst.row = r_box;
                tb_obj = QQ("TextBox", {
                    Position = l(12, 0), Size = f(1, -24, 1, 0), Text = n_inst.val, TextSize = 13,
                    PlaceholderText = O_opt.placeholder or "", TextTruncate = UQ, ClipsDescendants = true,
                    ZIndex = 2, Parent = r_box
                }, {PlaceholderColor3 = "dim"});
            end;
            n_inst.b = tb_obj;
            n_inst.ctl = tb_obj;
            GQ(tb_obj.Focused, function()
                n_inst.foc = true;
                ai(n_inst.row, true);
                if n_inst.sk then w(n_inst.sk, {Color = tQ.acc, Transparency = 0.5}, 0.14, gQ); end;
            end);
            GQ(tb_obj.FocusLost, function(enter_p)
                if n_inst.foc then n_inst.foc = false; ai(n_inst.row, false); end;
                if n_inst.sk then w(n_inst.sk, {Color = sQ, Transparency = ZQ.ctle}, 0.14, gQ); end;
                n_inst:set(tb_obj.Text);
                if enter_p and O_opt.onenter then k(O_opt.onenter, n_inst.val); end;
            end);
            if O_opt.live then 
                GQ(tb_obj:GetPropertyChangedSignal("Text"), function()
                    if tb_obj:IsFocused() and tb_obj.Text ~= n_inst.val then 
                        n_inst.val = tb_obj.Text;
                        n_inst:fire();
                    end;
                end);
            end;
            n_inst:draw();
            mi_register(n_inst);
            return n_inst;
        end;

        F_inp.set = function(self, str_v, no_fire)
            str_v = tostring(str_v or "");
            local mx = self.o.max;
            str_v = if mx then L(str_v, 1, mx) else str_v;
            if self.b.Text ~= str_v then self.b.Text = str_v; end;
            if str_v == self.val then return self; end;
            self.val = str_v;
            self:fire(no_fire);
            return self;
        end;
        F_inp.load = function(self, val) if type(val) == "string" then self:set(val); end; end;
        F_inp.draw = function(self)
            self.b.TextColor3 = self.dis and tQ.faint or tQ.txt;
            self.b.TextEditable = not self.dis;
            if self.lbl then self.lbl.TextColor3 = self.dis and tQ.faint or tQ.txt; end;
        end;
        F_inp.focus = function(self) self.b:CaptureFocus(); return self; end;

        local F_btn = setmetatable({}, R);
        F_btn.__index = F_btn;
        local btn_styles = {
            ghost = {tc = "txt", ic = "sub"},
            primary = {tc = "acc", ic = "acc"},
            danger = {tc = "bad", ic = "bad"}
        };
        ci_cnt.button = function(n_cnt, O_opt)
            O_opt = O_opt or {};
            local j_inst = xQ(F_btn, n_cnt, O_opt, "btn");
            local st_def = btn_styles[O_opt.style or "ghost"] or btn_styles.ghost;
            local row_f = n_cnt:free();
            j_inst.row = row_f;
            local card_t = ZQ.card;
            local btn = QQ("TextButton", {
                Size = f(1, 0, 0, O_opt.h or (n_cnt.pop and 28 or 30)),
                BackgroundColor3 = sQ, BackgroundTransparency = card_t, Parent = row_f
            });
            SQ(btn, 7);
            JQ(btn, ZQ.edge);
            local inner_f = QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(0, 20), AutomaticSize = p, Parent = btn});
            IQ_lay(inner_f, 7);
            if O_opt.icon then 
                j_inst.ic = QQ("ImageLabel", {Size = l(12, 12), Image = XQ(O_opt.icon), LayoutOrder = 1, Parent = inner_f}, {ImageColor3 = st_def.ic});
            end;
            j_inst.t = QQ("TextLabel", {Size = l(0, 20), AutomaticSize = p, Text = j_inst.name, TextSize = 13, LayoutOrder = 2, Parent = inner_f}, {TextColor3 = st_def.tc});
            j_inst.b = btn;
            j_inst.vr = st_def;
            _i(btn, n_cnt.pop, "BackgroundTransparency", card_t, 0.94);
            GQ(btn.MouseButton1Click, function()
                if not j_inst.dis and j_inst.cb then k(j_inst.cb); end;
            end);
            j_inst:draw();
            return j_inst;
        end;

        F_btn.draw = function(self)
            self.t.TextTransparency = self.dis and 0.55 or 0;
            if self.ic then self.ic.ImageTransparency = self.dis and 0.55 or 0; end;
        end;
        F_btn.press = function(self) if self.cb then k(self.cb); end; end;
        F_btn.settext = function(self, str_t)
            self.name = tostring(str_t or "");
            self.t.Text = self.name;
            return self;
        end;

        local F_lbl = setmetatable({}, R);
        F_lbl.__index = F_lbl;
        ci_cnt.label = function(c_cnt, n_opt)
            n_opt = (if type(n_opt) == "string" then {text = n_opt} else n_opt) or {};
            local O_inst, j_row = xQ(F_lbl, c_cnt, n_opt, "lbl"), c_cnt:row(n_opt.h or 30, true);
            j_row.AutomaticSize = D;
            O_inst.row = j_row;
            local pad_f = QQ("Frame", {Size = f(1, 0, 0, 0), AutomaticSize = D, Parent = j_row});
            eQ(pad_f, 12, 12, 8, 8);
            O_inst.l = QQ("TextLabel", {
                Size = f(1, 0, 0, 14), AutomaticSize = D, TextWrapped = true,
                RichText = n_opt.rich == true, TextSize = 13,
                TextXAlignment = n_opt.center and b.Center or b.Left,
                Text = O_inst.name, Parent = pad_f
            }, {TextColor3 = n_opt.bright and "sub" or "dim"});
            return O_inst;
        end;
        F_lbl.settext = function(self, str_t)
            self.name = tostring(str_t or "");
            self.l.Text = self.name;
            return self;
        end;

        local F_crd = setmetatable({}, R);
        F_crd.__index = F_crd;
        local function c_crd_val(n_entry)
            if type(n_entry) == "table" then 
                local v_val = n_entry.value;
                v_val = if v_val == nil then n_entry.name else v_val;
                return v_val, tostring(n_entry.name or v_val), n_entry.image, n_entry.crop == true;
            end;
            return n_entry, tostring(n_entry), nil, false;
        end;

        local function n_crd_item(O_crd, j_lo)
            local btn = QQ("TextButton", {Size = l(100, 100), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.card, LayoutOrder = j_lo, Parent = O_crd.gr});
            SQ(btn, 7);
            local it_data = {
                b = btn, sk = JQ(btn, ZQ.edge),
                im = QQ("ImageLabel", {AnchorPoint = s(0.5, 0), Position = f(0.5, 0, 0, 7), Size = f(1, -14, 1, -34), Parent = btn}),
                tl = QQ("TextLabel", {AnchorPoint = s(0, 1), Position = f(0, 8, 1, -7), Size = f(1, -16, 0, 16), FontFace = LQ.m, TextSize = 12, TextXAlignment = b.Center, TextTruncate = UQ, TextColor3 = tQ.sub, Parent = btn}),
                h = false
            };
            Ri(btn, O_crd.c.pop, function() it_data.h = true; O_crd:paint(it_data, true); end, function() it_data.h = false; O_crd:paint(it_data, true); end);
            GQ(btn.MouseButton1Click, function()
                if not O_crd.dis and it_data.v ~= nil then O_crd:set(it_data.v); end;
            end);
            return it_data;
        end;

        ci_cnt.cards = function(O_cnt, j_opt)
            j_opt = j_opt or {};
            local Z_inst = xQ(F_crd, O_cnt, j_opt, "crd");
            Z_inst.cols = E(P(tonumber(j_opt.cols) or 3), 1, 6);
            Z_inst.gap = 6;
            Z_inst.ratio = tonumber(j_opt.ratio) or 0.75;
            Z_inst.pool = {};
            Z_inst.items = {};
            Z_inst.idx = {};
            Z_inst.val = j_opt.default;
            local row_f = O_cnt:free();
            Z_inst.row = row_f;
            local gr_f = QQ("Frame", {Size = f(1, 0, 0, 0), AutomaticSize = D, Parent = row_f});
            Z_inst.gr = gr_f;
            Z_inst.grid = QQ("UIGridLayout", {CellPadding = l(Z_inst.gap, Z_inst.gap), CellSize = l(100, 100), FillDirectionMaxCells = Z_inst.cols, SortOrder = Enum.SortOrder.LayoutOrder, Parent = gr_f});
            GQ(gr_f:GetPropertyChangedSignal("AbsoluteSize"), function() Z_inst:fit(); end);
            Z_inst:setvalues(j_opt.values, true);
            if Z_inst.val == nil and Z_inst.items[1] then 
                Z_inst.val = Z_inst.items[1].v;
            end;
            Z_inst:fit();
            Z_inst:draw();
            mi_register(Z_inst);
            return Z_inst;
        end;

        F_crd.fit = function(self)
            local w_px = self.gr.AbsoluteSize.X / nQ();
            if w_px <= 0 then return; end;
            local cols = self.cols;
            local cw = P((w_px - self.gap * (cols - 1)) / cols);
            local ch = P((cw - 14) * self.ratio + 34 + 0.5);
            if self.cw ~= cw or self.ch ~= ch then 
                self.cw = cw;
                self.ch = ch;
                self.grid.CellSize = l(cw, ch);
            end;
        end;

        F_crd.paint = function(self, it_data, anim)
            local is_sel = it_data.v ~= nil and it_data.v == self.val;
            local is_dis = self.dis;
            local bg_c = is_sel and tQ.acc or sQ;
            local bg_t = is_sel and 0.9 or (it_data.h and not is_dis and ZQ.ctlh or ZQ.card);
            local sk_c = is_sel and tQ.acc or sQ;
            local sk_t = is_sel and 0.35 or ZQ.edge;
            local txt_c = is_dis and tQ.faint or (is_sel and tQ.txt or (it_data.h and tQ.txt or tQ.sub));
            local img_t = is_dis and 0.55 or 0;
            if anim then 
                w(it_data.b, {BackgroundColor3 = bg_c, BackgroundTransparency = bg_t}, 0.14, gQ);
                w(it_data.sk, {Color = sk_c, Transparency = sk_t}, 0.14, gQ);
                w(it_data.tl, {TextColor3 = txt_c}, 0.14, gQ);
                w(it_data.im, {ImageTransparency = img_t}, 0.14, gQ);
            else 
                it_data.b.BackgroundColor3, it_data.b.BackgroundTransparency = bg_c, bg_t;
                it_data.sk.Color, it_data.sk.Transparency = sk_c, sk_t;
                it_data.tl.TextColor3 = txt_c;
                it_data.im.ImageTransparency = img_t;
            end;
        end;

        F_crd.draw = function(self)
            local pool = self.pool;
            for idx = 1, #pool, 1 do 
                local it_data = pool[idx];
                if it_data.v ~= nil then self:paint(it_data, true); end;
            end;
        end;

        F_crd.setvalues = function(self, vals, no_adjust)
            local items_arr, idx_map, pool = {}, {}, self.pool;
            if type(vals) == "table" then 
                for idx = 1, #vals, 1 do 
                    local v_val, t_name, img_url, is_crop = c_crd_val(vals[idx]);
                    if v_val ~= nil and idx_map[v_val] == nil then 
                        local pos = #items_arr + 1;
                        items_arr[pos] = {v = v_val, t = t_name, img = img_url, crop = is_crop};
                        idx_map[v_val] = pos;
                    end;
                end;
            end;
            self.items = items_arr;
            self.idx = idx_map;
            for idx = 1, #items_arr, 1 do 
                local it_obj = pool[idx];
                if not it_obj then 
                    it_obj = n_crd_item(self, idx);
                    pool[idx] = it_obj;
                end;
                local item_d = items_arr[idx];
                it_obj.v = item_d.v;
                if it_obj.t ~= item_d.t then 
                    it_obj.t = item_d.t;
                    it_obj.tl.Text = item_d.t;
                end;
                local img_s = item_d.img or "";
                if it_obj.img ~= img_s then 
                    it_obj.img = img_s;
                    it_obj.im.Image = img_s;
                end;
                local sc_t = item_d.crop and Enum.ScaleType.Crop or Enum.ScaleType.Fit;
                if it_obj.im.ScaleType ~= sc_t then it_obj.im.ScaleType = sc_t; end;
                it_obj.b.Visible = true;
                self:paint(it_obj, false);
            end;
            for idx = #items_arr + 1, #pool, 1 do 
                local it_obj = pool[idx];
                it_obj.v = nil;
                it_obj.h = false;
                it_obj.b.Visible = false;
            end;
            if not no_adjust and self.val ~= nil and idx_map[self.val] == nil then 
                local first_it = items_arr[1];
                self.val = first_it and first_it.v or nil;
                self:draw();
                self:fire();
            end;
            return self;
        end;

        F_crd.set = function(self, val, no_fire)
            if val ~= nil and self.idx[val] == nil then return self; end;
            if self.val == val then return self; end;
            self.val = val;
            self:draw();
            self:fire(no_fire);
            return self;
        end;
        F_crd.load = function(self, val) if val ~= nil then self:set(val); end; end;

        local F_sub = setmetatable({}, R);
        F_sub.__index = F_sub;
        ci_cnt.submenu = function(R_cnt, c_opt)
            c_opt = (if type(c_opt) == "string" then {name = c_opt} else c_opt) or {};
            local n_inst = xQ(F_sub, R_cnt, c_opt, "sub");
            n_inst.lo = 1000000;
            local row_f, hit_b, accf_p = ni_row_item(n_inst, R_cnt);
            n_inst.ch = QQ("ImageLabel", {Size = l(12, 12), Image = XQ("right"), LayoutOrder = n_inst.lo, Parent = accf_p}, {ImageColor3 = "dim"});
            local sub_pop = ri_pop({w = c_opt.w, keep = true, anchor = row_f, par = R_cnt.pop, tab = R_cnt.tab, tmp = R_cnt.tmp, title = c_opt.title});
            sub_pop.owner = n_inst;
            sub_pop.c.page, sub_pop.c.sec = R_cnt.page, R_cnt.sec;
            n_inst.sp = sub_pop;
            GQ(hit_b.MouseButton1Click, function()
                if n_inst.dis then return; end;
                if sub_pop.isopen then t_pop_close_inst(sub_pop); return; end;
                ai(row_f, true);
                w(n_inst.ch, {ImageColor3 = tQ.txt}, 0.12, gQ);
                function sub_pop.onclose()
                    ai(row_f, false);
                    w(n_inst.ch, {ImageColor3 = tQ.dim}, 0.12, gQ);
                end;
                if sub_pop.aw then sub_pop:fitw(); end;
                local sc, abs_p, abs_s, pr_p, gui_sz = nQ(), row_f.AbsolutePosition, row_f.AbsoluteSize, kQ.probe.AbsolutePosition, kQ.gui.AbsoluteSize;
                local pop_w_px = sub_pop.w * sc;
                local l_bound, r_bound = abs_p.X, abs_p.X + abs_s.X;
                if R_cnt.pop then 
                    local pf = R_cnt.pop.frame;
                    l_bound, r_bound = pf.AbsolutePosition.X, pf.AbsolutePosition.X + pf.AbsoluteSize.X;
                end;
                local px_calc = r_bound + 8 * sc;
                local px_res = if px_calc + pop_w_px > pr_p.X + gui_sz.X - 6 then l_bound - 8 * sc - pop_w_px else px_calc;
                uQ_pop_open(sub_pop, px_res, abs_p.Y - 6 * sc);
            end);
            n_inst:draw();
            return sub_pop.c, n_inst;
        end;
        ci_cnt.menu = ci_cnt.submenu;
        F_sub.draw = function(self)
            if self.lbl then self.lbl.TextColor3 = self.dis and tQ.faint or tQ.txt; end;
        end;

        local R_subt = {};
        R_subt.__index = R_subt;
        local function F_build_subtabs(t_par, c_names, n_init, O_cb, j_pop)
            local total = #c_names;
            local inst = setmetatable({i = n_init or 1, b = {}, cb = O_cb, n = total}, R_subt);
            local is_soft = j_pop ~= nil;
            local bar_f = QQ("Frame", {
                Size = f(1, 0, 0, 30),
                BackgroundColor3 = sQ, BackgroundTransparency = is_soft and ZQ.pfil or ZQ.card,
                Parent = t_par
            });
            SQ(bar_f, is_soft and 8 or 7);
            if not is_soft then JQ(bar_f, ZQ.edge); end;
            eQ(bar_f, 3, 3, 3, 3);
            inst.hl = QQ("Frame", {Size = f(1 / total, 0, 1, 0), BackgroundColor3 = sQ, BackgroundTransparency = is_soft and 0.935 or ZQ.tab, Parent = bar_f});
            SQ(inst.hl, is_soft and 6 or 5);
            local btn_row = QQ("Frame", {Size = g(1, 1), ZIndex = 2, Parent = bar_f});
            IQ_lay(btn_row, 0);
            inst.f = bar_f;
            for idx = 1, total, 1 do 
                local b_tab = QQ("TextButton", {Size = f(1 / total, 0, 1, 0), Text = c_names[idx], TextSize = 13, LayoutOrder = idx, ZIndex = 2, Parent = btn_row}, {TextColor3 = "dim"});
                inst.b[idx] = b_tab;
                GQ(b_tab.MouseButton1Click, function() inst:set(idx, true); end);
                Ri(b_tab, j_pop, function()
                    if inst.i ~= idx then w(b_tab, {TextColor3 = tQ.sub}, 0.1, gQ); end;
                end, function()
                    if inst.i ~= idx then w(b_tab, {TextColor3 = tQ.dim}, 0.1, gQ); end;
                end);
            end;
            inst:paint(false);
            inst:place(false);
            return inst;
        end;

        R_subt.place = function(self, anim)
            local pos_v = g((self.i - 1) / self.n, 0);
            if anim then w(self.hl, {Position = pos_v}, 0.22); else self.hl.Position = pos_v; end;
        end;
        R_subt.paint = function(self, anim)
            for idx = 1, #self.b, 1 do 
                local is_active, b_obj = idx == self.i, self.b[idx];
                b_obj.FontFace = is_active and LQ.b or LQ.s;
                local col = is_active and tQ.txt or tQ.dim;
                if anim then w(b_obj, {TextColor3 = col}, 0.14, gQ); else b_obj.TextColor3 = col; end;
            end;
        end;
        R_subt.set = function(self, idx, fire_cb)
            if idx == self.i or not self.b[idx] then return; end;
            self.i = idx;
            self:paint(true);
            self:place(true);
            if self.cb then self.cb(idx, fire_cb); end;
        end;

        ci_cnt.subtabs = function(R_cnt, t_names, c_opt)
            local n_opt = c_opt or {};
            local free_f, cnt_arr = R_cnt:free(), table.create(#t_names);
            local tabs_ctrl = F_build_subtabs(free_f, t_names, n_opt.default or 1, function(new_i, fire_cb)
                _Q_pop_sub(R_cnt.pop);
                for idx = 1, #cnt_arr, 1 do 
                    if idx ~= new_i then cnt_arr[idx].frame.Visible = false; end;
                end;
                fi_anim(cnt_arr[new_i].frame, true, 0.2);
                if fire_cb and n_opt.cb then k(n_opt.cb, new_i, t_names[new_i]); end;
            end, R_cnt.pop);
            for idx = 1, #t_names, 1 do 
                R_cnt.n = R_cnt.n + 1;
                local sub_f = QQ("Frame", {
                    Size = f(1, 0, 0, 0), AutomaticSize = D, LayoutOrder = R_cnt.n,
                    Visible = idx == tabs_ctrl.i, Parent = R_cnt.frame
                });
                MQ_lay(sub_f, 6);
                local sub_cnt = VQ(sub_f, R_cnt.tab, R_cnt.pop);
                sub_cnt.tmp, sub_cnt.page, sub_cnt.sec = R_cnt.tmp, R_cnt.page, R_cnt.sec;
                sub_cnt.sub = {s = tabs_ctrl, i = idx, up = R_cnt.sub};
                cnt_arr[idx] = sub_cnt;
            end;
            R_cnt.cb = nil;
            return cnt_arr;
        end;

        DQ = function(R_el)
            if R_el.tmp or R_el.dead or kQ.dead or kQ.eat then return; end;
            local F_ind = R_el.ind;
            local t_bnd = R_el.bnd;
            if not F_ind and not t_bnd then return; end;
            local pop_inst = ri_pop({tmp = true, par = R_el.c and R_el.c.pop, title = R_el.name});
            local cnt = pop_inst.c;
            local tgl_show, inp_name, sld_val, kbd_el;
            if t_bnd then 
                kbd_el = cnt:keybind({
                    name = "Key", icon = "keyboard", default = t_bnd.key,
                    cb = function(new_k)
                        if new_k and not t_bnd.key then 
                            if sld_val and t_bnd.v == R_el.val then 
                                R_el:setbv(R_el.val >= R_el.max and R_el.min or R_el.max);
                                sld_val:set(t_bnd.v, true);
                            end;
                            if F_ind and not F_ind.on then 
                                F_ind.on = true;
                                if tgl_show then tgl_show:set(true, true); end;
                            end;
                        end;
                        R_el:setbind(new_k);
                    end
                });
                cnt:dropdown({
                    name = "Mode", icon = "refresh", values = {"Hold", "Toggle"},
                    default = t_bnd.mode == "hold" and "Hold" or "Toggle", w = 96,
                    cb = function(new_m)
                        R_el:setbind(t_bnd.key, new_m == "Hold" and "hold" or "toggle");
                    end
                });
                if R_el.kind == "sld" then 
                    sld_val = cnt:slider({
                        name = "Value", icon = "sliders", min = R_el.min, max = R_el.max,
                        dec = R_el.dec, step = R_el.step, suffix = R_el.suf, zero = R_el.zero,
                        fmt = R_el.o.fmt, sw = 56, default = t_bnd.v,
                        cb = function(new_v) R_el:setbv(new_v); end
                    });
                end;
            end;
            if F_ind then 
                cnt:brk();
                tgl_show = cnt:toggle({
                    name = "Show in list", icon = "eye", default = F_ind.on,
                    cb = function(is_on) F_ind.on = is_on; pQ(); end
                });
                inp_name = cnt:input({
                    name = "List name", icon = "pencil", placeholder = R_el.name,
                    default = F_ind.name, w = 104,
                    cb = function(new_n) F_ind.name = new_n; pQ(); end
                });
            end;
            pop_inst:hbtn("trash", "bad", function()
                if t_bnd then 
                    R_el:setbind(nil);
                    if kbd_el then kbd_el:setkey(nil, true); end;
                end;
                if F_ind then 
                    F_ind.on = false;
                    F_ind.name = "";
                    if tgl_show then tgl_show:set(false, true); end;
                    if inp_name then inp_name:set("", true); end;
                end;
                pQ();
            end);
            local row_el = R_el:rw();
            ai(row_el, true);
            pop_inst.onclose = function() ai(row_el, false); end;
            local mpos = BQ();
            uQ_pop_open(pop_inst, mpos.X + 4, mpos.Y + 4);
        end;
    end;

    -- [Конец Части 2]

    -- [Начало Части 3]

    local R_spec_cb;
    local F_wm_items, t_kb, c_spec, n_wm, O_wm_upd, j_wm_rebuild, Z_notify, i_kb_init, W_wm_init, KQ_spec_init = {"User", "FPS", "Ping", "CPU", "RAM", "Time"};
    do 
        local _Q_fnt = Font.new("rbxasset://fonts/families/SourceSansPro.json");
        local NQ_bg, uQ_trans = h(12, 20, 25), 0.686274528503418;
        local xQ_txt = h(210, 220, 230);
        local vQ_clr = h(20, 20, 20);

        local function h_strip(DQ_s)
            return Q(Q(Q(Q(DQ_s, "<[^>]->", ""), "&lt;", "<"), "&gt;", ">"), "&amp;", "&");
        end;

        local function DQ_shd_lbl(Ni_l, ri_a)
            local Gi = QQ("TextLabel", {
                Position = l(1, 1), Size = g(1, 1),
                Text = Ni_l.RichText and h_strip(Ni_l.Text) or Ni_l.Text,
                FontFace = Ni_l.FontFace, TextSize = Ni_l.TextSize, TextXAlignment = Ni_l.TextXAlignment,
                TextColor3 = CQ, TextTransparency = ri_a or 0.2, ZIndex = Ni_l.ZIndex, Parent = Ni_l
            });
            local ri = QQ("TextLabel", {
                Size = g(1, 1), Text = Ni_l.Text, RichText = Ni_l.RichText,
                FontFace = Ni_l.FontFace, TextSize = Ni_l.TextSize, TextXAlignment = Ni_l.TextXAlignment,
                TextColor3 = Ni_l.TextColor3, ZIndex = Ni_l.ZIndex + 1, Parent = Ni_l
            });
            Ni_l.TextTransparency = 1;
            GQ(Ni_l:GetPropertyChangedSignal("Text"), function()
                ri.Text = Ni_l.Text;
                Gi.Text = Ni_l.RichText and h_strip(Ni_l.Text) or Ni_l.Text;
            end);
            GQ(Ni_l:GetPropertyChangedSignal("TextColor3"), function()
                ri.TextColor3 = Ni_l.TextColor3;
            end);
            return Ni_l, ri, Gi;
        end;

        local function h_hud_txt(Ni_p, ri_t)
            Ni_p.FontFace = _Q_fnt;
            Ni_p.TextSize = 16;
            if Ni_p.AutomaticSize == nil then Ni_p.AutomaticSize = V; end;
            if Ni_p.TextColor3 == nil and not ri_t then Ni_p.TextColor3 = sQ; end;
            return DQ_shd_lbl(QQ("TextLabel", Ni_p, ri_t), 0.15);
        end;

        local function _Q_sep(DQ_p, Ni_lo)
            local ri = QQ("Frame", {Size = l(25, 14), LayoutOrder = Ni_lo, Parent = DQ_p});
            QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(1, 14), BackgroundColor3 = sQ, BackgroundTransparency = 0.392, Parent = ri});
            return ri;
        end;

        local function DQ_hud_ico(Ni_p, ri_i, Gi_lo, ai_col, mi_sz, ci_tr)
            return QQ("ImageLabel", {Size = l(mi_sz, mi_sz), Image = XQ(ri_i), ImageTransparency = ci_tr, LayoutOrder = Gi_lo, Parent = Ni_p}, ai_col and {ImageColor3 = ai_col} or nil);
        end;

        local function Ni_spacer(ri_p, Gi_w, ai_lo)
            return QQ("Frame", {Size = l(Gi_w, 1), LayoutOrder = ai_lo, Parent = ri_p});
        end;

        local function ri_hud_av(Gi_p, ai_uid, mi_lo)
            local ci = QQ("ImageLabel", {
                Size = l(18, 18), Image = "rbxthumb://type=AvatarHeadShot&id=" .. ai_uid .. "&w=48&h=48",
                ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = vQ_clr, BackgroundTransparency = 0,
                LayoutOrder = mi_lo, Parent = Gi_p
            });
            AQ(ci);
            return ci;
        end;

        local function vQ_hud_shd(Gi_p, ai_t, mi_is_p)
            local ci, ni = pcall(Instance.new, "UIShadow");
            if ci and ni then 
                ni.BlurRadius = u(0, 8);
                ni.Spread = l(2, 2);
                ni.Transparency = 0.5;
                ni.Parent = ai_t;
                return;
            end;
            local shd_asset = mi_is_p and jQ.pshadow or jQ.bshadow;
            if shd_asset then 
                QQ("ImageLabel", {
                    Image = shd_asset, ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = mi_is_p and Rect.new(31, 0, 32, 61) or Rect.new(24, 24, 28, 28),
                    Position = l(-14, -14), Size = mi_is_p and f(1, 28, 0, 62) or f(1, 28, 1, 28),
                    ZIndex = 0, Parent = Gi_p
                });
            end;
        end;

        local function u_hud_card(jQ_p, Gi_round, ai_lo, mi_fullw)
            local ci = QQ("Frame", {Size = l(0, 34), LayoutOrder = ai_lo or 0, Parent = jQ_p});
            local bg = QQ("Frame", {Size = g(1, 1), BackgroundColor3 = NQ_bg, BackgroundTransparency = uQ_trans, ZIndex = 1, Parent = ci});
            if Gi_round then AQ(bg); else SQ(bg, 17); end;
            vQ_hud_shd(ci, bg, Gi_round);
            local NQ_inner = QQ("Frame", {AnchorPoint = s(0, Gi_round and 0.5 or 0), Position = g(0, Gi_round and 0.5 or 0), Size = mi_fullw and f(1, 0, 0, 0) or l(0, 0), AutomaticSize = mi_fullw and D or V, ZIndex = 2, Parent = ci});
            eQ(NQ_inner, 12, 12, 8, 8);
            local function uQ_fit()
                local sz = NQ_inner.AbsoluteSize;
                si_sz(ci, mi_fullw and f(1, 0, 0, sz.Y) or l(sz.X, Gi_round and T(sz.Y, 34) or sz.Y));
            end;
            GQ(NQ_inner:GetPropertyChangedSignal("AbsoluteSize"), uQ_fit);
            uQ_fit();
            return ci, NQ_inner, uQ_fit;
        end;

        local function NQ_hud_head(uQ_p, jQ_ico, vQ_txt)
            local Gi = QQ("Frame", {Size = f(1, 0, 0, 20), LayoutOrder = 0, Parent = uQ_p});
            IQ_lay(Gi, 0);
            DQ_hud_ico(Gi, jQ_ico, 1, "acc", 18, 0.392);
            Ni_spacer(Gi, 8, 2);
            h_hud_txt({Text = vQ_txt, LayoutOrder = 3, Parent = Gi});
            local div_f = QQ("Frame", {Size = f(1, 0, 0, 10), LayoutOrder = 1, Parent = uQ_p});
            QQ("Frame", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = f(1, 0, 0, 1), BackgroundColor3 = sQ, BackgroundTransparency = 0.75, Parent = div_f});
            local box_c = QQ("Frame", {Size = f(1, 0, 0, 0), AutomaticSize = D, LayoutOrder = 2, Parent = uQ_p});
            MQ_lay(box_c, 4);
            return box_c;
        end;

        t_kb = {on = true, rows = {}, q = false};
        local function uQ_val_fmt(jQ_el)
            local k_kind = jQ_el.kind;
            if k_kind == "tgl" then 
                local eff = jQ_el:eff();
                return eff and "ON" or "OFF", eff and tQ.acc or xQ_txt;
            elseif k_kind == "sld" then 
                return jQ_el:fmtv(jQ_el:eff()), jQ_el.bnd.act and tQ.acc or xQ_txt;
            elseif k_kind == "drp" then 
                return jQ_el:text(), xQ_txt;
            end;
            return "", xQ_txt;
        end;

        local function jQ_kb_upd()
            local vQ_f = t_kb.f;
            if not vQ_f or kQ.dead then return; end;
            local rows_map, alive_map, els, cnt, max_w = t_kb.rows, {}, iQ.els, 0, 0;
            for idx = 1, #els, 1 do 
                local el = els[idx];
                local ind = el.ind;
                if ind and not el.dead and not el.dis and (ind.on or (el.bnd and el.bnd.key)) then 
                    cnt += 1;
                    alive_map[el] = true;
                    local r_dat = rows_map[el];
                    if not r_dat then 
                        local r_f = QQ("Frame", {Size = f(1, 0, 0, 20), Parent = vQ_f});
                        local n_lbl, n_t, n_sh = h_hud_txt({Size = l(0, 20), AutomaticSize = p, TextColor3 = xQ_txt, Parent = r_f});
                        local v_lbl, v_t, v_sh = h_hud_txt({AnchorPoint = s(1, 0), Position = g(1, 0), Size = l(0, 20), AutomaticSize = p, TextXAlignment = b.Right, TextColor3 = xQ_txt, Parent = r_f});
                        r_dat = {f = r_f, n = n_lbl, v = v_lbl};
                        rows_map[el] = r_dat;
                        n_t.TextTransparency = 1; n_sh.TextTransparency = 1;
                        v_t.TextTransparency = 1; v_sh.TextTransparency = 1;
                        w(n_t, {TextTransparency = 0}, 0.22, gQ);
                        w(v_t, {TextTransparency = 0}, 0.22, gQ);
                        w(n_sh, {TextTransparency = 0.15}, 0.22, gQ);
                        w(v_sh, {TextTransparency = 0.15}, 0.22, gQ);
                        GQ(r_dat.n:GetPropertyChangedSignal("AbsoluteSize"), pQ);
                        GQ(r_dat.v:GetPropertyChangedSignal("AbsoluteSize"), pQ);
                    end;
                    r_dat.f.LayoutOrder = 10 + cnt;
                    r_dat.n.Text = ind.name ~= "" and ind.name or el.name;
                    local str_v, col_v = uQ_val_fmt(el);
                    r_dat.v.Text = str_v;
                    w(r_dat.v, {TextColor3 = col_v}, 0.14, gQ);
                    max_w = T(max_w, r_dat.n.AbsoluteSize.X + T(r_dat.v.AbsoluteSize.X, 26) + 2);
                end;
            end;
            for el_k, r_v in next, rows_map, nil do 
                if not alive_map[el_k] then 
                    rows_map[el_k] = nil;
                    r_v.f:Destroy();
                end;
            end;
            si_sz(t_kb.g, l(24 + T(132, P(max_w + 0.5)), 0));
            zi(t_kb.g, t_kb.on and (kQ.open or cnt > 0));
        end;

        pQ = function()
            if t_kb.q or not t_kb.f or kQ.dead then return; end;
            t_kb.q = true;
            d(function()
                t_kb.q = false;
                jQ_kb_upd();
            end);
        end;

        local function uQ_kb_build(jQ_gui, vQ_pos)
            local Gi = QQ("Frame", {Position = vQ_pos, Size = l(156, 0), AutomaticSize = D, Visible = false, Parent = jQ_gui});
            local _, vQ_inner = u_hud_card(Gi, false, 0, true);
            MQ_lay(vQ_inner, 0);
            t_kb.g, t_kb.f = Gi, NQ_hud_head(vQ_inner, "code", "Keybinds");
            t_kb.hh = QQ("TextButton", {Size = g(1, 1), ZIndex = 5, Visible = false, Parent = Gi});
            return Gi;
        end;

        c_spec = {on = true, use = false, rows = {}, list = {}, q = false};
        local function jQ_spec_upd()
            local vQ_f = c_spec.f;
            if not vQ_f or kQ.dead then return; end;
            local rows_map, alive_map, slist, cnt, max_w = c_spec.rows, {}, c_spec.list, 0, 0;
            for idx = 1, #slist, 1 do 
                local it = slist[idx];
                local uid = it.id;
                if not alive_map[uid] then 
                    cnt += 1;
                    alive_map[uid] = true;
                    local r_dat = rows_map[uid];
                    if not r_dat then 
                        local r_f = QQ("Frame", {Size = f(1, 0, 0, 20), Parent = vQ_f});
                        IQ_lay(r_f, 0);
                        local av_im = ri_hud_av(r_f, uid, 1);
                        Ni_spacer(r_f, 8, 2);
                        local n_lbl, n_t, n_sh = h_hud_txt({Size = l(0, 20), AutomaticSize = p, TextColor3 = xQ_txt, LayoutOrder = 3, Parent = r_f});
                        r_dat = {f = r_f, n = n_lbl};
                        rows_map[uid] = r_dat;
                        av_im.ImageTransparency = 1; av_im.BackgroundTransparency = 1;
                        n_t.TextTransparency = 1; n_sh.TextTransparency = 1;
                        w(n_t, {TextTransparency = 0}, 0.22, gQ);
                        w(n_sh, {TextTransparency = 0.15}, 0.22, gQ);
                        w(av_im, {ImageTransparency = 0, BackgroundTransparency = 0}, 0.22, gQ);
                        GQ(n_lbl:GetPropertyChangedSignal("AbsoluteSize"), R_spec_cb);
                    end;
                    r_dat.f.LayoutOrder = 10 + cnt;
                    r_dat.n.Text = it.name;
                    max_w = T(max_w, r_dat.n.AbsoluteSize.X + 26);
                end;
            end;
            for uid_k, r_v in next, rows_map, nil do 
                if not alive_map[uid_k] then 
                    rows_map[uid_k] = nil;
                    r_v.f:Destroy();
                end;
            end;
            si_sz(c_spec.g, l(24 + T(132, P(max_w + 0.5)), 0));
            zi(c_spec.g, c_spec.use and c_spec.on and (kQ.open or cnt > 0));
        end;

        R_spec_cb = function()
            if c_spec.q or not c_spec.f or kQ.dead then return; end;
            c_spec.q = true;
            d(function()
                c_spec.q = false;
                jQ_spec_upd();
            end);
        end;

        local function xQ_spec_build(jQ_gui, vQ_pos)
            local si = QQ("Frame", {AnchorPoint = s(1, 0), Position = vQ_pos, Size = l(156, 0), AutomaticSize = D, Visible = false, Parent = jQ_gui});
            local _, jQ_inner = u_hud_card(si, false, 0, true);
            MQ_lay(jQ_inner, 0);
            c_spec.g, c_spec.f = si, NQ_hud_head(jQ_inner, "eye", "Spectators");
            c_spec.hh = QQ("TextButton", {Size = g(1, 1), ZIndex = 5, Visible = false, Parent = si});
            return si;
        end;

        iQ.spectators = function(self, list_arr)
            local target_list = c_spec.list;
            e(target_list);
            if type(list_arr) == "table" then 
                for idx = 1, #list_arr, 1 do 
                    local item = list_arr[idx];
                    local uid, disp_n;
                    if typeof(item) == "Instance" and item:IsA("Player") then 
                        uid, disp_n = item.UserId, item.DisplayName;
                    elseif type(item) == "table" then 
                        uid, disp_n = tonumber(item.id), item.name;
                    end;
                    if uid and disp_n ~= nil then 
                        target_list[#target_list + 1] = {id = uid, name = tostring(disp_n)};
                    end;
                end;
            end;
            R_spec_cb();
        end;

        n_wm = {on = true, show = {"User", "FPS", "Ping", "RAM", "Time"}, title = "polar", v = {}, n = 0};
        local NQ_wm_ico = {FPS = "layers", Ping = "wifi", CPU = "cpu", RAM = "ram", Time = "clock"};
        local function jQ_cpu_val()
            local ok_s, val_s = pcall(function() return m.PerformanceStats.CPU:GetValue(); end);
            if not ok_s or type(val_s) ~= "number" or val_s <= 0 then 
                ok_s, val_s = pcall(function() return m.RenderCPUFrameTime * 1000; end);
            end;
            if not ok_s or type(val_s) ~= "number" or val_s <= 0 then return nil; end;
            return E(P(val_s * T(kQ.fps or 60, 1) / 10 + 0.5), 0, 100);
        end;

        O_wm_upd = function()
            local nl = n_wm.nl;
            if not nl then return; end;
            nl.Text = n_wm.title;
            local v_tbl = n_wm.v;
            if v_tbl.User then v_tbl.User.Text = N.Name; end;
            if v_tbl.FPS then v_tbl.FPS.Text = tostring(kQ.fps or 0); end;
            if v_tbl.Ping then 
                local ok_p, ping_v = pcall(N.GetNetworkPing, N);
                v_tbl.Ping.Text = P((ok_p and ping_v or 0) * 1000 + 0.5) .. "ms";
            end;
            if v_tbl.CPU then 
                local cpu_v = jQ_cpu_val();
                v_tbl.CPU.Text = cpu_v and cpu_v .. "%" or "-";
            end;
            if v_tbl.RAM then 
                local ok_m, ram_v = pcall(m.GetTotalMemoryUsageMb, m);
                v_tbl.RAM.Text = (ok_m and P(ram_v + 0.5) or 0) .. "mb";
            end;
            if v_tbl.Time then v_tbl.Time.Text = os.date("%H:%M"); end;
        end;

        j_wm_rebuild = function()
            local box = n_wm.f;
            if not box then return; end;
            local children = box:GetChildren();
            for idx = 1, #children, 1 do 
                if children[idx]:IsA("GuiObject") then children[idx]:Destroy(); end;
            end;
            local new_v = {};
            n_wm.v = new_v;
            local count = 0;
            for idx = 1, #F_wm_items, 1 do 
                local item_n = F_wm_items[idx];
                if J(n_wm.show, item_n) then 
                    count += 1;
                    if count > 1 then _Q_sep(box, idx * 2 - 1); end;
                    local cell = QQ("Frame", {Size = l(0, 0), AutomaticSize = V, LayoutOrder = idx * 2, Parent = box});
                    IQ_lay(cell, 0);
                    if item_n == "User" then 
                        ri_hud_av(cell, N.UserId, 1);
                    else 
                        DQ_hud_ico(cell, NQ_wm_ico[item_n], 1, nil, 14, 0.392);
                    end;
                    Ni_spacer(cell, 8, 2);
                    new_v[item_n] = h_hud_txt({LayoutOrder = 3, Parent = cell});
                end;
            end;
            n_wm.n = count;
            n_wm.p2.Visible = count > 0;
            O_wm_upd();
        end;

        local function N_wm_build(m_par, NQ_pos)
            local root = QQ("Frame", {AnchorPoint = s(1, 0), Position = NQ_pos, Size = l(0, 0), AutomaticSize = V, Visible = false, Parent = m_par});
            local cont = QQ("Frame", {Size = l(0, 0), AutomaticSize = V, Parent = root});
            IQ_lay(cont, 10, H.Right);
            local _, p1_inner = u_hud_card(cont, true, 1);
            IQ_lay(p1_inner, 0);
            DQ_hud_ico(p1_inner, "code", 1, nil, 18, 0.392);
            Ni_spacer(p1_inner, 8, 2);
            n_wm.nl = h_hud_txt({LayoutOrder = 3, Parent = p1_inner});
            local p2_card, p2_inner = u_hud_card(cont, true, 2);
            IQ_lay(p2_inner, 0);
            n_wm.g, n_wm.p2, n_wm.f = root, p2_card, p2_inner;
            n_wm.hh = QQ("TextButton", {Size = g(1, 1), ZIndex = 10, Visible = false, Parent = root});
            j_wm_rebuild();
            return root;
        end;

        Z_notify = {on = true, n = 0, l = {}};
        local notif_styles = {ok = "ok", bad = "bad", warn = "warn"};
        local function NQ_del_notif(jQ_item)
            local idx = J(Z_notify.l, jQ_item);
            if idx then y(Z_notify.l, idx); end;
            li(jQ_item);
        end;

        iQ.notify = function(self, text_v, style_t, dur_s)
            local notif_f = Z_notify.f;
            if not notif_f or kQ.dead or not Z_notify.on then return; end;
            Z_notify.n = Z_notify.n + 1;
            local col_k = notif_styles[style_t] or "acc";
            local host_box = QQ("Frame", {Size = l(0, 34), LayoutOrder = Z_notify.n, Parent = notif_f});
            local card_w, inner_f, fit_fn = u_hud_card(host_box, true);
            card_w.Visible = false;
            IQ_lay(inner_f, 0);
            DQ_hud_ico(inner_f, "code", 1, col_k, 18, 0.15);
            Ni_spacer(inner_f, 8, 2);
            h_hud_txt({Text = kQ.brand or "polar", LayoutOrder = 3, Parent = inner_f}, {TextColor3 = col_k});
            _Q_sep(inner_f, 4);
            h_hud_txt({Text = YQ(tostring(text_v), tQ.acc), RichText = true, LayoutOrder = 5, Parent = inner_f});
            fit_fn();
            host_box.Size = l(inner_f.AbsoluteSize.X, 34);
            GQ(card_w:GetPropertyChangedSignal("AbsoluteSize"), function()
                host_box.Size = l(card_w.AbsoluteSize.X, 34);
            end);
            local list_arr = Z_notify.l;
            list_arr[#list_arr + 1] = host_box;
            while #list_arr > 6 do 
                NQ_del_notif(list_arr[1]);
            end;
            fi_anim(card_w, true, 0.24, nil, true);
            B(dur_s or 4, function()
                if not host_box.Parent or kQ.dead then return; end;
                fi_anim(card_w, false, 0.3, nil, true, function()
                    NQ_del_notif(host_box);
                end);
            end);
        end;
        iQ.log = function(self, msg, st, dur) return self:notify(msg, st, dur); end;

        i_kb_init, W_wm_init, KQ_spec_init = uQ_kb_build, N_wm_build, xQ_spec_build;
    end;

    local N_page_cls = {};
    N_page_cls.__index = N_page_cls;
    local function h_page_inst(u_tab, m_name, y_idx, _Q_opts)
        local frame_v = QQ("Frame", {Size = g(1, 1), Visible = false, Parent = u_tab.frame});
        eQ(frame_v, 10, 10, 0, 0);
        return setmetatable({
            tab = u_tab, name = m_name, i = y_idx, frame = frame_v, sn = 0,
            cols = {}, nc = E(P(tonumber(_Q_opts and _Q_opts.cols) or 2), 1, 4)
        }, N_page_cls);
    end;

    N_page_cls.col = function(self, m_idx)
        local cols = self.cols;
        m_idx = E(P(tonumber(m_idx) or 1), 1, 4);
        if m_idx > self.nc then self.nc = m_idx; end;
        local count_c = self.nc;
        if #cols < count_c then 
            for idx = #cols + 1, count_c, 1 do 
                local scr = QQ("ScrollingFrame", {ScrollBarThickness = 0, Parent = self.frame});
                eQ(scr, 2, 2, 10, 12);
                MQ_lay(scr, 8);
                cols[idx] = scr;
            end;
            for idx = 1, count_c, 1 do 
                cols[idx].Position = f((idx - 1) / count_c, (idx - 1) * 8 / count_c, 0, 0);
                cols[idx].Size = f(1 / count_c, -(count_c - 1) * 8 / count_c, 1, 0);
            end;
        end;
        return cols[m_idx];
    end;

    N_page_cls.section = function(self, m_opt)
        m_opt = (if type(m_opt) == "string" then {name = m_opt} else m_opt) or {};
        local side_n = m_opt.side;
        local col_box = self:col(tonumber(
            if side_n == "left" then 1
            elseif side_n == "right" then (self.nc > 2 and self.nc or 2)
            elseif side_n == "center" or side_n == "middle" then 2
            else side_n
        ) or 1);
        self.sn = self.sn + 1;
        local sec_f = QQ("Frame", {Size = f(1, 0, 0, 0), AutomaticSize = D, LayoutOrder = self.sn, Parent = col_box});
        MQ_lay(sec_f, 6);
        local cnt_builder = VQ(sec_f, self.tab);
        cnt_builder.page = self;
        cnt_builder.sec = {name = m_opt.name or "", page = self, frame = sec_f};
        if m_opt.name and m_opt.name ~= "" then 
            cnt_builder.n = cnt_builder.n + 1;
            local head_f = QQ("Frame", {Size = f(1, 0, 0, 14), LayoutOrder = cnt_builder.n, Parent = sec_f});
            QQ("TextLabel", {Position = l(10, 0), Size = f(1, -10, 1, 0), Text = m_opt.name, FontFace = LQ.s, TextSize = 12, TextTruncate = UQ, Parent = head_f}, {TextColor3 = "dim"});
        end;
        return cnt_builder;
    end;

    local u_tab_cls = {};
    u_tab_cls.__index = u_tab_cls;
    u_tab_cls.pgdraw = function(self)
        local pgs = self.pages;
        local multi = #pgs > 1;
        for idx = 1, #pgs, 1 do 
            local p_data = pgs[idx];
            local is_cur, btn = p_data == self.pg, p_data.btn;
            btn.Visible = multi;
            btn.FontFace = is_cur and LQ.b or LQ.s;
            w(btn, {TextColor3 = is_cur and tQ.txt or (p_data.hov and tQ.sub or tQ.dim)}, 0.14, gQ);
        end;
    end;

    u_tab_cls.page = function(self, y_name, D_opt)
        if type(y_name) == "table" then y_name, D_opt = y_name.name, y_name; end;
        local pgs = self.pages;
        local new_pg = h_page_inst(self, y_name or "Main", #pgs + 1, D_opt);
        pgs[#pgs + 1] = new_pg;
        local p_btn = QQ("TextButton", {Size = l(0, 40), AutomaticSize = p, Text = new_pg.name, TextSize = 13, LayoutOrder = new_pg.i, Parent = self.tr}, {TextColor3 = "dim"});
        new_pg.btn = p_btn;
        Ri(p_btn, nil, function() new_pg.hov = true; self:pgdraw(); end, function() new_pg.hov = false; self:pgdraw(); end);
        GQ(p_btn.MouseButton1Click, function() self:show(new_pg.i); end);
        if not self.pg then 
            self.pg = new_pg;
            new_pg.frame.Visible = true;
        end;
        self:pgdraw();
        return new_pg;
    end;

    u_tab_cls.show = function(self, idx_p)
        local target_p = self.pages[idx_p];
        if not target_p or target_p == self.pg then return; end;
        _pop_close_all();
        fi_anim(self.pg.frame, false, 0.12);
        self.pg = target_p;
        fi_anim(target_p.frame, true, 0.2, 0.07);
        self:pgdraw();
    end;

    u_tab_cls.section = function(self, m_sec)
        return (self.pages[1] or self:page("Main")):section(m_sec);
    end;

    u_tab_cls.navdraw = function(self)
        local is_sel = self.win.cur == self;
        local is_hov = self.hov and not is_sel;
        self.nl.FontFace = is_sel and LQ.b or LQ.s;
        w(self.ni, {ImageColor3 = is_sel and tQ.acc or (is_hov and tQ.sub or tQ.dim)}, 0.14, gQ);
        w(self.nl, {TextColor3 = is_sel and tQ.txt or (is_hov and tQ.sub or tQ.dim)}, 0.14, gQ);
    end;

    u_tab_cls.hc = function(self)
        local hcc = self.hcc;
        if not hcc then 
            hcc = VQ(self.tl, self, nil);
            self.hcc = hcc;
        end;
        return hcc;
    end;

    u_tab_cls.tbdrop = function(self, m_opt)
        m_opt = m_opt or {};
        m_opt.noprof = true;
        self.tn = self.tn + 1;
        m_opt.par = self.tl;
        m_opt.lo = self.tn;
        m_opt.auto = true;
        m_opt.h = m_opt.h or 24;
        return self:hc():dropdown(m_opt);
    end;

    local h_prof_cls = {};
    h_prof_cls.__index = h_prof_cls;
    u_tab_cls.profile = function(self, y_opt)
        y_opt = y_opt or {};
        local glob_n = y_opt.global or "Global";
        local items_list, src_items = {glob_n}, y_opt.items or {};
        for idx = 1, #src_items, 1 do 
            if src_items[idx] ~= glob_n then items_list[#items_list + 1] = src_items[idx]; end;
        end;
        local prof_inst = setmetatable({
            tab = self, items = items_list, g = glob_n, data = {}, els = {},
            id = y_opt.id or y_opt.flag or self.name
        }, h_prof_cls);
        prof_inst.cur = J(items_list, y_opt.default) and y_opt.default or glob_n;
        self.prof = prof_inst;
        prof_inst.idd = self:tbdrop({values = items_list, default = prof_inst.cur, cb = function(sel_v) prof_inst:select(sel_v); end});
        iQ.profs[#iQ.profs + 1] = prof_inst;
        return prof_inst;
    end;

    h_prof_cls.store = function(self)
        local cur_key = tostring(self.cur);
        local cur_d = self.data[cur_key];
        if not cur_d then 
            if not self.dirty and cur_key ~= self.g then return; end;
            cur_d = {};
            self.data[cur_key] = cur_d;
        end;
        local els = self.els;
        for idx = 1, #els, 1 do 
            local el = els[idx];
            cur_d[el.flag] = el:ser();
        end;
    end;

    h_prof_cls.apply = function(self)
        local cur_key = tostring(self.cur);
        local cur_d = self.data[cur_key];
        cur_d = if cur_d == nil then (if cur_key ~= self.g then self.data[self.g] else cur_d) else cur_d;
        self.ld = true;
        local els = self.els;
        for idx = 1, #els, 1 do 
            local el = els[idx];
            local v_saved = cur_d and cur_d[el.flag];
            el:load(if v_saved == nil then el.def else v_saved);
        end;
        self.ld = false;
        self.dirty = false;
        if self.cb then k(self.cb, self.cur); end;
    end;

    h_prof_cls.select = function(self, val)
        if val == self.cur or not J(self.items, val) then return; end;
        self:store();
        self.cur = val;
        if self.idd.val ~= val then self.idd:set(val, true); end;
        self:apply();
    end;

    h_prof_cls.spread = function(self, el_item)
        local f_name = el_item.flag;
        for k_p, data_t in next, self.data, nil do 
            if k_p ~= self.g then data_t[f_name] = el_item:ser(); end;
        end;
    end;

    h_prof_cls.get = function(self, f_name, p_name)
        local cur_k = tostring(self.cur);
        p_name = if p_name ~= nil then tostring(p_name) else cur_k;
        p_name = if cur_k == self.g then self.g else (if J(self.items, p_name) then p_name else self.g);
        if p_name == cur_k then return iQ.flags[f_name]; end;
        local data_t = self.data[p_name];
        if data_t == nil and p_name ~= self.g then return self:get(f_name, self.g); end;
        local el_obj, val_s = iQ.fl[f_name], data_t and data_t[f_name];
        val_s = if val_s == nil then (el_obj and el_obj.def) else val_s;
        return if el_obj then el_obj:unser(val_s) else val_s;
    end;

    h_prof_cls.ser = function(self)
        self:store();
        return {cur = self.cur, data = self.data};
    end;

    h_prof_cls.load = function(self, data_in)
        if type(data_in) ~= "table" then return; end;
        self.data = type(data_in.data) == "table" and data_in.data or {};
        if data_in.cur ~= nil and J(self.items, data_in.cur) then 
            self.cur = data_in.cur;
            self.idd:set(data_in.cur, true);
        end;
        self:apply();
    end;

    local h_win_cls = {};
    h_win_cls.__index = h_win_cls;
    h_win_cls.group = function(self) return self; end;

    h_win_cls.barhl = function(self, anim)
        local cur_t = self.cur;
        if not cur_t then return; end;
        local nb_b = cur_t.nb;
        if nb_b.AbsoluteSize.X <= 0 then return; end;
        local sc = nQ();
        local rel_p, rel_s = (nb_b.AbsolutePosition - self.bls.AbsolutePosition) / sc, nb_b.AbsoluteSize / sc;
        local p_udim, s_udim = l(rel_p.X, rel_p.Y), l(rel_s.X, rel_s.Y);
        if anim then 
            w(self.bhl, {Position = p_udim, Size = s_udim}, 0.24);
        else 
            self.bhl.Position, self.bhl.Size = p_udim, s_udim;
        end;
    end;

    h_win_cls.tab = function(self, y_opt)
        y_opt = (if type(y_opt) == "string" then {name = y_opt} else y_opt) or {};
        self.nn = self.nn + 1;
        local tab_inst = setmetatable({win = self, o = y_opt, name = y_opt.name or "Tab", pages = {}, tn = 0}, u_tab_cls);
        local nav_btn = QQ("TextButton", {Size = l(0, 26), AutomaticSize = p, LayoutOrder = self.nn, ZIndex = 4, Parent = self.bls});
        eQ(nav_btn, 10, 12, 0, 0);
        IQ_lay(nav_btn, 6);
        tab_inst.ni = QQ("ImageLabel", {Size = l(13, 13), Image = XQ(y_opt.icon or "misc"), LayoutOrder = 1, ZIndex = 4, Parent = nav_btn}, {ImageColor3 = "dim"});
        tab_inst.nl = QQ("TextLabel", {Size = l(0, 26), AutomaticSize = p, Text = tab_inst.name, TextSize = 13, LayoutOrder = 2, ZIndex = 4, Parent = nav_btn}, {TextColor3 = "dim"});
        tab_inst.nb = nav_btn;
        tab_inst.frame = QQ("Frame", {Size = g(1, 1), Visible = false, Parent = self.body});
        tab_inst.tl = QQ("Frame", {Size = l(0, 40), AutomaticSize = p, Visible = false, LayoutOrder = 10 + self.nn, Parent = self.tl});
        IQ_lay(tab_inst.tl, 8);
        tab_inst.tr = QQ("Frame", {Size = l(0, 40), AutomaticSize = p, Visible = false, Parent = self.tr});
        IQ_lay(tab_inst.tr, 16, H.Right);
        Ri(nav_btn, nil, function() tab_inst.hov = true; tab_inst:navdraw(); end, function() tab_inst.hov = false; tab_inst:navdraw(); end);
        GQ(nav_btn.MouseButton1Click, function() self:select(tab_inst); end);
        GQ(nav_btn:GetPropertyChangedSignal("AbsoluteSize"), function()
            if self.cur == tab_inst then self:barhl(true); end;
        end);
        local tabs_arr = self.tabs;
        tabs_arr[#tabs_arr + 1] = tab_inst;
        if self.cur then 
            tab_inst:navdraw();
        else 
            self:select(tab_inst);
        end;
        return tab_inst;
    end;

    h_win_cls.select = function(self, target_tab)
        local cur_t = self.cur;
        if cur_t == target_tab then return; end;
        _pop_close_all();
        self.cur = target_tab;
        if cur_t then 
            fi_anim(cur_t.frame, false, 0.12);
            cur_t.tl.Visible = false;
            cur_t.tr.Visible = false;
            cur_t:navdraw();
        end;
        fi_anim(target_tab.tl, true, 0.2);
        fi_anim(target_tab.tr, true, 0.2);
        fi_anim(target_tab.frame, true, 0.2, cur_t and 0.07 or nil);
        target_tab:navdraw();
        self:barhl(cur_t ~= nil);
        d(function()
            if self.cur == target_tab then self:barhl(cur_t ~= nil); end;
        end);
    end;

    h_win_cls.toggle = function(self, state_b)
        iQ:toggle(state_b);
        return self;
    end;

    local function m_cfgl_dummy() end;
    local y_cfg_dir, D_cfg_chk;
    do 
        y_cfg_dir = function() return iQ.dir .. "/configs"; end;
        local function _Q_cfg_path(name) return y_cfg_dir() .. "/" .. name .. ".json"; end;
        local function NQ_clean_name(name)
            return L(S(Q(tostring(name or ""), "[\\/:%*%?\"<>|]", ""), "^%s*(.-)%s*$") or "", 1, 40);
        end;
        local function L_cur_time() return os.date("%Y-%m-%d %H:%M"); end;

        local function Q_pos_to_arr(obj)
            if not obj then return nil; end;
            local pos = gi(obj);
            return {pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset};
        end;
        local function uQ_arr_to_pos(arr)
            if type(arr) == "table" and #arr == 4 then 
                return f(tonumber(arr[1]) or 0, tonumber(arr[2]) or 0, tonumber(arr[3]) or 0, tonumber(arr[4]) or 0);
            end;
            return nil;
        end;

        local function xQ_get_ui_cfg()
            local hold_f = kQ.hold;
            return {
                kbp = t_kb and Q_pos_to_arr(t_kb.g),
                wmp = n_wm and Q_pos_to_arr(n_wm.g),
                spp = c_spec and Q_pos_to_arr(c_spec.g),
                mob = Q_pos_to_arr(kQ.mob),
                size = hold_f and {hold_f.Size.X.Offset, hold_f.Size.Y.Offset} or nil
            };
        end;

        local function Q_apply_ui_cfg(cfg_ui)
            if type(cfg_ui) ~= "table" then return; end;
            local p_kb = uQ_arr_to_pos(cfg_ui.kbp);
            if p_kb and t_kb and t_kb.g then ui(t_kb.g, p_kb); end;
            local p_wm = uQ_arr_to_pos(cfg_ui.wmp);
            if p_wm and n_wm and n_wm.g then ui(n_wm.g, p_wm); end;
            local p_sp = uQ_arr_to_pos(cfg_ui.spp);
            if p_sp and c_spec and c_spec.g then ui(c_spec.g, p_sp); end;
            local p_mb = uQ_arr_to_pos(cfg_ui.mob);
            if p_mb and kQ.mob then ui(kQ.mob, p_mb); end;
            local sz_arr, hold_f = cfg_ui.size, kQ.hold;
            if hold_f and type(sz_arr) == "table" and tonumber(sz_arr[1]) and tonumber(sz_arr[2]) then 
                hold_f.Size = l(T(680, P(tonumber(sz_arr[1]))), T(400, P(tonumber(sz_arr[2]))));
            end;
            WQ();
        end;

        local function uQ_pack_cfg()
            local packed = {flags = {}, binds = {}, inds = {}, profs = {}, ui = xQ_get_ui_cfg()};
            local profs_arr = iQ.profs;
            for idx = 1, #profs_arr, 1 do 
                local pr = profs_arr[idx];
                packed.profs[pr.id] = pr:ser();
            end;
            local els_arr = iQ.els;
            for idx = 1, #els_arr, 1 do 
                local el = els_arr[idx];
                local flag_n = el.flag;
                if flag_n and el.o.nocfg then 
                    packed.flags[flag_n] = el:ser();
                elseif flag_n then 
                    if not el.prof then packed.flags[flag_n] = el:ser(); end;
                    local bnd = el.bnd;
                    if bnd and (bnd.key or (el.kind == "sld" and bnd.v ~= el.val)) then 
                        packed.binds[flag_n] = {k = bnd.key, m = bnd.mode, v = bnd.v};
                    end;
                    local ind = el.ind;
                    if ind and (ind.on or ind.name ~= "") then 
                        packed.inds[flag_n] = {on = ind.on, n = ind.name};
                    end;
                end;
            end;
            return packed;
        end;

        local function xQ_unpack_cfg(data_in)
            if type(data_in) ~= "table" then return false; end;
            local flags_d = type(data_in.flags) == "table" and data_in.flags or {};
            local binds_d = type(data_in.binds) == "table" and data_in.binds or {};
            local inds_d = type(data_in.inds) == "table" and data_in.inds or {};
            local profs_d = type(data_in.profs) == "table" and data_in.profs or {};
            local els_arr = iQ.els;
            for idx = 1, #els_arr, 1 do 
                local el = els_arr[idx];
                local f_name = el.flag;
                if f_name and el.o.nocfg then 
                    local v_saved = flags_d[f_name];
                    if v_saved ~= nil then el:load(v_saved); end;
                elseif f_name then 
                    if not el.prof then 
                        local v_saved = flags_d[f_name];
                        el:load(if v_saved == nil then el.def else v_saved);
                    end;
                    local bnd = el.bnd;
                    if bnd then 
                        local b_cfg = binds_d[f_name];
                        local k_want, m_want;
                        if type(b_cfg) == "table" then 
                            k_want = type(b_cfg.k) == "string" and b_cfg.k or nil;
                            m_want = (b_cfg.m == "hold" or b_cfg.m == "toggle") and b_cfg.m or nil;
                            if el.kind == "sld" and type(b_cfg.v) == "number" then 
                                bnd.v = el:rnd(b_cfg.v);
                            end;
                        elseif el.kind == "sld" then 
                            bnd.v = el.val;
                        end;
                        if bnd.key ~= k_want or (m_want and bnd.mode ~= m_want) then 
                            el:setbind(k_want, m_want);
                        end;
                    end;
                    local ind = el.ind;
                    if ind then 
                        local ind_cfg = inds_d[f_name];
                        if type(ind_cfg) == "table" then 
                            ind.on = ind_cfg.on == true;
                            ind.name = type(ind_cfg.n) == "string" and ind_cfg.n or "";
                        else 
                            ind.on = el.o.ind ~= nil and el.o.ind ~= false;
                            ind.name = type(el.o.ind) == "string" and el.o.ind or "";
                        end;
                    end;
                end;
            end;
            local profs_arr = iQ.profs;
            for idx = 1, #profs_arr, 1 do 
                local pr = profs_arr[idx];
                local pr_data = profs_d[pr.id];
                if type(pr_data) == "table" then 
                    pr:load(pr_data);
                else 
                    pr.data = {};
                    pr:apply();
                end;
            end;
            Q_apply_ui_cfg(data_in.ui);
            pQ();
            return true;
        end;

        local function Q_write_cfg_file(cfg_name, cfg_data)
            local json_str = aQ({meta = {name = cfg_name, modified = L_cur_time(), ver = iQ.ver}, data = cfg_data});
            return json_str ~= nil and cQ.write(_Q_cfg_path(cfg_name), json_str);
        end;

        local function jQ_set_last(cfg_name)
            kQ.cfg = cfg_name;
            cQ.write(iQ.dir .. "/last.txt", cfg_name or "");
        end;

        local function YQ_parse_cfg_str(raw_str)
            if type(raw_str) ~= "string" or raw_str == "" then return nil; end;
            local parsed = mQ(raw_str);
            if not parsed then 
                local ok_b64, dec_str = pcall(rQ, raw_str);
                parsed = if ok_b64 then mQ(dec_str) else parsed;
            end;
            if parsed and type(parsed.data) == "table" then return parsed.data; end;
            return parsed;
        end;

        local rQ_share = {
            seen = {}, busy = {}, get = false,
            pack = function(raw_v)
                local data_obj = YQ_parse_cfg_str(raw_v);
                if type(data_obj) ~= "table" or type(data_obj.flags) ~= "table" then return nil; end;
                local clean_flags = {};
                for k_f, v_f in next, data_obj.flags, nil do 
                    local el = iQ.fl[k_f];
                    if not el or not el.o.nocfg then clean_flags[k_f] = v_f; end;
                end;
                return aQ({data = {flags = clean_flags, binds = data_obj.binds, inds = data_obj.inds, profs = data_obj.profs}});
            end,
            fail = function(code_num, str_cd)
                if code_num == 404 then return "Share code {" .. tostring(str_cd) .. "} not found";
                elseif code_num == 429 then return "Too many share requests, wait a minute";
                elseif code_num == 413 then return "Config is too big to share";
                elseif code_num == 400 then return "Config can not be shared"; end;
                return "Share server is not responding";
            end,
            names = function()
                local names_list = {};
                local files_arr = cQ.list(y_cfg_dir());
                for idx = 1, #files_arr, 1 do 
                    local f_n = S(files_arr[idx], "([^/\\]+)%.json$");
                    if f_n then names_list[#names_list + 1] = f_n; end;
                end;
                I(names_list);
                return M(names_list, "\0");
            end
        };

        iQ.export = function(self)
            return aQ({meta = {name = kQ.cfg or "shared", modified = L_cur_time(), ver = iQ.ver}, data = uQ_pack_cfg()});
        end;

        iQ.share = function(self)
            local exp = self:export();
            return exp and qQ(exp) or nil;
        end;

        iQ.import = function(self, raw_data)
            local parsed = YQ_parse_cfg_str(raw_data);
            if not parsed then return false; end;
            return xQ_unpack_cfg(parsed);
        end;

        iQ.save = function(self, cfg_n)
            cfg_n = NQ_clean_name(cfg_n or kQ.cfg or "default");
            cfg_n = if cfg_n == "" then "default" else cfg_n;
            if Q_write_cfg_file(cfg_n, uQ_pack_cfg()) then 
                jQ_set_last(cfg_n);
                self:notify("Saved config {" .. cfg_n .. "}", "ok");
                m_cfgl_dummy();
                return true;
            end;
            return false;
        end;

        iQ.load = function(self, cfg_n)
            cfg_n = NQ_clean_name(cfg_n);
            local parsed = YQ_parse_cfg_str(cQ.read(_Q_cfg_path(cfg_n)));
            if not parsed then 
                self:notify("Config {" .. cfg_n .. "} is broken", "bad");
                return false;
            end;
            xQ_unpack_cfg(parsed);
            jQ_set_last(cfg_n);
            self:notify("Loaded config {" .. cfg_n .. "}", "ok");
            m_cfgl_dummy();
            return true;
        end;

        iQ.create = function(self, cfg_n, share_cd)
            cfg_n = NQ_clean_name(cfg_n);
            if cfg_n == "" then self:notify("Enter a config name", "warn"); return false; end;
            if cQ.has(_Q_cfg_path(cfg_n)) then self:notify("Config {" .. cfg_n .. "} already exists", "warn"); return false; end;
            share_cd = S(tostring(share_cd or ""), "^%s*(.-)%s*$") or "";
            if share_cd ~= "" then 
                if rQ_share.get then return false; end;
                local sh_srv = kQ.share;
                local parsed_imp;
                if sh_srv and #share_cd <= 32 then 
                    rQ_share.get = true;
                    local ok_get, res_data, st_code = pcall(sh_srv.get, share_cd);
                    rQ_share.get = false;
                    if kQ.dead then return false; end;
                    parsed_imp = ok_get and YQ_parse_cfg_str(res_data) or nil;
                    if not parsed_imp then 
                        self:notify(rQ_share.fail(ok_get and st_code, share_cd), "bad");
                        return false;
                    end;
                else 
                    parsed_imp = YQ_parse_cfg_str(share_cd);
                end;
                if not parsed_imp then self:notify("Share code is invalid", "bad"); return false; end;
                if cQ.has(_Q_cfg_path(cfg_n)) then self:notify("Config {" .. cfg_n .. "} already exists", "warn"); return false; end;
                xQ_unpack_cfg(parsed_imp);
            end;
            Q_write_cfg_file(cfg_n, uQ_pack_cfg());
            jQ_set_last(cfg_n);
            self:notify("Created config {" .. cfg_n .. "}", "ok");
            m_cfgl_dummy();
            return true;
        end;

        iQ.sharecode = function(self, cfg_n)
            cfg_n = NQ_clean_name(cfg_n);
            local file_data = cQ.read(_Q_cfg_path(cfg_n));
            if not file_data then return nil; end;
            local sh_srv = kQ.share;
            if not sh_srv then 
                setclipboard(qQ(file_data));
                self:notify("Share code for {" .. cfg_n .. "} copied");
                return true;
            end;
            local seen_item = rQ_share.seen[cfg_n];
            if seen_item and seen_item.raw == file_data then 
                setclipboard(seen_item.code);
                self:notify("Share code {" .. seen_item.code .. "} for {" .. cfg_n .. "} copied", "ok");
                return seen_item.code;
            end;
            if rQ_share.busy[cfg_n] then return nil; end;
            local packed_str = rQ_share.pack(file_data);
            if not packed_str then self:notify("Config {" .. cfg_n .. "} is broken", "bad"); return nil; end;
            rQ_share.busy[cfg_n] = true;
            local ok_put, ret_code, ret_st = pcall(sh_srv.put, packed_str);
            rQ_share.busy[cfg_n] = nil;
            if kQ.dead then return nil; end;
            if not ok_put or type(ret_code) ~= "string" or ret_code == "" then 
                self:notify(rQ_share.fail(ok_put and ret_st), "bad");
                return nil;
            end;
            rQ_share.seen[cfg_n] = {raw = file_data, code = ret_code};
            setclipboard(ret_code);
            self:notify("Share code {" .. ret_code .. "} for {" .. cfg_n .. "} copied", "ok");
            return ret_code;
        end;

        iQ.delete = function(self, cfg_n)
            cfg_n = NQ_clean_name(cfg_n);
            cQ.del(_Q_cfg_path(cfg_n));
            if kQ.cfg == cfg_n then jQ_set_last(nil); end;
            self:notify("Deleted config {" .. cfg_n .. "}");
            m_cfgl_dummy();
        end;

        iQ.rename = function(self, old_n, new_n)
            old_n, new_n = NQ_clean_name(old_n), NQ_clean_name(new_n);
            if new_n == "" or old_n == new_n or cQ.has(_Q_cfg_path(new_n)) then return false; end;
            local parsed = mQ(cQ.read(_Q_cfg_path(old_n)));
            if not parsed then return false; end;
            if type(parsed.meta) == "table" then parsed.meta.name = new_n; end;
            local json_res = aQ(parsed);
            if not json_res or not cQ.write(_Q_cfg_path(new_n), json_res) then return false; end;
            cQ.del(_Q_cfg_path(old_n));
            if kQ.cfg == old_n then jQ_set_last(new_n); end;
            self:notify("Renamed {" .. old_n .. "} to {" .. new_n .. "}");
            m_cfgl_dummy();
            return true;
        end;

        iQ.list = function(self)
            local res_list = {};
            local files = cQ.list(y_cfg_dir());
            for idx = 1, #files, 1 do 
                local path_str = files[idx];
                local name_s = S(path_str, "([^/\\]+)%.json$");
                if name_s then 
                    local parsed = mQ(cQ.read(path_str));
                    local meta_t = parsed and parsed.meta;
                    res_list[#res_list + 1] = {
                        name = name_s,
                        modified = type(meta_t) == "table" and tostring(meta_t.modified or "") or ""
                    };
                end;
            end;
            I(res_list, function(a_i, b_i) return X(a_i.name) < X(b_i.name); end);
            return res_list;
        end;

        iQ.current = function(self) return kQ.cfg; end;
        iQ.get = function(self, flag_n) return self.flags[flag_n]; end;
        iQ.set = function(self, flag_n, val_a, val_b)
            local el = self.fl[flag_n];
            if not el then return nil; end;
            if el.kind == "cpk" then el:set(val_a, val_b); else el:set(val_a); end;
            return el;
        end;
        iQ.el = function(self, flag_n) return self.fl[flag_n]; end;
        iQ.onunload = function(self, fn_cb) kQ.unl[#kQ.unl + 1] = fn_cb; end;

        local function L_build_cfg_btn(par_f, ico_n, lo_idx, pop_c, col_k)
            local btn = QQ("ImageButton", {Size = l(22, 22), BackgroundColor3 = sQ, BackgroundTransparency = 1, LayoutOrder = lo_idx, ZIndex = 3, Parent = par_f});
            SQ(btn, 5);
            local ico = QQ("ImageLabel", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(13, 13), Image = XQ(ico_n), ZIndex = 3, Parent = btn}, {ImageColor3 = col_k or "dim"});
            Ri(btn, pop_c, function()
                w(btn, {BackgroundTransparency = ZQ.ctl}, 0.1);
                w(ico, {ImageColor3 = tQ.txt}, 0.1);
            end, function()
                w(btn, {BackgroundTransparency = 1}, 0.1);
                w(ico, {ImageColor3 = tQ[col_k or "dim"]}, 0.1);
            end);
            return btn, ico;
        end;

        local function X_build_cfg_row(par_blk, it_data)
            local cfg_n = it_data.name;
            local is_cur = kQ.cfg == cfg_n;
            local row_f = par_blk:add(30);
            local name_lbl = QQ("TextLabel", {Position = l(12, 0), Size = f(1, -230, 1, 0), Text = cfg_n, FontFace = is_cur and LQ.b or LQ.s, TextSize = 13, TextTruncate = UQ, ZIndex = 2, Parent = row_f}, {TextColor3 = is_cur and "acc" or "txt"});
            QQ("TextLabel", {AnchorPoint = s(1, 0), Position = f(1, -108, 0, 0), Size = l(110, 30), Text = it_data.modified ~= "" and it_data.modified or "never saved", TextSize = 11, TextXAlignment = b.Right, ZIndex = 2, Parent = row_f}, {TextColor3 = "dim"});
            local act_bar = QQ("Frame", {AnchorPoint = s(1, 0.5), Position = f(1, -6, 0.5, 0), Size = l(0, 22), AutomaticSize = p, ZIndex = 3, Parent = row_f});
            IQ_lay(act_bar, 2, H.Right);
            local b_load = L_build_cfg_btn(act_bar, is_cur and "save" or "load", 1);
            local b_share = L_build_cfg_btn(act_bar, "copy", 2);
            local b_ren = L_build_cfg_btn(act_bar, "pencil", 3);
            local b_del, del_ico = L_build_cfg_btn(act_bar, "trash", 4);
            GQ(b_load.MouseButton1Click, function()
                if is_cur then iQ:save(cfg_n); else iQ:load(cfg_n); end;
            end);
            GQ(b_share.MouseButton1Click, function() k(iQ.sharecode, iQ, cfg_n); end);
            local confirm_del = false;
            GQ(b_del.MouseButton1Click, function()
                if confirm_del then iQ:delete(cfg_n); return; end;
                confirm_del = true;
                w(del_ico, {ImageColor3 = tQ.bad}, 0.12);
                iQ:notify("Click again to delete {" .. cfg_n .. "}", "warn", 2.5);
                B(2.5, function()
                    if del_ico.Parent then confirm_del = false; w(del_ico, {ImageColor3 = tQ.dim}, 0.12); end;
                end);
            end);
            GQ(b_ren.MouseButton1Click, function()
                name_lbl.Visible = false;
                local tb_ren = QQ("TextBox", {Position = l(8, 4), Size = f(1, -226, 0, 22), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, Text = cfg_n, TextSize = 13, ZIndex = 4, Parent = row_f});
                SQ(tb_ren, 5);
                JQ(tb_ren, 0.5, tQ.acc);
                eQ(tb_ren, 4, 4, 0, 0);
                GQ(tb_ren.FocusLost, function(enter_p)
                    local new_str = NQ_clean_name(tb_ren.Text);
                    tb_ren:Destroy();
                    name_lbl.Visible = true;
                    if enter_p and new_str ~= "" and new_str ~= cfg_n then 
                        iQ:rename(cfg_n, new_str);
                    end;
                end);
                tb_ren:CaptureFocus();
            end);
            return row_f;
        end;

        local function L_poll_cfgs()
            if not kQ.dead and rQ_share.names() ~= rQ_share.sig then 
                m_cfgl_dummy();
            end;
        end;

        m_cfgl_dummy = function()
            if kQ.dead then return; end;
            rQ_share.sig = rQ_share.names();
            local list_data = iQ:list();
            if kQ.cfgl then kQ.cfgl(list_data); end;
            local cdd = kQ.cdd;
            if cdd then 
                local names_t = table.create(#list_data);
                for idx = 1, #list_data, 1 do names_t[idx] = list_data[idx].name; end;
                cdd.values = names_t;
                cdd.val = kQ.cfg and J(names_t, kQ.cfg) and kQ.cfg or nil;
                cdd:draw();
            end;
        end;

        N_page_cls.configs = function(self, S_opt)
            S_opt = S_opt or {};
            local blk_cont = self:section({name = "Configs"}):blk();
            function kQ.cfgl(list_in)
                blk_cont:clear();
                if #list_in == 0 then 
                    local r_empty = blk_cont:add(30, true);
                    QQ("TextLabel", {Position = l(12, 0), Size = f(1, -24, 1, 0), Text = "No configs yet. Create one on the right.", TextSize = 13, TextTruncate = UQ, Parent = r_empty}, {TextColor3 = "dim"});
                    return;
                end;
                for idx = 1, #list_in, 1 do X_build_cfg_row(blk_cont, list_in[idx]); end;
            end;
            local sec_create = self:section({name = "Create", side = 2});
            sec_create.tmp = true;
            local inp_name = sec_create:input({placeholder = "Config name", nosearch = true});
            local inp_code = sec_create:input({placeholder = "Share code (optional)", nosearch = true});
            sec_create:button({name = "Create config", icon = "plus", style = "primary", cb = function()
                if iQ:create(inp_name.val, inp_code.val) then 
                    inp_name:set("", true);
                    inp_code:set("", true);
                end;
            end});
            m_cfgl_dummy();
            if S_opt.autoload ~= false then 
                d(function()
                    local last_n = cQ.read(iQ.dir .. "/last.txt");
                    if last_n and last_n ~= "" and cQ.has(_Q_cfg_path(last_n)) and not kQ.dead then 
                        iQ:load(last_n);
                    end;
                end);
            end;
            return self;
        end;

        u_tab_cls.configs = function(self, Q_opt)
            self:page("Configs"):configs(Q_opt);
            return self;
        end;

        local prop_names = {"BackgroundColor3", "TextColor3", "ImageColor3", "Color", "PlaceholderColor3", "ScrollBarImageColor3"};
        local attr_names = {};
        for idx = 1, #prop_names, 1 do attr_names[idx] = "t_" .. prop_names[idx]; end;

        local function S_redraw_all()
            local els = iQ.els;
            for idx = 1, #els, 1 do els[idx]:draw(); end;
            local win_inst = kQ.win;
            if win_inst then 
                for idx = 1, #win_inst.tabs, 1 do win_inst.tabs[idx]:navdraw(); end;
            end;
            pQ();
            m_cfgl_dummy();
        end;

        iQ.settheme = function(self, col_key, col_val)
            if tQ[col_key] == nil or typeof(col_val) ~= "Color3" then return; end;
            tQ[col_key] = col_val;
            local gui_inst = kQ.gui;
            if gui_inst then 
                local descs = gui_inst:GetDescendants();
                for d_i = 1, #descs, 1 do 
                    local obj = descs[d_i];
                    for p_i = 1, #attr_names, 1 do 
                        if obj:GetAttribute(attr_names[p_i]) == col_key then 
                            obj[prop_names[p_i]] = col_val;
                        end;
                    end;
                end;
            end;
            S_redraw_all();
        end;

        D_cfg_chk = L_poll_cfgs;
    end;

local L_mouselock = {key = "polar"};
    L_mouselock.rk = r:GenerateGUID(false);
    local X_mouselock_ctrl;
    do 
        local def_mouse_mode = Enum.MouseBehavior.Default;
        local function S_is_module_loaded(mod_inst)
            local ok_m, loaded_arr = pcall(getloadedmodules);
            return ok_m and type(loaded_arr) == "table" and J(loaded_arr, mod_inst) ~= nil;
        end;

        local function M_resolve_lock_table()
            local cur_t = L_mouselock.t;
            if cur_t == nil then 
                cur_t = false;
                local ctrl_f = G:FindFirstChild("Controllers");
                local cam_mod = ctrl_f and ctrl_f:FindFirstChild("CameraController");
                if cam_mod and cam_mod:IsA("ModuleScript") and S_is_module_loaded(cam_mod) then 
                    local ok_r, mod_res = pcall(require, cam_mod);
                    local fn_lock = ok_r and type(mod_res) == "table" and mod_res.isForceLockOverrideActive;
                    if type(fn_lock) == "function" then 
                        local ok_u, ups_t = pcall(debug.getupvalues, fn_lock);
                        if ok_u and type(ups_t) == "table" then 
                            for _, val in next, ups_t, nil do 
                                if type(val) == "table" then cur_t = val; break; end;
                            end;
                        end;
                    end;
                end;
                L_mouselock.t = cur_t;
            end;
            return cur_t or nil;
        end;

        local function G_set_lock_state(is_locked)
            is_locked = is_locked == true;
            if L_mouselock.on == is_locked then return; end;
            L_mouselock.on = is_locked;
            if kQ.modal then kQ.modal.Visible = is_locked; end;
            local lock_tbl = M_resolve_lock_table();
            if is_locked then 
                if lock_tbl then 
                    lock_tbl[L_mouselock.key] = true;
                else 
                    L_mouselock.mb, L_mouselock.mi = z.MouseBehavior, z.MouseIconEnabled;
                end;
                C:BindToRenderStep(L_mouselock.rk, Enum.RenderPriority.Last.Value, function()
                    if lock_tbl and lock_tbl[L_mouselock.key] == nil then 
                        lock_tbl[L_mouselock.key] = true;
                    end;
                    if z.MouseBehavior ~= def_mouse_mode then z.MouseBehavior = def_mouse_mode; end;
                    if not z.MouseIconEnabled then z.MouseIconEnabled = true; end;
                end);
                return;
            end;
            pcall(C.UnbindFromRenderStep, C, L_mouselock.rk);
            if lock_tbl then 
                lock_tbl[L_mouselock.key] = nil;
            elseif L_mouselock.mb then 
                z.MouseBehavior = L_mouselock.mb;
                z.MouseIconEnabled = L_mouselock.mi;
            end;
            L_mouselock.mb = nil;
            L_mouselock.mi = nil;
        end;
        X_mouselock_ctrl = G_set_lock_state;
    end;

    local G_blur_reg, Q_blur_step, S_blur_clean;
    do 
        local M_blur = {off = {}, rg = {}, dead = {}};
        local function I_blur_dof(enable_b, near_int)
            local dof = M_blur.d;
            if enable_b then 
                if not dof then 
                    dof = Instance.new("DepthOfFieldEffect");
                    dof.Name = r:GenerateGUID(false);
                    dof.FarIntensity = 0;
                    dof.FocusDistance = 0;
                    dof.InFocusRadius = 0.1;
                    dof.NearIntensity = 1;
                    dof.Enabled = false;
                    M_blur.d = dof;
                end;
                if M_blur.ni ~= near_int then 
                    M_blur.ni = near_int;
                    dof.NearIntensity = near_int;
                end;
                if M_blur.on then return; end;
                M_blur.on = true;
                local children = a:GetChildren();
                for idx = 1, #children, 1 do 
                    local eff = children[idx];
                    if eff:IsA("DepthOfFieldEffect") and eff ~= dof and eff.Enabled then 
                        M_blur.off[eff] = true;
                        eff.Enabled = false;
                    end;
                end;
                dof.Parent = a;
                dof.Enabled = true;
            elseif M_blur.on then 
                M_blur.on = false;
                if dof then dof.Enabled = false; end;
                for eff in next, M_blur.off, nil do 
                    if eff.Parent then eff.Enabled = true; end;
                end;
                e(M_blur.off);
            end;
        end;

        local function a_blur_add(gui_obj, val_fn, ix_v, iy_v, lead_b)
            if M_blur.rg[gui_obj] then return; end;
            local part = Instance.new("Part");
            part.Name = r:GenerateGUID(false);
            part.Material = Enum.Material.Glass;
            part.Color = CQ;
            part.Transparency = 1;
            part.Anchored = true;
            part.CanCollide = false;
            part.CanQuery = false;
            part.CanTouch = false;
            part.CastShadow = false;
            part.Size = Vector3.new(1, 1, 0.001);
            local mesh = Instance.new("SpecialMesh");
            mesh.MeshType = Enum.MeshType.Brick;
            mesh.Scale = Vector3.new(0, 0, 0);
            mesh.Parent = part;
            M_blur.rg[gui_obj] = {p = part, m = mesh, f = val_fn, ix = ix_v or 3, iy = iy_v or ix_v or 3, v = false, lead = lead_b == true};
        end;

        local function k_blur_rem(gui_obj)
            local item = M_blur.rg[gui_obj];
            if item then 
                M_blur.rg[gui_obj] = nil;
                item.p:Destroy();
            end;
        end;

        local function b_ray_pt(cam, px, py)
            local ray = cam:ScreenPointToRay(px, py);
            return ray.Origin + ray.Direction * 0.001;
        end;

        local function UQ_blur_render(dt)
            local cam = workspace.CurrentCamera;
            if not cam or kQ.dead then return; end;
            local is_active = kQ.blur and kQ.live;
            local dead_arr = M_blur.dead;
            local any_vis, max_lead_v, last_cam_cf = false;
            for gui_k, reg_v in next, M_blur.rg, nil do 
                local cur_val = 0;
                if gui_k.Parent and is_active and gui_k.Visible then 
                    local ok_f, val_f = pcall(reg_v.f);
                    cur_val = ok_f and tonumber(val_f) or 0;
                else 
                    dead_arr[#dead_arr + 1] = gui_k;
                end;
                max_lead_v = if reg_v.lead then T(max_lead_v or 0, cur_val) else max_lead_v;
                local show_part = false;
                if cur_val > (reg_v.lead and 0.01 or 0.45) then 
                    local pos_px, sz_px = gui_k.AbsolutePosition, gui_k.AbsoluteSize;
                    local x1, y1 = pos_px.X + reg_v.ix, pos_px.Y + reg_v.iy;
                    local x2, y2 = pos_px.X + sz_px.X - reg_v.ix, pos_px.Y + sz_px.Y - reg_v.iy;
                    if x2 - x1 > 2 and y2 - y1 > 2 then 
                        local cf_c = last_cam_cf or cam.CFrame;
                        local p_tl = b_ray_pt(cam, x1, y1);
                        local p_tr = b_ray_pt(cam, x2, y1);
                        local p_br = b_ray_pt(cam, x2, y2);
                        local p_box = reg_v.p;
                        p_box.CFrame = CFrame.fromMatrix((p_tl + p_br) / 2, cf_c.XVector, cf_c.YVector, cf_c.ZVector);
                        reg_v.m.Scale = Vector3.new((p_tr - p_tl).Magnitude, (p_tr - p_br).Magnitude, 0);
                        if p_box.Parent ~= cam then p_box.Parent = cam; end;
                        show_part, any_vis, last_cam_cf = true, true, cf_c;
                    end;
                end;
                if reg_v.v ~= show_part then 
                    reg_v.v = show_part;
                    reg_v.p.Transparency = show_part and 0.98 or 1;
                end;
            end;
            for idx = #dead_arr, 1, -1 do 
                k_blur_rem(dead_arr[idx]);
                dead_arr[idx] = nil;
            end;
            local target_lead = max_lead_v and max_lead_v > 0 and max_lead_v < 0.999 and max_lead_v or 1;
            local cur_c = M_blur.c or 0;
            cur_c = if any_vis then (if target_lead < cur_c then target_lead else Y(target_lead, cur_c + (tonumber(dt) or 0.016666666666666666) * 4)) else 0;
            M_blur.c = cur_c;
            I_blur_dof(any_vis, P(cur_c^2.5 * 500 + 0.5) / 500);
        end;

        local function k_blur_destroy()
            for _, reg_v in next, M_blur.rg, nil do reg_v.p:Destroy(); end;
            e(M_blur.rg);
            I_blur_dof(false);
            if M_blur.d then M_blur.d:Destroy(); M_blur.d = nil; end;
            M_blur.ni = nil;
            M_blur.c = nil;
        end;

        G_blur_reg, Q_blur_step, S_blur_clean = a_blur_add, UQ_blur_render, k_blur_destroy;
    end;

    local a_tw_in = TweenInfo.new(0.2, gQ, Enum.EasingDirection.Out);
    local M_tw_out = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
    local function I_fade_win(open_b)
        local hold_f = kQ.hold;
        local cv_f = kQ.cv;
        kQ.fn = kQ.fn + 1;
        local cur_fn = kQ.fn;
        if kQ.ft then 
            kQ.ft:Cancel();
            kQ.ft = nil;
        end;
        if hold_f.Parent ~= cv_f then 
            cv_f.GroupTransparency = open_b and 1 or 0;
            hold_f.Parent = cv_f;
        end;
        hold_f.Visible = true;
        cv_f.Visible = true;
        cv_f.Interactable = open_b;
        local tw = q:Create(cv_f, open_b and a_tw_in or M_tw_out, {GroupTransparency = open_b and 0 or 1});
        kQ.ft = tw;
        tw.Completed:Once(function(status)
            if kQ.dead or kQ.fn ~= cur_fn or status ~= fQ then return; end;
            kQ.ft = nil;
            hold_f.Visible = open_b;
            hold_f.Parent = kQ.gui;
            cv_f.Visible = false;
        end);
        tw:Play();
    end;

    local function q_scale_calc()
        local us, gui_i = kQ.us, kQ.gui;
        if not us or not gui_i then return; end;
        local flags_d = iQ.flags;
        local scale_res;
        if flags_d.ps_fscale and type(flags_d.ps_scale) == "number" then 
            scale_res = flags_d.ps_scale;
        else 
            local g_sz = gui_i.AbsoluteSize;
            g_sz = if g_sz.Y <= 0 then workspace.CurrentCamera.ViewportSize else g_sz;
            local hold_sz = kQ.hold.Size;
            scale_res = E(Y((g_sz.Y - 40) / hold_sz.Y.Offset, (g_sz.X - 40) / hold_sz.X.Offset), 0.45, 1);
        end;
        if kQ.sc == scale_res and kQ.skd then return; end;
        kQ.sc = scale_res;
        kQ.skd = true;
        us.Scale = scale_res;
        yQ(scale_res, kQ.hold);
        d(function()
            local pops = kQ.pops;
            for idx = 1, #pops, 1 do pops[idx]:clampit(); end;
        end);
    end;

    iQ.toggle = function(self, state_b)
        if kQ.dead or not kQ.root then return; end;
        state_b = if state_b == nil then not kQ.open else state_b;
        if state_b == kQ.open then return; end;
        kQ.open = state_b;
        t_kb.hh.Visible = state_b;
        n_wm.hh.Visible = state_b;
        if c_spec.hh then c_spec.hh.Visible = state_b; end;
        if not state_b then 
            _pop_close_all(true);
            wQ();
            local ls = kQ.listen;
            if ls then 
                kQ.listen = nil;
                ls.lst = false;
                ls:draw();
            end;
            local foc_box = z:GetFocusedTextBox();
            if foc_box and foc_box:IsDescendantOf(kQ.gui) then 
                foc_box:ReleaseFocus();
            end;
        end;
        X_mouselock_ctrl(state_b);
        I_fade_win(state_b);
        Ki();
        pQ();
        if state_b then D_cfg_chk(); end;
        R_spec_cb();
        if state_b then 
            d(function()
                if kQ.win and kQ.open then kQ.win:barhl(false); end;
            end);
        end;
    end;

    local function a_read_prefs()
        kQ.prefs = mQ(cQ.read(iQ.dir .. "/prefs.json")) or {};
    end;

    WQ = function()
        if kQ.pst then return; end;
        kQ.pst = true;
        B(0.5, function()
            kQ.pst = false;
            if kQ.dead then return; end;
            local flags_d = iQ.flags;
            local function I_to_arr(obj)
                if not obj then return nil; end;
                local p_v = gi(obj);
                return {p_v.X.Scale, p_v.X.Offset, p_v.Y.Scale, p_v.Y.Offset};
            end;
            cQ.write(iQ.dir .. "/prefs.json", aQ({
                key = flags_d.ps_key,
                acc = typeof(flags_d.ps_acc) == "Color3" and PQ(flags_d.ps_acc) or nil,
                blur = flags_d.ps_blur, op = flags_d.ps_op,
                fscale = flags_d.ps_fscale, scale = flags_d.ps_scale,
                wm = flags_d.ps_wm, wms = flags_d.ps_wms,
                kb = flags_d.ps_kb, spec = flags_d.ps_spec, logs = flags_d.ps_logs,
                size = kQ.hold and {kQ.hold.Size.X.Offset, kQ.hold.Size.Y.Offset},
                mob = I_to_arr(kQ.mob), kbp = I_to_arr(t_kb.g),
                wmp = I_to_arr(n_wm.g), spp = I_to_arr(c_spec.g)
            }) or "{}");
        end);
    end;

    local function M_parse_arr_pos(arr)
        if type(arr) == "table" and #arr == 4 then 
            return f(tonumber(arr[1]) or 0, tonumber(arr[2]) or 0, tonumber(arr[3]) or 0, tonumber(arr[4]) or 0);
        end;
        return nil;
    end;

    local function I_recalc_trans()
        local root = kQ.root;
        if root then root.BackgroundTransparency = kQ.bgt; end;
        for obj, off in next, kQ.hbg, nil do 
            if obj.Parent then 
                obj.BackgroundTransparency = Y(kQ.bgt + (tonumber(off) or 0), 0.9);
            else 
                kQ.hbg[obj] = nil;
            end;
        end;
    end;

    N_page_cls.settings = function(self)
        local prefs = kQ.prefs or {};
        xi_bind_rem(kQ.mk, kQ.mkey);
        local sec_menu = self:section({name = "Menu"});
        sec_menu:keybind({
            name = "Menu key", flag = "ps_key", nocfg = true, nonone = true, nomouse = true,
            default = kQ.mkey, onpress = function() iQ:toggle(); end,
            cb = function(new_k) kQ.mkey = new_k; WQ(); end
        });
        sec_menu:colorpicker({
            name = "Accent color", flag = "ps_acc", nocfg = true, default = tQ.acc,
            cb = function(col) iQ:settheme("acc", col); WQ(); end
        });
        sec_menu:toggle({
            name = "Background blur", flag = "ps_blur", nocfg = true, default = kQ.blur,
            cb = function(is_b) kQ.blur = is_b; WQ(); end
        });
        sec_menu:slider({
            name = "Background opacity", flag = "ps_op", nocfg = true, min = 50, max = 100,
            suffix = "%", default = P((1 - kQ.bgt) * 100 + 0.5),
            cb = function(val) kQ.bgt = 1 - val / 100; I_recalc_trans(); WQ(); end
        });
        local tgl_scale = sec_menu:toggle({
            name = "Custom scale", flag = "ps_fscale", nocfg = true, default = prefs.fscale == true,
            cb = function() q_scale_calc(); WQ(); end
        });
        tgl_scale:slider({
            flag = "ps_scale", nocfg = true, release = true, min = 0.5, max = 1.5,
            dec = 2, suffix = "x", sw = 64, default = tonumber(prefs.scale) or 1,
            cb = function() q_scale_calc(); WQ(); end
        }):dep(tgl_scale);

        local sec_ov = self:section({name = "Overlay", side = 2});
        sec_ov:toggle({
            name = "Watermark", flag = "ps_wm", nocfg = true, default = n_wm.on,
            cb = function(is_on) n_wm.on = is_on; zi(n_wm.g, is_on); WQ(); end
        }):dropdown({
            flag = "ps_wms", nocfg = true, multi = true, values = F_wm_items, default = n_wm.show, w = 112,
            cb = function(arr) n_wm.show = arr; j_wm_rebuild(); WQ(); end
        });
        sec_ov:toggle({
            name = "Keybind list", flag = "ps_kb", nocfg = true, default = t_kb.on,
            cb = function(is_on) t_kb.on = is_on; pQ(); WQ(); end
        });
        if c_spec.use then 
            sec_ov:toggle({
                name = "Spectator list", flag = "ps_spec", nocfg = true, default = c_spec.on,
                cb = function(is_on) c_spec.on = is_on; R_spec_cb(); WQ(); end
            });
        end;
        sec_ov:toggle({
            name = "Event logs", flag = "ps_logs", nocfg = true, default = Z_notify.on,
            cb = function(is_on) Z_notify.on = is_on; WQ(); end
        });
        sec_ov:button({
            name = "Reset overlay", icon = "refresh",
            cb = function()
                ui(t_kb.g, kQ.kbd);
                ui(n_wm.g, kQ.wmd);
                if c_spec.g then ui(c_spec.g, kQ.spd); end;
                WQ();
            end
        });
        sec_ov:button({name = "Unload", icon = "power", style = "danger", cb = function() iQ:unload(); end});
        q_scale_calc();
        return self;
    end;

    u_tab_cls.settings = function(self)
        self:page("Settings"):settings();
        return self;
    end;

    local function R_drag_bind(trigger_el, target_el, cond_fn, up_cb)
        GQ(trigger_el.InputBegan, function(inp)
            local it = inp.UserInputType;
            if not bQ(it) or (cond_fn and not cond_fn()) then return; end;
            local init_m = it == hQ and dQ(inp) or BQ();
            local init_p = gi(target_el);
            HQ(function(cur_m)
                local delta = cur_m - init_m;
                ui(target_el, f(init_p.X.Scale, init_p.X.Offset + P(delta.X + 0.5), init_p.Y.Scale, init_p.Y.Offset + P(delta.Y + 0.5)));
            end, up_cb, nil, inp);
        end);
    end;

    local function N_resize_bind(trigger_el, target_el)
        GQ(trigger_el.InputBegan, function(inp)
            local it = inp.UserInputType;
            if not bQ(it) then return; end;
            local init_m = it == hQ and dQ(inp) or BQ();
            local init_sz = target_el.Size;
            HQ(function(cur_m)
                local delta, vp_sz = (cur_m - init_m) / nQ(), workspace.CurrentCamera.ViewportSize / nQ();
                target_el.Size = l(E(init_sz.X.Offset + delta.X, 680, T(680, vp_sz.X - 40)), E(init_sz.Y.Offset + delta.Y, 400, T(400, vp_sz.Y - 40)));
            end, function() WQ(); end, nil, inp);
        end);
    end;

    local function u_mobile_btn(opt_cfg, prefs_t)
        local ast_img = OQ(iQ.dir .. "/assets/astolfo.png", opt_cfg.mobimg or "https://cdn3.emoji.gg/emojis/3859-astolfowink.png", 1000);
        local btn_sz = z.TouchEnabled and 46 or 52;
        local gui_sz = kQ.gui.AbsoluteSize;
        local is_mob = opt_cfg.mobile;
        if is_mob == nil then 
            local ok_pl, pl_val = pcall(z.GetPlatform, z);
            is_mob = if ok_pl and typeof(pl_val) == "EnumItem" and pl_val ~= Enum.Platform.None
                then (pl_val == Enum.Platform.IOS or pl_val == Enum.Platform.Android)
                else (z.TouchEnabled and not z.MouseEnabled);
        end;
        local mb_btn = QQ("ImageButton", {
            Size = l(btn_sz, btn_sz), Position = M_parse_arr_pos(prefs_t.mob) or l(16, P(T(gui_sz.Y, 400) * 0.3)),
            Image = ast_img or XQ("code"), ImageTransparency = 1, ZIndex = 30, Visible = false, Parent = kQ.gui
        });
        local mb_sc, cur_ver = QQ("UIScale", {Parent = mb_btn}), 0;
        function kQ.mobv(show_b)
            cur_ver += 1;
            local snap_v = cur_ver;
            if show_b then 
                mb_btn.Visible = true;
                w(mb_btn, {ImageTransparency = 0}, 0.2, gQ);
            elseif mb_btn.Visible then 
                w(mb_btn, {ImageTransparency = 1}, 0.2, gQ).Completed:Once(function(status)
                    if status == fQ and cur_ver == snap_v then mb_btn.Visible = false; end;
                end);
            end;
        end;

        GQ(mb_btn.InputBegan, function(inp)
            local it = inp.UserInputType;
            if not bQ(it) then return; end;
            local init_m = it == hQ and dQ(inp) or BQ();
            local init_p, is_drag = mb_btn.Position, false;
            w(mb_sc, {Scale = 0.9}, 0.08, gQ);
            HQ(function(cur_m)
                local delta = cur_m - init_m;
                if not is_drag and delta.Magnitude < 6 then return; end;
                is_drag = true;
                local sz = kQ.gui.AbsoluteSize;
                mb_btn.Position = l(E(init_p.X.Offset + delta.X, 0, T(0, sz.X - btn_sz)), E(init_p.Y.Offset + delta.Y, 0, T(0, sz.Y - btn_sz)));
            end, function(was_drag)
                w(mb_sc, {Scale = 1}, 0.16);
                if is_drag then WQ(); elseif was_drag then iQ:toggle(); end;
            end, nil, inp);
        end);
        if is_mob then kQ.mobv(true); end;
        return mb_btn;
    end;

    iQ.window = function(self, opt_w)
        opt_w = opt_w or {};
        local existing = zQ.polar_lib;
        if existing and existing ~= iQ and type(existing.unload) == "function" then 
            pcall(existing.unload, existing);
        end;
        zQ.polar_lib = iQ;
        iQ.dir = opt_w.folder or iQ.dir;
        kQ.brand = opt_w.title or "polar";
        kQ.share = type(opt_w.share) == "table" and type(opt_w.share.put) == "function" and type(opt_w.share.get) == "function" and opt_w.share or nil;
        cQ.dir(iQ.dir);
        cQ.dir(y_cfg_dir());
        cQ.dir(iQ.dir .. "/fonts");
        cQ.dir(iQ.dir .. "/assets");
        if opt_w.font ~= false then oQ(iQ.dir .. "/fonts", opt_w.font); end;
        EQ(iQ.dir .. "/assets");
        a_read_prefs();
        local prefs = kQ.prefs;
        local acc_col = TQ(prefs.acc);
        if acc_col then tQ.acc = acc_col; end;
        kQ.blur = prefs.blur ~= false;
        if tonumber(prefs.op) then kQ.bgt = E(1 - tonumber(prefs.op) / 100, 0, 0.5); end;
        n_wm.on = prefs.wm ~= false;
        if type(prefs.wms) == "table" then 
            local new_wms = {};
            for idx = 1, #prefs.wms, 1 do 
                local it_n = if prefs.wms[idx] == "Name" then "User" else prefs.wms[idx];
                if J(F_wm_items, it_n) and not J(new_wms, it_n) then 
                    new_wms[#new_wms + 1] = it_n;
                end;
            end;
            n_wm.show = new_wms;
        end;
        n_wm.title = opt_w.script or kQ.brand;
        t_kb.on = prefs.kb ~= false;
        c_spec.on = prefs.spec ~= false;
        c_spec.use = opt_w.spectators == true;
        Z_notify.on = prefs.logs ~= false;
        local k_raw = opt_w.key;
        k_raw = if typeof(k_raw) == "EnumItem" then k_raw.Name else k_raw;
        kQ.mkey = type(prefs.key) == "string" and prefs.key or k_raw or "Insert";

        local gui_inst = QQ("ScreenGui", {
            Name = r:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10000, AutoLocalize = false
        });
        kQ.gui = gui_inst;
        qi_pop(gui_inst);
        kQ.probe = QQ("Frame", {Size = l(0, 0), Parent = gui_inst});
        kQ.cv = QQ("CanvasGroup", {Size = g(1, 1), GroupTransparency = 1, Visible = false, ZIndex = 5, Parent = gui_inst});
        local init_sz = type(prefs.size) == "table" and prefs.size or opt_w.size or {780, 470};
        local hold_f = QQ("Frame", {
            Size = l(T(680, P(tonumber(init_sz[1]) or 780)), T(400, P(tonumber(init_sz[2]) or 470))),
            Visible = false, ZIndex = 5, Parent = gui_inst
        });
        kQ.hold = hold_f;
        kQ.sc = 1;
        kQ.us = QQ("UIScale", {Parent = hold_f});
        hi_shd(hold_f, 10, 0);

        local root_f = QQ("Frame", {Size = g(1, 1), BackgroundTransparency = kQ.bgt, ZIndex = 1, Parent = hold_f}, {BackgroundColor3 = "bg"});
        kQ.root = root_f;
        SQ(root_f, 10);
        JQ(root_f, ZQ.edge);
        FQ_hit(root_f);
        G_blur_reg(root_f, function()
            if not hold_f.Visible then return 0; end;
            local cv = kQ.cv;
            if hold_f.Parent == cv then return cv.Visible and 1 - cv.GroupTransparency or 0; end;
            return 1;
        end, 3, 3, true);

        local top_bar = QQ("Frame", {Size = f(1, 0, 0, 40), Parent = root_f});
        local top_clip = QQ("Frame", {Size = g(1, 1), ClipsDescendants = true, ZIndex = 0, Parent = top_bar});
        SQ(QQ("Frame", {Size = f(1, 0, 1, 12), BackgroundColor3 = sQ, BackgroundTransparency = 0.976, ZIndex = 0, Parent = top_clip}), 10);
        local drag_area = QQ("TextButton", {Size = g(1, 1), ZIndex = 0, Parent = top_bar});
        QQ("Frame", {Position = l(0, 40), Size = f(1, 0, 0, 1), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.line, Parent = root_f});
        local tl_box = QQ("Frame", {Position = l(14, 0), Size = l(0, 40), AutomaticSize = p, ZIndex = 2, Parent = top_bar});
        IQ_lay(tl_box, 8);
        if opt_w.logo then 
            local logo_v = opt_w.logo;
            logo_v = if type(logo_v) == "string" and A(logo_v, "^https?://") then OQ(iQ.dir .. "/assets/logo.png", logo_v, 100) else logo_v;
            QQ("ImageLabel", {Size = l(opt_w.logow or 24, 24), Image = XQ(logo_v), LayoutOrder = 1, Parent = tl_box});
        else 
            QQ("TextLabel", {Size = l(0, 40), AutomaticSize = p, Text = kQ.brand, FontFace = LQ.b, TextSize = 15, LayoutOrder = 1, Parent = tl_box});
        end;
        QQ("Frame", {Size = l(4, 1), LayoutOrder = 2, Parent = tl_box});
        local b_save_quick = QQ("ImageButton", {Size = l(24, 24), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.ctl, LayoutOrder = 3, Parent = tl_box});
        SQ(b_save_quick, 6);
        JQ(b_save_quick, ZQ.ctle);
        local ico_sq = QQ("ImageLabel", {AnchorPoint = s(0.5, 0.5), Position = g(0.5, 0.5), Size = l(13, 13), Image = XQ("save"), Parent = b_save_quick}, {ImageColor3 = "dim"});
        Ri(b_save_quick, nil, function()
            w(b_save_quick, {BackgroundTransparency = ZQ.ctlh}, 0.12);
            w(ico_sq, {ImageColor3 = tQ.txt}, 0.12);
        end, function()
            w(b_save_quick, {BackgroundTransparency = ZQ.ctl}, 0.12);
            w(ico_sq, {ImageColor3 = tQ.dim}, 0.12);
        end);
        GQ(b_save_quick.MouseButton1Click, function() iQ:save(); end);

        local tl_cnt = VQ(tl_box);
        tl_cnt.tmp = true;
        kQ.cdd = tl_cnt:dropdown({
            par = tl_box, lo = 4, auto = true, h = 24, none = true,
            empty = "No config", values = {},
            cb = function(sel_c)
                if sel_c and sel_c ~= kQ.cfg then iQ:load(sel_c); end;
            end
        });

        local tr_box = QQ("Frame", {AnchorPoint = s(1, 0), Position = f(1, -16, 0, 0), Size = l(0, 40), AutomaticSize = p, ZIndex = 2, Parent = top_bar});
        IQ_lay(tr_box, 0, H.Right);
        local body_box = QQ("Frame", {Position = l(0, 41), Size = f(1, 0, 1, -89), Parent = root_f});
        local nav_bar = QQ("Frame", {
            AnchorPoint = s(0.5, 1), Position = f(0.5, 0, 1, -9), Size = l(0, 32),
            AutomaticSize = p, BackgroundColor3 = sQ, BackgroundTransparency = ZQ.card,
            ZIndex = 3, Parent = root_f
        });
        AQ(nav_bar);
        JQ(nav_bar, ZQ.edge);
        eQ(nav_bar, 3, 3, 3, 3);
        local nav_hl = QQ("Frame", {Size = l(0, 26), BackgroundColor3 = sQ, BackgroundTransparency = ZQ.tab, ZIndex = 3, Parent = nav_bar});
        AQ(nav_hl);
        local nav_list = QQ("Frame", {Size = l(0, 26), AutomaticSize = p, ZIndex = 4, Parent = nav_bar});
        IQ_lay(nav_list, 2);
        kQ.pl = QQ("Frame", {Size = g(1, 1), ZIndex = 50, Parent = hold_f});
        kQ.modal = QQ("TextButton", {Modal = true, Size = l(0, 0), Visible = false, Parent = gui_inst});
        local grip_btn = QQ("ImageButton", {AnchorPoint = s(1, 1), Position = f(1, -6, 1, -6), Size = l(11, 11), Image = XQ("grip"), ZIndex = 10, Parent = root_f}, {ImageColor3 = "faint"});
        _i(grip_btn, nil, "ImageColor3", tQ.faint, tQ.sub);

        N_resize_bind(grip_btn, hold_f);
        R_drag_bind(drag_area, hold_f);

        local inset_v, vp_y = x:GetGuiInset(), workspace.CurrentCamera.ViewportSize.Y;
        kQ.kbd = l(16, P(vp_y * 0.34));
        kQ.wmd = f(1, -16, 0, inset_v.Y + 10);
        i_kb_init(gui_inst, M_parse_arr_pos(prefs.kbp) or kQ.kbd);
        W_wm_init(gui_inst, M_parse_arr_pos(prefs.wmp) or kQ.wmd);
        R_drag_bind(t_kb.hh, t_kb.g, function() return kQ.open; end, WQ);
        R_drag_bind(n_wm.hh, n_wm.g, function() return kQ.open; end, WQ);
        if c_spec.use then 
            kQ.spd = f(1, -16, 0, P(vp_y * 0.34));
            KQ_spec_init(gui_inst, M_parse_arr_pos(prefs.spp) or kQ.spd);
            R_drag_bind(c_spec.hh, c_spec.g, function() return kQ.open; end, WQ);
        end;
        zi(n_wm.g, n_wm.on);

        Z_notify.f = QQ("Frame", {AnchorPoint = s(0.5, 0), Position = g(0.5, 0.64), Size = l(0, 0), AutomaticSize = V, ZIndex = 20, Parent = gui_inst});
        MQ_lay(Z_notify.f, 8, H.Center);

        local acc_dt, frame_cnt, tick_poll = 0, 0, 0;
        kQ.md:add(C.Heartbeat:Connect(function(dt)
            frame_cnt += 1;
            acc_dt += dt;
            if acc_dt >= 0.5 then 
                kQ.fps = P(frame_cnt / acc_dt + 0.5);
                acc_dt, frame_cnt = 0, 0;
                O_wm_upd();
                if kQ.open then 
                    tick_poll += 1;
                    if tick_poll >= 2 then 
                        tick_poll = 0;
                        D_cfg_chk();
                    end;
                end;
            end;
        end));
        kQ.md:add(C.PreRender:Connect(Q_blur_step));
        kQ.md:add(z.InputBegan:Connect(lQ_inp_beg));
        kQ.md:add(z.InputEnded:Connect(RQ_inp_end));
        kQ.md:add(z.InputChanged:Connect(o_inp_chg));
        kQ.md:add(z.WindowFocusReleased:Connect(v_focus_rel));
        kQ.md:add(gui_inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(q_scale_calc));
        kQ.md:add(hold_f:GetPropertyChangedSignal("Size"):Connect(q_scale_calc));

        kQ.mk = {bdown = function() iQ:toggle(); end, bup = function() end};
        Fi_bind_add(kQ.mk, kQ.mkey);

        local win_obj = setmetatable({
            tabs = {}, top = top_bar, tl = tl_box, tr = tr_box,
            body = body_box, root = root_f, bw = nav_bar,
            bhl = nav_hl, bls = nav_list, nn = 0
        }, h_win_cls);
        kQ.win = win_obj;

        if protect_gui then protect_gui(gui_inst); end;
        gui_inst.Parent = type(gethui) == "function" and gethui() or game:GetService("CoreGui");
        kQ.mob = u_mobile_btn(opt_w, prefs);
        m_cfgl_dummy();
        q_scale_calc();

        local g_sz, h_sz = gui_inst.AbsoluteSize, hold_f.Size;
        g_sz = if g_sz.X <= 0 then workspace.CurrentCamera.ViewportSize else g_sz;
        hold_f.Position = l(P((g_sz.X - h_sz.X.Offset * kQ.sc) / 2), P((g_sz.Y - h_sz.Y.Offset * kQ.sc) / 2));
        kQ.open = false;
        kQ.live = true;
        iQ:toggle(true);
        return win_obj;
    end;

    iQ.unload = function(self)
        if kQ.dead then return; end;
        _pop_close_all(true);
        wQ();
        X_mouselock_ctrl(false);
        S_blur_clean();
        kQ.dead = true;
        kQ.live = false;
        kQ.listen = nil;
        kQ.tg = nil;
        if kQ.ft then 
            kQ.ft:Cancel();
            kQ.ft = nil;
        end;
        kQ.md:clean();
        if kQ.gui then kQ.gui:Destroy(); end;
        local unl = kQ.unl;
        for idx = 1, #unl, 1 do pcall(unl[idx]); end;
        e(unl);
        e(Ui);
        e(ti_cgrp);
        e(Ci_vis);
        e(t_kb.rows);
        e(kQ.bmap);
        e(kQ.pops);
        e(self.els);
        e(self.fl);
        e(self.flags);
        e(self.profs);
        kQ.gui, kQ.root, kQ.hold, kQ.pl, kQ.win, kQ.us, kQ.mk, kQ.probe, kQ.cv, kQ.mob, kQ.mobv, kQ.modal, kQ.cdd, kQ.cfgl, kQ.share = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil;
        t_kb.g, t_kb.f, t_kb.hh = nil, nil, nil;
        c_spec.g, c_spec.f, c_spec.hh = nil, nil, nil;
        e(c_spec.rows);
        e(c_spec.list);
        n_wm.g, n_wm.f, n_wm.nl, n_wm.hh, n_wm.p2 = nil, nil, nil, nil, nil;
        n_wm.v, n_wm.n = {}, 0;
        Z_notify.f = nil;
        e(Z_notify.l);
        L_mouselock.t = nil;
        m_cfgl_dummy = function() end;
        if zQ.polar_lib == self then zQ.polar_lib = nil; end;
    end;

    return iQ;
end)();

return PolarLib;
