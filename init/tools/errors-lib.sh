# Library of some common Shell commands:

# Write log messages to STDERR, prefixing each item after $1 (i.e. $2...)
# with the contents of $1:
log() {
  log_level="$1"; shift
  [[ "$log_level" ]] && log_level="${log_level}:"
  for message in "$@"; do
    echo "#${log_level} ${message}" >&2
  done
}

# Exit if $1 != "" or "continue":
exitp() {
  [ "$1" = "exit" ] && exit 1
  [ -z "$1" ] || [ "$1" = "continue" ] || exit
}

# Run the given command (in $2...) and then exit with $1 as the status code:
eval_exit_code() {
  exit_code="${1:-0}"; shift
  [ -n "$*" ] && "$@"
  [ -n "${exit_code}" ] || exit
  exit "${exit_code}"
}

# "Run" the given args as a command, then exit with status code 1:
eval_exit() {
  eval_exit_code 1 "$@"
}

# Log the given args as an Error;  i.e. log each arg, prefixing with "ERR":
log_error() {
  log ERR "$@"
}

# Log the given args as an Error;  i.e. log each arg, prefixing with "WARN":
log_warn() {
  log WARN "$@"
}

# Log the given args as an Error;  i.e. log each arg, prefixing with "WARN":
log_info() {
  log "" "$@"
}
