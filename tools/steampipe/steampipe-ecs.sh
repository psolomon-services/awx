#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<QUERY0
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  e.cluster_name,
  e.region,
  e.status,
  e.attachments_status AS attach_status,
  REPLACE(e.capacity_providers[0]::text, '"', '')                                         AS provider,
  CASE WHEN e.tags->>'Owner' IS NOT NULL THEN e.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN e.tags->>'CreatedBy' IS NOT NULL THEN e.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_ecs_cluster e
INNER JOIN
  aws_account a ON a.account_id = e.account_id
-- WHERE
  -- e.tags->>'Owner' = 'psolomon'
      -- e.tags->>'Name' NOT LIKE '%default%'  
ORDER BY
  account,
  e.tags->>'Name'
QUERY0
)

steampipe query --search-path ${SEARCH_PATH} "$QUERY"
#steampipe query --output csv --search-path ${SEARCH_PATH} "$QUERY" | tr -d '"'
