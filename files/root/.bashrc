gstatus()
{
  git status
}

gbranch()
{
  if [ -z ${1+x} ]
  then
    git branch
  else
    git checkout ${1}
  fi
}

gcheckout()
{
  git checkout ${1}
}

gnewbranch()
{
  export branchname="$(echo ${1} | tr ' ' '_')"
  echo "Create new branch - ${branchname}"

  git checkout -b "${branchname}" origin/${2:-develop}
}

gdelbranch()
{
  git branch -D ${1}
}

grebase()
{
  git stash
  git pull --rebase origin ${1:-develop} ${2}
  git stash pop
}

gpush()
{
  git push -u origin ${1} ${2}
}

bump()
{
  ENV=test OVERRIDE_SERVICES=${1}  make bump
  ENV=test OVERRIDE_SERVICES=${1}  make prepare
  #ENV=test OVERRIDE_SERVICES=${1} ./scripts/wrapper.sh make plan
}

test_instance_up()
{
   TEST_INSTANCE_AMI=${1}
   aws --profile test ec2 run-instances \
      --image-id ${TEST_INSTANCE_AMI} \
      --count 1 \
      --instance-type t2.micro \
      --security-group-ids ${TEST_SECURITY_GROUP} \
      --subnet-id ${TEST_SUBNET} \
      --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="For AMI Testing, Delete Me"}]'
}

test_instance_shell()
{
 mssh -u test "${1}"
}

ec2_tags()
{
	aws --profile ${ec2_env:=test} ec2 describe-instances | jq '.Reservations[].Instances[].Tags'
}

ec2_tags_2tsv()
{
	aws --profile ${ec2_env:=test} ec2 describe-instances | jq '.Reservations[].Instances[].Tags | @tsv'
}

context()
{
    continue
}