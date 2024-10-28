#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  l.region,
  name,
  l.runtime,
  l.architectures[0]                                                                AS arch,
  CASE WHEN l.tags->>'Owner'     IS NOT NULL THEN l.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN l.tags->>'CreatedBy' IS NOT NULL THEN l.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_lambda_function l
INNER JOIN
  aws_account a ON a.account_id = l.account_id
-- WHERE
  -- l.tags->>'Owner' = 'psolomon'
      -- l.tags->>'Name' NOT LIKE '%default%'  
  -- l.state != 'deleted'
  -- AND l.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  name
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
