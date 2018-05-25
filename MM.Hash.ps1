﻿param(
    [Parameter(Mandatory=$false)]
    [String]$Wallet,
    [Parameter(Mandatory=$false)]
    [String]$Wallet1,
    [Parameter(Mandatory=$false)]
    [String]$Wallet2,
    [Parameter(Mandatory=$false)]
    [String]$Wallet3,
    [Parameter(Mandatory=$false)]
    [String]$Wallet4,
    [Parameter(Mandatory=$false)]
    [String]$Wallet5,
    [Parameter(Mandatory=$false)]
    [String]$Wallet6,
    [Parameter(Mandatory=$false)]
    [String]$Wallet7,
    [Parameter(Mandatory=$false)]
    [String]$Wallet8,
    [Parameter(Mandatory=$false)]
    [String]$UserName = "MaynardVII", 
    [Parameter(Mandatory=$false)]
    [String]$WorkerName = "Rig1",
    [Parameter(Mandatory=$false)]
    [String]$RigName = "MMHash",
    [Parameter(Mandatory=$false)]
    [Int]$API_ID = 0, 
    [Parameter(Mandatory=$false)]
    [String]$API_Key = "", 
    [Parameter(Mandatory=$false)]
    [Int]$Interval = 300, #seconds before reading hash rate from miners
    [Parameter(Mandatory=$false)] 
    [Int]$StatsInterval = "1", #seconds of current active to gather hashrate if not gathered yet 
    [Parameter(Mandatory=$false)]
    [String]$Location = "US", #europe/us/asia
    [Parameter(Mandatory=$false)]
    [String]$MPHLocation = "US", #europe/us/asia
    [Parameter(Mandatory=$false)]
    [Switch]$SSL = $false, 
    [Parameter(Mandatory=$false)]
    [Array]$Type = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type1 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type2 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type3 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type4 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type5 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type6 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type7 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Type8 = $null, #AMD/NVIDIA/CPU
    [Parameter(Mandatory=$false)]
    [Array]$Algorithm = $null, #i.e. Ethash,Equihash,Cryptonight ect.
    [Parameter(Mandatory=$false)]
    [Array]$MinerName = $null,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices1, 
    [Parameter(Mandatory=$false)] 
    [String]$GPUDevices2,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices3,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices4,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices5,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices6,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices7,
    [Parameter(Mandatory=$false)]
    [String]$GPUDevices8,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices1, 
    [Parameter(Mandatory=$false)] 
    [String]$EWBFDevices2,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices3,
    [Parameter(Mandatory=$false)]
    [String]$EwBFDevices4,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices5,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices6,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices7,
    [Parameter(Mandatory=$false)]
    [String]$EWBFDevices8,
    [Parameter(Mandatory=$false)]
    [Array]$PoolName = $null, 
    [Parameter(Mandatory=$false)]
    [Array]$Currency = ("USD"), #i.e. GBP,EUR,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency1 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency2 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency3 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency4 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency5 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency6 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency7 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Array]$Passwordcurrency8 = ("BTC"), #i.e. BTC,LTC,ZEC,ETH ect.
    [Parameter(Mandatory=$false)]
    [Int]$Donate = 5, #Minutes per Day
    [Parameter(Mandatory=$false)]
    [String]$Proxy = "", #i.e http://192.0.0.1:8080 
    [Parameter(Mandatory=$false)]
    [Int]$Delay = 1, #seconds before opening each miner
    [Parameter(Mandatory=$false)]
    [Array]$SelectedAlgo = $null,
    [Parameter(Mandatory=$false)]
    [String]$CoinExchange = ""
)

Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)

Get-ChildItem . -Recurse | Out-Null 

try{if((Get-MpPreference).ExclusionPath -notcontains (Convert-Path .)){Start-Process powershell -Verb runAs -ArgumentList "Add-MpPreference -ExclusionPath '$(Convert-Path .)'"}}catch{}

if($Proxy -eq ""){$PSDefaultParameterValues.Remove("*:Proxy")}
else{$PSDefaultParameterValues["*:Proxy"] = $Proxy}

. .\Include.ps1

$DecayStart = Get-Date
$DecayPeriod = 60 #seconds
$DecayBase = 1-0.1 #decimal percentage

$ActiveMinerPrograms = @()

#Start the log
Start-Transcript ".\Logs\$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss").txt"
    
#Update stats with missing data and set to today's date/time
if(Test-Path "Stats"){Get-ChildItemContent "Stats" | ForEach {$Stat = Set-Stat $_.Name $_.Content.Week}}


if((Get-Item ".\Build\Data\Info.txt" -ErrorAction SilentlyContinue) -eq $null)
 {
  New-Item -Path ".\Build\Data\" -Name "Info.txt"
 }
if((Get-Item ".\Build\Data\System.txt" -ErrorAction SilentlyContinue) -eq $null)
 {
  New-Item -Path ".\Build\Data" -Name "System.txt"
 }
if((Get-Item ".\Build\Data\TimeTable.txt" -ErrorAction SilentlyContinue) -eq $null)
 {
  New-Item -Path ".\Build\Data" -Name "TimeTable.txt"
 }

$DonationClear = Get-Content ".\Build\Data\Info.txt" | Out-String

if($DonationClear -ne "")
 {
  Clear-Content ".\Build\Data\Info.txt"
 }


$WalletDonate = "1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i"
$UserDonate = "MaynardVII"
$WorkerDonate = "Rig1"
$WalletSwitch = $Wallet
$WalletSwitch1 = $Wallet1
$WalletSwitch2 = $Wallet2
$WalletSwitch3 = $Wallet3
$WalletSwitch4 = $Wallet4
$WalletSwitch5 = $Wallet5
$WalletSwitch6 = $Wallet6
$WalletSwitch7 = $Wallet7
$WalletSwitch8 = $Wallet8
$PasswordSwitch = $Passwordcurrency
$PasswordSwitch1 = $Passwordcurrency1
$PasswordSwitch2 = $Passwordcurrency2
$PasswordSwitch3 = $Passwordcurrency3
$PasswordSwitch4 = $Passwordcurrency4
$PasswordSwitch5 = $Passwordcurrency5
$PasswordSwitch6 = $Passwordcurrency6
$PasswordSwitch7 = $Passwordcurrency7
$PasswordSwitch8 = $Passwordcurrency8
$UserSwitch = $UserName
$WorkerSwitch = $WorkerName
$RigSwitch = $RigName
$IntervalSwitch = $Interval
     
#Update stats with missing data and set to today's date/time
if(Test-Path "Stats"){Get-ChildItemContent "Stats" | ForEach {$Stat = Set-Stat $_.Name $_.Content.Week}}

Write-Host "








    MMMMMMMM               MMMMMMMMMMMMMMMM               MMMMMMMM        HHHHHHHHH     HHHHHHHHH               AAA                 SSSSSSSSSSSSSSS HHHHHHHHH     HHHHHHHHH
    M:::::::M             M:::::::MM:::::::M             M:::::::M        H:::::::H     H:::::::H              A:::A              SS:::::::::::::::SH:::::::H     H:::::::H
    M::::::::M           M::::::::MM::::::::M           M::::::::M        H:::::::H     H:::::::H             A:::::A            S:::::SSSSSS::::::SH:::::::H     H:::::::H
    M:::::::::M         M:::::::::MM:::::::::M         M:::::::::M        HH::::::H     H::::::HH            A:::::::A           S:::::S     SSSSSSSHH::::::H     H::::::HH
    M::::::::::M       M::::::::::MM::::::::::M       M::::::::::M          H:::::H     H:::::H             A:::::::::A          S:::::S              H:::::H     H:::::H  
    M:::::::::::M     M:::::::::::MM:::::::::::M     M:::::::::::M          H:::::H     H:::::H            A:::::A:::::A         S:::::S              H:::::H     H:::::H  
    M:::::::M::::M   M::::M:::::::MM:::::::M::::M   M::::M:::::::M          H::::::HHHHH::::::H           A:::::A A:::::A         S::::SSSS           H::::::HHHHH::::::H  
    M::::::M M::::M M::::M M::::::MM::::::M M::::M M::::M M::::::M          H:::::::::::::::::H          A:::::A   A:::::A         SS::::::SSSSS      H:::::::::::::::::H  
    M::::::M  M::::M::::M  M::::::MM::::::M  M::::M::::M  M::::::M          H:::::::::::::::::H         A:::::A     A:::::A          SSS::::::::SS    H:::::::::::::::::H  
    M::::::M   M:::::::M   M::::::MM::::::M   M:::::::M   M::::::M          H::::::HHHHH::::::H        A:::::AAAAAAAAA:::::A            SSSSSS::::S   H::::::HHHHH::::::H  
    M::::::M    M:::::M    M::::::MM::::::M    M:::::M    M::::::M          H:::::H     H:::::H       A:::::::::::::::::::::A                S:::::S  H:::::H     H:::::H  
    M::::::M     MMMMM     M::::::MM::::::M     MMMMM     M::::::M          H:::::H     H:::::H      A:::::AAAAAAAAAAAAA:::::A               S:::::S  H:::::H     H:::::H  
    M::::::M               M::::::MM::::::M               M::::::M        HH::::::H     H::::::HH   A:::::A             A:::::A  SSSSSSS     S:::::SHH::::::H     H::::::HH
    M::::::M               M::::::MM::::::M               M::::::M ...... H:::::::H     H:::::::H  A:::::A               A:::::A S::::::SSSSSS:::::SH:::::::H     H:::::::H
    M::::::M               M::::::MM::::::M               M::::::M .::::. H:::::::H     H:::::::H A:::::A                 A:::::AS:::::::::::::::SS H:::::::H     H:::::::H
    MMMMMMMM               MMMMMMMMMMMMMMMM               MMMMMMMM ...... HHHHHHHHH     HHHHHHHHHAAAAAAA                   AAAAAAASSSSSSSSSSSSSSS   HHHHHHHHH     HHHHHHHHH

				             By: MaynardMiner                      v1.1.7-final              GitHub: http://Github.com/MaynardMiner/MM.Hash

																					
									      SUDO APT-GET LAMBO

						BTC DONATION ADRRESS TO SUPPORT DEVELOPMENT: 1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i





" -foregroundColor "darkred"

while($true)
{
$DecayExponent = [int](((Get-Date)-$DecayStart).TotalSeconds/$DecayPeriod)
$InfoCheck = Get-Content ".\Build\Data\Info.txt" | Out-String
$DonateCheck = Get-Content ".\Build\Data\System.txt" | Out-String
$LastRan = Get-Content ".\Build\Data\TimeTable.txt" | Out-String

if($Donate -ne 0)
 {
  $DonationTotal = (864*[int]$Donate)
  $DonationIntervals = ([int]$DonationTotal/288)
  $FinalDonation = (86400/[int]$DonationIntervals)

 if($LastRan -eq "")
  {
   Get-Date | Out-File ".\Build\Data\TimeTable.txt"
   Continue
  }

if($LastRan -ne "")
 {
 $RanDonate = [DateTime]$LastRan
 $LastRanDonated = [math]::Round(((Get-Date)-$RanDonate).TotalSeconds)
 if($LastRanDonated -ge 86400)
  {
  Clear-Content ".\Build\Data\TimeTable.txt"
  Get-Date | Out-File ".\Build\Data\TimeTable.txt"
  Continue
  }
 }

if($LastRan -ne "")
 {
 $LastRanDonate = [DateTime]$LastRan
 $LastTimeActive = [math]::Round(((Get-Date)-$LastRanDonate).TotalSeconds)
  if($LastTimeActive -ge 1) 
   {
   if($DonateCheck -eq "")
    {
    Get-Date | Out-File ".\Build\Data\System.txt"
    Continue
    }
   $Donated = [DateTime]$DonateCheck
   $CurrentlyDonated = [math]::Round(((Get-Date)-$Donated).TotalSeconds)
   if($CurrentlyDonated -ge [int]$FinalDonation)
    {
     $Wallet = $WalletDonate
     $Wallet1 = $WalletDonate
     $Wallet2 = $WalletDonate
     $Wallet3 = $WalletDonate
     $Wallet4 = $WalletDonate
     $Wallet5 = $WalletDonate
     $Wallet6 = $WalletDonate
     $Wallet7 = $WalletDonate
     $Wallet8 = $WalletDonate
     $UserName = $UserDonate
     $WorkerName = $WorkerDonate
     $RigName = "DONATING!!!"
     $Interval = 288
     $Passwordcurrency = ("BTC")
     $Passwordcurrency1 = ("BTC")
     $Passwordcurrency2 = ("BTC")	
     $Passwordcurrency3 = ("BTC")
     $Passwordcurrency4 = ("BTC")
     $Passwordcurrency5 = ("BTC")
     $Passwordcurrency6 = ("BTC")
     $Passwordcurrency7 = ("BTC")
     $Passwordcurrency8 = ("BTC")	
     if(($InfoCheck) -eq "")
     {	
     Get-Date | Out-File ".\Build\Data\Info.txt"
     }
     Clear-Content ".\Build\Data\System.txt"
     Get-Date | Out-File ".\Build\Data\System.txt"
     Start-Sleep -s 1
     Write-Host  "Entering Donation Mode" -foregroundColor "darkred"
     Continue
    }
  }
 }

 if($InfoCheck -ne "")
  {
     $TimerCheck = [DateTime]$InfoCheck
     $LastTimerCheck = [math]::Round(((Get-Date)-$LastRanDonate).TotalSeconds)
     if(((Get-Date)-$TimerCheck).TotalSeconds -ge $Interval)
      {
        $Wallet = $WalletSwitch
        $Wallet1 = $WalletSwitch1
        $Wallet2 = $WalletSwitch2
	$Wallet3 = $WalletSwitch3
        $Wallet4 = $WalletSwitch4
        $Wallet5 = $WalletSwitch5
	$Wallet6 = $WalletSwitch6
	$Wallet7 = $WalletSwitch7
	$Wallet8 = $WalletSwitch8
	$UserName = $UserSwitch
	$WorkerName = $WorkerSwitch
	$RigName = $RigSwitch
        $Interval = $IntervalSwitch
        $Passwordcurrency = $PasswordSwitch
	$Passwordcurrency1 = $PasswordSwitch1
        $Passwordcurrency2 = $PasswordSwitch2
        $Passwordcurrency3 = $PasswordSwitch3
        $Passwordcurrency4 = $PasswordSwitch4
        $Passwordcurrency5 = $PasswordSwitch5
        $Passwordcurrency6 = $PasswordSwitch6
        $Passwordcurrency7 = $PasswordSwitch7
        $Passwordcurrency8 = $PasswordSwitch8
	Clear-Content ".\Build\Data\Info.txt"
	Write-Host "Leaving Donation Mode- Thank you For The Support!" -foregroundcolor "darkred"
	Continue
       }
   }
}


    try {
	$T = [string]$CoinExchange
	$R= [string]$Currency
        Write-Host "MM.Hash Is Exiting Any Open Miner If Better Algo Is Found & Checking CryptoCompare For $CoinExchange prices" -foregroundcolor "Yellow"
        $Exchanged =  Invoke-RestMethod "https://min-api.cryptocompare.com/data/price?fsym=$T&tsyms=$R" -UseBasicParsing | Select-Object -ExpandProperty $R
	$Rates = Invoke-RestMethod "https://api.coinbase.com/v2/exchange-rates?currency=$R" -UseBasicParsing | Select-Object -ExpandProperty data | Select-Object -ExpandProperty rates
        $Currency | Where-Object {$Rates.$_} | ForEach-Object {$Rates | Add-Member $_ ([Double]$Rates.$_) -Force}
    }
    catch {
    Write-Host -Level Warn "Coinbase Unreachable. "

    Write-Host -ForegroundColor Yellow "Last Refresh: $(Get-Date)"
    Write-host "Trying To Contact Cryptonator.." -foregroundcolor "Yellow"
        $Rates = [PSCustomObject]@{}
        $Currency | ForEach {$Rates | Add-Member $_ (Invoke-WebRequest "https://api.cryptonator.com/api/ticker/btc-$_" -UseBasicParsing | ConvertFrom-Json).ticker.price}
   }
    #Load the Stats
    $Stats = [PSCustomObject]@{}
    if(Test-Path "Stats"){Get-ChildItemContent "Stats" | ForEach {$Stats | Add-Member $_.Name $_.Content}}

    #Load information about the Pools
    $AllPools = if(Test-Path "Pools"){Get-ChildItemContent "Pools" | ForEach {$_.Content | Add-Member @{Name = $_.Name} -PassThru} | 
        Where Location -EQ $Location | 
        Where SSL -EQ $SSL | 
        Where {$PoolName.Count -eq 0 -or (Compare-Object $PoolName $_.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}}
    if($AllPools.Count -eq 0){"No Pools!" | Out-Host; start-sleep $Interval; continue}
    $Pools = [PSCustomObject]@{}
    $Pools_Comparison = [PSCustomObject]@{}
    $AllPools.Algorithm | Select -Unique | ForEach {$Pools | Add-Member $_ ($AllPools | Where Algorithm -EQ $_ | Sort-Object Price -Descending | Select -First 1)}
    $AllPools.Algorithm | Select -Unique | ForEach {$Pools_Comparison | Add-Member $_ ($AllPools | Where Algorithm -EQ $_ | Sort-Object StablePrice -Descending | Select -First 1)}

    #Load information about the Miners
    #Messy...?
    $Miners = if(Test-Path "Miners"){Get-ChildItemContent "Miners" | ForEach {$_.Content | Add-Member @{Name = $_.Name} -PassThru} | 
 Where-Object {$Type.Count -eq 0 -or (Compare-Object $Type $_.Type -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0} |
 Where-Object {$Algorithm.count -eq 0 -or (Compare-Object $Algorithm $_.HashRates.PSObject.Properties.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0} | 
 Where-Object {$MinerName.Count -eq 0 -or (Compare-Object  $MinerName $_.Name -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}}
    $Miners = $Miners | ForEach {
        $Miner = $_
       if((Test-Path $Miner.Path) -eq $false)
        {
	if($Miner.BUILD -eq "Linux" -or $Miner.BUILD -eq "Linux-Clean")
	  {
          Expand-WebRequest -URI $Miner.URI -BuildPath $Miner.BUILD -Path (Split-Path $Miner.Path)
          }
        if($Miner.BUILD -eq "Windows" -or "Linux-Zip")
	 {
	 if((Split-Path $Miner.URI -Leaf) -eq (Split-Path $Miner.Path -Leaf))
          {
           New-Item (Split-Path $Miner.Path) -ItemType "Directory" | Out-Null
           Invoke-WebRequest $Miner.URI -OutFile $_.Path -UseBasicParsing
          }
	 else
            {
             Expand-WebRequest -URI $Miner.URI -BuildPath $Miner.BUILD -Path (Split-Path $Miner.Path)
            }
           }
	  }
       else
	{
	 $Miner
        }
   }
 
    if($Miners.Count -eq 0){"No Miners!" | Out-Host; start-sleep $Interval; continue}
    $Miners | ForEach {
        $Miner = $_

        $Miner_HashRates = [PSCustomObject]@{}
        $Miner_Pools = [PSCustomObject]@{}
        $Miner_Pools_Comparison = [PSCustomObject]@{}
        $Miner_Profits = [PSCustomObject]@{}
        $Miner_Profits_Comparison = [PSCustomObject]@{}
        $Miner_Profits_Bias = [PSCustomObject]@{}

        $Miner_Types = $Miner.Type | Select -Unique
        $Miner_Indexes = $Miner.Index | Select -Unique

        $Miner.HashRates | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
            $Miner_HashRates | Add-Member $_ ([Double]$Miner.HashRates.$_)
            $Miner_Pools | Add-Member $_ ([PSCustomObject]$Pools.$_)
            $Miner_Pools_Comparison | Add-Member $_ ([PSCustomObject]$Pools_Comparison.$_)
            $Miner_Profits | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools.$_.Price)
            $Miner_Profits_Comparison | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools_Comparison.$_.Price)
            $Miner_Profits_Bias | Add-Member $_ ([Double]$Miner.HashRates.$_*$Pools.$_.Price*(1-($Pools.$_.MarginOfError*[Math]::Pow($DecayBase,$DecayExponent))))
        }
        
        $Miner_Profit = [Double]($Miner_Profits.PSObject.Properties.Value | Measure -Sum).Sum
        $Miner_Profit_Comparison = [Double]($Miner_Profits_Comparison.PSObject.Properties.Value | Measure -Sum).Sum
        $Miner_Profit_Bias = [Double]($Miner_Profits_Bias.PSObject.Properties.Value | Measure -Sum).Sum
        
        $Miner.HashRates | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
            if(-not [String]$Miner.HashRates.$_)
            {
                $Miner_HashRates.$_ = $null
                $Miner_Profits.$_ = $null
                $Miner_Profits_Comparison.$_ = $null
                $Miner_Profits_Bias.$_ = $null
                $Miner_Profit = $null
                $Miner_Profit_Comparison = $null
                $Miner_Profit_Bias = $null
            }
        }

        if($Miner_Types -eq $null){$Miner_Types = $Miners.Type | Select -Unique}
        if($Miner_Indexes -eq $null){$Miner_Indexes = $Miners.Index | Select -Unique}
        
        if($Miner_Types -eq $null){$Miner_Types = ""}
        if($Miner_Indexes -eq $null){$Miner_Indexes = 0}
        
        $Miner.HashRates = $Miner_HashRates

        $Miner | Add-Member Pools $Miner_Pools
        $Miner | Add-Member Profits $Miner_Profits
        $Miner | Add-Member Profits_Comparison $Miner_Profits_Comparison
        $Miner | Add-Member Profits_Bias $Miner_Profits_Bias
        $Miner | Add-Member Profit $Miner_Profit
        $Miner | Add-Member Profit_Comparison $Miner_Profit_Comparison
        $Miner | Add-Member Profit_Bias $Miner_Profit_Bias
        
        $Miner | Add-Member Type $Miner_Types -Force
        $Miner | Add-Member Index $Miner_Indexes -Force

        $Miner.Path = Convert-Path $Miner.Path
    }
    $Miners | ForEach {
        $Miner = $_
        $Miner_Devices = $Miner.Device | Select -Unique
        if($Miner_Devices -eq $null){$Miner_Devices = ($Miners | Where {(Compare-Object $Miner.Type $_.Type -IncludeEqual -ExcludeDifferent | Measure).Count -gt 0}).Device | Select -Unique}
        if($Miner_Devices -eq $null){$Miner_Devices = $Miner.Type}
        $Miner | Add-Member Device $Miner_Devices -Force
    }

    #Don't penalize active miners
    $ActiveMinerPrograms | ForEach {$Miners | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments | ForEach {$_.Profit_Bias = $_.Profit}}

    #Get most profitable miner combination i.e. AMD+NVIDIA+CPU
    $BestMiners = $Miners | Select Type,Index -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare-Object $Miner_GPU.Type $_.Type | Measure).Count -eq 0 -and (Compare-Object $Miner_GPU.Index $_.Index | Measure).Count -eq 0} | Sort-Object -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Bias -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestDeviceMiners = $Miners | Select Device -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare-Object $Miner_GPU.Device $_.Device | Measure).Count -eq 0} | Sort-Object -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Bias -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestMiners_Comparison = $Miners | Select Type,Index -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare-Object $Miner_GPU.Type $_.Type | Measure).Count -eq 0 -and (Compare-Object $Miner_GPU.Index $_.Index | Measure).Count -eq 0} | Sort-Object -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Comparison -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $BestDeviceMiners_Comparison = $Miners | Select Device -Unique | ForEach {$Miner_GPU = $_; ($Miners | Where {(Compare-Object $Miner_GPU.Device $_.Device | Measure).Count -eq 0} | Sort-Object -Descending {($_ | Where Profit -EQ $null | Measure).Count},{($_ | Measure Profit_Comparison -Sum).Sum},{($_ | Where Profit -NE 0 | Measure).Count} | Select -First 1)}
    $Miners_Type_Combos = @([PSCustomObject]@{Combination = @()}) + (Get-Combination ($Miners | Select Type -Unique) | Where{(Compare-Object ($_.Combination | Select -ExpandProperty Type -Unique) ($_.Combination | Select -ExpandProperty Type) | Measure).Count -eq 0})
    $Miners_Index_Combos = @([PSCustomObject]@{Combination = @()}) + (Get-Combination ($Miners | Select Index -Unique) | Where{(Compare-Object ($_.Combination | Select -ExpandProperty Index -Unique) ($_.Combination | Select -ExpandProperty Index) | Measure).Count -eq 0})
    $Miners_Device_Combos = (Get-Combination ($Miners | Select Device -Unique) | Where{(Compare-Object ($_.Combination | Select -ExpandProperty Device -Unique) ($_.Combination | Select -ExpandProperty Device) | Measure).Count -eq 0})
    $BestMiners_Combos = $Miners_Type_Combos | ForEach {$Miner_Type_Combo = $_.Combination; $Miners_Index_Combos | ForEach {$Miner_Index_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Type_Combo | ForEach {$Miner_Type_Count = $_.Type.Count; [Regex]$Miner_Type_Regex = ‘^(‘ + (($_.Type | ForEach {[Regex]::Escape($_)}) -join “|”) + ‘)$’; $Miner_Index_Combo | ForEach {$Miner_Index_Count = $_.Index.Count; [Regex]$Miner_Index_Regex = ‘^(‘ + (($_.Index | ForEach {[Regex]::Escape($_)}) –join “|”) + ‘)$’; $BestMiners | Where {([Array]$_.Type -notmatch $Miner_Type_Regex).Count -eq 0 -and ([Array]$_.Index -notmatch $Miner_Index_Regex).Count -eq 0 -and ([Array]$_.Type -match $Miner_Type_Regex).Count -eq $Miner_Type_Count -and ([Array]$_.Index -match $Miner_Index_Regex).Count -eq $Miner_Index_Count}}}}}}
    $BestMiners_Combos += $Miners_Device_Combos | ForEach {$Miner_Device_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Device_Combo | ForEach {$Miner_Device_Count = $_.Device.Count; [Regex]$Miner_Device_Regex = ‘^(‘ + (($_.Device | ForEach {[Regex]::Escape($_)}) -join “|”) + ‘)$’; $BestDeviceMiners | Where {([Array]$_.Device -notmatch $Miner_Device_Regex).Count -eq 0 -and ([Array]$_.Device -match $Miner_Device_Regex).Count -eq $Miner_Device_Count}}}}
    $BestMiners_Combos_Comparison = $Miners_Type_Combos | ForEach {$Miner_Type_Combo = $_.Combination; $Miners_Index_Combos | ForEach {$Miner_Index_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Type_Combo | ForEach {$Miner_Type_Count = $_.Type.Count; [Regex]$Miner_Type_Regex = ‘^(‘ + (($_.Type | ForEach {[Regex]::Escape($_)}) -join “|”) + ‘)$’; $Miner_Index_Combo | ForEach {$Miner_Index_Count = $_.Index.Count; [Regex]$Miner_Index_Regex = ‘^(‘ + (($_.Index | ForEach {[Regex]::Escape($_)}) –join “|”) + ‘)$’; $BestMiners_Comparison | Where {([Array]$_.Type -notmatch $Miner_Type_Regex).Count -eq 0 -and ([Array]$_.Index -notmatch $Miner_Index_Regex).Count -eq 0 -and ([Array]$_.Type -match $Miner_Type_Regex).Count -eq $Miner_Type_Count -and ([Array]$_.Index -match $Miner_Index_Regex).Count -eq $Miner_Index_Count}}}}}}
    $BestMiners_Combos_Comparison += $Miners_Device_Combos | ForEach {$Miner_Device_Combo = $_.Combination; [PSCustomObject]@{Combination = $Miner_Device_Combo | ForEach {$Miner_Device_Count = $_.Device.Count; [Regex]$Miner_Device_Regex = ‘^(‘ + (($_.Device | ForEach {[Regex]::Escape($_)}) -join “|”) + ‘)$’; $BestDeviceMiners_Comparison | Where {([Array]$_.Device -notmatch $Miner_Device_Regex).Count -eq 0 -and ([Array]$_.Device -match $Miner_Device_Regex).Count -eq $Miner_Device_Count}}}}
    $BestMiners_Combo = $BestMiners_Combos | Sort-Object -Descending {($_.Combination | Where Profit -EQ $null | Measure).Count},{($_.Combination | Measure Profit_Bias -Sum).Sum},{($_.Combination | Where Profit -NE 0 | Measure).Count} | Select -First 1 | Select -ExpandProperty Combination
    $BestMiners_Combo_Comparison = $BestMiners_Combos_Comparison | Sort-Object -Descending {($_.Combination | Where Profit -EQ $null | Measure).Count},{($_.Combination | Measure Profit_Comparison -Sum).Sum},{($_.Combination | Where Profit -NE 0 | Measure).Count} | Select -First 1 | Select -ExpandProperty Combination

    #Add the most profitable miners to the active list
    $BestMiners_Combo | ForEach {
        if(($ActiveMinerPrograms | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments).Count -eq 0)
        {
            $ActiveMinerPrograms += [PSCustomObject]@{
                Name = $_.Name
		Type = $_.Type
		PName = $_.PName
		Distro = $_.Distro
		Devices = $_.Devices
	        MinerName = $_.MinerName
                Path = $_.Path
		Arguments = $_.Arguments
	        Wrap = $_.Wrap
                MiningName = $null
		MiningId = $null
                API = $_.API
                Port = $_.Port
                Algorithms = $_.HashRates.PSObject.Properties.Name
                New = $false
                Active = [TimeSpan]0
                Activated = 0
                Failed30sLater = 0
                Recover30sLater = 0
                Status = "Idle"
                HashRate = 0
                Benchmarked = 0
                Hashrate_Gathered = ($_.HashRates.PSObject.Properties.Value -ne $null)
		Screens = 0
            }
        }
    }
    
	#Start Or Stop Miners
    $ActiveMinerPrograms | ForEach {
        if(($BestMiners_Combo | Where Path -EQ $_.Path | Where Arguments -EQ $_.Arguments).Count -eq 0)
         {
	       if($_.MiningId -eq $null)
	        {
		   $_.Status = "Failed"
	        }

         	elseif((Get-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue) -ne $null)
           	 {
	  	 $Active1 =  Get-Process -Id "$($_.MiningId)" | Select -ExpandProperty StartTime
          	 $_.Active += (Get-Date)-$Active1
		 Stop-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue		 
	         $_.Status = "Idle"
            	}
        }
           
     
        else
	 {
	 if($_.MiningId -eq $null -or (Get-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue) -eq $null)
               {
                Start-Sleep $Delay #Wait to prevent BSOD
                $DecayStart = Get-Date
                $_.New = $true
		$Screens = 0
		$_.Activated++
		     if($_.Wrap){$_.Process = Start-Process -FilePath "PowerShell" -ArgumentList "-executionpolicy bypass -command . '$(Convert-Path ".\Wrapper.ps1")' -ControllerProcessID $PID -Id '$($_.Port)' -FilePath '$($_.Path)' -ArgumentList '$($_.Arguments)' -WorkingDirectory '$(Split-Path $_.Path)'" -PassThru}
                else{
		     if($_.Type -eq "NVIDIA" -or $_.Type -eq "NVIDIA1" -or $_.Type -eq "NVIDIA2" -or $_.Type -eq "NVIDIA3" -or $_.Type -eq "NVIDIA4" -or $_.Type -eq "NVIDIA5" -or $_.Type -eq "NVIDIA6" -or $_.Type -eq "NVIDIA7" -or $_.Type -eq "NVIDIA8")
		      {
			if($_.Type -eq "NVIDIA"){$_.Screens = 0}
			if($_.Type -eq "NVIDIA1"){$_.Screens = 0}
			if($_.Type -eq "NVIDIA2"){$_.Screens = 100}
			if($_.Type -eq "NVIDIA3"){$_.Screens = 200}
			if($_.Type -eq "NVIDIA4"){$_.Screens = 300}
			if($_.Type -eq "NVIDIA5"){$_.Screens = 400}
			if($_.Type -eq "NVIDIA6"){$_.Screens = 500}
			if($_.Type -eq "NVIDIA7"){$_.Screens = 600}
			if($_.Type -eq "NVIDIA8"){$_.Screens = 700}

                        if($_.Distro -eq "Linux")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                            $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
		          if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
			 }
			if($_.Distro -eq "Linux-EWBF")
			 {
		          $4 = "--cuda_devices"
		          Set-Location (Split-Path -Path $_.Path)
                            $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
		          if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "$4  $($_.Devices) $($_.Arguments)"
			   }
			 }

		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  if($_.Devices -eq $null)
			   {
                          $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
                         }
		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)   		       
		      }
		    if($_.Type -eq "CPU")
		     {
                        if($_.Distro -eq "Linux")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+0+0 -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
                          $3 = "$($_.Arguments)"
			 }
		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+0+0 -T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  $3 = "$($_.Arguments)"
                         }
		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)                
                     }
if($_.Type -eq "AMD" -or $_.Type -eq "AMD1" -or $_.Type -eq "AMD2" -or $_.Type -eq "AMD3" -or $_.Type -eq "AMD4" -or $_.Type -eq "AMD5" -or $_.Type -eq "AMD6" -or $_.Type -eq "AMD7" -or $_.Type -eq "AMD8")
		      {
                        if($_.Type -eq "AMD"){$_.Screens = 0}
			if($_.Type -eq "AMD1"){$_.Screens = 0}
			if($_.Type -eq "AMD2"){$_.Screens = 100}
			if($_.Type -eq "AMD3"){$_.Screens = 200}
			if($_.Type -eq "AMD4"){$_.Screens = 300}
			if($_.Type -eq "AMD5"){$_.Screens = 400}
			if($_.Type -eq "AMD6"){$_.Screens = 500}
			if($_.Type -eq "AMD7"){$_.Screens = 600}
			if($_.Type -eq "AMD8"){$_.Screens = 700}
			
       		       if($_.Distro -eq "Linux")
			{
		         Set-Location (Split-Path -Path $_.Path)
                         $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
		         if($_.Devices -eq $null)
			  {
                           $3 = "$($_.Arguments)"
			  }
		         else
			  {
			   $3 = "-d $($_.Devices) $($_.Arguments)"
			  }
			 }
		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
                         }
		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path) 
		      }
                    }
                if($_.MiningId -eq $null){$_.Status = "Failed"}
                else{$_.Status = "Running"}
            }
        }
      
   }
    
    #Display mining information
    Clear-Host
    #Display active miners list
    $ActiveMinerPrograms | Sort-Object -Descending Status,
	{	 
	 if($_.MiningId -eq $null)
	  {[DateTime]0}
	  else
           {Get-Process $_.MiningId | Select -ExpandProperty StartTime}
        } | Select -First (1+6+6) | Format-Table -Wrap -GroupBy Status (
        @{Label = "Speed"; Expression={$_.HashRate | ForEach {"$($_ | ConvertTo-Hash)/s"}}; Align='right'}, 
       @{Label = "Active"; Expression={"{0:dd} Days {0:hh} Hours {0:mm} Minutes" -f $(if($_.MiningId -eq $null){$_.Active}else{if((Get-Process -Id $_.MiningId -ea SilentlyContinue) -ne $null){($_.Active)}else{
	$TimerStart = Get-Process -Id $($_.MiningId) | Select -ExpandProperty StartTime
        ($_.Active+((Get-Date)-$TimerStart))}})}}, 
        @{Label = "Launched"; Expression={Switch($_.Activated){0 {"Never"} 1 {"Once"} Default {"$_ Times"}}}}, 
        @{Label = "Command"; Expression={"$($_.Path.TrimStart((Convert-Path ".\"))) $($_MinerName) $($_.Devices) $($_.Arguments)"}}
    ) | Out-Host
        #Write-Host "..........Excavator is dormant in Sniffdog for Neoscrypt,Keccak,Lyra2rev2, and Nist5..............." -foregroundcolor "Green"
        #Write-Host "..........Remove # in front of Algo in ExcavatorNvidianeo.ps1 file in Miners Folder......................" -foregroundcolor "Green"  
        #Write-Host "................Then restart SniffDog and let Excavator Download to Bin Folder..........................." -foregroundcolor "Green"
        #Write-Host "................Shutdown SniffDog....Goto Bin Folder and to Excavator Folder............................." -foregroundcolor "Green"
        #Write-Host "...........Find Files and move back one folder so it's Bin\Excavator\excavator.exe......................." -foregroundcolor "Green"
        #Write-Host ""
        #Write-Host "..........All miners algos in Miners Folder can be opened by removing # or closed by adding a #.........." -foregroundcolor "Green"
        Write-Host "                                                       
                                                                             *      *         )        (       )  
                                                                           (  `   (  `     ( /(  (     )\ ) ( /(  
                                                                          )\))(  )\))(    )\()) )\   (()/( )\()) 
                                                                          ((_)()\((_)()\  ((_)((((_)(  /(_)|(_)\  
                                                                          (_()((_|_()((_)  _((_)\ _ )\(_))  _((_) 
                                                                          |  \/  |  \/  | | || (_)_\(_) __|| || | 
                                                                          | |\/| | |\/| |_| __ |/ _ \ \__ \| __ | 
                                                                          |_|  |_|_|  |_(_)_||_/_/ \_\|___/|_||_| 
                                                                                                                                               " -foregroundcolor "DarkRed"
        Write-Host "                                                                                    Sudo Apt-Get Lambo" -foregroundcolor "Yellow"
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host ""
	$Y = [string]$CoinExchange
	$H = [string]$Currency
	$J = [string]'BTC'
        $BTCExchangeRate = Invoke-WebRequest "https://min-api.cryptocompare.com/data/pricemulti?fsyms=$Y&tsyms=$J" -UseBasicParsing | ConvertFrom-Json | Select-Object -ExpandProperty $Y | Select-Object -ExpandProperty $J
       $CurExchangeRate = Invoke-WebRequest "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC&tsyms=$H" -UseBasicParsing | ConvertFrom-Json | Select-Object -ExpandProperty $J | Select-Object -ExpandProperty $H
        Write-Host "1 $CoinExchange  = $BTCExchangeRate of a Bitcoin" -foregroundcolor "Yellow"
     Write-Host "1 $CoinExchange = " "$Exchanged"  "$Currency" -foregroundcolor "Yellow"
    $Miners | Where {$_.Profit -ge 1E-5 -or $_.Profit -eq $null} | Sort-Object -Descending Type,Profit | Format-Table -GroupBy Type (
        @{Label = "Miner"; Expression={$_.Name}}, 
        @{Label = "Algorithm"; Expression={$_.HashRates.PSObject.Properties.Name}}, 
        @{Label = "Speed"; Expression={$_.HashRates.PSObject.Properties.Value | ForEach {if($_ -ne $null){"$($_ | ConvertTo-Hash)/s"}else{"Bench"}}}; Align='center'}, 
        @{Label = "BTC/Day"; Expression={$_.Profits.PSObject.Properties.Value | ForEach {if($_ -ne $null){  $_.ToString("N5")}else{"Bench"}}}; Align='right'}, 
        @{Label = "$Y/Day"; Expression={$_.Profits.PSObject.Properties.Value | ForEach {if($_ -ne $null){  ($_ / $BTCExchangeRate).ToString("N5")}else{"Bench"}}}; Align='right'},        @{Label = "$Currency/Day"; Expression={$_.Profits.PSObject.Properties.Value | ForEach {if($_ -ne $null){($_ / $BTCExchangeRate * $Exchanged).ToString("N3")}else{"Bench"}}}; Align='center'}, 
        @{Label = "Pool"; Expression={$_.Pools.PSObject.Properties.Value | ForEach {"$($_.Name)"}}; Align='center'},
        @{Label = "Coins"; Expression={$_.Pools.PSObject.Properties.Value | ForEach {"  $($_.Info)"}}; Align='center'},
        @{Label = "Pool Fees"; Expression={$_.Pools.PSObject.Properties.Value | ForEach {"$($_.Fees)%"}}; Align='center'},
        @{Label = "# of Workers"; Expression={$_.Pools.PSObject.Properties.Value | ForEach {"$($_.Workers)"}}; Align='center'}
        
    ) | Out-Host
    

    #Display profit comparison
    if (($BestMiners_Combo | Where-Object Profit -EQ $null | Measure-Object).Count -eq 0) {
        $MinerComparisons = 
        [PSCustomObject]@{"Miner" = "MM.Hash ... Finds!"}, 
        [PSCustomObject]@{"Miner" = $BestMiners_Combo_Comparison | ForEach-Object {"$($_.Name)-$($_.Algorithm -join "/")"}}
            
        $BestMiners_Combo_Stat = Set-Stat -Name "Profit" -Value ($BestMiners_Combo | Measure-Object Profit -Sum).Sum

        $MinerComparisons_Profit = $BestMiners_Combo_Stat.Day, ($BestMiners_Combo_Comparison | Measure-Object Profit_Comparison -Sum).Sum

        $MinerComparisons_MarginOfError = $BestMiners_Combo_Stat.Day_Fluctuation, ($BestMiners_Combo_Comparison | ForEach-Object {$_.Profit_MarginOfError * (& {if ($MinerComparisons_Profit[1]) {$_.Profit_Comparison / $MinerComparisons_Profit[1]}else {1}})} | Measure-Object -Sum).Sum

        $Currency | ForEach-Object {
            $MinerComparisons[0] | Add-Member $_ ("{0:N5} ±{1:P0} ({2:N5}-{3:N5})" -f ($MinerComparisons_Profit[0] * $Rates.$_), $MinerComparisons_MarginOfError[0], (($MinerComparisons_Profit[0] * $Rates.$_) / (1 + $MinerComparisons_MarginOfError[0])), (($MinerComparisons_Profit[0] * $Rates.$_) * (1 + $MinerComparisons_MarginOfError[0])))
            $MinerComparisons[1] | Add-Member $_ ("{0:N5} ±{1:P0} ({2:N5}-{3:N5})" -f ($MinerComparisons_Profit[1] * $Rates.$_), $MinerComparisons_MarginOfError[1], (($MinerComparisons_Profit[1] * $Rates.$_) / (1 + $MinerComparisons_MarginOfError[1])), (($MinerComparisons_Profit[1] * $Rates.$_) * (1 + $MinerComparisons_MarginOfError[1])))
        }

        if ($MinerComparisons_Profit[0] -gt $MinerComparisons_Profit[1]) {
            $MinerComparisons_Range = ($MinerComparisons_MarginOfError | Measure-Object -Average | Select-Object -ExpandProperty Average), (($MinerComparisons_Profit[0] - $MinerComparisons_Profit[1]) / $MinerComparisons_Profit[1]) | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
            Write-Host -BackgroundColor Yellow -ForegroundColor Black "MM.Hash Finds $([Math]::Round((((($MinerComparisons_Profit[0]-$MinerComparisons_Profit[1])/$MinerComparisons_Profit[1])-$MinerComparisons_Range)*100)))% and upto $([Math]::Round((((($MinerComparisons_Profit[0]-$MinerComparisons_Profit[1])/$MinerComparisons_Profit[1])+$MinerComparisons_Range)*100)))% more profit than the fastest (listed) miner: "
        }

        $MinerComparisons | Out-Host
    }


#Do nothing for 15 seconds, and check if ccminer is actually running
    $CheckMinerInterval = 15
    Start-Sleep ($CheckMinerInterval)
    $ActiveMinerPrograms | ForEach {
        if($_.MiningId -eq $null -or (Get-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue) -eq $null)
        {
          if($_.Status -eq "Running")
           {
              $_.Failed30sLater++

                if($_.Wrap){$_.Process = Start-Process -FilePath "PowerShell" -ArgumentList "-executionpolicy bypass -command . '$(Convert-Path ".\Wrapper.ps1")' -ControllerProcessID $PID -Id '$($_.Port)' -FilePath '$($_.Path)' -ArgumentList '$($_.Arguments)' -WorkingDirectory '$(Split-Path $_.Path)'" -PassThru}
                else{
		    if($_.Type -eq "NVIDIA" -or $_.Type -eq "NVIDIA1" -or $_.Type -eq "NVIDIA2" -or $_.Type -eq "NVIDIA3" -or $_.Type -eq "NVIDIA4" -or $_.Type -eq "NVIDIA5" -or $_.Type -eq "NVIDIA6" -or $_.Type -eq "NVIDIA7" -or $_.Type -eq "NVIDIA8")
		      {
			if($_.Type -eq "NVIDIA"){$_.Screens = 0}
			if($_.Type -eq "NVIDIA1"){$_.Screens = 0}
			if($_.Type -eq "NVIDIA2"){$_.Screens = 100}
			if($_.Type -eq "NVIDIA3"){$_.Screens = 200}
			if($_.Type -eq "NVIDIA4"){$_.Screens = 300}
			if($_.Type -eq "NVIDIA5"){$_.Screens = 400}
			if($_.Type -eq "NVIDIA6"){$_.Screens = 500}
			if($_.Type -eq "NVIDIA7"){$_.Screens = 600}
			if($_.Type -eq "NVIDIA8"){$_.Screens = 700}
			
                        if($_.Distro -eq "Linux")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
		          if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
			 }
		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 70x6 -T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
                          $_.MiningId = (Start-Process ).Id
		          Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)
			 }
		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)   		       
		      }
		    if($_.Type -eq "CPU")
		     {
                        if($_.Distro -eq "Linux")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 70x6 -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
                          $3 = "$($_.Arguments)"
			 }
		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  $3 = "$($_.Arguments)"
                         }
		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path)                
                     }
if($_.Type -eq "AMD" -or $_.Type -eq "AMD1" -or $_.Type -eq "AMD2" -or $_.Type -eq "AMD3" -or $_.Type -eq "AMD4" -or $_.Type -eq "AMD5" -or $_.Type -eq "AMD6" -or $_.Type -eq "AMD7" -or $_.Type -eq "AMD8")
		      {
                        if($_.Type -eq "AMD"){$_.Screens = 0}
			if($_.Type -eq "AMD1"){$_.Screens = 0}
			if($_.Type -eq "AMD2"){$_.Screens = 100}
			if($_.Type -eq "AMD3"){$_.Screens = 200}
			if($_.Type -eq "AMD4"){$_.Screens = 300}
			if($_.Type -eq "AMD5"){$_.Screens = 400}
			if($_.Type -eq "AMD6"){$_.Screens = 500}
			if($_.Type -eq "AMD7"){$_.Screens = 600}
			if($_.Type -eq "AMD8"){$_.Screens = 700}
			
       		       if($_.Distro -eq "Linux")
			{
		         Set-Location (Split-Path -Path $_.Path)
                         $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -e ./$($_.MinerName)"
		         if($_.Devices -eq $null)
			  {
                           $3 = "$($_.Arguments)"
			  }
		         else
			  {
			   $3 = "-d $($_.Devices) $($_.Arguments)"
			  }
			 }
		        if($_.Distro -eq "Windows")
			 {
		          Set-Location (Split-Path -Path $_.Path)
                          $2 = "-geometry 68x5+1015+$($_.Screens) -T $($_.Name) -fg White -bg Black -hold -e wine $($_.PName)"
			  if($_.Devices -eq $null)
			   {
                            $3 = "$($_.Arguments)"
			   }
		          else
			   {
			    $3 = "-d $($_.Devices) $($_.Arguments)"
			   }
		 	 }
       		       $_.MiningId = (Start-Process -FilePath xterm -ArgumentList "$2 $3" -PassThru).Id
                       Set-Location (Split-Path $script:MyInvocation.MyCommand.Path) 
		      }
                 Start-Sleep ($CheckMinerInterval)
		 if($_.MiningId -eq $null -or (Get-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue) -eq $null)
		  {
          	   continue
                   }
                else 
                 {
            $_.Recover30sLater++
                }
        }
      }
    }
 }
    
    Write-Host "1 $CoinExchange  = " "$Exchanged" "$Currency" -foregroundcolor "Yellow"

    #Do nothing for a set Interval to allow miner to run
    If ([int]$Interval -gt [int]$CheckMinerInterval) {
	Start-Sleep ($Interval-$CheckMinerInterval)
    } else {
        Start-Sleep ($Interval)
    }

     

    #Save current hash rates
    $ActiveMinerPrograms | ForEach {
        if($_.MiningId -eq $null -or (Get-Process -Id "$($_.MiningId)" -ErrorAction SilentlyContinue) -eq $null)
        {
            if($_.Status -eq "Running"){$_.Status = "Failed"}
        }
        else
        {
          $Start = Get-Process -Id "$($_.MiningId)" | Select -ExpandProperty StartTime
          $WasActive = [math]::Round(((Get-Date)-$Start).TotalSeconds) 
             if ($WasActive -ge $StatsInterval) {
            $_.HashRate = 0  
            $Miner_HashRates = $null  
   
            if($_.New){$_.Benchmarked++} 

            $Miner_HashRates = Get-HashRate $_.API $_.Port ($_.New -and $_.Benchmarked -lt 3)

            $_.HashRate = $Miner_HashRates | Select -First $_.Algorithms.Count
            
            if($Miner_HashRates.Count -ge $_.Algorithms.Count)
            {
                for($i = 0; $i -lt $_.Algorithms.Count; $i++)
                {
                    $Stat = Set-Stat -Name "$($_.Name)_$($_.Algorithms | Select -Index $i)_HashRate" -Value ($Miner_HashRates | Select -Index $i)
                }

                $_.New = $false
                $_.Hashrate_Gathered = $true 
                Write-Host "HH.Hash is saving hashrate" -foregroundcolor "Yellow"
            }
        }
    }

        #Benchmark timeout
        if($_.Benchmarked -ge 6 -or ($_.Benchmarked -ge 2 -and $_.Activated -ge 2))
        {
            for($i = 0; $i -lt $_.Algorithms.Count; $i++)
            {
                if((Get-Stat "$($_.Name)_$($_.Algorithms | Select -Index $i)_HashRate") -eq $null)
                {
                    $Stat = Set-Stat -Name "$($_.Name)_$($_.Algorithms | Select -Index $i)_HashRate" -Value 0
                }
            }
        }
        
    }
 }

#Stop the log
Stop-Transcript
Get-Date | Out-File "TimeTable.txt"
