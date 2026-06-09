#!/bin/zsh
# drafty-cron — manage LOCAL launchd jobs that mechanically refresh Drafty
# canvases. The jobs run a plain command on a schedule with NO Claude in the
# loop (no claude -p, no /loop session) — so they're free and run whether or not
# Claude is around. Claude only uses this to install/list/remove them.
#
#   drafty-cron.sh add <name> <interval_secs> <command...>
#   drafty-cron.sh ls
#   drafty-cron.sh rm <name>
#   drafty-cron.sh log <name>
set -e
AGENTS="$HOME/Library/LaunchAgents"
LOGS="$HOME/Library/Logs"
PREFIX="im.drafty.cron"

cmd="${1:-}"; shift 2>/dev/null || true
case "$cmd" in
  add)
    name="$1"; interval="$2"; shift 2
    work="$*"
    label="$PREFIX.$name"
    plist="$AGENTS/$label.plist"
    log="$LOGS/drafty-cron-$name.log"
    mkdir -p "$AGENTS" "$LOGS"
    cat > "$plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/zsh</string>
    <string>-lc</string>
    <string>$work</string>
  </array>
  <key>StartInterval</key><integer>$interval</integer>
  <key>RunAtLoad</key><true/>
  <key>StandardOutPath</key><string>$log</string>
  <key>StandardErrorPath</key><string>$log</string>
</dict>
</plist>
PLIST
    launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$plist"
    echo "✓ scheduled $label every ${interval}s"
    echo "  log: $log"
    ;;
  ls)
    launchctl list 2>/dev/null | grep "$PREFIX" || echo "(no drafty crons)"
    ;;
  rm)
    name="$1"; label="$PREFIX.$name"
    launchctl bootout "gui/$(id -u)/$label" 2>/dev/null || true
    rm -f "$AGENTS/$label.plist"
    echo "✓ removed $label"
    ;;
  log)
    name="$1"; tail -n 30 "$LOGS/drafty-cron-$name.log" 2>/dev/null || echo "(no log yet for $name)"
    ;;
  *)
    echo "usage: drafty-cron.sh add <name> <interval_secs> <command...> | ls | rm <name> | log <name>"
    ;;
esac
