$word = New-Object -Com Word.Application
$word.Visible = $false #to prevent the document you open to show
$doc = $word.Documents.Open("C:\test.doc")

$binding = "System.Reflection.BindingFlags" -as [type]
Foreach($property in $doc.BuiltInDocumentProperties) {
   try {
      $pn = [System.__ComObject].invokemember("name",$binding::GetProperty,$null,$property,$null)
      if ($pn -eq "Last author") {
         $lastSaved = [System.__ComObject].invokemember("value",$binding::GetProperty,$null,$property,$null)
         echo "Last saved by: "$lastSaved      
      }        }
   catch { }
}

$doc.Close($false)
$word.Quit()