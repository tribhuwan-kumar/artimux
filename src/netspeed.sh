#!/usr/bin/env bash
#<------------------------------Netspeed widget for ARTITMUX------------------------------------>
# author : @tribhuwan-kumar
# email : trashbhuwan@proton.me
#<------------------------------------------------------------------------------------------>

# Check the global values
SHOW_NETSPEED=$(tmux show-option -gv @Artimux_show_netspeed)
if [ "$SHOW_NETSPEED" != "true" ]; then
	exit 0
fi

# Get network interface
function find_interface() {
	local interface
	if [[ $(uname) == "Linux" ]]; then
		interface=$(tmux show-option -gv @Artimux_netspeed_iface 2>/dev/null)
	elif [[ $(uname) == "Darwin" ]]; then
		interface=$(route get default 2>/dev/null | grep interface | awk '{print $2}')
		# If VPN, fallback to en0
		[[ ${interface:0:4} == "utun" ]] && interface="en0"
	fi
	echo "$interface"
}


# Get network transmit data
function get_bytes() {
	local interface="$1"
	if [[ "$(uname)" == "Linux" ]]; then
		awk -v interface="$interface" '$1 == interface ":" {print $2, $10}' /proc/net/dev
	elif [[ "$(uname)" == "Darwin" ]]; then
		netstat -ib | awk -v interface="$interface" '/^'"${interface}"'/ {print $7, $10}' | head -n1
	else
		# Unsupported operating system
		exit 1
	fi
}

# Convert into readable format
readable_format() {
	local bytes=$1
	# Convert bytes to KBps
	local kbps=$(echo "scale=1; $bytes / 1024" | bc)
	if (( $(echo "$kbps < 1" | bc -l) )); then
		echo "0.0B"
	elif (( $(echo "$kbps >= 1024" | bc -l) )); then
		# Convert KBps to MBps
		local mbps=$(echo "scale=1; $kbps / 1024" | bc)
		echo "${mbps}MB/s"
	else
		echo "${kbps}KB/s"
	fi
}

# Echo
INTERFACE=$(find_interface)
while true; do
	read RX1 TX1 < <(get_bytes "$INTERFACE")
	sleep 1
	read RX2 TX2 < <(get_bytes "$INTERFACE")

	RX_DIFF=$((RX2 - RX1))
	TX_DIFF=$((TX2 - TX1))

	TIME_DIFF=1

	RX_SPEED=$(readable_format "$((RX_DIFF / TIME_DIFF))")
	TX_SPEED=$(readable_format "$((TX_DIFF / TIME_DIFF))")

	if [[ $(uname) == "Linux" ]]; then
		echo "❬ ⮛ $RX_SPEED ⮙ $TX_SPEED"
	elif [[ $(uname) == "Darwin" ]]; then
		echo "❬ 󰄼 $RX_SPEED 󰄿 $TX_SPEED"
	fi
done
