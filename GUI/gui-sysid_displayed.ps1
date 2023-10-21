#TextBox Name="RITMNumber"

Add-Type -AssemblyName PresentationFramework

$user = 'admin'
$pass = 'IjWI17lj/=Ta'

$env = "dev127921"
#$env = "kronosclouddev"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')

function readritm($ritm){
	$uri = "https://"+ $env + ".service-now.com/api/now/table/sc_req_item?sysparm_query=number%3D" + $ritm + "&sysparm_display_value=true&sysparm_limit=1"
	$method = "get"
	$response = Invoke-RestMethod -Headers $headers -ContentType "application/json" -Method $method -Uri $uri 
	$sysid.content = $response.result.sys_id
	#Write-Host "$sys_id"
	return $sysid
}


[xml]$form = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="System Check" Height="396.022" Width="536.587">
    <Grid>
        <TabControl Name="tabControl" HorizontalAlignment="Left" Height="345" Margin="10,10,0,0" VerticalAlignment="Top" Width="509">
            <TabItem Header="General">
                <Grid Background="#FFE5E5E5">
                    <Image Name="image" HorizontalAlignment="Left" Height="213" Margin="10,10,0,0" VerticalAlignment="Top" Width="483" Source="C:\Users\jadkin\Pictures\pluralsight-logo.png" Stretch="UniformToFill"/>
                    <Label Name="label" Content="Enter RITM NUmber and click start to run the program" HorizontalAlignment="Left" Height="26" Margin="30,226,0,0" VerticalAlignment="Top" Width="451"/>
                    <Label Name="label1" Content="RITM Number:" HorizontalAlignment="Left" Height="33" Margin="30,263,0,0" VerticalAlignment="Top" Width="109"/>
                    <TextBox Name="RITMNumber" HorizontalAlignment="Left" Height="32" Margin="147,264,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="224"/>
                    <Button Name="Start" Content="Start" HorizontalAlignment="Left" Height="31" Margin="380,265,0,0" VerticalAlignment="Top" Width="101"/>
                </Grid>
            </TabItem>
            <TabItem Header="RITM Result">
                <Grid Background="#FFE5E5E5">
                    <Label Name="label2" Content="SYS ID:" HorizontalAlignment="Left" Height="28" Margin="10,10,0,0" VerticalAlignment="Top" Width="118"/>
                    <Label Name="label3" Content="Result:" HorizontalAlignment="Left" Height="27" Margin="10,51,0,0" VerticalAlignment="Top" Width="116"/>
                    <Label Name="SYSID" Content="" HorizontalAlignment="Left" Height="28" Margin="131,10,0,0" VerticalAlignment="Top" Width="289"/>
                    <Label Name="Result" Content="" HorizontalAlignment="Left" Height="27" Margin="131,51,0,0" VerticalAlignment="Top" Width="289"/>
                </Grid>
            </TabItem>

        </TabControl>

    </Grid>
</Window>

"@
$NR=(New-Object System.Xml.XmlNodeReader $Form)
$Win=[Windows.Markup.XamlReader]::Load( $NR ) 

$ritm = $win.FindName("RITMNumber")
$start = $win.FindName("Start")
$sysid = $win.FindName("SYSID")
#$Result = $win.FindName("Result")

$arrev = New-Object System.Collections.ArrayList
$arrproc = New-Object System.Collections.ArrayList

$start.add_click({
$ritm_no = $ritm.Text
readritm $ritm_no
})
$Win.ShowDialog()
