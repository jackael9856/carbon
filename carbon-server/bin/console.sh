#!/bin/sh

baseDir=`dirname $PWD`
SERVER_NAME=remind-sync
# path
BIN_PATH=../bin
LOG_PATH=../logs
LIB_PATH=../lib
# 
nowday=`date +%Y%m%d_%H%M%S`
test -d $LOG_PATH || mkdir $LOG_PATH
test -f $LOG_PATH/stdout.log || touch $LOG_PATH/stdout.log
test -d ../gclogs || mkdir ../gclogs
# 
CLASS_NAME=com.weibo.api.remind.sync.boot.RemindSyncBootstrap
CLASS_PATH=../conf

# 
for f in $LIB_PATH/*.jar
do
    CLASS_PATH=$CLASS_PATH:$f;
done
#
#PROGRAM_ARGS="-Xms5g -Xmx5g -Xmn1300m -XX:+UseConcMarkSweepGC -DServer=$SERVER_NAME  -Dunread.home=$baseDir -server -XX:SurvivorRatio=5 -XX:CMSInitiatingOccupancyFraction=80 -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCDateStamps  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data1/monitor/memory.hprof -Xloggc:../gclogs/gc.log.$nowday -Xdebug -Xrunjdwp:transport=dt_socket,address=18787,server=y,suspend=n"

PROGRAM_ARGS="-server -Xms3600m -Xmx3600m -Xmn1500m -Xss512k -DServer=$SERVER_NAME -XX:PermSize=196m -XX:MaxPermSize=196m -XX:+UseParallelOldGC -XX:+UseAdaptiveSizePolicy -XX:ParallelGCThreads=6 -XX:+PrintFlagsFinal -XX:+PrintCommandLineFlags -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintGCApplicationConcurrentTime -Xloggc:../gclogs/gc.log.$nowday"

 
PIDFILE=./remind-sync.pid

# 
STDOUT=$LOG_PATH/stdout.log
STDERR=$LOG_PATH/stderr.log

start()
{
if test -e $PIDFILE
        then
                echo
                echo The $SERVER_NAME Server already Started!
                echo
        else
                echo
                echo Start The $SERVER_NAME Server....
                echo
                $JAVA_HOME/bin/java $PROGRAM_ARGS -classpath $CLASS_PATH $CLASS_NAME >>$STDOUT 2>>$STDERR &
                echo $!>$PIDFILE
                sleep 2
                STATUS=`ps -p $!|grep java |awk '{print $1}'`
                if test $STATUS
                        then
                                echo The $SERVER_NAME Server Started!
                                echo
                        else
                                rm $PIDFILE
				echo The $SERVER_NAME Server Start Failed
                                echo please Check the system
                                echo
                fi
fi
}

stop()
{
if test -e $PIDFILE
        then
                echo
                echo Stop The $SERVER_NAME Server....
                echo
                TPID=`cat $PIDFILE`
                kill -9 $TPID
                sleep 1
                STATUS=`ps -p $TPID |grep java | awk '{print $1}'`
                if test $STATUS
                        then
                                echo The $SERVER_NAME Server NOT Stoped!
                                echo please Check the system
                                echo
                        else
                                echo The $SERVER_NAME Server Stoped
                                echo
                                rm $PIDFILE
                fi
        else
                echo
                echo The $SERVER_NAME Server already Stoped!
                echo
fi
}



status()
{
echo
if test -e $PIDFILE
        then
                TPID=`cat $PIDFILE`
                STATUS=`ps -p $TPID|grep java | awk '{print $1}'`
                if test $STATUS
                        then
                             #   echo "The $SERVER_NAME Server Running($TPID)!"
                                echo
                        else
                             #   echo The $SERVER_NAME Server NOT Running!
                                rm $PIDFILE
                                echo
                fi
        else
                echo
               # echo The $SERVER_NAME Server NOT Running!
                echo
fi
}

status
case "$1" in
'start')
                start
        ;;
'stop')
                stop
        ;;
'status')
                status
        ;;
*)
        echo
        echo
        echo "Usage: $0 {status | start | stop }"
        echo
        echo Status of $SERVER_NAME Servers ......
                status
        ;;
esac
exit 0
