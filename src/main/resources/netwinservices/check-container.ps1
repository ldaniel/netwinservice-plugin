$_InstallutilPath = $($container.InstallutilPath)

function ExecuteCheck()
{

	If (Test-Path $_InstallutilPath)
	{
		PrintMessageOk $_InstallutilPath 
	}
	else
	{
		PrintHowToSolveIssue $_InstallutilPath
		Exit 1
	}
}

function PrintMessageOk($folder)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "[OK!]"
	Write-Host "Folder '$($folder)' exists on server."	
}

function PrintHowToSolveIssue($folder)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "[ERROR!]"
	Write-Host "Check task failed due the following reason: Folder '$($folder)' does not exists on server."	
	Write-Host "The folder '$($folder)' must be created on target server in order to solve this issue."	
}

ExecuteCheck