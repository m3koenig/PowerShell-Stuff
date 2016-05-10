## Source: https://blogs.msdn.microsoft.com/nav/2014/11/27/how-to-compile-a-database-twice-as-fast-or-faster/
function ParallelCompile-NAVApplicationObject
(
	[Parameter(Mandatory=$true)]
	$DatabaseName
)
{
	$objectTypes = 'Table','Page','Report','Codeunit','Query','XMLport','MenuSuite'
	$jobs = @()
	foreach($objectType in $objectTypes)
	{
		$jobs += Compile-NAVApplicationObject $DatabaseName -Filter Type=$objectType -Recompile -SynchronizeSchemaChanges No -AsJob
	}

	Receive-Job -Job $jobs -Wait
	Compile-NAVApplicationObject $DatabaseName -SynchronizeSchemaChanges No
} 