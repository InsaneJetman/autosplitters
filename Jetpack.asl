// Auto Splitter for Jetpack
// by InsaneJetman
// v1.0

state("DOSBOX")
{
    string26 Regular    : 0x193A1A0, 0x626F4;
    string26 Shareware  : 0x193A1A0, 0x63114;
    string26 Christmas  : 0x193A1A0, 0x62314;
    string26 Alpha      : 0x193A1A0, 0x1A514;
    string8  Program    : 0x193A1A0, 0x01918;
}

startup
{
    settings.Add("gem_split", false, "Gem Splits");
    settings.Add("treasure_split", false, "Treasure Splits");
    settings.Add("death_reset", false, "Reset on Death");
}

init
{
    vars.DOSBoxVersions = new Dictionary<string, int> {
        { "0, 74, 3, 0", 0x193C370 },
        { "0, 74, 2, 0", 0x193E370 },
        { "0, 74, 0, 0", 0x193A1A0 }
    };

    int MemoryOffset = 0;
    vars.MemoryStart = IntPtr.Zero;
    if (vars.DOSBoxVersions.TryGetValue(modules.First().FileVersionInfo.FileVersion, out MemoryOffset)) {
        vars.MemoryStart = modules.First().BaseAddress;
        vars.MemoryStart = IntPtr.Add(vars.MemoryStart, MemoryOffset);
    } else {
        throw new InvalidOperationException("Unsupported DOSBox version");
    }

    vars.DOSBoxWatchers = new MemoryWatcherList {
        new MemoryWatcher<ushort>(new DeepPointer(vars.MemoryStart, 0x1871)) { Name = "ProgramSegment" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x1918), 8) { Name = "ProgramName" }
    };
    vars.JetScanWatchers = new MemoryWatcherList {
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x626F4), 26) { Name = "Regular" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x61FC4), 26) { Name = "Shareware v1.0" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x62DD4), 26) { Name = "Shareware v1.1" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x61C64), 26) { Name = "Shareware v1.2" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x63104), 26) { Name = "Shareware v1.3" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x63114), 26) { Name = "Shareware v1.4" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x62314), 26) { Name = "Christmas" },
        new StringWatcher(new DeepPointer(vars.MemoryStart, 0x1A514), 26) { Name = "Alpha" }
    };

    vars.doInit = (Action)(() => {
        vars.JetpackVersion = "None";
        vars.JetpackWatchers = new MemoryWatcherList {};
        vars.DOSBoxWatchers.UpdateAll(game);
        if (vars.DOSBoxWatchers["ProgramSegment"].Current != 0 && vars.DOSBoxWatchers["ProgramName"].Current == "JETPACK") {
            vars.JetScanWatchers.UpdateAll(game);
            if (vars.JetScanWatchers["Regular"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Regular";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x21D19)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x21D69)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23294)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x232AC)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x232C8)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23234)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x2324C)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23268)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Shareware v1.0"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Shareware v1.0";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x21B17)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x21B47)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x2320C)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23224)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23240)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x2316C)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23184)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x231A0)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Shareware v1.1"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Shareware v1.1";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x228B7)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22907)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23FF2)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x2400A)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x24026)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23F92)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23FAA)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23FC6)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Shareware v1.2"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Shareware v1.2";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x21737)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x21787)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22E86)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x22E9A)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x22EB6)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22E26)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x22E3A)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x22E56)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Shareware v1.3"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Shareware v1.3";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x22727)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22777)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23CFE)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23D1A)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23D36)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23C9E)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23CBA)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23CD6)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Shareware v1.4"].Current == " WELCOME TO    JETPACK!   ") {
                vars.JetpackVersion = "Shareware v1.4";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x22737)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22787)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23D0E)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23D2A)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23D46)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x23CAE)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x23CCA)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x23CE6)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Christmas"].Current == "   ROOKIE       SANTA     ") {
                vars.JetpackVersion = "Christmas";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x217B7)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x21807)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22E72)) { Name = "GameReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x22E8A)) { Name = "GameGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x22EA6)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x22E12)) { Name = "EditReady" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x22E2A)) { Name = "EditGo" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x22E46)) { Name = "EditDirection" });
            } else if (vars.JetScanWatchers["Alpha"].Current == "   BLANKET                ") {
                vars.JetpackVersion = "Alpha";
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x19264)) { Name = "Score" });
                vars.JetpackWatchers.Add(new MemoryWatcher<short>(new DeepPointer(vars.MemoryStart, 0x19284)) { Name = "Level" });
                vars.JetpackWatchers.Add(new MemoryWatcher<int>  (new DeepPointer(vars.MemoryStart, 0x122F9E5)) { Name = "Playing" });
                vars.JetpackWatchers.Add(new MemoryWatcher<byte> (new DeepPointer(vars.MemoryStart, 0x19349)) { Name = "Door" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x2150E)) { Name = "GameDirection" });
                vars.JetpackWatchers.Add(new MemoryWatcher<uint> (new DeepPointer(vars.MemoryStart, 0x2149A)) { Name = "EditDirection" });
            } else {
                vars.JetpackVersion = "Unknown";
            }
            vars.JetpackWatchers.UpdateAll(game);
        }
        vars.State = -1;
        vars.Score = 0;
        vars.Level = 0;
        vars.ExpectLevelUp = false;
        vars.FirstScan = true;
    });
    vars.doInit();
}

update
{
    if (vars.JetpackVersion != "None") {
        vars.DOSBoxWatchers.UpdateAll(game);
        if (vars.DOSBoxWatchers["ProgramSegment"].Current != 0 && vars.DOSBoxWatchers["ProgramName"].Current == "JETPACK")
            vars.JetpackWatchers.UpdateAll(game);
        else
            vars.JetpackVersion = "None";
    }

    vars.OldState = vars.State;
    vars.OldScore = vars.Score;
    vars.OldLevel = vars.Level;
    Func<uint, bool> EvalDirection = (direction) => {
        short UpDown = (short)(direction & 0xFFFF);
        short LeftRight = (short)(direction >> 16);
        return UpDown >= -1 && UpDown <= 1 && LeftRight >= -1 && LeftRight <= 1;
    };

    switch ((string)vars.JetpackVersion) {
    case "Regular":
    case "Shareware v1.0":
    case "Shareware v1.1":
    case "Shareware v1.2":
    case "Shareware v1.3":
    case "Shareware v1.4":
    case "Christmas":
        if (vars.JetpackWatchers["GameReady"].Current == -1) {
            vars.State = vars.JetpackWatchers["GameGo"].Current;
            if (vars.OldState != 0 && vars.State == 0 && !EvalDirection(vars.JetpackWatchers["GameDirection"].Current)) vars.State = -1;
        } else if (vars.JetpackWatchers["EditReady"].Current == -1) {
            vars.State = vars.JetpackWatchers["EditGo"].Current;
            if (vars.OldState != 0 && vars.State == 0 && !EvalDirection(vars.JetpackWatchers["EditDirection"].Current)) vars.State = -1;
        } else vars.State = -1;
        vars.Score = vars.JetpackWatchers["Score"].Current;
        vars.Level = vars.JetpackWatchers["Level"].Current;
        break;
    case "Alpha":
        if (vars.JetpackWatchers["Playing"].Current == 0x007A7A00) {
            if (vars.JetpackWatchers["Playing"].Old == 0x007A7A00) {
                if (vars.OldState == 1) {
                    if (EvalDirection(((vars.JetpackWatchers["EditDirection"].Old & 0xFFFF) == 0x482D)?
                                      (vars.JetpackWatchers["EditDirection"].Current):
                                      (vars.JetpackWatchers["GameDirection"].Current))) vars.State = 0;
                } else if (vars.OldState == 0 && vars.JetpackWatchers["Door"].Current == 69) vars.State = 4;
            } else vars.State = 1;
        } else {
            vars.State = -1;
        }
        vars.Score = vars.JetpackWatchers["Score"].Current;
        vars.Level = vars.JetpackWatchers["Level"].Current;
        break;
    case "Unknown":
    case "None":
    default:
        vars.doInit();
        vars.Split = false;
        vars.Reset = settings["death_reset"];
        return true;
    }

    vars.Split = false;
    if (vars.State == 4 && vars.OldState == 0) {
        vars.Split = true;
        vars.ExpectLevelUp = true;
    }
    if (vars.Level == vars.OldLevel + 1) {
        if (!vars.ExpectLevelUp) vars.Split = true;
        vars.ExpectLevelUp = false;
    }

    int DeltaScore = vars.Score - vars.OldScore;
    if (DeltaScore == 5) {
        if (settings["gem_split"]) vars.Split = true;
    }
    else if (DeltaScore > 5) {
        if (settings["treasure_split"]) vars.Split = true;
    }

    vars.Reset = false;
    if (settings["death_reset"] && vars.State != 0 && vars.State != 4 && vars.OldState == 0) {
        vars.Reset = true;
    }

    if (vars.FirstScan) { vars.FirstScan = false; return false; }
}

start
{
    return vars.State == 0 && vars.OldState != 0;
}

split
{
    return vars.Split;
}

isLoading
{
    return vars.State != 0;
}

reset
{
    return vars.Reset;
}
