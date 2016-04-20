# Source: https://navscripts.codeplex.com/SourceControl/latest#Scripts/CommonPSFunctions/CommonPSFunctions.psm1
function Get-Confirmation
{
    <#
        .SYNOPSIS
        Display query with answer Yes or No
        .DESCRIPTION
        Display query with answer Yes or No and return the result
        .EXAMPLE
        Get-Confirmation -title "Question" -message "Do you want to continue?" -yeshint 'It will continue' -nohint 'processing will be cancelled'

        result is 0 for Yes, 1 is for no
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [System.String]
        $title,
        
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $message ,
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $yeshint,
        [Parameter(Mandatory=$false, Position=1)]
        [Object]
        $nohint
    )
    
    $yes = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes', $yeshint
    $no = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&No', $nohint
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
    $result = $host.ui.PromptForChoice($title, $message, $options, 1) 
    return $result
}

