#!/bin/sh


. /etc/profile

CONSOLE_SERVER_PORT=19000


help()
{
   cat << HELP
Start read from mcq.
------------------------------------------
USAGE EXAMPLE: sh startReadMcq.sh
------------------------------------------
HELP
   exit 0
}

# check status
startReadMcq()
{
        echo '-- Start mq read  -----'
        printf "startReadMq\r\n" | nc localhost ${CONSOLE_SERVER_PORT}

        status=`printf "status\r\n" | nc localhost ${CONSOLE_SERVER_PORT} | grep "reading_queue" | grep "false" |wc -l`
        echo "status:$status"
}

# 0. start mq read
startReadMcq;

