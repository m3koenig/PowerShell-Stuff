## SOURCE: http://vjeko.com/deploying-control-add-ins-during-development-in-nav-2016
Param(
	[string]$DllFile,
	[string]$ServerInstance,
	[string]$ProjectPath
)

$ServerInstance
return

Function ImportNavManagementModule() 
{
	Param([string]$Server)

	$svcName = "MicrosoftDynamicsNavServer$" + $Server
	foreach ($mo in [System.Management.ManagementClass]::new("Win32_Service").GetInstances())
	{
		if ($mo.GetPropertyValue("Name").ToString() -eq $svcName)
		{
			$path = $mo.GetPropertyValue("PathName").ToString()
			$path = $path.Substring(1, $path.IndexOf("$") - 3)
			$path = [System.IO.Path]::Combine(
				[System.IO.Path]::GetDirectoryName($path),
				"Microsoft.Dynamics.Nav.Management.dll")
			Import-Module -FullyQualifiedName $path
			return
		}
	}
}

Function ImportAddIn() 
{
	Param (
		[string]$AddInName,
		[string]$Token,
		[string]$Path,
		[string]$Server
	)

	$resFile = $null
	$folder = [System.IO.Path]::Combine($Path, "Resource", $AddInName)
	if ([System.IO.Directory]::Exists($folder))
	{
		$resFile = ZipFolder -Folder $folder
	}
	Try
	{
		if ($resFile -ne $null)
		{
			New-NAVAddIn `
				-AddInName $AddInName `
				-PublicKeyToken $Token `
				-ServerInstance $Server `
				-Category JavaScriptControlAddIn `
				-ResourceFile $resFile `
				-ErrorAction Stop
		} 
		else 
		{
			New-NAVAddIn `
				-AddInName $AddInName `
				-PublicKeyToken $Token `
				-ServerInstance $Server `
				-Category DotNetControlAddIn `
				-ErrorAction Stop
		}
	}
	Catch [System.Exception]
	{
		if ($resFile -ne $null)
		{
			Set-NAVAddIn `
				-AddInName $AddInName `
				-PublicKeyToken $Token `
				-ServerInstance $Server `
				-Category JavaScriptControlAddIn `
				-ResourceFile $resFile
		}
		else
		{
			Set-NAVAddIn `
				-AddInName $AddInName `
				-PublicKeyToken $Token `
				-ServerInstance $Server `
				-Category DotNetControlAddIn
		}
	}
	Finally
	{
		if ($resFile -ne $null -and [System.IO.File]::Exists($resFile))
		{
			[System.IO.File]::Delete($resFile)
		}
	}
}

Function LoadAssemblies() 
{
	Param (
		[string]$path
	)

	$navPath = $null
	$project = [Xml](Get-Content $path)
	[System.Xml.XmlNamespaceManager] $nsmgr = $project.NameTable
	$nsmgr.AddNamespace("p", "http://schemas.microsoft.com/developer/msbuild/2003")
	$nodes = $project.SelectNodes("/p:Project/p:ItemGroup//p:Reference", $nsmgr)
	foreach ($node in $nodes)
	{
		$hint = $node.SelectSingleNode("p:HintPath", $nsmgr)
		if ($hint -ne $null) 
		{
			$deppath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($path), $hint.InnerText)
			$a = [System.Reflection.Assembly]::LoadFile($deppath)
			if ($node.Include -eq "Microsoft.Dynamics.Framework.UI.Extensibility")
			{
				$navPath = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($deppath), "Add-ins")
			}
		}
	}
	return $navPath
}

Function ZipFolder()
{
	Param(
		[string]$Folder
	)

	Add-Type -Assembly "System.IO.Compression.FileSystem"
	$dest = [System.IO.Path]::GetTempFileName()
	[System.IO.File]::Delete($dest)
	[System.IO.Compression.ZipFile]::CreateFromDirectory($Folder, $dest)
	return $dest
}

Function GetToken()
{
	Param(
		[string]$file
	)

	return -join ([Reflection.AssemblyName]::GetAssemblyName($file).GetPublicKeyToken() `
		| foreach { $_.ToString("X2").ToLower() })
}

Function InstallAllControlAddIns() 
{
	Param (
		[string]$Dll,
		[string]$Server,
		[string]$Project
	)

	$addInsPath = LoadAssemblies -path $Project
	$path = [System.IO.Path]::GetDirectoryName($Project)
	$token = GetToken -file $Dll
	$asm = [System.Reflection.Assembly]::LoadFile($Dll)
	$types = $asm.GetTypes() | Where { $_.GetCustomAttributes($false).Count -gt 0 }
	foreach ($type in $types)
	{
		$ctrlAddIn = $type.GetCustomAttributes($false) `
			| Where { $_.TypeId.ToString() -eq `
				"Microsoft.Dynamics.Framework.UI.Extensibility.ControlAddInExportAttribute" }
		if ($ctrlAddIn -ne $null) 
		{
			ImportAddIn `
				-AddInName $ctrlAddIn.Name `
				-Token $token `
				-Path $path `
				-Server $Server
			CopyDllToNavAddIns `
				-AddInsPath $addInsPath `
				-ControlAddInName $ctrlAddIn.Name `
				-Dll $Dll `
				-Server $Server
		}
	}
}

Function CopyDllToNavAddIns()
{
	Param(
		[string]$AddInsPath,
		[string]$ControlAddInName,
		[string]$Dll,
		[string]$Server
	)

	$path = [System.IO.Path]::Combine($AddInsPath, $ControlAddInName)
	$p = [System.IO.Directory]::CreateDirectory($path)
	$allDlls = [System.IO.Path]::GetDirectoryName($Dll) + "\*.dll"
	Try
	{
		Copy-Item $allDlls $path
	}
	Catch [System.Exception]
	{
		Try
		{
			Write-Host "Restarting service tier."
			Set-NAVServerInstance $Server -Restart
			Copy-Item $allDlls $path
		}
		Catch [System.Exception]
		{
			Write-Host "Dll files are still in use. Could they be locked by the Development Environment?"
		}
	}
}

#Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\Microsoft.Dynamics.Nav.Management.dll'
ImportNavManagementModule -Server $ServerInstance
InstallAllControlAddIns -Dll $DllFile -Server $ServerInstance -Project $ProjectPath
