resources:
  requests:
    cpu: 10m
    memory: 32Mi

webhook:
  resources:
    requests:
      cpu: 10m
      memory: 32Mi

certController:
  resources:
    requests:
      cpu: 10m
      memory: 32Mi

serviceAccount:
  create: true
  name: external-secrets
  # if using IRSA, uncomment and set the role ARN below
  # annotations:
  #   eks.amazonaws.com/role-arn: arn:aws:iam::${AWS_ACCOUNT_ID}:role/${IAM_ROLE_NAME}
installCRDs: true