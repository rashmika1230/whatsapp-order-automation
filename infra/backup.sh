#!/usr/bin/env bash
# Dumps the Postgres database into backups/ and keeps 14 days of dumps.
# Cron (daily at 02:00):  0 2 * * * $HOME/n8n/backup.sh >> $HOME/n8n/backups/backup.log 2>&1
set -euo pipefail
cd "$(dirname "$0")"
set -a; source .env; set +a

mkdir -p backups
ts=$(date +%F_%H%M)
docker compose exec -T postgres pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" | gzip > "backups/n8n_${ts}.sql.gz"
find backups -name 'n8n_*.sql.gz' -mtime +14 -delete
echo "$(date '+%F %T') backup ok: backups/n8n_${ts}.sql.gz"
