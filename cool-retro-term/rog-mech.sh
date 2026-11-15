#!/usr/bin/env bash
# Opens cool-retro-term in the ROG Mech profile (bound to SUPER + ALT + T).
# cool-retro-term only knows profiles stored in its own database, and every
# instance rewrites that list on exit, so the profile is restored from
# rog-mech.json before each launch. Only --profile works; -p is ignored.
dir=$(dirname "$(readlink -f "$0")")
db=${XDG_DATA_HOME:-$HOME/.local/share}/cool-retro-term/cool-retro-term/QML/OfflineStorage/Databases/27e743fe85b8912a46804fed99e8a9ab.sqlite

if [ -f "$db" ]; then
  python3 -I - "$dir/rog-mech.json" "$db" <<'PY'
import json, sqlite3, sys

src, db = sys.argv[1:]
profile = json.load(open(src))
name = profile.pop("name")
profile.pop("version", None)

con = sqlite3.connect(db, timeout=5)
row = con.execute("SELECT value FROM settings WHERE setting = '_CUSTOM_PROFILES'").fetchone()
profiles = [p for p in json.loads(row[0] if row else "[]") if p.get("text") != name]
profiles.append({"text": name, "obj_string": json.dumps(profile), "builtin": False})
con.execute("INSERT OR REPLACE INTO settings VALUES ('_CUSTOM_PROFILES', ?)", (json.dumps(profiles),))
con.commit()
PY
fi

# cool-retro-term can't parse fish's kitty keyboard protocol request (ESC[=5u)
# and prints "5u" at each prompt, so fish runs without it here.
[ $# -eq 0 ] && set -- -e fish --features no-keyboard-protocols
exec cool-retro-term --profile "ROG Mech" "$@"
