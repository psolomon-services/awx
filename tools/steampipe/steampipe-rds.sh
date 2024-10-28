#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')                AS account,
  rds.region,
  rds.tags->>'Name'                                                                     AS name_tag,
  rds.status,
  rds.activity_stream_status                                                            AS status_stream,
  rds.engine,
  rds.engine_version,
  rds.master_user_name                                                                  AS user,
  CASE WHEN rds.tags->>'Owner' IS NOT NULL THEN rds.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN rds.tags->>'CreatedBy' IS NOT NULL THEN rds.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_rds_db_cluster rds
INNER JOIN
  aws_account a ON a.account_id = rds.account_id
-- WHERE
  -- rds.tags->>'Owner' = 'psolomon'
      -- rds.tags->>'Name' NOT LIKE '%default%'  
  -- AND rds.tags->>'Owner' = 'psolomon'
  -- rds.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  rds.region,
  name_tag
EOF
)

OUTPUT=$(steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}")

RED='\033[0;31m'
NC='\033[0m' # No Color
printf "${RED}$OUTPUT${NC}\n"
