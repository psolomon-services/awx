#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  v.region,
  v.title,
  v.vpc_id,
  CASE WHEN v.tags->>'Owner' IS NOT NULL THEN v.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN v.tags->>'CreatedBy' IS NOT NULL THEN v.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_vpc v
INNER JOIN
  aws_account a ON a.account_id = v.account_id
-- WHERE
  -- v.tags->>'Owner' = 'psolomon'
      -- v.tags->>'Name' NOT LIKE '%default%'  
  -- v.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  title
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
