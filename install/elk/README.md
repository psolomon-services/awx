# https://medium.com/@nevincansel/elk-stack-in-kubernetes-using-helm-52398564f7fc

values.txt: (for helm)

# no passwords
esConfig:
  elasticsearch.yml: |
    xpack.security.enabled: false


