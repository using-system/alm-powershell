# Use the script

## Step 1
Add a build step to execute PowerShell script "Set-AssemblyVersion.ps1"

<img src="http://img.over-blog-kiwi.com/1/52/77/28/20150717/ob_b444aa_build-step.png" />

## Step 2
Change the build number format to $(BuildDefinitionName)_$(MajorVersion).$(MinorVersion).$(Year:yy)$(DayOfYear)$(Rev:.rr).

<img src="http://img.over-blog-kiwi.com/1/52/77/28/20150717/ob_0390b7_build-number-format.png" />

## Step 3
Add the variables "MajorVersion" and "MinorVersion"

<img src="http://img.over-blog-kiwi.com/1/52/77/28/20150717/ob_9cdb27_variables.png" />

#Optional Arguments

* versionFileSearchPattern : Search Pattern to find assembly version files (default value : AssemblyInfo.*).