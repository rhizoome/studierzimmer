=== function debug_out(text) ===
{debug:
    - {text}
}

=== function setTheme(theme) ===
~ debug_out("Setting theme to: {theme}'")

=== function keepSoundAlive ===
~ debug_out("Keep sound alive")

=== function createSlot(name, loop, groupList) ===
~ debug_out("Creating slot='{name}' loop={loop} groupList='{groupList}'")

=== function loadSound(slot, sound, url) ===
~ debug_out("Laoding sound='{sound}' into slot='{slot}' from url='{url}'")

=== function playSound(slot, sound, volume, crossFade) ===
~ debug_out("Playing sound='{sound}' in slot='{slot}' with volume={volume} and crossFade={crossFade}")

=== function playSoundV(slot, sound, volume) ===
~ debug_out("Playing sound='{sound}' in slot='{slot}' with volume={volume}")

=== function playSoundS(slot, sound) ===
~ debug_out("Playing sound='{sound}' in slot='{slot}'")

=== function stopSound(slot) ===
~ debug_out("Stop slot='{slot}'")

=== function stopGroup(group) ===
~ debug_out("Stop group='{group}'")

=== function currentSound(slot) ===
~ debug_out("Checking sound of slot='{slot}'")
~ return ""

=== function hasFrontend() ===
~ return 0

=== function activity() ===
~ return 0
