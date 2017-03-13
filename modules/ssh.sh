#!/usr/bin/expect

set user [lindex $argv 0]  
set pass [lindex $argv 1]  
set host [lindex $argv 2]  
set port [lindex $argv 3]  
set timeout 30
spawn ssh -l $user $host -p $port
puts "password: $pass"
expect {
  -re "Are you sure you want to" 
  {
    send "yes\r"
    expect "password:"
    send "$pass\r"
  } 
  -re "password:"
  {
    send "$pass\r"
  }
}
#expect "password:"
#send "$pass\r"
interact
