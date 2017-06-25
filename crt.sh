#!/bin/bash

# Debug switch
# set -ex

# Init

PASSWD_ERROR=3
KEY_ERROR=4
REFUSED_ERROR=5

ROOT=/etc/crt
CONF_PATH=${ROOT}/conf/host
GO_PATH=${ROOT}/modules/ssh.sh
PUT_PATH=${ROOT}/modules/put.sh
GET_PATH=${ROOT}/modules/get.sh

readonly PASSWD_ERROR
readonly KEY_ERROR
readonly REFUSED_ERROR
readonly ROOT=/etc/crt
readonly GO_PATH=${ROOT}/modules/ssh.sh
readonly PUT_PATH=${ROOT}/modules/put.sh
readonly GET_PATH=${ROOT}/modules/get.sh


# The function of the prompt usage information 
function usage {
echo '''usage: crt {-l|--list|-h|--help}
       crt [-s] <host name>
       crt { [-pg] <host name> path path}
         -l, --list               show host table -l
         -s, --ssh                ssh host -s Name
         -p, --put                upload files from locacl path to host path -p Name ./localfile.txt /mnt/
         -g, --get                download files from host path to local path -g Name /root/orginfile.txt ./'''
exit 0
}

# "h\l" not parameter, "g\p\s" [:]must be parameters, [::] must be Follow closely parameters
ARGS=`getopt -o hlg:p:s: --long help,list,put:,get:,ssh:: -n 'crt' -- "$@"`

# Determines whether the "getopt" function is successful or not
if [ $? != 0 ]; then
   usage
fi

# must be parameters
if [ $# = 0 ]; then
    usage
fi

# determines whether "~/.host" file
if [ -f "$HOME/.host" ]; then 
  CONF_PATH=$HOME/.host
fi

# =~ 正则匹配
# if [[ "${ARGS[*]}" =~ "-l" ]]; then
#   echo "-l in ARGS"
# fi

InitParameters(){
  Init_status=$(grep ^${1} ${CONF_PATH} || echo 1)
  if [ "${Init_status}" == "1" ]; then
    echo -e "\n \033[41;37m ERROR: Name not exist !!! \033[0m"
    awk '{print $1"\t"$2"\t"$3}' ${CONF_PATH}
    exit 1
  fi
  Param_string=$(grep ^${1} ${CONF_PATH})
  # Convert string into array
  Param_arrays=(${Param_string})
  IP=${Param_arrays[1]}
  PORT=${Param_arrays[2]}
  USER=${Param_arrays[3]}
  PW=${Param_arrays[4]}
  CMD="${2} ${USER} ${PW} ${IP} ${PORT} ${3} ${4}"
  unset Init_status
  unset Param_string
  unset Param_arrays
  unset IP
  unset PORT
  unset USER
  unset PW
}


while true;
do 
   case "$1" in
     -h|--help)
       usage
       ;;
     -l|--list)
       echo ""
       awk '{print $1"\t"$2"\t"$3}' ${CONF_PATH}
       echo ""
       exit 0
       ;;
     -s|--ssh)
       InitParameters ${2} ${GO_PATH}
       break
       ;;
     -g|--get)
       InitParameters ${2} ${GET_PATH} $3 $4
       break
       ;;
     -p|--put)
       InitParameters ${2} ${PUT_PATH} $3 $4
       break
       ;;
     *) usage ;;
   esac
done

ExceptionHandling(){
  ${1}
  STATUS_CODE=$?
  if [ ${STATUS_CODE} == ${KEY_ERROR} ]; then
     echo -e "\n \033[43;37m WARNING: known_hosts expire !!! \033[0m"
     echo "" > ~/.ssh/known_hosts
     ExceptionHandling "${1}"
  elif [ ${STATUS_CODE} == ${PASSWD_ERROR} ]; then
     echo -e "\n \033[41;37m ERROR: Password error !!! \033[0m"
  elif [ ${STATUS_CODE} == ${REFUSED_ERROR} ]; then
     echo -e "\n \033[41;37m ERROR: Connection refused !!! \033[0m"
  fi
  unset STATUS_CODE
}

ExceptionHandling "${CMD}"
exit 0
