- export variable
```
export NAME=devops.debiverse.com
export KOPS_STATE_STORE=s3://romi-d15-kops-state
```
- create bucket
```
aws s3api create-bucket --bucket romi-d15-kops-state --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1
```

- check hosted zone id
```
aws route53 list-hosted-zones | jq '.HostedZones[] | select(.Name=="devops.debiverse.com.") | .Id'
```
Output:
``` 
"/hostedzone/Z01504293VYVJ3L61O7N3"
```

- create cluster:
``` 
kops create cluster \
    --master-size t2.medium \
	--node-size t2.medium \
    --node-count 2 \
    --name=${NAME} \
    --cloud=aws \
    --zones=ap-south-1a \
    --discovery-store s3://romi-d15-kops-state/${NAME}/discovery
```

- update cluster
```
kops update cluster --name devops.debiverse.com --yes --admin
```

- delete object
```
aws s3api delete-objects \
      --bucket romi-d15-kops-state \
      --delete "$(aws s3api list-object-versions \
      --bucket <value> | \
      jq '{Objects: [.Versions[] | {Key:.Key, VersionId : .VersionId}], Quiet: false}')"
```

- Kubeconfig update
```
kops export kubecfg --admin
``` 