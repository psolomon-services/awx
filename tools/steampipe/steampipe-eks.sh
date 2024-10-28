#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')                AS account,
  eks.region,
  eks.status,
  eks.tags->>'Name'                                                                     AS name_tag,
  eks.platform_version                                                                  AS version,
  CASE WHEN eks.tags->>'Owner'     IS NOT NULL THEN eks.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN eks.tags->>'CreatedBy' IS NOT NULL THEN eks.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_eks_cluster eks
INNER JOIN
  aws_account a ON a.account_id = eks.account_id
-- WHERE
  -- eks.tags->>'Owner' = 'psolomon'
      -- eks.tags->>'Name' NOT LIKE '%default%'  
  -- eks.state != 'deleted'
  -- AND eks.tags->>'Owner' = 'psolomon'
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
