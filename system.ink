EXTERNAL setTheme(theme)
EXTERNAL keepSoundAlive()
EXTERNAL createSlot(name, loop, groupList)
EXTERNAL loadSound(slot, sound, url)
EXTERNAL playSound(slot, sound, volume, crossFade)
EXTERNAL playSoundV(slot, sound, volume)
EXTERNAL playSoundS(slot, sound)
EXTERNAL stopSound(slot)

=== function setTheme(theme) ===
Setting theme to: {theme}

=== function keepSoundAlive ===
Keep sound alive

=== function createSlot(name, loop, groupList) ===
Creating slot="{name}" loop={loop} groupList="{groupList}"

=== function loadSound(slot, sound, url) ===
Laoding sound="{sound}" into slot="{slot}" from url="{url}"

=== function playSound(slot, sound, volume, crossFade) ===
Playing sound="{sound}" in slot="{slot}" with volume={volume} and crossFade={crossFade}

=== function playSoundV(slot, sound, volume) ===
Playing sound="{sound}" in slot="{slot}" with volume={volume}

=== function playSoundS(slot, sound) ===
Playing sound="{sound}" in slot="{slot}"

=== function stopSound(slot) ===
Stop slot="{slot}"
