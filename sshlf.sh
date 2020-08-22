#!/bin/sh
# SSH LocalForward on MacOS
#      -L [bind_address:]port:host:hostport
#      -L [bind_address:]port:remote_socket
# bind [127.AAA.BBB.CCC]:PPPP: Can't assign requested address
# channel_setup_fwd_listener_tcpip: cannot listen to port: PPPP
# Could not request local forwarding.

usage() { echo "Usage: $0 <IP> <FQDN>" 1>&2; exit 1; }

[ $# -eq 0 ] && usage
[ $# -eq 1 ] && usage
[ $# -ge 3 ] && usage
SSHLFIP=$1
SSSHLFHOSTNAME=$2

# Cleaning...
ifconfig lo0 | grep $SSHLFIP >> /dev/null
if [ $? -eq 0 ]
then
  sudo ifconfig lo0 inet $SSHLFIP netmask 0xff000000 delete
fi
sudo sed -i '' "/^$SSHLFIP/d" /etc/hosts
sudo sed -i '' "/$SSSHLFHOSTNAME/d" /etc/hosts

# Add Alias
sudo ifconfig lo0 alias $SSHLFIP 255.255.255.0
sudo bash -c "
cat >> /etc/hosts << EOF
$SSHLFIP    $SSSHLFHOSTNAME   #Added by $0
EOF
"
