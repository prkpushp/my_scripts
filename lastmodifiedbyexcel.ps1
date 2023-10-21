$excel = New-Object -Com excel.Application
$excel.Visible = $false #to prevent the document you open to show
$xlsx = $excel.Workbooks.Open("C:\test2.xlsx")

$binding = "System.Reflection.BindingFlags" -as [type]
Foreach($property in $xlsx.BuiltInDocumentProperties) {
   try {
      $pn = [System.__ComObject].invokemember("name",$binding::GetProperty,$null,$property,$null)
      if ($pn -eq "Last author") {
         $lastSaved = [System.__ComObject].invokemember("value",$binding::GetProperty,$null,$property,$null)
         echo "Last saved by: "$lastSaved      
      }        }
   catch { }
}

$xlsx.Close($false)
$excel.Quit()