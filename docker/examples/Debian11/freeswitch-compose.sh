#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
compose_file="${script_dir}/compose.yaml"
command_name="${1:-up}"

usage() {
	cat <<'EOF'
Usage: ./freeswitch-compose.sh [command]

Commands:
  up       Build the image and start FreeSWITCH in the background (default)
  build    Build or rebuild the image
  down     Stop and remove the container
  restart  Restart the container
  status   Show container and FreeSWITCH status
  logs     Follow container logs
  cli      Open an interactive fs_cli session
EOF
}

case "${command_name}" in
	-h|--help|help)
		usage
		exit 0
		;;
esac

if ! command -v docker >/dev/null 2>&1; then
	echo "error: docker is not installed or is not in PATH" >&2
	exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
	echo "error: Docker Compose v2 ('docker compose') is required" >&2
	exit 1
fi

compose() {
	docker compose -f "${compose_file}" "$@"
}

case "${command_name}" in
	up)
		compose up --detach --build
		compose ps
		;;
	build)
		compose build
		;;
	down)
		compose down
		;;
	restart)
		compose restart
		compose ps
		;;
	status)
		compose ps
		compose exec --no-TTY freeswitch /usr/local/freeswitch/bin/fs_cli -x status
		;;
	logs)
		compose logs --follow
		;;
	cli)
		compose exec freeswitch /usr/local/freeswitch/bin/fs_cli
		;;
	*)
		echo "error: unsupported command: ${command_name}" >&2
		usage >&2
		exit 2
		;;
esac
