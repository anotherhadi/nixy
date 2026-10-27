{
  flake.modules.nixos.kernel-hardening = {
    boot.kernel.sysctl = {
      # Restrict access to kernel logs and pointers
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;

      # BPF hardening
      "net.core.bpf_jit_harden" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;

      # Restrict ptrace to parent processes only
      "kernel.yama.ptrace_scope" = 1;

      # Disable kexec (loading a new kernel at runtime)
      "kernel.kexec_load_disabled" = 1;

      # Disable magic SysRq key
      "kernel.sysrq" = 0;

      # Restrict performance events (perf) to root
      "kernel.perf_event_paranoid" = 3;

      # No O_CREAT on FIFOs/files owned by someone else in world/group-writable sticky dirs (/tmp)
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;

      # No core dumps of setuid processes
      "fs.suid_dumpable" = 0;

      # Unprivileged users can't autoload TTY line discipline modules
      "dev.tty.ldisc_autoload" = 0;

      # userfaultfd (kernel exploitation primitive) for root only
      "vm.unprivileged_userfaultfd" = 0;

      # Reverse path filtering (anti-spoofing)
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;

      # SYN flood protection
      "net.ipv4.tcp_syncookies" = 1;

      # Disable IP source routing
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;

      # Ignore ICMP redirects (prevent MITM)
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;

      # Don't send ICMP redirects
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;

      # Ignore broadcast pings (smurf)
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;

      # Ignore bogus ICMP error responses
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

      # Protect against time-wait assassination
      "net.ipv4.tcp_rfc1337" = 1;
    };

    boot.kernelParams = [
      "init_on_alloc=1" # zero freshly allocated kernel memory
      "init_on_free=1" # zero freed kernel memory
      "slab_nomerge" # don't merge slab caches of different sizes
      "page_alloc.shuffle=1" # randomize page allocator freelists
      "randomize_kstack_offset=1" # randomize the kernel stack offset on syscall entry
    ];

    # Rarely used network protocols and FireWire (DMA): historical sources of kernel bugs
    boot.blacklistedKernelModules = [
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "firewire-core"
      "firewire-ohci"
      "firewire-sbp2"
    ];

    # No kexec, no hibernation (no swap anyway)
    security.protectKernelImage = true;

    # Only wheel members can run sudo
    security.sudo.execWheelOnly = true;

    # Only wheel members can talk to the nix daemon
    nix.settings.allowed-users = ["@wheel"];

    services.dbus.implementation = "broker";
  };
}
