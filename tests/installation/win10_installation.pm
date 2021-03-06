# SUSE's openQA tests
#
# Copyright © 2016-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Windows 10 installation test module
#    modiffied (only win10 drivers) iso from https://fedoraproject.org/wiki/Windows_Virtio_Drivers is needed
#    Works only with CDMODEL=ide-cd and QEMUCPU=host or core2duo (maybe other but not qemu64)
# Maintainer: Jozef Pupava <jpupava@suse.com>

use base "installbasetest";
use strict;
use warnings;

use testapi;

sub run {
    if (get_var('UEFI')) {
        assert_screen 'windows-boot';
        send_key 'spc';    # boot from CD or DVD
    }
    # This test works onlywith CDMODEL=ide-cd due to windows missing scsi drivers which are installed via scsi iso
    assert_screen 'windows-setup', 1000;
    send_key 'alt-n';      # next
    save_screenshot;
    send_key 'alt-i';      # install Now
    save_screenshot;
    send_key 'alt-n';      # next
    assert_screen 'windows-activate';
    assert_and_click 'windows-no-prod-key';
    assert_screen 'windows-select-system';
    send_key_until_needlematch('windows-10-pro', 'down');
    send_key 'alt-n';      # select OS (Win 10 Pro)
    assert_screen 'windows-license';
    send_key 'alt-a';      # accept eula
    send_key 'alt-n';      # next
    assert_screen 'windows-installation-type';
    send_key 'alt-c';      # custom
    assert_screen 'windows-disk-partitioning';
    send_key 'alt-l';      # load driver
    assert_screen 'windows-load-driver';
    send_key 'alt-b';      # browse button
    send_key 'c';
    save_screenshot;
    send_key 'c';          # go to second CD drive with drivers
    send_key 'right';      # ok
    sleep 0.5;
    send_key 'ret';
    send_key_until_needlematch 'windows-all-drivers-selected', 'shift-down', 5;    # select all drivers
    sleep 0.5;
    send_key 'alt-n';                                                              # next
    wait_still_screen;
    send_key 'alt-n';                                                              # next ->Installing windows!
    assert_screen 'windows-restart', 600;
    send_key 'alt-r';                                                              # restart
}

sub test_flags {
    return {fatal => 1};
}

1;
