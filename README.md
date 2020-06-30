# Auto Splitters by InsaneJetman

Welcome to my auto splitter collection.
At present it contains just the one auto splitter, but more are planned.

**- InsaneJetman**

## Jetpack

This auto splitter provides timing for all versions of Jetpack:

* Jetpack
* Jetpack Alpha
* Jetpack Shareware Edition (versions 1.0 to 1.4)
* Jetpack Christmas Special!

The auto splitter will:

* automatically start your timer when you begin a new level
* split when you finish a level

There are also options to:

* split whenever you collect a gem
* split whenever you collect any treasure (including fuel tanks and stunners)
* reset your timer after you die

These options are useful for doing individual level runs.

Game time is also tracked.
Although not officially used in full-game runs,
it can be used to extract individual level runs from longer runs.

### Setup

Activate the auto splitter directly in LiveSplit,
or [download](https://raw.githubusercontent.com/InsaneJetman/autosplitters/master/Jetpack.asl) it yourself and add it to your layout.

The script assumes that Jetpack is running in DOSBox.
Versions 0.74, 0.74-2, and 0.74-3 are supported.

Tracking game variables in DOSBox is tricky.
Following old segment/offset pointers is not viable in ASL (if pointer paths could even be found),
Instead, we must keep the DOSBox setup consistent in order for the script to work.

The following restrictions are known and must be met when running the game:

* mount the Jetpack directory directly so that JETPACK.EXE is run from the root directory of a drive
* do not set or adjust any environment variables (including %PATH%)
