
# sample steampipe queries:

select
  name,
  namespace,
  CONVERT_FROM(decode(data->>'ca.crt', 'base64'), 'UTF-8') AS cert
FROM
  kubernetes_secret
WHERE
      data IS NOT NULL
  AND data->>'ca.crt' IS NOT NULL;


> select
  namespace, count(namespace)
from
  kubernetes_pod group by namespace order by count desc
+--------------------+-------+
| namespace          | count |
+--------------------+-------+
| kube-system        | 15    |
| monitoring         | 9     |
| argocd             | 8     |
| awx                | 6     |
| default            | 5     |
| test-dev           | 3     |
| cert-manager       | 3     |
| external-secrets   | 3     |
| ingress-nginx      | 3     |
| argo-rollouts      | 3     |
| vault              | 2     |
| pihole             | 1     |
| test               | 1     |
| local-path-storage | 1     |
| jenkins            | 1     |
+--------------------+-------+
