#!/usr/bin/expect -f

# exit 只能返回 0到255
# PASSWD_ERROR is Permission denied
# KEY_ERROR is Host key verification failed
# REFUSED_ERROR is Connection refused

set PASSWD_ERROR 3   
set KEY_ERROR 4
set REFUSED_ERROR 5  

# 设置信号 修改窗口大小
trap {
 set rows [stty rows]
 set cols [stty columns]
 stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

set user [lindex $argv 0] 
set pass [lindex $argv 1] 
set host [lindex $argv 2]
set port [lindex $argv 3]
set local [lindex $argv 4]
set origin [lindex $argv 5]
set timeout 30
spawn scp -P${port} -r ${user}@${host}:${local} ${origin}
expect {
  -re "Connection refused"
  {
      exit ${REFUSED_ERROR}
  }
  -re "Host key verification failed"
  {
      exit ${KEY_ERROR}
  }
  -re "Permission denied"
  {
      # send_user "向用户输出信息"
      send "exit\r"
      exit ${PASSWD_ERROR}
  }
  -re "Are you sure you want to"
  {
      send "yes\r"
      # 进入下一次循环执行字符匹配
      exp_continue
  }
  -re "password:"
  {
      send "$pass\r"
      exp_continue
  }
  -re "#"
  {
      interact
  }

}

