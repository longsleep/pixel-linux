## Chrome OS Linux kernel command line

Chrome OS uses quite a lot of kernel parameters. So here is the full line as i
see it in dmesg after booting into Chrome OS.

  cros_secure  console= loglevel=7 init=/sbin/init cros_secure oops=panic panic=-1 root=/dev/dm-0 rootwait ro dm_verity.error_behavior=3 dm_verity.max_bios=-1 dm_verity.dev_wait=1 dm="1 vroot none ro 1,0 2506752 verity payload=PARTUUID=XXX/PARTNROFF=1 hashtree=PARTUUID=XXX/PARTNROFF=1 hashstart=2506752 alg=sha1 root_hexdigest=XXX salt=XXX" noinitrd vt.global_cursor_default=0 kern_guid=XXX add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic iTCO_vendor_support.vendorsupport=3  gpt

## Lightbar control

The lightbar on the Pixel can be controlled through [EC](http://www.chromium.org/chromium-os/ec-development). The tool for this is `ectool` which is part of
the Chrome OS installation.

### Konami code

    ectool lightbar seq stop
    ectool lightbar seq run

### Run the sequence

	ectool lightbar seq konami

### Stop sequences so you can play with the lightbar

	ectool lightbar seq stop

### Turn all lights to green

	ectool lightbar 4 00 ff 00

### Turn the first led to blue

	ectool lightbar 0 00 00 ff

### Turn the lightbar off

	ectool lightbar off

### Turn the lightbar on

	ectool lightbar on

### Start the sequence again and return things to normal

	ectool lightbar init
	ectool lightbar seq run

To get all this on Linux we need the `ectool` binary. The source code and
details is checked into [Chromium OS repository](https://chromium.googlesource.com/chromiumos/platform/ec).

There is also a [Mainline Kernel patch](https://chromium-review.googlesource.com/#/c/187680/) available which exposes EC lightbar through
sysfs. I might add this to my Kernel patches eventually. THis patch has been
submitted to the upstream Kernel [here](https://lkml.org/lkml/2015/2/2/214).
These patches require a modified ectool which seems to be available too.

## Building ectool

	git clone git://git.collabora.co.uk/git/user/javier/ec.git
	cd ec
	git checkout mainline-ioctl
	make BOARD=link CROSS_COMPILE= HOST_CROSS_COMPILE= build/link/util/ectool
	sudo ./build/link/util/ectool version

## Controlling the fan with ectool

Once you have ectool built for Linux it can be used to get control on the fan.

	sudo ./build/link/util/ectool fanduty 0
	sudo ./build/link/util/ectool fanduty 100
	sudo ./build/link/util/ectool autofanctrl on

## Firmware event log

	http://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/chromebook-pixel