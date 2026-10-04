#!/bin/sh
echo "Content-Type: text/plain; charset=utf-8"
echo

service=llama-serve.service

if ! command -v systemctl >/dev/null 2>&1; then
    echo "systemctl introuvable — impossible de relancer $service"
    exit 1
fi

echo "Relance de $service…"
systemctl restart "$service"
rc=$?

if [ "$rc" -eq 0 ]; then
    state=$(systemctl is-active "$service" 2>/dev/null)
    case "$state" in
        active)   echo "$service est actif" ;;
        failed)   echo "$service a échoué au démarrage" ;;
        *)        echo "$service est $state" ;;
    esac
else
    echo "Échec de la relance ($service), code $rc"
    systemctl status "$service" --no-pager 2>&1 | head -n 20
fi
