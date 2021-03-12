#Powershell script which runs a light weight webserver to serve a single file, intended for serving the proxy pac files in windows.
#v1.0 vMan.ch, 11.03.2021 - Initial Version


param
(
    [String]$FileName = 'my.pac'
)

$ScriptPath = (Get-Item -Path ".\" -Verbose).FullName

$byteFile = [System.IO.File]::ReadAllBytes("$ScriptPath\$FileName")
$httpListener = New-Object System.Net.HttpListener
$httpListener.Prefixes.Add("http://+:8080/")
$httpListener.Start()

try
{
  while ($httpListener.IsListening) {  
 
    $httpListenerContext = $httpListener.GetContext()
    $httpResponse = $httpListenerContext.Response
    $httpResponse.ContentType = "application/x-ns-proxy-autoconfig"
    $httpResponse.ContentLength64 = $byteFile.Length
    $httpResponse.OutputStream.Write($byteFile,0,$byteFile.Length)
    $httpResponse.Close()
  }
}
finally
{ 
    $httpListener.Close()
}
