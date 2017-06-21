#!/usr/bin/expect

trap {
 set rows [stty rows]
 set cols [stty columns]
 stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

set user [lindex $argv 0]  
set pass [lindex $argv 1]  
set host [lindex $argv 2]  
set port [lindex $argv 3]  
set timeout 30
spawn ssh -l $user $host -p $port
# puts "password: $pass"
expect {
  -re "ssh-keygen -f"
  {
    exit 403
  }
  -re "Are you sure you want to"
  {
    send "yes\r"
    exp_continue
  }
  -re "password:"
  {
    send "$pass\r"
  }
}

interact
