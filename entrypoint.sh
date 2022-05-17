#!/usr/bin/env bash

# The openttd content directory changes if the -c option is supplied.
# Without -c option, the content directory is ~/.local/share/openttd,
# with -c option, the content directory is the directory containing the loaded cfg.
# As workaround, we always supply the -c option, using a default config file if no custom config is present.

set -e

log() {
  echo >&2 "$*"
}

content="/data"

addgroup --gid "${PGID}" --system openttd &>/dev/null
adduser --uid "${PUID}" --system --ingroup openttd --disabled-password --home "$content" openttd &>/dev/null

cd "$content"

# openttd option arguments
args=()

# container args
if [[ $# -gt 0 ]]; then
  args+=("$*")
fi

# dedicated server mode
args+=("-D0.0.0.0:3979")

if [[ ! -f "openttd.cfg" ]]; then
  log "Creating empty config"
  touch ./openttd.cfg
fi
args+=("-c openttd.cfg")

if [[ -n $LOAD_AUTOSAVE ]]; then
  # shellcheck disable=SC2010 # ls sort by time
  latest_savegame=$(ls -t "save/autosave/" 2>/dev/null | grep -E "autosave[0-9]+.sav" | head -1)
  if [[ -n "$latest_savegame" ]]; then
    save_file="save/autosave/$latest_savegame"
  else
    log "No autosave found!"
  fi
fi

if [[ -z $save_file && -f save/template.sav ]]; then
  save_file="save/template.sav"
fi

if [[ -n $save_file ]]; then
  log "Loading save: $save_file"
  args+=("-g $save_file")
fi

chown -R openttd:openttd "$content"

log "Starting server with options: ${args[*]}"
sudo -u openttd sh -c "/usr/games/openttd ${args[*]}"
