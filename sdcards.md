# Linux-Compatible MicroSD Cards:

## Why some cards are "incompatible" with Switch-Linux?
Nintendo did some mistakes while designing Switch, so fast SDHCI bus clock
speed will corrupt communication between SD card and Switch.

Limiting `UHS_SDR104_MAX_DTR` to `100000000` will solve this problem.

## Patched fork of Switch-Linux kernel
https://github.com/perillamint/switch-linux/tree/hacky_UHS_SDR104_MAX_DTR has SDHCI fix patch

You can clone this repo by using this command: `git clone -b hacky_UHS_SDR104_MAX_DTR https://github.com/perillamint/switch-linux.git`

## Reported Working:

* 64GB Samsung Evo
* 128GB Samsung Evo
* 64GB Sandisk Ultra
* 32GB Sandisk Ultra
## Reported NOT Working:

* 32GB Samsung Evo Plus
* 64GB Samsung Evo Select
