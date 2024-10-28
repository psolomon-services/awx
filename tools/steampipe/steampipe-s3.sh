#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')              AS account,
  s3.region,
  s3.name,
  s3.tags->>'Name'                                                                    AS name_tag,
  CASE WHEN s3.tags->>'Owner'     IS NOT NULL THEN s3.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN s3.tags->>'CreatedBy' IS NOT NULL THEN s3.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_s3_bucket s3
INNER JOIN
  aws_account a ON a.account_id = s3.account_id
-- WHERE
  -- s3.tags->>'Owner' = 'psolomon'
      -- s3.tags->>'Name' NOT LIKE '%default%'  
  -- s3.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  region,
  name_tag
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
