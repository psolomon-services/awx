#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  n.region,
  n.state,
  n.tags->>'Name'                                                                   AS name_tag,
  n.nat_gateway_id,
  n.subnet_id,
  CASE WHEN n.tags->>'Owner'     IS NOT NULL THEN n.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN n.tags->>'CreatedBy' IS NOT NULL THEN n.tags->>'CreatedBy' ELSE '-' END AS createdby_tag,
  state
FROM
  aws_vpc_nat_gateway n
INNER JOIN
  aws_account a ON a.account_id = n.account_id
-- WHERE
  -- n.tags->>'Owner' = 'psolomon'
      -- n.tags->>'Name' NOT LIKE '%default%'  
  -- n.state != 'deleted'
  -- AND n.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  name_tag
EOF
)

OUTPUT=$(steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}")

RED='\033[0;31m'
NC='\033[0m' # No Color
printf "${RED}$OUTPUT${NC}\n"
