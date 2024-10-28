#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<QUERY0
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  cf.region,
  cf.name,
  cf.status,
  CASE WHEN cf.tags->>'Owner' IS NOT NULL THEN cf.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN cf.tags->>'CreatedBy' IS NOT NULL THEN cf.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_cloudformation_stack cf
INNER JOIN
  aws_account a ON a.account_id = cf.account_id
-- WHERE
  -- cf.tags->>'Owner' = 'psolomon'
      -- cf.tags->>'Name' NOT LIKE '%default%'  
ORDER BY
  account,
  cf.name
QUERY0
)

steampipe query --search-path ${SEARCH_PATH} "$QUERY"
#steampipe query --output csv --search-path ${SEARCH_PATH} "$QUERY" | tr -d '"'
