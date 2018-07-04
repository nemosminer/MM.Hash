$Path = ".\Bin\krnlx\6"
$Uri = "https://github.com/krnlx/ccminer-xevan.git"
$Build = "Linux"
$Distro = "Linux"

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

if($CCDevices3 -ne ''){$Devices = $CCDevices3}
if($GPUDevices3 -ne ''){$Devices = $GPUDevices3}

#Algorithms:
#Xevan

$Commands = [PSCustomObject]@{
"BSD" = '' #xevan
"ELLI" = '' #xevan
"ELP" = '' #xevan
"FLC" = '' #xevan
"HASH" = '' #xevan
"KRAIT" = '' #xevan
"URALS" = '' #xevan
}

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    if($Algorithm -eq "$($Pools.$_.Algorithm)")
     {
        [PSCustomObject]@{
        MinerName = "ccminer"
        Type = "NVIDIA3"
        Path = $Path
        Distro = $Distro
        Devices = $Devices
        Arguments = "-a $($Pools.$_.Algorithm) -o stratum+tcp://$($Pools.$_.Host):$($Pools.$_.Port) -b 0.0.0.0:4071 -u $($Pools.$_.User3) -p $($Pools.$_.Pass3) $($Commands.$_)"
        HashRates = [PSCustomObject]@{$_ = $Stats."$($Name)_$($_)_HashRate".Live}
        API = "Ccminer"
        Selected = [PSCustomObject]@{$($Pools.$_.Algorithm) = ""}
        Port = 4071
        Wrap = $false
        URI = $Uri
        BUILD = $Build
      }
     }
    }

