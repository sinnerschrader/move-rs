#!/usr/bin/expect -f
set timeout 180

spawn rls --cli
 
expect "{\"jsonrpc\":\"2.0\",\"method\":\"window/progress\",\"params\":{\"done\":true,\"id\":\"progress_0\",\"title\":\"Indexing\"}}"
 
send -- "\nquit\n"

expect eof
