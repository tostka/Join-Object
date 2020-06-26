#*------v Function Copy-Command v------
Function Copy-Command {
<#
  .SYNOPSIS
  Copy-Command - Fork of iRon's Join-Object script conv to PS Module:Combines two object lists based on a related property between them.
  .NOTES
  Version     : 3.2.2.0
  Author      : iRon
  Website     :	https://github.com/iRon7/Join-Object
  Twitter     :	
  CreatedDate : 6/26/2020
  FileName    : Join-Object.psm1
  License     : MIT
  Copyright   : 
  Github      : https://github.com/tostka
  AddedCredit : Todd Kadrie
  AddedWebsite:	https://www.toddomation.com
  AddedTwitter:	@tostka / http://twitter.com/tostka
  REVISIONS
  * 6/26/2020 - 3.2.2.0 - iniital conv to Mod ; added function-level CBH
  * 3.2.2 2020-04-05 join-object.ps1: Ronald Bode Better handling argument exceptions
  .DESCRIPTION
  Combines properties from one or more objects. It creates a set that can
  be saved as a new object or used as it is. An object join is a means for
  combining properties from one (self-join) or more tables by using values
  common to each. The Join-Object cmdlet supports a few proxy commands with
  their own (-JoinType and -Property) defaults:
  .PARAMETER Command
  .PARAMETER Name
  .PARAMETER DefaultParameters
  .LINK
  https://github.com/iRon7/Join-Object
  .LINK
  https://github.com/tostka/Join-Object
  #>
  PARAM(
    [System.Management.Automation.CommandInfo]$Command, 
    [String]$Name, 
    [HashTable]$DefaultParameters
  )
	Try {
		$MetaData = [System.Management.Automation.CommandMetadata]$Command
		$Value = [System.Management.Automation.ProxyCommand]::Create($MetaData)
		$Null = New-Item -Path Function:\ -Name "Script:$Name" -Value $Value -Force
		ForEach ($Key in $DefaultParameters.Keys) {$PSDefaultParameterValues["$Name`:$Key"] = $DefaultParameters.$Key}
	} Catch {$PSCmdlet.WriteError($_)}
}
#*------^ END Function Copy-Command ^------