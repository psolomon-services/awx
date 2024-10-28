#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

for LBTYPE in application network classic gateway
do
  printf "${GREEN}LB Type:  ${BLUE}${LBTYPE}${NC}\n"
  QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')              AS account,
  lb.region,
  lb.title,
  CASE WHEN lb.tags->>'Owner' IS NOT NULL THEN lb.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN lb.tags->>'CreatedBy' IS NOT NULL THEN lb.tags->>'CreatedBy' ELSE '-' END AS createdby_tag,
  lb.vpc_id,
  lb.dns_name
FROM
  aws_ec2_${LBTYPE}_load_balancer lb
INNER JOIN
  aws_account a ON a.account_id = lb.account_id
-- WHERE
  -- lb.tags->>'Owner' = 'psolomon'
     -- lb.tags->>'Name' NOT LIKE '%default%'
  -- AND lb.tags->>'Owner' = 'psolomon'
  -- lb.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  lb.region,
  lb.title
EOF
  )

  OUTPUT=$(steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}")
  printf "${RED}$OUTPUT${NC}\n"
done
