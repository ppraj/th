#!/bin/bash
mkdir /opt/tomcat
yum update -y
yum install java-1.8.0-openjdk-devel httpd24 -y
service httpd start
chkconfig httpd on
yum remove java-1.7.0-openjdk -y
# calling the version may ensure that java recognizes 1.8 as the new defaut
java -version
echo "JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk/jre" | \
tee --append /etc/environment
echo "CATALINA_HOME=/opt/tomcat" | \
tee --append /etc/environment
source /etc/environment
export JAVA_HOME
export CATALINA_HOME
groupadd tomcat
useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
wget -q https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.14/bin/apache-tomcat-8.5.14.tar.gz
tar xf apache-tomcat-8.*.tar.gz -C /opt/tomcat --strip-components=1
rm -f apache-tomcat-8.5.14.tar.gz
chgrp -R tomcat /opt/tomcat/conf
chmod g+rwx /opt/tomcat/conf
chmod g+r /opt/tomcat/conf/*
chown -R tomcat /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
# sed -i -e 's/8080/<PORT_YOU_WANT_TO_RUN_ON>/g' /opt/tomcat/conf/server.xml
# remove this step to keep default of 8080
cat << EOM > /etc/init.d/tomcat
#!/bin/bash
# description: Tomcat Start Stop Restart
# processname: tomcat
# chkconfig: 234 20 80
case \$1 in
start)
sh /opt/tomcat/bin/catalina.sh start
;;
stop)
sh /opt/tomcat/bin/catalina.sh stop
;;
restart)
sh /opt/tomcat/bin/catalina.sh stop
sh /opt/tomcat/bin/catalina.sh start
;;
esac
exit 0
EOM
chmod +x /etc/init.d/tomcat
chgrp -R tomcat /opt/tomcat
chmod g+rwx /opt/tomcat/*
chown -R tomcat /opt/tomcat
chkconfig tomcat on
# exec /opt/tomcat/bin/catalina.sh start
service tomcat start
# Add a Host Manager for Tomcat8:
ex /opt/tomcat/conf/tomcat-users.xml << EOM
normal G
i
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<role rolename="admin-gui"/>
<role rolename="admin-script"/>
<user username="<CHANGE_ME>" password="<CHANGE_ME>" roles="manager-gui, manager-script, manager-jmx, manager-status, admin-gui, admin-script"/>
.
wq
EOM
# Allow the IP of the instance to be accessed via the Host Manager app
ex /opt/tomcat/webapps/manager/META-INF/context.xml << EOM
normal G2k
i
<!--
.
normal G
i
-->
.
wq
EOM
#privateIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
aws s3 cp s3://${s3location}/companyNews.war /opt/tomcat/webapps/
chgrp -R tomcat /opt/tomcat
chmod g+rwx /opt/tomcat/*
chown -R tomcat /opt/tomcat
service tomcat restart
