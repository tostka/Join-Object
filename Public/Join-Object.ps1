#*------v Function Join-Object v------
Function Join-Object {
<#
  .SYNOPSIS
  Join-Object - Fork of iRon's Join-Object script conv to PS Module:Combines two object lists based on a related property between them.
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
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseLiteralInitializerForHashtable', '', Scope='Function')]
	[CmdletBinding(DefaultParameterSetName='Default')][OutputType([Object[]])]Param (

		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'Default')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'On')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'Expression')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'Property')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'Discern')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'OnProperty')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'OnDiscern')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'ExpressionProperty')]
		[Parameter(ValueFromPipeLine = $True, Mandatory = $True, ParameterSetName = 'ExpressionDiscern')]
		$LeftObject,

		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'Default')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'On')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'Expression')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'Property')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'Discern')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'OnProperty')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'OnDiscern')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'ExpressionProperty')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'ExpressionDiscern')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'Self')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfOn')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfExpression')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfProperty')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfDiscern')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfOnProperty')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfOnDiscern')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfExpressionProperty')]
		[Parameter(Position = 0, Mandatory = $True, ParameterSetName = 'SelfExpressionDiscern')]
		$RightObject,

		[Parameter(Position = 1, ParameterSetName = 'On', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'OnProperty', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'OnDiscern', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfOn', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfOnProperty', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfOnDiscern', Mandatory = $True)]
		[Alias("Using")][String[]]$On,

		[Parameter(Position = 1, ParameterSetName = 'Expression', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'ExpressionProperty', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'ExpressionDiscern', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfExpression', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfExpressionProperty', Mandatory = $True)]
		[Parameter(Position = 1, ParameterSetName = 'SelfExpressionDiscern', Mandatory = $True)]
		[Alias("UsingExpression")][ScriptBlock]$OnExpression,

		[Parameter(ParameterSetName = 'On')]
		[Parameter(ParameterSetName = 'OnProperty')]
		[Parameter(ParameterSetName = 'OnDiscern')]
		[Parameter(ParameterSetName = 'SelfOn')]
		[Parameter(ParameterSetName = 'SelfOnProperty')]
		[Parameter(ParameterSetName = 'SelfOnDiscern')]
		[String[]]$Equals,

		[Parameter(Position = 2, ParameterSetName = 'Discern', Mandatory = $True)]
		[Parameter(Position = 2, ParameterSetName = 'OnDiscern', Mandatory = $True)]
		[Parameter(Position = 2, ParameterSetName = 'ExpressionDiscern', Mandatory = $True)]
		[Parameter(Position = 2, ParameterSetName = 'SelfDiscern', Mandatory = $True)]
		[Parameter(Position = 2, ParameterSetName = 'SelfOnDiscern', Mandatory = $True)]
		[Parameter(Position = 2, ParameterSetName = 'SelfExpressionDiscern', Mandatory = $True)]
		[AllowEmptyString()][String[]]$Discern,

		[Parameter(ParameterSetName = 'Property', Mandatory = $True)]
		[Parameter(ParameterSetName = 'OnProperty', Mandatory = $True)]
		[Parameter(ParameterSetName = 'ExpressionProperty', Mandatory = $True)]
		[Parameter(ParameterSetName = 'SelfProperty', Mandatory = $True)]
		[Parameter(ParameterSetName = 'SelfOnProperty', Mandatory = $True)]
		[Parameter(ParameterSetName = 'SelfExpressionProperty', Mandatory = $True)]
		$Property,

		[Parameter(Position = 3, ParameterSetName = 'Default')]
		[Parameter(Position = 3, ParameterSetName = 'On')]
		[Parameter(Position = 3, ParameterSetName = 'Expression')]
		[Parameter(Position = 3, ParameterSetName = 'Property')]
		[Parameter(Position = 3, ParameterSetName = 'Discern')]
		[Parameter(Position = 3, ParameterSetName = 'OnProperty')]
		[Parameter(Position = 3, ParameterSetName = 'OnDiscern')]
		[Parameter(Position = 3, ParameterSetName = 'ExpressionProperty')]
		[Parameter(Position = 3, ParameterSetName = 'ExpressionDiscern')]
		[Parameter(Position = 3, ParameterSetName = 'Self')]
		[Parameter(Position = 3, ParameterSetName = 'SelfOn')]
		[Parameter(Position = 3, ParameterSetName = 'SelfExpression')]
		[Parameter(Position = 3, ParameterSetName = 'SelfProperty')]
		[Parameter(Position = 3, ParameterSetName = 'SelfDiscern')]
		[Parameter(Position = 3, ParameterSetName = 'SelfOnProperty')]
		[Parameter(Position = 3, ParameterSetName = 'SelfOnDiscern')]
		[Parameter(Position = 3, ParameterSetName = 'SelfExpressionProperty')]
		[Parameter(Position = 3, ParameterSetName = 'SelfExpressionDiscern')]
		[ScriptBlock]$Where = {$True},

		[Parameter(ParameterSetName = 'Default')]
		[Parameter(ParameterSetName = 'On')]
		[Parameter(ParameterSetName = 'Expression')]
		[Parameter(ParameterSetName = 'Property')]
		[Parameter(ParameterSetName = 'Discern')]
		[Parameter(ParameterSetName = 'OnProperty')]
		[Parameter(ParameterSetName = 'OnDiscern')]
		[Parameter(ParameterSetName = 'ExpressionProperty')]
		[Parameter(ParameterSetName = 'ExpressionDiscern')]
		[Parameter(ParameterSetName = 'Self')]
		[Parameter(ParameterSetName = 'SelfOn')]
		[Parameter(ParameterSetName = 'SelfExpression')]
		[Parameter(ParameterSetName = 'SelfProperty')]
		[Parameter(ParameterSetName = 'SelfDiscern')]
		[Parameter(ParameterSetName = 'SelfOnProperty')]
		[Parameter(ParameterSetName = 'SelfOnDiscern')]
		[Parameter(ParameterSetName = 'SelfExpressionProperty')]
		[Parameter(ParameterSetName = 'SelfExpressionDiscern')]
		[ValidateSet('Inner', 'Left', 'Right', 'Full', 'Cross')]$JoinType = 'Inner',

		[Parameter(ParameterSetName = 'On')]
		[Parameter(ParameterSetName = 'OnProperty')]
		[Parameter(ParameterSetName = 'OnDiscern')]
		[Parameter(ParameterSetName = 'SelfOn')]
		[Parameter(ParameterSetName = 'SelfOnProperty')]
		[Parameter(ParameterSetName = 'SelfOnDiscern')]
		[Switch]$Strict,

		[Parameter(ParameterSetName = 'On')]
		[Parameter(ParameterSetName = 'OnProperty')]
		[Parameter(ParameterSetName = 'OnDiscern')]
		[Parameter(ParameterSetName = 'SelfOn')]
		[Parameter(ParameterSetName = 'SelfOnProperty')]
		[Parameter(ParameterSetName = 'SelfOnDiscern')]
		[Alias("CaseSensitive")][Switch]$MatchCase
	)
	Begin {
		$HashTable = $Null; $Esc = [Char]27; $EscSeparator = $Esc + ','
		$Expression = [Ordered]@{}; $PropertyList = [Ordered]@{}; $Related = @()
		If ($RightObject -isnot [Array] -and $RightObject -isnot [Data.DataTable]) {$RightObject = @($RightObject)}
		$RightKeys = @(
			If ($RightObject -is [Data.DataTable]) {$RightObject.Columns | Select-Object -ExpandProperty 'ColumnName'}
			Else {
				$First = $RightObject | Select-Object -First 1
				If ($First -is [System.Collections.IDictionary]) {$First.Get_Keys()}
				Else {$First.PSObject.Properties | Select-Object -ExpandProperty 'Name'}
			}
		)
		$RightProperties = @{}; ForEach ($Key in $RightKeys) {$RightProperties.$Key = $Null}
		$RightVoid = New-Object PSCustomObject -Property $RightProperties
		$RightLength = @($RightObject).Length; $LeftIndex = 0; $InnerRight = @($False) * $RightLength
		Function OutObject($LeftIndex, $RightIndex, $Left = $LeftVoid, $Right = $RightVoid) {
			If (&$Where) {
				ForEach ($_ in $Expression.Get_Keys()) {$PropertyList.$_ = &$Expression.$_}
				New-Object PSCustomObject -Property $PropertyList
			}
		}
		Function SetExpression([String]$Key, [ScriptBlock]$ScriptBlock) {
			If ($Key -eq '*') {$Key = $Null}
			If ($Key -and $ScriptBlock) {$Expression.$Key = $ScriptBlock}
			Else {
				$Keys = If ($Key) {@($Key)} Else {$LeftKeys + $RightKeys}
				ForEach ($Key in $Keys) {
					If (!$Expression.Contains($Key)) {
						$InLeft  = $LeftKeys  -Contains $Key
						$InRight = $RightKeys -Contains $Key
						If ($InLeft -and $InRight) {
							$Expression.$Key = If ($ScriptBlock) {$ScriptBlock}
								ElseIf ($Related -NotContains $Key) {{$Left.$_, $Right.$_}}
								Else {{If ($Null -ne $LeftIndex) {$Left.$_} Else {$Right.$_}}}
						}
						ElseIf ($InLeft)  {$Expression.$Key = {$Left.$_}}
						ElseIf ($InRight) {$Expression.$Key = {$Right.$_}}
						Else {Throw [ArgumentException]"The property '$Key' cannot be found on the left or right object."}
					}
				}
			}
		}
	}
	Process {
		Try {
			$SelfJoin = !$PSBoundParameters.ContainsKey('LeftObject'); If ($SelfJoin) {$LeftObject = $RightObject}
			ForEach ($Left in @($LeftObject)) {
				$InnerLeft = $Null
				If (!$LeftIndex) {
					$LeftKeys = @(
						If ($Left -is [Data.DataRow]) {$Left.Table.Columns | Select-Object -ExpandProperty 'ColumnName'}
						ElseIf ($Left -is [System.Collections.IDictionary]) {$Left.Get_Keys()}
						Else {$Left.PSObject.Properties | Select-Object -ExpandProperty 'Name'}
					)
					$LeftProperties = @{}; ForEach ($Key in $LeftKeys) {$LeftProperties.$Key = $Null}
					$LeftVoid = New-Object PSCustomObject -Property $LeftProperties
					If ($Null -ne $On -or $Null -ne $Equals) {
						$On = If ($On) {,@($On)} Else {,@()}; $Equals = If ($Equals) {,@($Equals)} Else {,@()}
						For ($i = 0; $i -lt [Math]::Max($On.Length, $Equals.Length); $i++) {
							If ($i -ge $On.Length) {$On += $Equals[$i]}
							If ($LeftKeys -NotContains $On[$i]) {Throw [ArgumentException]"The property '$($On[$i])' cannot be found on the left object."}
							If ($i -ge $Equals.Length) {$Equals += $On[$i]}
							If ($RightKeys -NotContains $Equals[$i]) {Throw [ArgumentException]"The property '$($Equals[$i])' cannot be found on the right object."}
							If ($On[$i] -eq $Equals[$i]) {$Related += $On[$i]}
						}
						$HashTable = If ($MatchCase) {[HashTable]::New(0, [StringComparer]::Ordinal)} Else {@{}}
						$RightIndex = 0; ForEach ($Right in $RightObject) {
							$Keys = ForEach ($Name in @($Equals)) {$Right.$Name}
							$HashKey = If (!$Strict) {[String]::Join($EscSeparator, @($Keys))}
									   Else {[System.Management.Automation.PSSerializer]::Serialize($Keys)}
							[Array]$HashTable[$HashKey] += $RightIndex++
						}
					}
					If ($Discern) {
						If (@($Discern).Count -le 1) {$Discern = @($Discern) + ''}
						ForEach ($Key in $LeftKeys) {
							If ($RightKeys -Contains $Key) {
								If ($Related -Contains $Key) {
									$Expression[$Key] = {If ($Null -ne $LeftIndex) {$Left.$_} Else {$Right.$_}}
								} Else {
									$Name = If ($Discern[0].Contains('*')) {([Regex]"\*").Replace($Discern[0], $Key, 1)} Else {$Discern[0] + $Key}
									$Expression[$Name] = [ScriptBlock]::Create("`$Left.'$Key'")
								}
							} Else {$Expression[$Key] = {$Left.$_}}
						}
						ForEach ($Key in $RightKeys) {
							If ($LeftKeys -Contains $Key) {
								If ($Related -NotContains $Key) {
									$Name = If ($Discern[1].Contains('*')) {([Regex]"\*").Replace($Discern[1], $Key, 1)} Else {$Discern[1] + $Key}
									$Expression[$Name] = [ScriptBlock]::Create("`$Right.'$Key'")
								}
							} Else {$Expression[$Key] = {$Right.$_}}
						}
					} ElseIf ($Property) {
						ForEach ($Item in @($Property)) {
							If ($Item -is [ScriptBlock]) {SetExpression $Null $Item}
							ElseIf ($Item -is [System.Collections.IDictionary]) {ForEach ($Key in $Item.Get_Keys()) {SetExpression $Key $Item.$Key}}
							Else {SetExpression $Item}
						}
					} Else {SetExpression}
				}
				$RightList = `
					If ($On) {
						If ($JoinType -eq "Cross") {Throw [ArgumentException]"The On parameter cannot be used on a cross join."}
						$Keys = ForEach ($Name in @($On)) {$Left.$Name}
						$HashKey = If (!$Strict) {[String]::Join($EscSeparator, @($Keys))}
								   Else {[System.Management.Automation.PSSerializer]::Serialize($Keys)}
						$HashTable[$HashKey]
					} ElseIf ($OnExpression) {
						If ($JoinType -eq "Cross") {Throw [ArgumentException]"The OnExpression parameter cannot be used on a cross join."}
						For ($RightIndex = 0; $RightIndex -lt $RightLength; $RightIndex++) {
							$Right = $RightObject[$RightIndex]; If (&$OnExpression) {$RightIndex}
						}
					}
					ElseIf ($JoinType -eq "Cross") {0..($RightObject.Length - 1)}
					ElseIf ($LeftIndex -lt $RightLength) {$LeftIndex} Else {$Null}
				ForEach ($RightIndex in $RightList) {
					$Right = If ($RightObject -is [Data.DataTable]) {$RightObject.Rows[$RightIndex]} Else {$RightObject[$RightIndex]}
						$OutObject = OutObject -LeftIndex $LeftIndex -RightIndex $RightIndex -Left $Left -Right $Right
						If ($Null -ne $OutObject) {$OutObject; $InnerLeft = $True; $InnerRight[$RightIndex] = $True}
				}
				If (!$InnerLeft -and ($JoinType -eq "Left" -or $JoinType -eq "Full")) {OutObject -LeftIndex $LeftIndex -Left $Left}
				$LeftIndex++
			}
		} Catch [ArgumentException] {
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}
	End {
		If ($JoinType -eq "Right" -or $JoinType -eq "Full") {$Left = $Null
			$RightIndex = 0; ForEach ($Right in $RightObject) {
				If (!$InnerRight[$RightIndex]) {OutObject -RightIndex $RightIndex -Right $Right}
				$RightIndex++
			}
		}
	}
}
#*------^ END Function Join-Object ^------