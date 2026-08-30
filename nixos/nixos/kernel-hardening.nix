{
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

    # Restrict access to /proc for non-root users
    "kernel.perf_event_paranoid" = 3;

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

    # Don't send ICMP redirects
    "net.ipv4.conf.all.send_redirects" = 0;

    # Ignore bogus ICMP error responses
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Protect against time-wait assassination
    "net.ipv4.tcp_rfc1337" = 1;
  };

  boot.kernelParams = [
    "init_on_alloc=1" # zero freshly allocated kernel memory
    "init_on_free=1" # zero freed kernel memory
    "slab_nomerge" # don't merge slab caches of different sizes (harder heap grooming)
    "page_alloc.shuffle=1" # randomize page allocator freelists
    "randomize_kstack_offset=1" # randomize the kernel stack offset on syscall entry
  ];
}
