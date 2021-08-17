#!/bin/bash
set -e
tgpath=$1
hclpath=$2
account=$3
config=$4

if [[ $TG_DISABLE_CONFIRM == "true" ]]
then
 echo "Processing $hclpath"
 exit 0
fi

pid_file="$tgpath/.tgpid"

if [ -f "$pid_file" ]
then
  old_ppid=$(cat $pid_file)
fi
new_ppid=$PPID

if [[ $old_ppid == $new_ppid ]]
then
  echo "Processing $hclpath"
  echo "Parent PID:$new_ppid, Current PID:$$" 
  exit 0
fi

profile=$(echo $account | jq -r .aws_profile)
cluster=$(echo $account | jq -r .parameters.CLUSTER)
account_id=$(echo $account | jq -r .aws_account_id)

echo Running Environment:
echo
echo $config
echo $account | jq .
echo
echo AWS Caller Identity
aws --profile $profile sts get-caller-identity
echo
#$tgpath/modules/scripts/refresh-kube-token.sh $profile $cluster $account_id
echo "Do you confirm? (y/n)"
read confirm

if [[ "$confirm" == "y" ]]
then 
  echo $new_ppid > "$pid_file"
  echo "Process $new_ppid Confirmed."
  exit 0
else
  echo "Process $new_ppid Cancelled."
  exit 1
fi