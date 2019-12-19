## DEPLOYING

#### overview 

cloudformation create-stack

connect to windows host and plink manually to get bouncybox ssh hash
update task scheduler with hash and bouncybox ip

update client rdp file with bouncybox ip


#### `cloudformation create-stack`

```
CLIENT_IP=`curl icanhazip.com` #run from client
WORKSPACE_IP=`curl icanhazip.com` #run from workspace
aws --region us-west-2 cloudformation create-stack --stack-name my-bouncybox --template-body file://bouncybox.yaml --parameters ParameterKey=Username,ParamterValue=james ParameterKey=GithubUsername,ParamterValue=jamesandariese ParameterKey=ClientIp ParamterValue=$CLIENT_IP ParameterKey=WorkspaceIp ParamterValue=WORKSPACE_IP
```

#### update client rdp file and task scheduler definition

run `./gen-artifacts.sh {BOUNCYBOXIP}` to create the following files:

- `chrome.rdp`
  RDP connection profile for use from the client host to connect to workspace via bouncybox proxy
- `plink_to_bouncybox.xml`
  Task Scheduler definition to maintain plink connection from workspace to bouncybox
  Import this on your workspace
