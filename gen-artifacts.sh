#!/bin/bash

KEYTYPE=ed25519

BOUNCYIP="$1"
HOSTKEY=`ssh $BOUNCYIP sudo ssh-keygen -l -E md5 -f "/etc/ssh/ssh_host_${KEYTYPE}_key" |cut -d: -f 2-17|cut -d' ' -f1`

echo '<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2019-12-18T10:08:51.5450582</Date>
    <Author>James Andariese</Author>
    <URI>\plink to bouncybox</URI>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <Repetition>
        <Interval>PT5M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
      <StartBoundary>2019-12-18T10:09:47</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
    <BootTrigger>
      <Repetition>
        <Interval>PT5M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
      <Enabled>true</Enabled>
    </BootTrigger>
    <IdleTrigger>
      <Repetition>
        <Interval>PT5M</Interval>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
      <Enabled>true</Enabled>
    </IdleTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>S-1-5-18</UserId>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <DisallowStartOnRemoteAppSession>false</DisallowStartOnRemoteAppSession>
    <UseUnifiedSchedulingEngine>true</UseUnifiedSchedulingEngine>
    <WakeToRun>true</WakeToRun>
    <ExecutionTimeLimit>PT0S</ExecutionTimeLimit>
    <Priority>7</Priority>
    <RestartOnFailure>
      <Interval>PT1M</Interval>
      <Count>999</Count>
    </RestartOnFailure>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>"C:\Program Files\PuTTY\plink.exe"</Command>
      <Arguments>-hostkey '"$HOSTKEY"' -R 3389:localhost:3389 -N -i c:\system-local\workspacetunnel-jetson.ppk -batch workspacetunnel@'"$BOUNCYIP"'</Arguments>
    </Exec>
  </Actions>
</Task> ' > plink_to_bouncybox.xml

echo 'allow desktop composition:i:1
allow font smoothing:i:1
alternate full address:s:'"$BOUNCYIP"'
alternate shell:s:rdpinit.exe
devicestoredirect:s:*
disableremoteappcapscheck:i:1
drivestoredirect:s:*
full address:s:'"$BOUNCYIP"'
prompt for credentials on client:i:1
promptcredentialonce:i:0
redirectcomports:i:1
redirectdrives:i:1
remoteapplicationmode:i:1
remoteapplicationname:s:Google Chrome
remoteapplicationprogram:s:||Google Chrome
span monitors:i:1
use multimon:i:1
' > chrome.rdp
