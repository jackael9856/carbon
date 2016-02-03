#!/bin/sh


. /etc/profile

CONSOLE_SERVER_PORT=19000


help()
{
   cat << HELP
Stop read from mcq.
------------------------------------------
USAGE EXAMPLE: sh stopReadMcq.sh
------------------------------------------
HELP
   exit 0
}

# check status
stopReadMcq()
{
        echo '-- stop mq read  -----'
        while [ 1 ]; do
                status=`printf "status\r\n" |nc localhost ${CONSOLE_SERVER_PORT} |grep "reading_queue" | grep "false" |wc -l`
                echo "status:$status"
                if [ "$status" = "1" ]; then
                        echo 'Stop reading mcq.';
                        echo 'Sleep 10s wait for leaving mcq process, plz wait.';
                        sleep 10;
                        break;
                else
                        printf "stopReadMq\r\n" |nc localhost ${CONSOLE_SERVER_PORT}
                        sleep 1s;
                fi
        done
        echo 'Stop reading mcq SUCCESS!';
}

# 0. stop mq read
stopReadMcq;

