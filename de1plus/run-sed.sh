#!/bin/sh

###
### WARNING: If you've symlinked your "live" directory
###          into your dev root, this will "attack" it
###

find . -name '*.tcl' -exec sed -i '' -f sed.commands {} \;

# Convert "old substate" to "NewSubstate"
# Convert {old substate} to "NewSubstate" as well
# Convert (old substate) to (NewSubstate) -- generally array references

# Convert [translate "NewSubstate"] to [translate {old substate}]
#    as sometimes in `return "[translate {NewSubstate}]"`

# Fixup translate with a token of (heating)


# One key of (heating), some text embeds (preinfusion)

git restore translation.tcl


# Single-point patch where "Flush" was already in use

sed -i '' -e 's/\[translate {ending}]/[translate "Flush"]/g' skins/SWDark4/skin.tcl


git diff --ignore-space-at-eol

git submodule foreach git diff --ignore-space-at-eol
