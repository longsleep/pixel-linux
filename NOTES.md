## Chrome OS Linux kernel command line

Chrome OS uses quite a lot of kernel parameters. So here is the full line as i
see it in dmesg after booting into Chrome OS.

  cros_secure  console= loglevel=7 init=/sbin/init cros_secure oops=panic panic=-1 root=/dev/dm-0 rootwait ro dm_verity.error_behavior=3 dm_verity.max_bios=-1 dm_verity.dev_wait=1 dm="1 vroot none ro 1,0 2506752 verity payload=PARTUUID=XXX/PARTNROFF=1 hashtree=PARTUUID=XXX/PARTNROFF=1 hashstart=2506752 alg=sha1 root_hexdigest=XXX salt=XXX" noinitrd vt.global_cursor_default=0 kern_guid=XXX add_efi_memmap boot=local noresume noswap i915.modeset=1 tpm_tis.force=1 tpm_tis.interrupts=0 nmi_watchdog=panic,lapic iTCO_vendor_support.vendorsupport=3  gpt

