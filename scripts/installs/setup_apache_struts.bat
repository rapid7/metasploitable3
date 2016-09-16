rm "%CATALINA_HOME%\conf\tomcat-users.xml"
copy C:\vagrant\resources\apache_struts\tomcat-users.xml "%CATALINA_HOME%\conf\tomcat-users.xml"
copy C:\vagrant\resources\apache_struts\server.xml "%CATALINA_HOME%\conf"

sc config Tomcat8 start= auto
net start "Apache Tomcat 8.0 Tomcat8"

copy C:\vagrant\resources\apache_struts\struts2-rest-showcase.war "%CATALINA_HOME%\webapps"