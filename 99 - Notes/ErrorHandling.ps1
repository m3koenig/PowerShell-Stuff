## Source 
# http://stackoverflow.com/questions/6430382/powershell-detecting-errors-in-script-functions

## 
# Error handling in PowerShell is a total mess. There are error records, script exceptions, .NET exceptions, $?, $LASTEXITCODE, traps, $Error array (between scopes), and so on. And constructs to interact these elements with each other (such as # $ErrorActionPreference). It is very difficult to get consistent when you have a morass like this; however, there is a way to achieve this goal.
# 
# The following observations must be made:
# 
# $? is an underdocumented mystery. $? values from cmdlet calls do not propagate, it is a "read-only variable" (thus cannot be set by hand) and it is not clear on when exactly it gets set (what could possibly be an "execution status", term never # used in PowerShell except on the description of $? in about_Automatic_Variables, is an enigma). Thankfully Bruce Payette has shed light on this: if you want to set $?, $PSCmdlet.WriteError() is the only known way.
# 
# If you want functions to set $? as cmdlets do, you must refrain from Write-Error and use $PSCmdlet.WriteError() instead. Write-Error and $PSCmdlet.WriteError() do the same thing, but the former does not set $? properly and the latter does. (Do # not bother trying to find this documented somewhere. It is not.)
# 
# If you want to handle .NET exceptions properly (as if they were non-terminating errors, leaving the decision of halting the entire execution up to the client code), you must catch and $PSCmdlet.WriteError() them. You cannot leave them # unprocessed, since they become non-terminating errors which do not respect $ErrorActionPreference. (Not documented either.)
# 
# In other words, the key to produce consistent error handling behavior is to use $PSCmdlet.WriteError() whenever possible. It sets $?, respects $ErrorActionPreference (and thus -ErrorAction) and accepts System.Management.Automation.ErrorRecord # objects produced from other cmdlets or a catch statement (in the $_ variable).
# 
# The following examples will show how to use this method.
# 
# Function which propagates an error from an internal cmdlet call,
# setting $? in the process.
function F1 {
    [CmdletBinding()]
    param([String[]]$Path)

    # Run some cmdlet that might fail, quieting any error output.
    Convert-Path -Path:$Path -ErrorAction:SilentlyContinue
    if (-not $?) {
        # Re-issue the last error in case of failure. This sets $?.
        # Note that the Global scope must be explicitly selected if the function is inside
        # a module. Selecting it otherwise also does not hurt.
        $PSCmdlet.WriteError($Global:Error[0])
        return
    }

    # Additional processing.
    # ...
}


# Function which converts a .NET exception in a non-terminating error,
# respecting both $? and $ErrorPreference.
function F2 {
    [CmdletBinding()]
    param()

    try {
        [DateTime]"" # Throws a RuntimeException.
    }
    catch {
        # Write out the error record produced from the .NET exception.
        $PSCmdlet.WriteError($_)
        return
    }
}

# Function which issues an arbitrary error.
function F3 {
    [CmdletBinding()]
    param()

    # Creates a new error record and writes it out.
    $PSCmdlet.WriteError((New-Object -TypeName:"Management.Automation.ErrorRecord"
        -ArgumentList:@(
            [Exception]"Some error happened",
            $null,
            [Management.Automation.ErrorCategory]::NotSpecified,
            $null
        )
    ))

    # The cmdlet error propagation technique using Write-Error also works.
    Write-Error -Message:"Some error happened" -Category:NotSpecified -ErrorAction:SilentlyContinue
    $PSCmdlet.WriteError($Global:Error[0])
}


#As a last note, if you want to create terminating errors from .NET exceptions, do try/catch and rethrow the exception caught.