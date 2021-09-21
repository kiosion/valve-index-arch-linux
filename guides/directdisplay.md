## VR view opens in desktop window, HMD screens stay blank
I've found this is usually because Steam didn't receive proper permissions during its install of SteamVR. There are likely other (and better) methods to fix this, but the following steps worked for me (as I don't use a DE & didn't want to setup polkit).

- Ensure SteamVR is installed and set to the latest non-beta release. I had no luck with either the Linux beta or normal SteamVR beta versions.
- cd to your SteamVR install location (default is `~/.local/share/Steam/steamapps/common/SteamVR`) and run the following command using bash.

```bash
set LB_LIBRARY_PATH="~/.local/share/Steam/steamapps/common/SteamVR/bin" && sudo ./vrstartup.sh &
```

- Let SteamVR launch; there may be popups about another instance running already, ignore these
- Open the SteamVR desktop menu and navigate to Developer > Developer Settings
- Click 'Enable Direct Display Mode' and let SteamVR restart
- Once restarted, navigate back to Developer Settings and click 'Reset HMD', this will restart your HMD and SteamVR
- Your monitor should turn black briefly, before the VR view appears on the HMD displays
