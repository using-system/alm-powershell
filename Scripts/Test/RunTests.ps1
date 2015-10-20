function RunTests
{
    param
    (
        # Test dll
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$TestDLL,

        # Account URL
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$TFSUrl,

        # Build id
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$BuildNumber,

        # Team project name
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$TeamProject,

        # Alternate creds to connect to TFS
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$TFSAlternateUserName,

        # Alternate creds to connect to TFS
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$TFSAlternatePassword
    )

	$basicAuth = ("{0}:{1}" -f $TFSAlternateUserName,$TFSAlternatePassword)
	$basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
	$basicAuth = [System.Convert]::ToBase64String($basicAuth)
	$headers = @{Authorization=("Basic {0}" -f $basicAuth)}
	$tfsBuildUrl = $TFSUrl + "/" + $TeamProject + "/_apis/build/builds/" + $BuildNumber + "?api-version=1.0"
	Write-Verbose -Verbose "Querying Build using $tfsBuildUrl for build details"
	$build = Invoke-RestMethod -Uri $tfsBuildUrl -headers $headers -Method Get
	
	$fs = New-Object -ComObject Scripting.FileSystemObject
	$f = $fs.GetFile("C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow\vstest.console.exe")
	$vstestPath = $f.shortpath
	$arguments = $TestDLL
		
	if ($build.buildNumber)
	{
		Write-Verbose -Verbose "Build Details Obtained. Build Number = $build.buildNumber"
		$platform = "x86"
		$flavor = "Debug"
		$runTitle = "TestsRunInRelease_" + $ReleaseId
		$arguments = $arguments + " /logger:TfsPublisher;Collection=`"" + $TFSUrl + "`";BuildName=`"" + $build.buildNumber + "`";TeamProject=`"" + $TeamProject +"`";Platform=`"" + $Platform + "`";Flavor=`"" + $Flavor +"`";RunTitle=`"" + $runTitle + "`""
	}
	else
	{
		Write-Error -Verbose "Build Details not Found. Check the TFS credentials. Continuing to Execute Tests without publishing to TFS"
	}	

	Write-Verbose -Verbose  "Executing $vstestPath --% $arguments"
	Invoke-Expression "$vstestPath --% $arguments" | Out-String | Write-Verbose -Verbose

}

$testDllPath = $applicationPath + "\" + $TestDLL
RunTests -TestDLL $testDllPath -TFSUrl $TFSUrl -BuildNumber $BuildNumber -TeamProject $TeamProject -TFSAlternateUserName $TFSAlternateUserName -TFSAlternatePassword $TFSAlternatePassword
