// Auto Splitter for Jetpack

state("DOSBOX")
{
    string26 Regular   : 0x193A1A0, 0x626F4;
    string26 Christmas : 0x193A1A0, 0x62314;
    int  JetScore      : 0x193A1A0, 0x21D19;
    byte JetLevel      : 0x193A1A0, 0x21D69;
    byte JetGameReady  : 0x193A1A0, 0x23294;
    byte JetGameGo     : 0x193A1A0, 0x232AC;
    byte JetEditReady  : 0x193A1A0, 0x23234;
    byte JetEditGo     : 0x193A1A0, 0x2324C;
    int  XmasScore     : 0x193A1A0, 0x217B7;
    byte XmasLevel     : 0x193A1A0, 0x21807;
    byte XmasGameReady : 0x193A1A0, 0x22E72;
    byte XmasGameGo    : 0x193A1A0, 0x22E8A;
    byte XmasEditReady : 0x193A1A0, 0x22E12;
    byte XmasEditGo    : 0x193A1A0, 0x22E2A;
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
    } else if (current.Christmas == "   ROOKIE       SANTA     ") {
        if (current.JetGameReady == 0xFF) vars.State = current.JetGameGo;
        else if (current.JetEditReady == 0xFF) vars.State = current.JetEditGo;
        else vars.State = 0xFF;
        vars.Score = current.XmasScore;
        vars.Level = current.XmasLevel;
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
    } else if (current.Christmas == "   ROOKIE       SANTA     ") {
        if (current.XmasGameReady == 0xFF) vars.State = current.XmasGameGo;
        else if (current.XmasEditReady == 0xFF) vars.State = current.XmasEditGo;
        else vars.State = 0xFF;
        vars.Score = current.XmasScore;
        vars.Level = current.XmasLevel;
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
