$_InstallutilEXE = $($deployed.container.InstallutilPath) + "Installutil.exe"
$_ServicePath = $($deployed.ServicePath)
$_BinaryName = $($deployed.BinaryName)
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

	# Call function to copy all deployables to target directory
	CopyDeployables

	# Call function to install the Windows Service
	InstallWindowsService

	# Call function to start the Windows Service
	StartWindowsService
}

function UninstallWindowsService
{
	PrintMessage "Uninstalling the windows service $_ServiceName..."
	&$_InstallutilEXE $_BinaryToInstall -u
}

function CopyDeployables
{
	PrintMessage "Deleting all files from target directory..."
	if (Test-Path $_ServicePath) 
	{
		Get-ChildItem -Path $_ServicePath -Recurse | Remove-Item -Force -Recurse | Out-Null
		Remove-Item $_ServicePath -Force | Out-Null
	}
	
	PrintMessage "Unzipping and copying files to target directory..."
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($deployed.file)
	$x = New-Item -Path $_ServicePath -ItemType directory
	foreach($item in $zip.items()) 
	{
		Write-Host "Copying file $($item.name)..."
		$shell.Namespace($_ServicePath).copyhere($item)
	}
}

function InstallWindowsService
{
	PrintMessage "Installing the windows service $_ServiceName..."
	&$_InstallutilEXE $_BinaryToInstall
}

function StartWindowsService
{
	PrintMessage "Starting the windows service $_ServiceName..."
	& net start $_ServiceName
}

function PrintMessage($message)
{
	Write-Host "-----------------------------------------------------------------------------------------------------"
	Write-Host "---- $message"
	Write-Host "-----------------------------------------------------------------------------------------------------"
}

ExecuteDeployment