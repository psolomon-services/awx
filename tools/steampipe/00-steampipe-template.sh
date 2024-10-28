#!/usr/bin/env bash

# REMOVE THESE COMMENTS BEFORE CHECKING IN
# simple template script for steampipe queries
# - allows a steampipe search path to be injected via env variable
# - includes JOIN for account names (default steampipe queries only include account_id)
# - example of included AWS tags

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<QUERY0
  -- SELECT
  --   jsonb_array_elements(a.account_aliases) AS account,
  -- REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '') AS account,
  --   e.instance_id,
  --   e.title,
  --   e.tags->>'Name' AS name_tag,
  --   e.tags->>'Backup' AS backup_tag,
  --   e.region
  -- FROM
  --   aws_ec2_instance e
  -- INNER JOIN
  --   aws_account a on a.account_id = e.account_id
  -- WHERE
  --   s.tags->>'Backup' = 'true'
  -- ORDER BY
  --   account,
  --   e.title
QUERY0
)

steampipe query --search-path ${SEARCH_PATH} "$QUERY"
#steampipe query --output csv --search-path ${SEARCH_PATH} "$QUERY" | tr -d '"'
