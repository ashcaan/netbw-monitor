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
```

## Make it executable

After downloading, make the script executable:

chmod +x netbw.sh

---

## Usage

### Interactive mode (recommended)

This mode lists available network interfaces and prompts you to select one:

./netbw.sh

Example:
Available network interfaces:
 - lo
 - eth0
 - bond0

Enter interface name: eth0

---

### Non-interactive mode

You can also specify the interface directly as an argument:

./netbw.sh eth0
./netbw.sh bond0
./netbw.sh ens192

---

## While the script is running

- Throughput is displayed once per second
- RX and TX values are shown in MB/s
- Press 'q' to exit the script cleanly

---

## Example output

Monitoring throughput on interface: eth0
Link speed (negotiated): 10000Mb/s
Press 'q' to quit.

iface=eth0 | RX: 245.12 MB/s | TX: 0.63 MB/s
iface=eth0 | RX: 251.04 MB/s | TX: 0.59 MB/s

The example above shows approximately 2 Gbps of inbound traffic.

---

## Notes and limitations

- Reported link speed reflects the negotiated NIC speed, not guaranteed throughput.
- Bonded, virtual, or logical interfaces may report link speed as Unknown. This is expected behavior.
- Throughput values represent kernel-level interface traffic, not per-process usage.
- For bonded interfaces, detailed slave information can be found in:

/proc/net/bonding/<bond_name>

---

## License

MIT License
