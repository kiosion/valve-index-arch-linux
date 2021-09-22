#!/usr/bin/env bash
# shellcheck source=/dev/null

# Credits: Based on fixVRDASH by frostworks https://gist.github.com/frostworx/d2fc821fe12a8eca076da772683d6463, I've added some parts that I found required to fix the issue.

# Usage: Ensure excecutable perms are set, run script

SQP="/usr/lib/qt/plugins"

#SEARDIR="$!"
SEARCHDIR="SteamVR"

function setSteamPath {
	HSR="$HOME/.steam/root"
	HSS="$HOME/.steam/steam"

	if [iz "${!1}" ]; then
		if [ -e "${HSR}/${2}" ]; then
			STPA="${HSR}/${2}"
			export "$1"="$STPA"
		elif [ -e "${HSS}/${2}" ]; then
			STPA="${HSS}/${2}"
			export "$1"="$STPA"
		else
			echo "ERROR" "${FUNCNAME[0]} - '$2' not found for variable '$1' in '$HSR' or '$HSS'!" "E"
		fi
	fi
}

function setSteamPaths {
	setSteamPath "DEFSTEAMAPPSCOMMON" "steamapps/common"
	setSteamPath "CFGVDF" "config/config.vdf"
}

function fixVRDash {
	BL="bin/linux64"
	BVL="bin/vrwebhelper/linux64"
	VRWH="$SVRDIR/$BVL/vrwebhelper.sh"
	RWF="resources/webinterface/fonts"

	if [ ! -f "$VRWH" ]; then
		echo "Could not find $VRWH - exiting"
	else
		if ! grep -q "$SVRDIR" "$VRWH"; then
		echo "Running script..."
		echo "------------"
		echo "Creating backup ${VRWH}-BACKUP"
		cp "$VRWH" "${VRWH}-BACKUP"
		echo "Expanding LD_LIBRARY_PATH in '$VRWH' by adding '$SVRDIR/$BL' and '$SVRDIR/$BVL'"
		sed "s:LD_LIBRARY_PATH=\"\${STEAM:LD_LIBRARY_PATH=\"$SVRDIR/$BL\:$SVRDIR/$BVL\:\${STEAM:g" -i "$VRWH"
		
		BLQP="$SVRDIR/$BL/qt/plugins"
		if [ -d "$BLQP" ] && [ ! -d "${BLQP}.old" ]; then
			echo "Creating backup ${BLQP}.old"
			
			if [ -d "$SQP" ]; then
				mv "$BLQP" "${BLQP}.old"
				echo "Creating 'plugins' symlink from '$SQP' in '$SVRDIR/$BL/qt'"
				cd "$SVRDIR/$BL/qt" || die
				ln -s "$SQP" "plugins"
				cd - || die
			else
				echo "System qt5 plugins not found under $SQP"
			fi
		fi

		if [ ! -f "$RWF" ]; then
			echo "Could not find $RWF - skipping"
		else
			if ! ls -la | grep -q Motiva-Sans; then
				echo "Could not find fonts, skipping..."
			else
				echo "Creating symlinks for fonts..."
				ln -s "$RWF/Motiva-Sans-Bold.ttf" "$RWF/motiva-sans-bold.ttf"
				ln -s "$RWF/Motiva-Sans-Regular.ttf" "$RWF/motiva-sans-bold.ttf"
			fi

		fi
	else
		echo "You already have the dashboard fixes applies - exiting"
	fi
}

setSteamPaths

SVRDIR="$(find "$DEFSTEAMAPPSCOMMON" -mindepth 1 -maxdepth 1 -type d -name "$SEARCHDIR")"

if [ ! -d "$SVRDIR" ]; then
	if [ -f "$CFGVDF" ]; then
		if ! grep -q "BaseInstallFolder" "$CFGVDF"; then
			writelog "INFO" "${FUNCNAME[0]} - No additional Steam Libraries configured in '$CFGVDF' - so no need to search in there"
		else
			while read -r protondir; do
				SVRDIR="$protondir"
			done <<< "$(while read -r SLP; do find "${SLP//\"/}/steamapps/common" -mindepth 1 -maxdepth 1 -type d -name "$SEARCHDIR"; done <<< "$(grep "BaseInstallFolder" "$CFGVDF" | gawk '{print $2}')")"
		fi
	fi
fi

if [ -d "$SVRDIR" ]; then
	echo "Found $SEARCHDIR in $SVRDIR"
	if [ "$SEARCHDIR" == "SteamVR" ]; then
		fixVRDash "$@"
	else
		exit
	fi
else
	echo "Could not find '$SEARCHDIR' - exiting"
fi
