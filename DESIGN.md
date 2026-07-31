# AI Agent Local Sandboxing — Design Notes

**Date:** 2026-07-21  
**Goal:** Run long-lived, isolated microVM sessions on macOS (Apple Silicon) and Linux (x86_64) with controlled host access and internet egress.

---

## Decision: Use Microsandbox

**Microsandbox** (`msb`) is the selected runtime. It provides true microVMs via `libkrun` (HVF on macOS, KVM on Linux), supports OCI images, Docker-like volume/port semantics, and detached Project mode that survives host reboots.

---

## Architecture
```
Host (macOS or Linux)
  └── microsandbox (libkrun)
        └── Linux guest (OCI image: ubuntu + runtimes + Docker)
              ├── tini (init)
              ├── sshd
              ├── dockerd
              ├── agent runtime (node/python/go)
              └── /workspace (ro)  /etc/agent/skills (ro)
```

### Base Image

- **Multi-arch OCI:** `linux/arm64` + `linux/amd64` via `docker buildx`
- **Pre-installed:** `tini`, `openssh-server`, `docker.io`, `git`, `rsync`, `node`, `python3`, `go`
- **Entry:** `tini` supervises `dockerd` + `sshd` + optional agent process

### Host Orchestrator (CLI)
A thin wrapper script around `msb` to manage per-project sessions:

- `up <project>` — `msb start` with randomized host ports, read-only mounts
- `down <project>` — `msb stop`
- `sync <project>` — `rsync` / `git` pull from guest via forwarded SSH port
- `skills` — mounted from `~/.agent-skills` into all guests

### Networking

- **Guest → Host (Ollama):** Guest reaches host via `host.internal` / bridge IP
- **Guest → Internet:** Routed through a host-side HTTP allowlist proxy (e.g., `tinyproxy`) with explicit domain lists
- **Host → Guest:** Published SSH port on `localhost` for `git remote` and testing

### Filesystem
| Path | Direction | Persistence |
|------|-----------|-------------|
| `/workspace` | Host → Guest (ro) | Host source of truth |
| `/etc/agent/skills` | Host → Guest (ro) | Host source of truth |
| `/workspace-out` | Guest only (or explicit pull) | Ephemeral; host pulls via `rsync`/`git` |
| `/var/lib/docker` | Guest internal | Ephemeral or host-mounted cache |
| `/tmp` | Guest | `tmpfs` |

### VM Lifecycle

- Use **Project mode** + `--detach` so VM state persists across host reboots
- Explicit `msb stop` / `msb start` to pause/resume
- No millisecond startup required; sessions are hours-to-days long

---

## Rejected Alternatives

| Option | Why Rejected |
|--------|-------------|
| **Apple Container** | macOS 26+ only; no Linux port. Would force a second runtime later. |
| **OpenShell (MicroVM driver)** | Drops unsolicited inbound connections. No host→guest port forwarding, so cannot satisfy git-remote or host testing requirements. |
| **Firecracker / Cloud Hypervisor** | Linux/KVM only. No native macOS support. |
| **QEMU microvm** | Poor HVF support on Apple Silicon; random hangs reported. |
| **Docker / rootless Podman** | Explicitly rejected by requirement for microVM-level isolation against untrusted LLM-generated code. |
| **GhostVM** | macOS guest VMs, not Linux. Not suitable for Linux agent runtimes. |

---

## Open Questions / Next Iterations

1. **Port allocation:** Random ports, sequential scan, or local registry (SQLite/lockfile)?
2. **Docker cache:** Ephemeral per-session layers, or host-mounted `/var/lib/docker` image cache?
3. **Guest identity:** Per-project SSH host keys, or host SSH agent forwarding?
4. **Allowlist proxy:** `tinyproxy` domain list, or MITM proxy for TLS inspection?
5. **Output sync:** Explicit `rsync` over SSH, or shared `virtio-fs` write-back mount?
