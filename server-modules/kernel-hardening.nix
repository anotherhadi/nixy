# Kernel hardening for the server
{
  boot.kernel.sysctl = {
    # Restrict access to kernel logs and pointers
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;

    # BPF hardening
    "net.core.bpf_jit_harden" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;

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

    # Restrict ptrace to parent processes only
    "kernel.yama.ptrace_scope" = 1;
  };
}
