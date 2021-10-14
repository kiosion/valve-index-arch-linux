# Valve Index & SteamVR on Arch Linux

Listed below are issues I ran into while getting SteamVR set up with my Index, and have found fixes for. For each issue there's a script that applies the fixes, as well as a manual guide if you prefer to know what changes are being made.

#### Other stuff:

- [Beat Saber fixes](/games/beat-saber.md) - Some fixes for Beat Saber, + guide for modding it!
- [VRChat fixes](/games/vrchat.md) - Some fixes for VRChat

---

### Direct Display failing

If the HMD stays blank and the image appears as a window in your DE - I've found this is *usually* because Steam didn't receive proper permissions during its initial install of SteamVR. There are likely other (and better) methods to fixing this, but the following steps worked for me (as I don't use a DE & didn't want to setup gnome polkit or an equivalent).

#### Manual steps:

- Ensure SteamVR is installed and set to the latest non-beta release. I had no luck with either the Linux beta or normal SteamVR beta versions.
- cd to your SteamVR install location (default is `~/.local/share/Steam/steamapps/common/SteamVR`) and run the following command using bash.

```bash
set LB_LIBRARY_PATH="~/.local/share/Steam/steamapps/common/SteamVR/bin" && sudo ./vrstartup.sh & disown
```

- Let SteamVR launch; there may be popups about another instance running already, ignore these
- Open the SteamVR desktop menu and navigate to Developer > Developer Settings
- Click 'Enable Direct Display Mode' and let SteamVR restart
- Once restarted, navigate back to Developer Settings and click 'Restart HMD', this will restart your HMD and SteamVR
- Your monitor should turn black briefly, before the VR view appears on the HMD displays

#### Script:

Working on it :)

---

### Bad tracking

If the image appears properly on the HMD but doesn't track correctly / has significant lag or stutters - Specifically in SteavVR Home, and *only* in SteamVR home/dashboard elements for me. Games are fine and run at the HMD's full refresh rate without stutters or input lag. I'm still looking into this, might have something to do with vulkan/specific video drivers. I've had slightly better results after adjusting the custom resolution to 90%, but that's not really a long-term fix.

---

### VRDashboard fails to open

If VRDashboard doesn't launch, controller menu buttons don't work, and/or in-game Steam notifications don't appear.

#### Manual steps:

- Open Steam and switch SteamVR to the latest release (I found success with this vs the beta & older, linux-specific branches)
- Cd into `{SteamVR}/bin/vrwebhelper/linux64/` and open `vrwebhelper.sh`. Change `LD_LIBRARY_PATH` to:
```shell
export LD_LIBRARY_PATH="$HOME/.steam/steam/steamapps/common/SteamVR/bin/linux64:$HOME/.steam/steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64:${STEAM_RUNTIME_HEAVY}${LD_LIBRARY_PATH:$LD_LIBRARY_PATH}"
```
- Cd into `{SteamVR}/resources/webinterface/fonts/`
- List the directory contents; if the fonts 'Motiva-Sans-Bold' and 'Motiva-Sans-Regular' are present with capitalised names, use the following command to create symlinks with lowercase names[^1]:
```shell
ln -s Motiva-Sans-Regular.ttf motiva-sans-regular.ttf && ln -s Motiva-Sans-Bold.ttf motiva-sans-bold.ttf
```

- In either `/usr/bin/steam` or `/usr/bin/steam-native`, whichever you use, add the following lines[^2]:
```shell
STEAMVR_TOOLSDIR="$HOME/.local/share/Steam/steamapps/common/SteamVR"
LD_LIBRARY_PATH="${STEAMVR_TOOLSDIR}/bin/linux64/:${LD_LIBRARY_PATH}"
exec /usr/lib/steam/steam "$@"
```

#### Script:

Clone this repo and run [scripts/dashboardfix.sh](/scripts/dashboardfix.sh) with sudo to automatically apply these fixes

---

### HMD connection failed / SteamVR fatal error

If the HMD's indicator lights are red on startup, or SteamVR reports a fatal error on launch, a simple, albeit slightly janky fix, is to open the Developer Settings menu panel inside SteamVR, and select 'Restart Headset/Restart SteamVR' (whichever option is available). I don't know why this fixes the issue, I don't know why whatever resets this does aren't done anyways on launch, but it works every time for me. Still looking into what causes this, I believe it may be a USB issue of some sort.

---

## Disclaimer
These fixes involve modifying files used by Steam and SteamVR. Follow these steps at your own risk, and always back up your Steam install beforehand.

[^1]: [t00](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/255#issuecomment-877844004)'s suggestion to rename vrwebhelper font resources
[^2]: [Supreeeme](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/255#issuecomment-775624892
)'s suggestion to modify 'LD_LIBRARY_PATH'
