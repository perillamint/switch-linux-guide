# Linux-Compatible MicroSD Cards:

## Why some cards are "incompatible" with Switch-Linux?
Nintendo did some mistakes while designing Switch, so fast SDHCI bus clock
speed will corrupt communication between SD card and Switch.

Limiting SDHCI driver's `max-frequency` to `100000000` will solve this problem.

## Patched fork of Switch-Linux kernel
https://github.com/perillamint/switch-linux/tree/sdhci-bus-fix has SDHCI fix patch

You can clone this repo by using this command: `git clone -b sdhci-bus-fix https://github.com/perillamint/switch-linux.git`

### If patch does not working
That patch only downclocks sdhci bus by 8MHz. On some devices, it would
solve problem, but if this would not solve your problem try editing
`arch/arm64/boot/dts/nvidia/tegra210-nintendo-switch.dts` file line 944.

It should read

```
	/* MMC/SD */
	sdhci@700b0000 {
		status = "okay";
		bus-width = <4>;
		max-frequency = <200000000>;

		cd-gpios = <&gpio TEGRA_GPIO(Z, 1) GPIO_ACTIVE_LOW>;
		power-gpios = <&gpio TEGRA_GPIO(E, 4) GPIO_ACTIVE_HIGH>;
		vqmmc-supply = <&vddio_sdmmc>;
	};
```

and you have to edit `max-frequency` line more lower.

100MHz will work on most Switches, so try some value between `100000000` and `200000000`

## Reported Working:

* 64GB Samsung Evo
* 128GB Samsung Evo
* 64GB Sandisk Ultra
* 32GB Sandisk Ultra
## Reported NOT Working:

* 32GB Samsung Evo Plus
* 64GB Samsung Evo Select
