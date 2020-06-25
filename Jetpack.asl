// Auto Splitter for Jetpack

state("DOSBOX")
{
    int  Score     : 0x34B6B0, 0x21D19;
    byte Level     : 0x34B6B0, 0x21D69;
    byte PrePlay   : 0x34B6B0, 0x2328C;
    byte PlayState : 0x34B6B0, 0x232A4;
    byte PreEdit   : 0x34B6B0, 0x2322C;
    byte EditState : 0x34B6B0, 0x23244;
}

init
{
    if (current.PrePlay == 0xFF) vars.State = current.PlayState;
    else if (current.PreEdit == 0xFF) vars.State = current.EditState;
    else vars.State = 0xFF;
    vars.OldState = vars.State;
    vars.ExpectLevelUp = false;
    vars.Split = false;
}

update
{
    vars.OldState = vars.State;
    if (current.PrePlay == 0xFF) vars.State = current.PlayState;
    else if (current.PreEdit == 0xFF) vars.State = current.EditState;
    else vars.State = 0xFF;
    vars.Split = false;
    if (vars.State == 4 && vars.OldState == 0) {
        vars.Split = true;
        vars.ExpectLevelUp = true;
    }
    if (current.Level != old.Level) {
        if (!vars.ExpectLevelUp) vars.Split = true;
        vars.ExpectLevelUp = false;
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
