#!/usr/bin/env bash

#| account       | region    | name_tag                | group_id             | vpc_id                | ingress                                                                                                                                                                                                                                                                              | egress                                                                                                                                                         | owner_tag | createdby_tag |
#+---------------+-----------+-------------------------+----------------------+-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------+---------------+
#| psolomon-mgmt | us-east-1 | AWS Lab Internal-Access | sg-0a5765a3919184c39 | vpc-00e1b36319511f201 | [{"FromPort":0,"IpProtocol":"tcp","IpRanges":[],"Ipv6Ranges":[],"PrefixListIds":[],"ToPort":22,"UserIdGroupPairs":[{"Description":null,"GroupId":"sg-06f3326e057bcb963","GroupName":null,"PeeringStatus":null,"UserId":"913076961925","VpcId":null,"VpcPeeringConnectionId":null}]}] | [{"FromPort":0,"IpProtocol":"tcp","IpRanges":[{"CidrIp":"0.0.0.0/0","Description":null}],"Ipv6Ranges":[],"PrefixListIds":[],"ToPort":0,"UserIdGroupPairs":[]}] | psolomon  | terraform     |
#| psolomon-mgmt | us-east-1 | AWS Lab Web-Access      | sg-06f3326e057bcb963 | vpc-00e1b36319511f201 | [{"FromPort":0,"IpProtocol":"tcp","IpRanges":[{"CidrIp":"0.0.0.0/0","Description":null}],"Ipv6Ranges":[],"PrefixListIds":[],"ToPort":22,"UserIdGroupPairs":[]}]                                                                                                                      | [{"FromPort":0,"IpProtocol":"tcp","IpRanges":[{"CidrIp":"0.0.0.0/0","Description":null}],"Ipv6Ranges":[],"PrefixListIds":[],"ToPort":0,"UserIdGroupPairs":[]}] | psolomon  | terraform     |
#+

PROFILE=aws_all
[[ $# -ge 1 ]] && PROFILE=$1
SEARCH_PATH=${PROFILE}

QUERY=$(cat <<EOF
SELECT
  REPLACE(REPLACE(a.account_aliases[0]::text, '"', ''), 'psolomon-', '')              AS account,
  sg.region,
  sg.title,
  sg.group_id,
  sg.vpc_id,
  sg.ip_permissions[0]->>'FromPort'                                                   AS ingress_from_port1,
  sg.ip_permissions[0]->>'ToPort'                                                     AS ingress_to_port1,
  sg.ip_permissions[1]->>'FromPort'                                                   AS ingress_from_port2,
  sg.ip_permissions[1]->>'ToPort'                                                     AS ingress_to_port2,

  -- to_jsonb(sg.ip_permissions[0]->>'UserIdGroupPairs')[0]                              AS ingress_sg,
  -- sg.ip_permissions_egress                                                            AS egress,
  CASE WHEN sg.tags->>'Owner'     IS NOT NULL THEN sg.tags->>'Owner' ELSE '-' END     AS owner_tag,
  CASE WHEN sg.tags->>'CreatedBy' IS NOT NULL THEN sg.tags->>'CreatedBy' ELSE '-' END AS createdby_tag
FROM
  aws_vpc_security_group sg
INNER JOIN
  aws_account a ON a.account_id = sg.account_id
-- WHERE
  -- sg.tags->>'Owner' = 'psolomon'
      -- sg.tags->>'Name' NOT LIKE '%default%'  
  -- sg.tags->>'Owner' = 'psolomon'
ORDER BY
  account,
  sg.region,
  sg.title
EOF
)

steampipe query --output table --search-path ${SEARCH_PATH} "${QUERY}"
