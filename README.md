# switch-linux-guide

This guide will help you build f0f's Linux kernel for your Nintendo Switch and boot into it. I plan on adding more to this guide so you can set up Debian with xfce on your Switch.

Thank you to natinusala on GBAtemp for the original guide and everyone on the Reswitched Discord channel for helping me figure most of this out.

The reason why I'm putting it here is so others will (hopefully) help contribute to this guide.

## Requirements
A computer running Linux (this can be a VM, guide coming soon)
USB-3 Port - I'm not sure which O/S requires this (I believe you can get around this with a patch if you are running Linux, but I haven't tried it) but if you are in a VM you do NOT need a USB 3.0 port.

## Dependencies

Clone this repo (with it's submodules) if you haven't already:
```
git clone --recursive --depth=1 https://github.com/nvitaterna/switch-linux-guide.git
```
This may take a while as some of the submodules are quite large.

After that, cd into the repo:
```
cd switch-linux-guide
```

### NOTE
I will be writing this guide as if we are alway in the repository's root directory.

Install the following dependencies using your package manager (I did this using debian, you may need more/less when using a different distribution):

```
build-essential
swig
python3
python-dev
flex
bison
zlib1g-dev
libusb-1.0-0-dev
pkg-config
bc
libssl-dev
python3-pip
```

After those are installed, install ``pyusb 1.0.0``:
```
sudo pip3 install pyusb==1.0.0
```

### Toolchains
We will also need a couple toolchains from [Linaro](https://releases.linaro.org/components/toolchain/binaries/latest-7). Download ``aarch64-linux-gnu`` and ``arm-linux-gnueabi`` (for your platform) to the downloads directory.

Untar these to /usr/share:
```
sudo tar -xf downloads/gcc-linaro-[version]-[platform]_arm-linux-gnueabi.tar.xz -C /usr/share/
sudo tar -xf downloads/gcc-linaro-[version]-[platform]_aarch64-linux-gnu.tar.xz -C /usr/share/
```

Add the following to the end of your .bashrc file:
```
export PATH=$PATH:/usr/share/gcc-linaro-[version]-[platform]_aarch64-linux-gnu/bin:/usr/share/gcc-linaro-[version]-[platform]_arm-linux-gnueabi/bin
```
Now run ``source ~/.bashrc`` so these are put into your path.

### Pixel C Image

You may skip this for now, and come back to it later if needed. You can grab the Pixel C image from [Google's Factopry Images Page](https://developers.google.com/android/images) ([direct link](https://dl.google.com/dl/android/aosp/ryu-mxb48j-factory-ce6d5a7b.zip).
Unzip this to the downloads directory, we will need it later.
```
unzip downloads/ryu-mxb48j-factory-ce6d5a7b.zip -d downloads/pixel-c-image
```

### Tegra Firmware
Download the firmware-misc-nonfree package from [Debian sid](https://packages.debian.org/sid/firmware-misc-nonfree) to your downloads folder. Extract this to your downloads folder and copy the ``nvidia`` directory to ``/lib/firmware/nvidia/``:

```
tar -xf downloads/firmware-nonfree_[version].orig.tar.xz -C downloads
sudo mv downloads/firmware-nonfree-[version]/nvidia /lib/firmware
```

### Broadcomm Firmware
Download the Broadcomm Firmware from [Chromium's source code](https://chromium.googlesource.com/chromiumos/third_party/linux-firmware/+/f151f016b4fe656399f199e28cabf8d658bcb52b/brcm) to your downloads folder ([direct link](https://chromium.googlesource.com/chromiumos/third_party/linux-firmware/+archive/f151f016b4fe656399f199e28cabf8d658bcb52b/brcm.tar.gz))

Make a ``brcm`` directory in ``/lib/firmware`` and extract the ``brcm.tar.gz`` file to ``/lib/firmware/brcm``:
```
sudo mkdir /lib/firmware/brcm
sudo tar -xzf downloads/brcm.tar.gz -C /lib/firmware/brcm
```

## Build
Now that we have all of our dependencies ready, we will start to build the kernel.

### Set up the build environment
```
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
```

### Build the shofel2 exploit
```
cd bootloader/shofel2/exploit
make
```

### Build u-boot
```
cd bootloader/u-boot
make nintendo-switch_defconfig
make
```

### Build coreboot
```
cd bootloader/coreboot
make nintendo-switch_defconfig
make iasl
make
```

If you get an error at ``make``, you need the [Pixel C Image](pixel-c-image). Download it if you haven't already, then run the following (while still in the ``coreboot`` directory):

```
make -C util/cbfstool
./util/cbfstool/cbfstool ../../downloads/pixel-c-image/bootloader-dragon-google_smaug.7132.260.0.img extract -n fallback/tegra_mtc -f tegra_mtc.bin
```

### Build imx_usb_loader
```
cd bootloader/imx_usb_loader
make
```

### Build linux
```
cd bootloader/linux
make nintendo-switch_defconfig
make
```

This build may take a while depending on your CPU.

## Boot the kernel
Put your switch in RCM mode, connect it to your computer, and run the following:
```
sudo ./scripts/boot_linux.sh
```
Your switch boot to the Linux kernel. If you see Penguins, it worked.
