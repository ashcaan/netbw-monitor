#!/bin/bash
# Real-time network throughput monitor (MB/s)
# Shows negotiated link speed when available
# Press 'q' to quit

get_ifaces() {
  awk -F: 'NR>2 {gsub(/^[ \t]+/,"",$1); print $1}' /proc/net/dev
}

get_link_speed() {
  local i="$1"
  local speed="unknown"

  if command -v ethtool >/dev/null 2>&1; then
    # Example line: Speed: 10000Mb/s
    speed=$(ethtool "$i" 2>/dev/null | awk -F': ' '/Speed:/ {print $2; exit}')
    [ -n "$speed" ] || speed="unknown"
  else
    # Fallback sysfs (may be -1 or missing on some drivers/virtual NICs)
    if [ -r "/sys/class/net/$i/speed" ]; then
      local s
      s=$(cat "/sys/class/net/$i/speed" 2>/dev/null)
      if [[ "$s" =~ ^[0-9]+$ ]] && [ "$s" -ge 0 ]; then
        speed="${s}Mb/s"
      fi
    fi
  fi

  echo "$speed"
}

# Interface selection
if [ -n "$1" ]; then
  iface="$1"
else
  echo "Available network interfaces:"
  get_ifaces | sed 's/^/ - /'
  echo
  read -p "Enter interface name: " iface
fi

# Sanity check
if ! grep -qE "^[[:space:]]*$iface:" /proc/net/dev; then
  echo
  echo "Error: Interface '$iface' not found."
  echo "Available interfaces:"
  get_ifaces | sed 's/^/ - /'
  exit 1
fi

link_speed=$(get_link_speed "$iface")

echo
echo "Monitoring throughput on interface: $iface"
echo "Link speed (negotiated): $link_speed"
echo "Press 'q' to quit."
echo

# Start monitor in background
awk -v iface="$iface" '
function readstats(    line, a) {
  while ((getline line < "/proc/net/dev") > 0) {
    gsub(/:/,"",line)
    split(line,a)
    if (a[1]==iface) { rx=a[2]; tx=a[10] }
  }
  close("/proc/net/dev")
}
BEGIN {
  readstats()
  rx0=rx; tx0=tx
  while (1) {
    system("sleep 1")
    readstats()
    printf "iface=%s | RX: %.2f MB/s | TX: %.2f MB/s\n",
           iface,
           (rx-rx0)/1024/1024,
           (tx-tx0)/1024/1024
    rx0=rx; tx0=tx
    fflush()
  }
}' &
MON_PID=$!

# Key listener
while true; do
  read -rsn1 key
  if [[ "$key" == "q" ]]; then
    echo
    echo "Exiting..."
    kill "$MON_PID" 2>/dev/null
    wait "$MON_PID" 2>/dev/null
    exit 0
  fi
done
