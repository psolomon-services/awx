#!/usr/bin/env bash

#> select account_id from aws_account where account_aliases[0]::text LIKE '%mgmt%';
#+--------------+
#| account_id   |
#+--------------+
#| 913076961925 |
#+--------------+

ACCT=mgmt
[[ $# -ge 1 ]] && ACCT=$1

SEARCH_PATH=aws_all

QUERY=$(cat <<QUERY0
  SELECT account_id FROM aws_account WHERE account_aliases[0]::text LIKE '%${ACCT}%';
QUERY0
)

#steampipe query --search-path ${SEARCH_PATH} "$QUERY"
steampipe query --header=false --output csv --search-path ${SEARCH_PATH} "$QUERY" | tr -d '"'
