function toggleAction(){
  var axis = document.getElementById('axis').checked;
  var struts = document.getElementById('struts').checked;
  var caidao = document.getElementById('caidao').checked;
  var elasticsearch = document.getElementById('elasticsearch').checked;
  var glassfish = document.getElementById('glassfish').checked;
  var iishttp = document.getElementById('iishttp').checked;
  var iisftp = document.getElementById('iisftp').checked;
  var jenkins = document.getElementById('jenkins').checked;
  var jmx = document.getElementById('jmx').checked;
  var mysql = document.getElementById('mysql').checked;
  var rails = document.getElementById('rails').checked;
  var snmp = document.getElementById('snmp').checked;
  var tomcat = document.getElementById('tomcat').checked;
  var webdav = document.getElementById('webdav').checked;
  var wordpress = document.getElementById('wordpress').checked;
  var test = '';
  var initial = '<b>Copy the following text to a file at the location : <i>chef/cookbooks/custom_build.rb</i></b><br /><br />';
  test += initial;
  if(axis) {
    test += 'include_recipe \'metasploitable::axis2\'<br />';
  }
  if(struts) {
    test += 'include_recipe \'metasploitable::apache_struts\'<br />';
  }
  if(caidao) {
    test += 'include_recipe \'metasploitable::backdoors\'<br />';
  }
  if(elasticsearch) {
    test += 'include_recipe \'metasploitable::elasticsearch\'<br />';
  }
  if(glassfish) {
    test += 'include_recipe \'metasploitable::glassfish\'<br />';
  }
  if(iishttp) {
    test += 'include_recipe \'metasploitable::iis\'<br />';
  }
  if(iisftp) {
    test += 'include_recipe \'metasploitable::ftp\'<br />';
  }
  if(jenkins) {
    test += 'include_recipe \'metasploitable::jenkins\'<br />';
  }
  if(jmx) {
    test += 'include_recipe \'metasploitable::jmx\'<br />';
  }
  if(mysql) {
    test += 'include_recipe \'metasploitable::mysql\'<br />';
  }
  if(rails) {
    test += 'include_recipe \'metasploitable::rails\'<br />';
  }
  if(snmp) {
    test += 'include_recipe \'metasploitable::snmp\'<br />';
  }
  if(tomcat) {
    test += 'include_recipe \'metasploitable::tomcat\'<br />';
  }
  if(webdav) {
    test += 'include_recipe \'metasploitable::webdav\'<br />';
  }
  if(wordpress) {
    test += 'include_recipe \'metasploitable::wordpress\'<br />';
  }
  test += '<br /><b>Use the command:</b> <i>packer build --only=virtualbox-iso packer/templates/pro/windows_2008_r2_pro.json</i><br />';
  document.getElementById('myDIV').innerHTML = test;
  document.getElementById('myDIV').scrollIntoView();
}