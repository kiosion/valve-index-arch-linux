## VR Dashboard doesn't launch / controller menu buttons don't work / in-game Steam notifications don't appear

### Manual fixes:

- Open Steam and switch SteamVR to the latest release (I found success with this vs the beta & older, linux-specific branches)
- Cd into `{SteamVR}/bin/vrwebhelper/linux64/` and open `vrwebhelper.sh`. Change `LD_LIBRARY_PATH` to:
```shell
export LD_LIBRARY_PATH="$HOME/.steam/steam/steamapps/common/SteamVR/bin/linux64:$HOME/.steam/steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64:${STEAM_RUNTIME_HEAVY}${LD_LIBRARY_PATH:$LD_LIBRARY_PATH}"
```
- Cd into `{SteamVR}/resources/webinterface/fonts/`
- List the directory contents; if the fonts 'Motiva-Sans-Bold' and 'Motiva-Sans-Regular' are present with capitalised names, use the following command to create symlinks with lowercase names
```shell
ln -s Motiva-Sans-Regular.ttf motiva-sans-regular.ttf && ln -s Motiva-Sans-Bold.ttf motiva-sans-bold.ttf
```

- In either `/usr/bin/steam` or `/usr/bin/steam-native`, whichever you use, add the following lines:
```shell
STEAMVR_TOOLSDIR="$HOME/.local/share/Steam/steamapps/common/SteamVR"
LD_LIBRARY_PATH="${STEAMVR_TOOLSDIR}/bin/linux64/:${LD_LIBRARY_PATH}"
exec /usr/lib/steam/steam "$@"
```

### Script:
Alternatively, you can clone this repo and run the following script to automatically apply these fixes:

[dashboardfix.sh](/scripts/dashboardfix.sh)

### Credits:

- [t00](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/255#issuecomment-877844004)'s suggestion to rename font resources
- [Supreeeme](https://github.com/ValveSoftware/SteamVR-for-Linux/issues/255#issuecomment-775624892
) for their suggestions to change 'LD_LIBRARY_PATH'
