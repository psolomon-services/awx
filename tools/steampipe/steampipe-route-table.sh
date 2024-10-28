#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')              AS account,
  rt.region,
  rt.tags->>'Name'                                                                    AS name_tag,
  rt.route_table_id,
  rt.routes[0]->>'DestinationCidrBlock'                                               AS cidr1,
  rt.routes[0]->>'GatewayId'                                                          AS gw_id1,
  rt.routes[1]->>'DestinationCidrBlock'                                               AS cidr2,
  rt.routes[1]->>'GatewayId'                                                          AS gw_id2,
  v.tags->>'Name' AS vpc_name,
  rt.vpc_id,
  CASE WHEN rt.tags->>'Owner' IS NOT NULL THEN rt.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN rt.tags->>'CreatedBy' IS NOT NULL THEN rt.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_vpc_route_table rt
INNER JOIN
  aws_account a ON a.account_id = rt.account_id
INNER JOIN
  aws_vpc v ON v.account_id = rt.account_id
-- WHERE
  -- rt.tags->>'Owner' = 'psolomon'
      -- rt.tags->>'Name' NOT LIKE '%default%'  
  -- rt.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  rt.tags->>'Name'
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
