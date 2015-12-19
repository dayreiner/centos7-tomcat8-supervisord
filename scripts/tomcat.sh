#!/bin/bash

exec 1> >(logger -s -t $(basename $0)) 2>&1

function shutdown()
{
    date
    echo "Shutting down Tomcat"
    ${CATALINA_HOME}/bin/catalina.sh stop
}

# Allow any signal which would kill a process to stop Tomcat
trap shutdown HUP INT QUIT ABRT KILL ALRM TERM TSTP

if [ ! -f ${CATALINA_HOME}/scripts/.tomcat_admin_created ]; then
	${CATALINA_HOME}/scripts/create_admin.sh
fi

date
echo "Starting Tomcat"
export CATALINA_PID=/tmp/$$

# JAVA_OPTS Override
#export JAVA_OPTS="-Dcom.sun.management.jmxremote.port=8999 -Dcom.sun.management.jmxremote.password.file=/etc/tomcat.jmx.pwd -Dcom.sun.management.jmxremote.access.file=/etc/tomcat.jmxremote.access -Dcom.sun.management.jmxremote.ssl=false -Xms128m -Xmx3072m -XX:MaxPermSize=256m -Djava.library.path=${CATALINA_HOME}/lindoapi/bin/linux64/liblindojni.so ${JAVA_OPTS}"

exec ${CATALINA_HOME}/bin/catalina.sh run

#echo "Waiting for `cat $CATALINA_PID`"
#wait `cat $CATALINA_PID
