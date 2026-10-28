#!/usr/bin/env bash
# Rebuilds both databases from scratch and loads the sample data.
# Run it from the repository folder in Git Bash:
#     bash database/reset.sh
# Everything in lib_members and lib_catalog is deleted first.

set -e

MYSQL="${MYSQL:-/c/xampp/mysql/bin/mysql}"
cd "$(dirname "$0")"

# fine and loan point at each other across the two databases,
# so foreign key checks are switched off while dropping them.
"$MYSQL" -u root -e "SET FOREIGN_KEY_CHECKS=0;
  DROP DATABASE IF EXISTS lib_catalog;
  DROP DATABASE IF EXISTS lib_members;"

for f in 01_lib_members.sql 02_lib_catalog.sql 03_fine_and_view.sql 04_seed.sql; do
  echo "Loading $f"
  "$MYSQL" -u root --default-character-set=utf8mb4 < "$f"
done

echo "Done: lib_members and lib_catalog are ready."
