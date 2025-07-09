# Low Battery Notification Script with Systemd Autostart

A simple Bash script that runs in the background on Linux to notify you when your laptop battery is below 20% and **not charging**. It uses `notify-send` for desktop notifications and is managed by a **systemd user service** for automatic startup.

---


## Files

- `setup.sh` — Installer script that sets up dependencies, copies scripts, and enables the systemd service.
- `battery_notify.sh` — The monitoring script that sends notifications.
- `battery_notify.service` — systemd user service unit file to manage the script.

---

## Requirements

- Linux system with system d and a graphical session.
- `notify-send` (installed automatically by `setup.sh`).
- Battery info accessible at `/sys/class/power_supply/BAT*/capacity` and `/status`.

---

## Installation
```bash
#clone this repositotry
git clone https://github.com/sanjivthapasvt/Low-Battery-Notification-Script.git

#change directory and make setup.sh executable and run it.
cd Low-Battery-Notification-Script
chmod +x setup.sh
./setup.sh

```
## Usage

- The battery notification will now run automatically in the background.
- It checks battery status every minute.
- If battery is below 20% and not charging, you will get a critical notification.
- To stop the notifications manually:

  ```bash
  systemctl --user stop battery_notify.service
  ```

- To disable autostart:

  ```bash
  systemctl --user disable battery_notify.service
  ```

---

## License

MIT License — Feel free to use and modify as you like!