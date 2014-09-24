Install-ChocolateyPackage 'HighTail_Express' 'exe' '/S /v/qn' 'https://static.hightail.com/plugins/HightailExpress-2_14_1.exe' 
get-process hightail | Stop-Process