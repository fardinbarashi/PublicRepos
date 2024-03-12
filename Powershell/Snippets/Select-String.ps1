$FilePath = ""
$Keywords = "Number1", "Number2", "Number3"
$GetItems = Get-ChildItem -Path $FilePath -Recurse -Force
$GetItems | Select-String -Pattern $Keywords