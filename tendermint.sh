#!/bin/bash
# Default variables
function="install"
tendermint_version=`wget -qO- https://api.github.com/repos/tendermint/tendermint/releases/latest | jq -r ".tag_name" | sed "s%v%%g"`

# Options
. <(wget -qO- https://raw.githubusercontent.com/1Malenok1/Stuff/main/colours.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/1Malenok1/Stuff/main/logo_mms.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script installs or uninstalls Tendermint"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help             show the help page"
		echo -e "  -v,  --version VERSION  Tendermint VERSION to install (default is ${C_LGn}${tendermint_version}${RES})"
		echo -e "  -un, --uninstall        uninstall Tendermint"
		echo
		echo -e "You can use either \"=\" or \" \" as an option and value ${C_LGn}delimiter${RES}"
		return 0 2>/dev/null; exit 0
		;;
	-v*|--version*)
		if ! grep -q "=" <<< "$1"; then shift; fi
		tendermint_version=`option_value "$1"`
		shift
		;;
	-u|-un|--uninstall)
		function="uninstall"
		shift
		;;
	*|--)
		break
		;;
	esac
done

# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
install() {
	sudo apt update
	sudo apt upgrade -y
	sudo apt install wget jq -y
	local temp_dir="$HOME/installer_temp/"
	mkdir "$temp_dir"
	cd "$temp_dir"
	wget -q "https://github.com/tendermint/tendermint/releases/download/v${tendermint_version}/tendermint_${tendermint_version}_linux_amd64.tar.gz"
	tar -xvf "tendermint_${tendermint_version}_linux_amd64.tar.gz"
	chmod +x "${temp_dir}tendermint"
	mv "${temp_dir}tendermint" /usr/bin/tendermint
	cd
	rm -rf "$temp_dir"
}
uninstall() {
	rm -rf /usr/bin/tendermint
}

# Actions
$function
echo -e "${Bl_Gn}All Operation Completed!${RES}"
. <(wget -qO- https://raw.githubusercontent.com/1Malenok1/Stuff/main/logo_mms.sh)
echo
		echo -e "${C_LGn}Visit our resources:${RES}"
		echo -e "${C_C}https://mms.team${RES} — Main_Site"
		echo -e "${C_C}https://t.me/nftmms${RES} — MMS_Research_Chat"
		echo -e "${C_C}https://t.me/cosmochannel_mms${RES} — MMS_Cosmos_Ecosystem_Chat"
		echo -e "${C_C}https://t.me/mmsnodes${RES} — MMS_Nodes_Chat"
		echo -e "${C_C}https://nodes.mms.team${RES} — Guides_and_Manual's"
		echo
