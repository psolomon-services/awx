#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')              AS account,
  gw.region,
  gw.tags->>'Name'                                                                    AS name_tag,
  gw.internet_gateway_id                                                              AS gw_id,
  gw.attachments[0]->>'VpcId'                                                         AS vpc_id,
  CASE WHEN gw.tags->>'Owner'     IS NOT NULL THEN gw.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN gw.tags->>'CreatedBy' IS NOT NULL THEN gw.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_vpc_internet_gateway gw
INNER JOIN
  aws_account a ON a.account_id = gw.account_id
-- WHERE
  -- gw.tags->>'Owner' = 'psolomon'
      -- gw.tags->>'Name' NOT LIKE '%default%'  
  -- gw.tags->>'Owner' = 'psolomon'
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
