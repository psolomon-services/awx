#!/usr/bin/env bash

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<QUERY0
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')            AS account,
  e.region,
  e.tags->>'Name'                                                                   AS name_tag,
  e.instance_id,
  e.instance_state                                                                  AS state,
  e.instance_type                                                                   AS itype,
  e.architecture                                                                    AS arch,
  -- this adds 1-2 minutes to the query
  -- it.memory_info->>'SizeInMiB'                                                      AS mem,
  e.platform_details                                                                AS plat,
  e.cpu_options_core_count                                                          AS cores,
  CASE WHEN e.tags->>'Owner' IS NOT NULL THEN e.tags->>'Owner' ELSE '-' END         AS owner_tag,
  CASE WHEN e.tags->>'CreatedBy' IS NOT NULL THEN e.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_ec2_instance e
INNER JOIN
  aws_account a ON a.account_id = e.account_id
-- INNER JOIN
  -- aws_ec2_instance_type it ON it.instance_type = e.instance_type
WHERE
  -- e.tags->>'Owner' = 'psolomon'
      -- e.tags->>'Name' NOT LIKE '%default%'  
  e.instance_state != 'terminated'
ORDER BY
  account,
  e.title
QUERY0
)

steampipe query --search-path ${SEARCH_PATH} "$QUERY"
#steampipe query --output csv --search-path ${SEARCH_PATH} "$QUERY" | tr -d '"'
