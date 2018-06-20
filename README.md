**MM.Hash**

**MULTI-ALGO, MULTI-COIN SWITCHING, MULTI-POOL, MULTI-DEVICE, MULTI-WALLET, MULTI-DEVICE AUTO-PROFIT SWITCHING MINING ADMINISTRATION APPLICATION FOR UNIX AND WINDOWS.**

NOTE- MM.Hash will run miners that are compiled with Windows Binaries in Linux. There are miners inside MM.Hash now that do so. However it will not work with all Windows-Based miners, but it works with most from my expirementation. AMD support will come when I get a chance to buy and test an AMD GPU. Clone from git, as I am updating it constantly.

NOTE- MM.HASH works for windows. Edit .Bat files and run the various scripts that come in MM.Hash to use. Will write more documentation on uses and support as I finish final 1.1.9-Full.

MM.Hash is intended to be Unix/Windows mining application, which will mine from NVIDIA GPU, AMD GPU, CPU devices. AMD is built into the code, but at this time I do not have any miners or settings loaded into MM.Hash. I am working on it- I don't own any AMD devices. The program is based off of various powershell mining applications available in Windows, in which I have used to invent a new way to mine. I made the base script fully compatible with UNIX, and then added UNIX specific features along with many other changes. After requests from users- I decided to make a Windows version.

The uses for MM.Hash- is pretty vast, being that it works in linux/unix environment. Hypothetically, with the right setup- MM.Hash can work in any device that can boot UNIX. This means you can mine from your PS4, Tablet, PC, Microcontrollers, etc. when are not using them, and you are not losing the massive hashrate from browser mining. Furthermore- you can do this all through building a minimal Ubuntu OS, and load directly off a USB!

MM.Hash works by utlizing Powershell, which is now a cross-platform software that is constantly being developed. It will query the API of any pool you have your "Pools" folder, and get the current prices of the coins of the algorithms you have chose. Once it has gathered that data, it will then select the most profitable, and choose the best mining application to mine with, which are denoted as separate .ps1 filed in the "Miners" folder. If you have never used that particular miner before- MM.Hash will go into benchmark mode, which will record your hashrate. This means you can test miners to see which gives you the best hashrate! If MM.Hash detects the coin yields little/no value from mining- it will remove the miner from its list.

Spend the extra dollar and get a USB 3.0 Stick: 16GB if you plan to try to build USB miner. I highly reccomend not using usb 2.0...It works, but takes forever to build.

IF YOU WANT TO SEE FURTHER DEVELOPMENT- PLEASE LEAVE DONATION SET & CONSIDER DONATING TO DEVELOPER!

DONATION ADDRESS: BTC 1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i



**HOW TO SETUP- NVIDIA/CPU (UNIX VERSION)**

If you are not setting up for a minimal installation, then this is what you need to run/dependencies:
```
libcurl4-openssl-dev
libssl-dev
libjansson-dev
automake
autotools-dev
build-essential
libgmp3-dev
curl
libunwind8
gcc-5 g++-5 (and set as default  
libicu55_55.1-7ubuntu0.4_amd64.deb
powershell
nvidia-390
cuda 9.1 toolkit
vim/nano
xterm
p7zip-full
wine (if you want to run Allium miner/windows binaries miners, if not remove from Miner files)
winehq-staging (if you want to run Allium miner/windws binaries miners, if not remove from miner files)
reccommended- NVIDIA setup for overclocking and fan speed increase.
```
**Building Ubuntu Minimal OS**

-Get Ubuntu Minimal 17.10 Here: https://help.ubuntu.com/community/Installation/MinimalCD 
-Make a bootable usb using etcher io (windows) or startup disk creator (ubuntu) 
-Boot to USB- Install Ubuntu. Select no packages. You can install onto the bootable USB by deleting usb boot partition, and then selecting it! Does not affect install.

After reboot and Ubuntu loads- if you are not there, press ctrl+alt+f1 to get to root terminal. Type the following commands:

```
sudo apt-get install git
```

This will allow you to download MM.Hash from repository. Now clone my repository:

```
git clone https://github.com/MaynardMiner/MM.Hash.git
```

Once finished, navigate to the directory:

```
cd MM.Hash/Apps
```

If you using NVIDIA- Type the following:

```
sudo bash Setup-Nvidia.part1
```

This will build the rest of the OS needed, and install all dependencies required for MM.Hash. It will also remove old install files, disable logs, and repair any installation that had an error to ensure maximum space if using USB. It will also make all app shell scripts executable, setup NVIDIA drivers, and append xorg.conf to allow overclocking. It is doing a lot...It takes awhile to complete, especially if doing it from USB drive. Be very patient- Don't interupt it! If you think you made a mistake- start over from beginning and re-install Ubuntu. If you are using CPU only, I reccommend running CPU-Setup.part1 and CPU-Setup.part2 instead.


Enter 'y' where asked, or press [enter] to continue were needed. If computer reboots, and your new login screen starts- login with password you made during Ubuntu install. 

Note: If you are having issues with the install script- You can open it up with vi or a text editor, and see all the dependencies, and how I am attempting to install them in Setup-Nvidia.part1. I noticed when making the install script- Nvidia changed cuda download links twice on me, and I had to rewrite script. I don't know if anyone will change links again.


Once in terminal- right click on black screen and select "Open Terminal Emulator". The next step is adjusting your terminal.:

Click Edit > Profile Preferences.

Check "Custom Font".

Click on box that says "Monospace regular font"

Reduce font size to 10 pts.

Click "Select" Box

Move to colors tab

Uncheck "Use Colors From System Theme"

Click "Close" Box

Once back in terminal- Type the following commands:

```
cd MM.Hash/Apps
sudo bash Setup-Nvidia.part2
```

Instructions will follow on what to enter next, but you have to run a needed dependency before starting miner to allow it to setup. Follow the instructions on the screen. Reboot  When finished- Right click on black screen and open terminal emulator:

```
cd MM.Hash/Apps
vi overclock
```

This will open the overclock bash script, which you can modify to match your NVIDIA GPU's. This is the setup for a 13 GPU miner, remove or add GPU's as necessary. Once completed, save changes, then enter:

```
sudo bash overclock
```

NVIDIA GPU's will begin overclocking to what I believe is optimal settings. If you are unhappy with settings- You can open overclock file by typing vi overclock and then append by pressing the [insert] first, then when finished typing, press [esc] then type :x. I also reccomend looking into using nvclock for additional settings. However, before starting, it reccommened you turn up fan speed to protect GPU. EVERYTHING IS NOW COMPLETE! MM.Hash is ready to rock.



**CONFIGURATION**

For Algo-Switching, or for Coin Switching:

```
vi ./StartMM.Coin
```

There is a list of options, with simple explanations as to how they work. Be sure to leave all '' and "" in each parameter where applicable! Basic edit commands: "i" or [insert] lets you edit file "esc" takes you to vi menu. While in vi menu, type :x to save, :q to quit. If you are new to mining- It would probably be good at looking at CCminer setup articles to understand the principle operation, as well as browsing some of the pool sites listed in the pools folder. If you do not have a large mining setup- I would highly reccomend using on one or two pools, or it will take a very long time to recieve your mining rewards. This is because of the pools themselves- It is out of my control.

Once saved and setup up, start MM.Hash by typing the following in terminal:

```
./StartMM.Coin
```

**ADVANCED SETTINGS**

Advanced Settings allow you to control multiple GPU devices in groups, and you are able to set each group with an individual wallet- Meaning you can auto-exchange mine for different coins at the same time (up to 8). To use- You first must swap Type Parameter- You do this by placing # in front of Type in "Normal Settings" and removing the # in front the type in the Advanced configuration. Type allows you declare which groups are active. You must add a numerical value behind each device you are using, starting with "1", i.e. This is the same process for Auto-Coin. Auto-Coin is built only with advanced settings, and can only use up to 3 device groups (anymore is too slow for usb).

```
Type=NVIDIA1,NVIDIA2 (You can still use CPU, but no CPU1,CPU2,CPU3 (There is no support for multi-cpu). Just use CPU. See StartMM.Coin help txt for more details)
```
If you are not using a devices groups, and only wish to mine your GPUS/CPUS from one wallet, the you can enter '' for the remaining parameters for device groups 2 & 3. See StartMM.Coin txt for more information.

IMPORTANT: ENSURE POOL OFFERS EXCHANGE TO YOUR COIN SELECTED IN WALLET ADDRESS!


**STARTING THE MINER**

Naviagate to MM.Hash directory and run this command:
```
./StartMM.Coin
```

Miner will start! It takes a little bit for the miner to download and install and miners you want to use. If you are running on a very slow drive- it may look like the screen has frozen, but it takes awhile to start the configure process to build. If the miner doesn't continue to the main screen, you can simple ctrl+c to close miner, delete the newly created "Bin" folder, re-clone then try and run MM.Hash again. If a miner fails to install- either your gpu settings/install are not correct, you are missing a dependency, or the owner of the miner recently committed to his code, and there was issues. MM.Hash pull the actual code source directly from github, configures, and builds the miner into an executable program! Currently it only has the capabilities to do this to the programs in which their source code is open to download. Because of this- I have included some already ready-to-run mining application in the Bin folder.
GIT THAT LAMBO!


**OPTIMIZATIONS**

By opening mining files, you can optimize miners by adding arguments under the aglo in the mining file. For example- If you wanted to mine x16r with and gpu intensity of 21, you would amend x16r in the optimizations section to = "-i 21". It can accept any argument the miner being used would normally accept. This includes API settings, if required.


**MAITENENCE/Issues**

-If you wish to reset all your benchmark stats- type the following while in MM.Hash Apps directory:

```
sudo bash ClearProfits.sh
```

-If you wish to remove the benchmark of a particular miner/algo- delete its "hashrate".txt file. If you want to reset all benchmarks, use:

```
sudo bash ResetBenchmarks.sh
```

-If you wish to clear your Logs

```
sudo bash RemoveLogs.sh
```

-If you wish to track your wallet, navigate to Apps directory and type:

```
vi Wallet_Tracker.sh
```
Then edit with your wallet and pool. When finished save and exit and then type:
```
sudo bash Wallet_Tracker.sh
```

Navigating to the Miner files, and opening them with vi lets you configure miners. Putting a # turns off algo, removing # turns them on. Optimizations are added to the command line, so if you wish to increase its intensity for example, add -i [intensity] between the "" of the algo.
-You can add/edit miner files while miner is running. JUST MAKE SURE THEY ARE CORRECT BEFORE SAVING!
-There is a Logs folder which lets you track MM.Hash's history
-If you have issues installing a miner- delete .zip or 7z file from the Downloads folder & the new miner from the bin folder. Try it again. Ensure you have moved the mini builder.sh script to the /bin folder and have enabled it as an executable.
-NVIDIA graphic card settings are fairly tedious to set-up, especially if you are used to the simplicity of Windows Afterburner. However, they are difficult because they are much more accurate and have far more options. It may take awhile of tweaking your card settings to get optimal conditions, but generally you get better performance and less issues once they compared to Windows miners.
I suggest looking into ssh and/or remote viewer so you can login into your miner remotely. It is also good to edit your boot settings to have your GPUs automatically configure, and your miner autostart. Lastly, it's good to invest in a watchdog/restarting device in case of pc crashes, but ensure that if you are getting one for a usb miner- It uses pinging to determine if cpu is working, rather than hdd activity!

PS4 MINING
I have not attempted enough mining with PS4 as of yet to confirm it is successful to do so. However, if you are interested- You would have to find mining programs that run AMD, and setup the Ubuntu minimal installation as if you are setting up the PS4 to run Steam. There are lots of guides to which show you how to install linux gpu drivers compatible for AMD. MM.Hash has Normal settings built to run AMD devices- I simply haven't made or fully tested and AMD miners to add them to the mining program.

MICROCONTROLLER MINING
JayDDee CPUminer support ARM core procesors, which means you simply need to load the miner into and Ubuntu minimal installation, then run in the microcontroller. You simply just need to confirm the microcontroller you are using is confirmed to run Ubuntu.


Open DevNotes.txt to see other notes on using MM.Hash, along with new changes, and future changes.


CONTACT


Discord Channel For MM.Hash- 
https://discord.gg/xVB5MqR

DONATE TO SUPPORT!

DONATION ADDRESS: BTC 1DRxiWx6yuZfN9hrEJa3BDXWVJ9yyJU36i
DONATION ADDRESS: RVN RKirUe978mBoa2MRWqeMGqDzVAKTafKh8H

Thanks To:

Sniffdog
Nemosminer
Uselessguru

They were thd pioneers to powershell scriptmining. Their scripts allowed me to piece together a buggy but workable linux miner, which was the original purpose of MM.Hash, since none of them did so at the time.
