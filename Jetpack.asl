// Auto Splitter for Jetpack

state("DOSBOX")
{
    byte Level : 0x34B6B0, 0x21D69;
    byte State : 0x1AD53F8, 0x90;
}

start
{
    return current.Level == 0 && old.State == 184 && current.State == 177;
}

split
{
    return (current.Level != old.Level) ||
           (current.Level == 99 && old.State == 177 && current.State == 176);
}

init
{
    vars.playing = false;
}

update
{
    if (!vars.playing && old.State == 184 && current.State == 177)
    {
        vars.playing = true;
    }
    else if (vars.playing && (current.State == 176 || current.Level != old.Level))
    {
        vars.playing = false;
    }
}

isLoading
{
    return !vars.playing;
}
