# Metasploitable3 — Vulnerabilities

Source: https://github.com/rapid7/metasploitable3/wiki/Vulnerabilities

---

## GlassFish ❓

**Ports:** 4884 (HTTP), 8989 (HTTP), 9898 (HTTPS)

**Credentials:** admin / easy

**Access:** `http://localhost:4884`, login with above credentials.

**Start/Stop:**
- Stop: Task Manager → kill `java.exe` (glassfish process)
- Start: Task Scheduler → find task → Run

**Vulnerability IDs:** CVE-2011-0807

**Modules:**
- `exploits/multi/http/glassfish_deployer`
- `auxiliary/scanner/http/glassfish_login`

---

## Apache Struts ✅

**Ports:** 7979 (HTTP)

**Credentials:** Apache Tomcat Web Application Manager — U: najboljsiHrib / P: Lisca

**Access:**
- Vulnerable app: `http://localhost:7979/struts2-rest-showcase`
- Tomcat Manager: `http://localhost:7979`

**Start/Stop:**
- `services.msc` → Apache Tomcat 8.0 Tomcat8 service (Stop/Start)

**Vulnerability IDs:** CVE-2016-3087

**Modules:**
- `exploit/multi/http/struts_dmi_rest_exec`

---

## Tomcat ✅

**Ports:** 7979 (HTTP)

**Credentials:** U: najboljsiHrib / P: Lisca

**Access:** `http://localhost:7979`

**Start/Stop:**
- `services.msc` → Apache Tomcat 8.0 Tomcat8 service

**Vulnerability IDs:** CVE-2009-3843, CVE-2009-4189

**Modules:**
- `auxiliary/scanner/http/tomcat_enum`
- `auxiliary/scanner/http/tomcat_mgr_login`
- `exploits/multi/http/tomcat_mgr_deploy`
- `exploits/multi/http/tomcat_mgr_upload`
- `post/windows/gather/enum_tomcat`

---

## Jenkins ❓
**Ports:** 8484 (HTTP)

**Credentials:** None enabled by default

**Access:** `http://localhost:8484`

**Start/Stop:**
- `services.msc` → jinkies service

**Modules:**
- `exploits/multi/http/jenkins_script_console`
- `auxiliary/scanner/http/jenkins_enum`

---

## IIS - FTP 

**Ports:** 21 (FTP)

**Credentials:** Windows credentials

**Access:** Any FTP client

**Start/Stop:**
- Stop: `net stop msftpsvc`
- Start: `net start msftpsvc`

**Modules:**
- `auxiliary/scanner/ftp/ftp_login`

---

## IIS - HTTP

**Ports:** 80 (HTTP)

**Credentials:** U: vagrant / P: vagrant

**Access:** `http://localhost`

**Start/Stop:**
- `services.msc` → World Wide Web Publishing service

**Vulnerability IDs:** CVE-2015-1635

**Modules:**
- `auxiliary/dos/http/ms15_034_ulonglongadd`

---

## psexec

**Ports:** 445 (SMB), 139 (NetBIOS)

**Credentials:** Any credentials valid for Metasploitable3 (see [Configuration wiki page](https://github.com/rapid7/metasploitable3/wiki/Configuration#credentials))

**Access:** Use the [psexec tool](https://technet.microsoft.com/en-us/sysinternals/pxexec.aspx) to run commands remotely.

**Start/Stop:** Enabled by default

**Vulnerabilities:** Multiple users with weak passwords exist on the target; passwords can be cracked and used with psexec to run remote code.

**Modules:**
- `exploits/windows/smb/psexec`
- `exploits/windows/smb/psexec_psh`

---

## SSH

**Ports:** 22 (SSH)

**Credentials:** Any credentials valid for Metasploitable3 (see Configuration page)

**Access:** Standard SSH client

**Start/Stop:** Enabled by default

**Vulnerabilities:** Multiple users with weak passwords exist; once cracked, remote code can be executed via SSH.

---

## WinRM

**Ports:** 5986 (HTTPS)

**Credentials:** Any credentials valid for Metasploitable3 (see Configuration page)

**Start/Stop:**
- `services.msc` → Windows Remote Management service

**Vulnerabilities:** Multiple users with weak passwords exist; WinRM can be used to run remote code once cracked.

**Modules:**
- `auxiliary/scanner/winrm/winrm_cmd`
- `auxiliary/scanner/winrm/winrm_wql`
- `auxiliary/scanner/winrm/winrm_login`
- `auxiliary/scanner/winrm/winrm_auth_methods`
- `exploits/windows/winrm/winrm_script_exec`

---

## Chinese Caidao

**Ports:** 80 (HTTP)

**Credentials:** Any credentials valid for Metasploitable3

**Access:** `http://localhost/caidao.asp`

**Start/Stop:**
- `services.msc` → World Wide Web Publishing service

**Modules:**
- `auxiliary/scanner/http/caidao_bruteforce_login`

---

## ManageEngine

**Ports:** 8020 (HTTP)

**Credentials:** admin / admin

**Access:** `http://localhost:8020`

**Start/Stop:**
- Stop: `net stop "ManageEngine Desktop Central Server"`
- Start: `net start "ManageEngine Desktop Central Server"`

**Vulnerability IDs:** CVE-2015-8249

**Modules:**
- `exploit/windows/http/manageengine_connectionid_write`

---

## ElasticSearch

**Ports:** 9200 (HTTP)

**Credentials:** None needed

**Access:** `http://localhost:9200`

**Start/Stop:**
- Stop: `net stop elasticsearch-service-x64`
- Start: `net start elasticsearch-service-x64`

**Vulnerability IDs:** CVE-2014-3120

**Modules:**
- `exploit/multi/elasticsearch/script_mvel_rce`

---

## Apache Axis2

**Ports:** 7979 (HTTP) ✅

**Credentials:** None needed

**Access:** `http://localhost:7979/axis2`

**Start/Stop:** Via Apache Tomcat application manager

**Vulnerability IDs:** CVE-2010-0219

**Modules:**
- `exploit/multi/http/axis2_deployer`

---

## WebDAV

**Ports:** 8585 (HTTP)

**Credentials:** None needed

**Access:** See [PR #16](https://github.com/rapid7/metasploitable3/pull/16)

**Start/Stop:**
- Stop: `net stop wampapache`
- Start: `net start wampapache`

**Modules:**
- `auxiliary/scanner/http/http_put`

---

## SNMP

**Ports:** 161 (UDP)

**Credentials:** Community string: `public`

**Access:** Use `auxiliary/scanner/snmp/snmp_enum` in Metasploit

**Start/Stop:**
- Stop: `net stop snmp`
- Start: `net start snmp`

**Modules:**
- `auxiliary/scanner/snmp/snmp_enum`

---

## MySQL

**Ports:** 3306 (TCP)

**Credentials:** U: root / P: (blank)

**Access:** MySQL client → port 3306

**Start/Stop:**
- Stop: `net stop wampmysql`
- Start: `net start wampmysql`

**Modules:**
- `windows/mysql/mysql_payload`

---

## JMX

**Ports:** 1617 (TCP)

**Credentials:** None needed

**Access:** Download connector client, see [Oracle JMX docs](http://docs.oracle.com/javase/tutorial/jmx/remote/index.html)

**Start/Stop:**
- Stop: `net stop jmx`
- Start: `net start jmx`

**Vulnerability IDs:** CVE-2015-2342

**Modules:**
- `multi/misc/java_jmx_server`

---

## WordPress

**Ports:** 8585 (HTTP)

**Credentials:** None needed

**Access:** `http://localhost:8585/wordpress`

**Start/Stop:**
- Stop: `net stop wampapache`
- Start: `net start wampapache`

**Vulnerable Plugins:** NinjaForms 2.9.42 — CVE-2016-1209

**Modules:**
- `unix/webapp/wp_ninja_forms_unauthenticated_file_upload`

---

## Remote Desktop

**Ports:** 3389 (RDP)

**Credentials:** Any Windows credentials

**Access:** Any RDP client

**Start/Stop:**
- Stop: `net stop rdesktop`
- Start: `net start rdesktop`

**Modules:** N/A

---

## PHPMyAdmin

**Ports:** 8585 (HTTP)

**Credentials:** U: root / P: (blank)

**Access:** `http://localhost:8585/phpmyadmin`

**Start/Stop:**
- Stop: `net stop wampapache`
- Start: `net start wampapache`

**Vulnerability IDs:** CVE-2013-3238

**Modules:**
- `multi/http/phpmyadmin_preg_replace`

---

## Ruby on Rails

**Ports:** 3000 (HTTP)

**Credentials:** N/A

**Access:** `http://localhost:3000`

**Start/Stop:**
- Stop: Task Manager → kill `ruby.exe`
- Start: Task Scheduler → find task → Run

**Vulnerability IDs:** CVE-2015-3224

**Modules:**
- `exploit/multi/http/rails_web_console_v2_code_exec`