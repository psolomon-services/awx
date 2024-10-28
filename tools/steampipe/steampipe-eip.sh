#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  e.region,
  e.tags->>'Name'                                                                   AS name_tag,
  CASE WHEN e.tags->>'Owner' IS NOT NULL THEN e.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN e.tags->>'CreatedBy' IS NOT NULL THEN e.tags->>'CreatedBy' ELSE '-' END AS createdby_tag,
  e.association_id                                                                  AS assoc_id,
  e.allocation_id                                                                   AS alloc_id,
  e.private_ip_address                                                              AS private_ip,
  e.public_ip
FROM
  aws_vpc_eip e
INNER JOIN
  aws_account a ON a.account_id = e.account_id
-- WHERE
  -- e.tags->>'Owner' = 'psolomon'
      -- e.tags->>'Name' NOT LIKE '%default%'  
  -- AND e.tags->>'Owner' = 'psolomon'
  -- e.tags->>'Owner' = 'psolomon'
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
