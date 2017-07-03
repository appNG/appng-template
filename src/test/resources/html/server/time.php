<?php
$timestamp = time();
$date = date("d.m.Y",$timestamp);
$time = date("H:i:s",$timestamp);
echo $date," - ",$time," \n";
$counter = date("s",$timestamp);

?>
(Sun Sep 13 23:02:05 2009): Beginning Wbemupgd.dll Registration
(Sun Sep 13 23:02:05 2009): Current build of wbemupgd.dll is 5.1.2600.2180 (xpsp_sp2_rtm.040803-2158)
(Sun Sep 13 23:02:05 2009): Beginning Core Upgrade
(Sun Sep 13 23:02:05 2009): Beginning MOF load
(Sun Sep 13 23:02:05 2009): Processing C:\WINDOWS\system32\WBEM\cimwin32.mof
(Sun Sep 13 23:02:09 2009): Processing C:\WINDOWS\system32\WBEM\cimwin32.mfl
(Sun Sep 13 23:02:12 2009): Processing C:\WINDOWS\system32\WBEM\system.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\evntrprv.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\hnetcfg.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\sr.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\dgnet.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\whqlprov.mof
(Sun Sep 13 23:02:16 2009): Processing C:\WINDOWS\system32\WBEM\ieinfo5.mof
(Sun Sep 13 23:02:17 2009): MOF load completed.
(Sun Sep 13 23:02:17 2009): Beginning MOF load
(Sun Sep 13 23:02:17 2009): MOF load completed.
(Sun Sep 13 23:02:17 2009): Core Upgrade completed.
(Sun Sep 13 23:02:17 2009): Wbemupgd.dll Service Security upgrade succeeded.
(Sun Sep 13 23:02:17 2009): Beginning WMI(WDM) Namespace Init
(Sun Sep 13 23:02:20 2009): WMI(WDM) Namespace Init Completed
(Sun Sep 13 23:02:20 2009): ESS enabled
(Sun Sep 13 23:02:20 2009): ODBC Driver &lt;system32&gt;\wbemdr32.dll not present
(Sun Sep 13 23:02:20 2009): Successfully verified WBEM OBDC adapter (incompatible version removed if it was detected).
(Sun Sep 13 23:02:20 2009): Wbemupgd.dll Registration completed.
(Sun Sep 13 23:02:20 2009): 
<?php

if (($counter % 2) == 1){
?>
(Sun Sep 13 23:02:05 2009): Beginning Wbemupgd.dll Registration
(Sun Sep 13 23:02:05 2009): Current build of wbemupgd.dll is 5.1.2600.2180 (xpsp_sp2_rtm.040803-2158)
<?php
}
else{
?>
(Sun Sep 13 23:02:05 2009): Beginning Core Upgrade
<?php
}

?>