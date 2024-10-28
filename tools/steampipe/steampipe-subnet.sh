#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  s.region,
  s.tags->>'Name'                                                                   AS name_tag,
  s.subnet_id,
  cidr_block                                                                        AS cidr,
  CASE WHEN s.tags->>'Owner' IS NOT NULL THEN s.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN s.tags->>'CreatedBy' IS NOT NULL THEN s.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_vpc_subnet s
INNER JOIN
  aws_account a ON a.account_id = s.account_id
-- WHERE
  -- s.tags->>'Owner' = 'psolomon'
      -- s.tags->>'Name' NOT LIKE '%default%'  
  -- s.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  tags->>'Name'
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
