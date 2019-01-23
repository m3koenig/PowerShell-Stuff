function MKO.New-NavContainer {
    Param(
        [switch]$accept_eula,
        [switch]$accept_outdated,
        [Parameter(Mandatory=$true)]
        [string]$containerName, 
        [string]$imageName = "", 
        [string]$navDvdPath = "", 
        [string]$navDvdCountry = "w1",
        [string]$licenseFile = "",
        [System.Management.Automation.PSCredential]$Credential = $null,
        [string]$authenticationEMail = "",
        [string]$memoryLimit = "",
        [ValidateSet('','process','hyperv')]
        [string]$isolation = "",
        [string]$databaseServer = "",
        [string]$databaseInstance = "",
        [string]$databaseName = "",
        [System.Management.Automation.PSCredential]$databaseCredential = $null,
        [ValidateSet('None','Desktop','StartMenu','CommonStartMenu')]
        [string]$shortcuts='Desktop',
        [switch]$updateHosts,
        [switch]$useSSL,
        [switch]$includeCSide,
        [switch]$enableSymbolLoading,
        [switch]$doNotExportObjectsToText,
        [switch]$alwaysPull,
        [switch]$useBestContainerOS,
        [switch]$assignPremiumPlan,
        [switch]$multitenant,
        [switch]$clickonce,
        [switch]$includeTestToolkit,
        [switch]$includeTestLibrariesOnly,
        [ValidateSet('no','on-failure','unless-stopped','always')]
        [string]$restart='unless-stopped',
        [ValidateSet('Windows','NavUserPassword','AAD')]
        [string]$auth='Windows',
        [int]$timeout = 1800,
        [string[]]$additionalParameters = @(),
        $myScripts = @(),
        [string]$TimeZoneId = $null,
        [int]$WebClientPort,
        [int]$FileSharePort,
        [int]$ManagementServicesPort,
        [int]$ClientServicesPort,
        [int]$SoapServicesPort,
        [int]$ODataServicesPort,
        [int]$DeveloperServicesPort,
        [int[]]$PublishPorts = @(),
        [string]$PublicDnsName
    )

    $ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
    foreach ($key in $ParameterList.keys)
    {
        $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
        if($var)
        {
            
            if([string]::IsNullOrEmpty($var.value) -eq $false)
            {
                write-host "$($var.name) > $($var.value)"
            }
        }
    }
}    


MKO.New-NavContainer -accept_eula -containerName "asd"


<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Test_190120
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 100
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(117,67)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($TextBox1))


#foreach(KeyValuePair<string,> kvp in someDictionary){
#    Label label = new Label();
#    label.Text = kvp.Key;
#    label.Top = usedHeight + 7; label.Left = 5;
#    form.Controls.Add(label);##

#    TextBox textBox = new TextBox();
#    textBox.Text = kvp.Value;
#    textBox.Top = usedHeight + 5; textBox.Left = 80;
#    textBox.Width = 115;
#    textBox.Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right;
#    form.Controls.Add(textBox);##



$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 115
$TextBox1.Top                    = $usedHeight + 5; 
$TextBox1Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right;

$TextBox1.location               = New-Object System.Drawing.Point(117,67)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($TextBox1))


#    usedHeight += textBox.Height + 5;
#}


#Write your logic code here

[void]$Form.ShowDialog()



#$Form.Width = 200;
#$Form.SuspendLayout();
#[int]$usedHeight = 0;


#foreach(KeyValuePair<string,> kvp in someDictionary){
#    Label label = new Label();
#    label.Text = kvp.Key;
#    label.Top = usedHeight + 7; label.Left = 5;
#    form.Controls.Add(label);##

#    TextBox textBox = new TextBox();
#    textBox.Text = kvp.Value;
#    textBox.Top = usedHeight + 5; textBox.Left = 80;
#    textBox.Width = 115;
#    textBox.Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right;
#    form.Controls.Add(textBox);##

#    usedHeight += textBox.Height + 5;
#}




