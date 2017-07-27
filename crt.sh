#!/bin/bash

# Debug switch
# set -ex

# Init

HOST_NOT_EXIST=1
PASSWD_ERROR=3
KEY_ERROR=4
REFUSED_ERROR=5
TIMEOUT_ERROR=124


ROOT=/etc/crt
CONF_PATH=${ROOT}/conf/host
GO_PATH=${ROOT}/modules/ssh.sh
PUT_PATH=${ROOT}/modules/put.sh
GET_PATH=${ROOT}/modules/get.sh

readonly PASSWD_ERROR
readonly KEY_ERROR
readonly REFUSED_ERROR

readonly ROOT
readonly GO_PATH
readonly PUT_PATH
readonly GET_PATH


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

Exception(){
  case ${1} in
     ${KEY_ERROR})
        echo -e "\n\033[43;37m WARNING: known_hosts expire \033[0m"
        echo "" > ~/.ssh/known_hosts
        EXE "${CMD}"
        ;;
     ${PASSWD_ERROR})
        echo -e "\n\033[41;37mERROR: Password error \033[0m"
        exit 1
        ;;
     ${REFUSED_ERROR})
        echo -e "\n\033[41;37mERROR: Connection refused \033[0m"
        exit 1
        ;;
     ${HOST_NOT_EXIST})
        echo -e "\n\033[41;37mERROR: Name not exist \033[0m"
        awk '{print $1"\t"$2"\t"$3}' ${CONF_PATH}
        exit 1
        ;;
     ${TIMEOUT_ERROR})
        echo -e "\n\033[41;37mERROR: Connection Timeout \033[0m"
        exit 1
        ;;
     *) ;;
   esac
}

EXE(){
  if [ -n "${2}" ]; then
    # eval主要用在对参数的特殊处理上面的，一般的命令行，shell处理参数就只执行一遍，像转义和变量转变；
    # 但加上eval后就可以对参数经行两遍处理
     STATUS_CODE=$(eval ${1})
     Exception ${STATUS_CODE}
  else
     ${1}
     STATUS_CODE=$?
     Exception ${STATUS_CODE}
  fi
}

InitParameters(){
  # $(cmd) can run script
  # Init_status=$(grep ^${1} ${CONF_PATH} || echo 1)
  EXE "grep '^${1}[[:space:]]' ${CONF_PATH} || echo 1" 1
  Param_string=$(grep "^${1}[[:space:]]" ${CONF_PATH})
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


# __main__

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
       InitParameters ${2} ${GET_PATH} ${3} ${4}
       break
       ;;
     -p|--put)
       InitParameters ${2} ${PUT_PATH} ${3} ${4}
       break
       ;;
     *) usage ;;
   esac
done

EXE "${CMD}"
exit 0
