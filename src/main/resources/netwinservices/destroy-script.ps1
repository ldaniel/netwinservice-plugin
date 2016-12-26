$_InstallutilEXE = $($deployed.container.InstallutilPath) + "Installutil.exe"
$_ServicePath = $($deployed.ServicePath)
$_BinaryName = $($deployed.BinaryName)
$_FullInstallation = $($deployed.FullInstallation)
$_BinaryToInstall = $_ServicePath + $_BinaryName
$_ServiceName = $($deployed.ServiceName)
$_ServiceLogonUser = $($deployed.container.Username)
$_ServiceLogonPassword = $($deployed.container.Password)

function ExecuteDeployment()
{
	Write-Host "Install util: $_InstallutilEXE" 
	Write-Host "Binary to install: $_BinaryToInstall"
	Write-Host "Service name: $_ServiceName" 
	
	# Call function to uninstall the Windows Service
	UninstallWindowsService

	# Call function to delete all files from the target directory
	DeleteFilesFromTargetDirectory
}

function UninstallWindowsService
{
	PrintMessage "Trying to uninstall the windows service $_ServiceName..."
	$service = Get-WmiObject -Class Win32_Service -Filter "Name='$($_ServiceName)'"
			
	if($service)
	{
		&$_InstallutilEXE $_BinaryToInstall -u
	}
	else
	{
		PrintMessage "The windows service $($_ServiceName) is not installed on this server."
	}	
}

function DeleteFilesFromTargetDirectory
{
	PrintMessage "Deleting all files from target directory..."
	if (Test-Path $_ServicePath) 
	{
		Get-ChildItem -Path $_ServicePath -Recurse | Remove-Item -Force -Recurse | Out-Null
		Remove-Item $_ServicePath -Force | Out-Null
	}
}

function PrintMessage($message)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "---- $message"
	Write-Host "-----------------------------------------------------------------------------------------------------"
}

ExecuteDeployment