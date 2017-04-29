function create_url($the_command) {
  $host_ip = "192.168.122.1"
  $host_port = "8080"
  $the_url = "http://" + $host_ip + ":" + $host_port + "/" + $the_command
  return $the_url
}
  

$wc = New-Object system.Net.WebClient;
Write-Host "Beginning communication to host server..."
Write-Host "*****************************************"

Write-Host "Client: sending message to add keyboard/mouse..."
$the_cmd = create_url("add_keyboard_mouse")
$result = $wc.DownloadString($the_cmd)
Write-Host $result
Write-Host "*****************************************"

Write-Host "Client: sending message to set VM status to online..."
$the_cmd = create_url("tell_online")
$result = $wc.DownloadString($the_cmd)
Write-Host $result
Write-Host "*****************************************"

Read-Host -Prompt "Press Enter to exit"