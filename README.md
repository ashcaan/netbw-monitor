# netbw-monitor

A lightweight, interactive **real-time network throughput monitor** for Linux systems.

This script measures **actual network throughput (RX/TX)** per interface in **MB/s** by sampling kernel counters from `/proc/net/dev`. It is designed for troubleshooting, validation, and performance analysis scenarios where installing additional packages is not desirable or possible.

---

## When to use this script

This tool is especially useful in the following cases:

- Investigating **slow backup or replication performance**
- Verifying **real network throughput** during large data transfers
- Validating NIC, switch port, or cabling performance
- Troubleshooting environments where:
  - Multiple jobs share available network bandwidth
  - Traditional tools (`iftop`, `nload`, etc.) are not installed
  - Package installation is restricted (appliances, hardened systems)

Unlike cumulative traffic counters, this script reports **true real-time throughput**, making it ideal for live diagnostics.

---

## Key features

- Real-time RX/TX throughput in **MB/s**
- Interactive interface selection
- Displays **available network interfaces**
- Optional display of negotiated link speed (when supported by the driver)
- Press **`q` to quit** (similar to `top` or `less`)
- No external dependencies
- Works over SSH
- Portable across:
  - CentOS 6
  - CentOS 7
  - AlmaLinux 9
  - Other RHEL-based distributions

---

## Installation

No installation is required.

Download the script directly from GitHub:

```bash
wget https://raw.githubusercontent.com/ashcaan/netbw-monitor/refs/heads/main/netbw.sh
