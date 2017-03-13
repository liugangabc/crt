#!/bin/bash -ex

ARGS=`getopt -o hlg:p:s: --long help,list,put:,get:,ssh: -n 'gogo' -- "$@"`

if [ $? != 0 ]; then
  echo "-h or --help"
  exit 1
fi


ROOT=~/proj/crt
CONF_PATH=${ROOT}/conf/host
GO_PATH=${ROOT}/modules/ssh.sh
PUT_PATH=${ROOT}/modules/put.sh
GET_PATH=${ROOT}/modules/get.sh

if [ ! -f "$HOME/host" ]; then 
  CONF_PATH=$HOME/host
fi

while true;
do 
   case "$1" in
     -l|--list)
       echo "==============="
       awk '{print $1"\t"$2"\t"$3}' ${CONF_PATH}
       echo "==============="
       shift
       ;;
     -s|--ssh)
       PA=$(grep ^$2 ${CONF_PATH})
       AA=(${PA})
       IP=${AA[1]}
       PORT=${AA[2]}
       USER=${AA[3]}
       PW=${AA[4]}
       ${GO_PATH} ${USER} ${PW} ${IP} ${PORT}
       shift
       shift
       ;;
     -g|--get)
       PA=$(grep ^$2 ${CONF_PATH})
       AA=(${PA})
       IP=${AA[1]}
       PORT=${AA[2]}
       USER=${AA[3]}
       PW=${AA[4]}
       ${GET_PATH} ${USER} ${PW} ${IP} ${PORT} $3 $4
       shift
       shift
       shift
       ;;
     -p|--put)
       PA=$(grep ^$2 ${CONF_PATH})
       AA=(${PA})
       IP=${AA[1]}
       PORT=${AA[2]}
       USER=${AA[3]}
       PW=${AA[4]}
       ${PUT_PATH} ${USER} ${PW} ${IP} ${PORT} $3 $4
       shift
       shift
       shift
       ;;
     *) break ;;
   esac
done
