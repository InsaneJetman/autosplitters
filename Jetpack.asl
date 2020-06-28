// Auto Splitter for Jetpack

state("DOSBOX")
{
    string26 Regular     : 0x193A1A0, 0x626F4;
    string26 Shareware   : 0x193A1A0, 0x63114;
    string26 Christmas   : 0x193A1A0, 0x62314;
    string26 Alpha       : 0x193A1A0, 0x1A514;
    int   JetScore       : 0x193A1A0, 0x21D19;
    byte  JetLevel       : 0x193A1A0, 0x21D69;
    byte  JetGameReady   : 0x193A1A0, 0x23294;
    byte  JetGameGo      : 0x193A1A0, 0x232AC;
    byte  JetEditReady   : 0x193A1A0, 0x23234;
    byte  JetEditGo      : 0x193A1A0, 0x2324C;
    int   ShareScore     : 0x193A1A0, 0x22737;
    byte  ShareLevel     : 0x193A1A0, 0x22787;
    byte  ShareGameReady : 0x193A1A0, 0x23D0E;
    byte  ShareGameGo    : 0x193A1A0, 0x23D2A;
    byte  ShareEditReady : 0x193A1A0, 0x23CAE;
    byte  ShareEditGo    : 0x193A1A0, 0x23CCA;
    int   XmasScore      : 0x193A1A0, 0x217B7;
    byte  XmasLevel      : 0x193A1A0, 0x21807;
    byte  XmasGameReady  : 0x193A1A0, 0x22E72;
    byte  XmasGameGo     : 0x193A1A0, 0x22E8A;
    byte  XmasEditReady  : 0x193A1A0, 0x22E12;
    byte  XmasEditGo     : 0x193A1A0, 0x22E2A;
    int   AlphaScore     : 0x193A1A0, 0x19264;
    byte  AlphaLevel     : 0x193A1A0, 0x19284;
    int   AlphaPlaying   : 0x193A1A0, 0x122F9E5;
    byte  AlphaDoor      : 0x193A1A0, 0x19349;
    short AlphaUpDown    : 0x193A1A0, 0x2150E;
    short AlphaUpDownEd  : 0x193A1A0, 0x2149A;
}

startup
{
    settings.Add("gem_split", false, "Gem Splits");
    settings.Add("treasure_split", false, "Treasure Splits");
    settings.Add("death_reset", false, "Reset on Death");
}

init
{
    if (current.Regular == " WELCOME TO    JETPACK!   ") {
        if (current.JetGameReady == 0xFF) vars.State = current.JetGameGo;
        else if (current.JetEditReady == 0xFF) vars.State = current.JetEditGo;
        else vars.State = 0xFF;
        vars.Score = current.JetScore;
        vars.Level = current.JetLevel;
    } else if (current.Shareware == " WELCOME TO    JETPACK!   ") {
        if (current.ShareGameReady == 0xFF) vars.State = current.ShareGameGo;
        else if (current.ShareEditReady == 0xFF) vars.State = current.ShareEditGo;
        else vars.State = 0xFF;
        vars.Score = current.ShareScore;
        vars.Level = current.ShareLevel;
    } else if (current.Christmas == "   ROOKIE       SANTA     ") {
        if (current.JetGameReady == 0xFF) vars.State = current.JetGameGo;
        else if (current.JetEditReady == 0xFF) vars.State = current.JetEditGo;
        else vars.State = 0xFF;
        vars.Score = current.XmasScore;
        vars.Level = current.XmasLevel;
    } else if (current.Alpha == "   BLANKET                ") {
        vars.State = 0xFF;
        vars.Score = current.AlphaScore;
        vars.Level = current.AlphaLevel;
    } else {
        vars.State = 0xFF;
        vars.Score = 0;
        vars.Level = 0;
    }
    vars.OldState = vars.State;
    vars.OldLevel = vars.Level;
    vars.OldScore = vars.Score;
    vars.ExpectLevelUp = false;
    vars.Split = false;
    vars.Reset = false;
}

update
{
    vars.OldState = vars.State;
    vars.OldScore = vars.Score;
    vars.OldLevel = vars.Level;
    if (current.Regular == " WELCOME TO    JETPACK!   ") {
        if (current.JetGameReady == 0xFF) vars.State = current.JetGameGo;
        else if (current.JetEditReady == 0xFF) vars.State = current.JetEditGo;
        else vars.State = 0xFF;
        vars.Score = current.JetScore;
        vars.Level = current.JetLevel;
    } else if (current.Shareware == " WELCOME TO    JETPACK!   ") {
        if (current.ShareGameReady == 0xFF) vars.State = current.ShareGameGo;
        else if (current.ShareEditReady == 0xFF) vars.State = current.ShareEditGo;
        else vars.State = 0xFF;
        vars.Score = current.ShareScore;
        vars.Level = current.ShareLevel;
    } else if (current.Christmas == "   ROOKIE       SANTA     ") {
        if (current.XmasGameReady == 0xFF) vars.State = current.XmasGameGo;
        else if (current.XmasEditReady == 0xFF) vars.State = current.XmasEditGo;
        else vars.State = 0xFF;
        vars.Score = current.XmasScore;
        vars.Level = current.XmasLevel;
    } else if (current.Alpha == "   BLANKET                ") {
        if (current.AlphaPlaying == 0x007A7A00) {
            if (old.AlphaPlaying == 0x007A7A00) {
                if (vars.OldState == 1) {
                    var UpDown = (old.AlphaUpDownEd == 0x482D)?(current.AlphaUpDownEd):(current.AlphaUpDown);
                    if (UpDown >= -1 && UpDown <= 1) vars.State = 0;
                } else if (vars.OldState == 0 && current.AlphaDoor == 69) vars.State = 4;
            } else vars.State = 1;
        } else {
            vars.State = 0xFF;
        }
        vars.Score = current.AlphaScore;
        vars.Level = current.AlphaLevel;
    } else {
        vars.State = 0xFF;
        vars.Score = 0;
        vars.Level = 0;
        vars.ExpectLevelUp = false;
        vars.Split = false;
        vars.Reset = settings["death_reset"];
        return true;
    }

    vars.Split = false;
    if (vars.State == 4 && vars.OldState == 0) {
        vars.Split = true;
        vars.ExpectLevelUp = true;
    }
    if (vars.Level != vars.OldLevel) {
        if (!vars.ExpectLevelUp) vars.Split = true;
        vars.ExpectLevelUp = false;
    }

    if (vars.Score - vars.OldScore == 5) {
        if (settings["gem_split"]) vars.Split = true;
    }
    else if (vars.Score - vars.OldScore > 5) {
        if (settings["treasure_split"]) vars.Split = true;
    }

    vars.Reset = false;
    if (settings["death_reset"] && vars.State != 0 && vars.State != 4 && vars.OldState == 0) {
        vars.Reset = true;
    }
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
