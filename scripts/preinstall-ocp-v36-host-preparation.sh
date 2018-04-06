set -x
sudo -E su

# Connectivity to RHN is sometimes spotty, this function helps deal with that
retry()
{

n=0
until [ $n -ge 5 ]
  do
  $@ && break
  n=$[$n+1]
  sleep 15
done

}

#TODO:// Reference separate credentials file
retry "subscription-manager register --username=$RHN_USERNAME --password=$RHN_PASSWORD --force"
retry "subscription-manager refresh"
POOLID=$(subscription-manager list --available --matches "*OpenShift Container*" --matches "*Employee*" | grep "Pool ID" | cut -d ':' -f2 | tr -s ' ' | cut -d ' ' -f2 | tail -n 1)
echo $POOLID
retry "subscription-manager attach --pool=$POOLID"
subscription-manager repos --disable="*"
retry "yum repolist"
retry "subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-ose-3.6-rpms --enable=rhel-7-fast-datapath-rpms"
retry "yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct atomic-openshift-utils docker"

