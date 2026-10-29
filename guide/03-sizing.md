# 3. Sizing

> **Status:** draft

Two questions: how big is the machine you have now, and how big does the new
one need to be? Then turn the answer into Service Units for your request.

## How big is the machine I'm on?

### From inside the machine

On a Linux machine (or a Mac, for some of these), open a terminal and type:

```bash
nproc                                          # number of CPU cores
free -h                                        # RAM ("total" column)
df -h                                          # disk size and usage per filesystem
lsblk                                          # disks and volumes attached
cat /proc/cpuinfo | grep 'model name' | head -1   # CPU model
```

If the machine is a Nectar VM, it can tell you about itself through the
OpenStack metadata service
([OpenStack docs](https://docs.openstack.org/nova/latest/user/metadata.html)):

```bash
# the instance's name, availability zone and project ID
curl -s http://169.254.169.254/openstack/latest/meta_data.json

# the flavour name, e.g. m3.large (EC2-style metadata)
curl -s http://169.254.169.254/latest/meta-data/instance-type
```

`meta_data.json` does not include the flavour; the `instance-type` path should.
TODO(verify) both on a current Nectar VM.

### From the Nectar dashboard

- **Project > Compute > Overview**: pie charts of how much of your project's
  quota (instances, vCPU, RAM, volumes) is in use.
- **Project > Compute > Instances**: each instance's flavour, IP address and
  availability zone. Click an instance's name for details.
- **Usage** menu: Service Units used over time, and how many are left
  ([usage graphs](https://support.ehelp.edu.au/support/solutions/articles/6000257054)).

## Reading flavour names

A flavour name is `family.size`. The general-purpose families
([flavours](https://support.ehelp.edu.au/support/solutions/articles/6000205341), Aug 2026):

| Family | For | RAM per vCPU | Root disk | Sizes |
|---|---|---|---|---|
| `t3` | Tiny, light jobs | 1 GB | 10 GB | 1–4 vCPU |
| `m3` | Balanced, the default | 2 GB | 30 GB | `m3.xsmall` 1 vCPU/2 GB to `m3.xxlarge` 32/64 |
| `r3` | RAM-heavy work | 4 GB | 30 GB | up to 32 vCPU/128 GB |
| `c3` | CPU priority | 2 GB | 30 GB | up to 64 vCPU/128 GB |
| `p3` | Preemptible: ¼ of the SU, but can be killed within 24 h | 2 GB | 30 GB | up to 32 vCPU/64 GB |

The sizes go `xsmall`, `small`, `medium`, `large`, `xlarge`, `xxlarge`, each
doubling the cores and RAM of the one before (e.g. `m3.medium` = 4 vCPU/8 GB,
`m3.large` = 8/16).

Other things to know:

- **No ephemeral disk** on these standard flavours: you get only the root disk
  (30 GB, or 10 GB on `t3`). Data goes on a volume
  ([05-storage.md](05-storage.md)). Only the reserved GPU (`g1`, `g2`, `g3`) and
  huge-RAM (`h4`) flavours come with ephemeral disk.
- **Node-private flavours** exist at some nodes, e.g. `tas.c16m64` at Tasmania
  (16 vCPU, 64 GB RAM). They're arranged with the node by support ticket, and
  their naming and SU rates aren't documented centrally:
  TODO(verify) with the node.
- `m1` and `m2` flavours are deprecated; if you see them on an old VM, plan to
  move to `m3`.
- GPU (`g1`/`g2`/`g3`) and huge-RAM (`h4`) flavours are reserved and need a
  special request.

## How big does mine need to be?

Rules of thumb:

- **RAM** is usually the limit. Take the largest data you hold in memory at
  once, and allow 2–3× for copies made during processing, plus a few GB for
  the operating system and RStudio. Watch `free -h` (or `htop`) on your laptop
  while your biggest job runs.
- **Cores** only help if your work runs in parallel (e.g. `parallel`, `future`,
  `furrr` in R; `multiprocessing`, `dask` in Python; or several jobs at once).
  A single-threaded R script runs no faster on 16 cores than on 2.
- **Disk**: the root disk is 30 GB and is lost when the instance is deleted.
  Put data on a volume sized to your data plus working space, or in object
  storage.
- **Start small.** You can resize an instance to a bigger flavour later
  (it reboots), so start with the smallest flavour that fits and grow.
- **Matching shape to family**: lots of RAM per core → `r3`; lots of cores and
  modest RAM → `m3` or `c3`; disposable batch work that can restart → `p3`.

## Back-of-envelope Service Units

Each flavour costs a fixed number of SU per hour for as long as the instance
**exists**, running or shut off
([Service Units](https://support.ehelp.edu.au/support/solutions/articles/6000257023)).
The arithmetic is:

> SU = SU per hour × hours × number of instances
>
> (a year is about 8,760 hours; a month about 730)

SU per hour for some common flavours
([flavours](https://support.ehelp.edu.au/support/solutions/articles/6000205341), Aug 2026):

| Flavour | vCPU / RAM | SU/hour | SU/year (always on) |
|---|---|---|---|
| `m3.small` | 2 / 4 GB | 0.057 | 500 |
| `m3.medium` | 4 / 8 GB | 0.114 | 1,000 |
| `m3.large` | 8 / 16 GB | 0.228 | 2,000 |
| `m3.xlarge` | 16 / 32 GB | 0.457 | 4,000 |
| `m3.xxlarge` | 32 / 64 GB | 0.913 | 8,000 |
| `r3.large` | 8 / 32 GB | 0.417 | 3,654 |
| `r3.xlarge` | 16 / 64 GB | 0.834 | 7,308 |
| `c3.xlarge` | 16 / 32 GB | 0.694 | 6,077 |
| `p3.xlarge` | 12 / 24 GB | 0.086 | 750 |

Within `m3`, SU scale exactly with cores: about **250 SU per vCPU per year**.
`r3` costs about 1.8× and `c3` about 1.5× the `m3` rate for the same core count.

### Worked examples

| You want | Sum | SU | Bundle |
|---|---|---|---|
| One `m3.small` all year | 0.057 × 8,760 | ≈ 500 | Standard (4,000) with lots to spare |
| One 16-core `m3.xlarge` all year | 0.457 × 8,760 | ≈ 4,000 | All of Standard, nothing left over: ask for Powerful (8,000) |
| One 16-core, 64 GB `r3.xlarge` all year | 0.834 × 8,760 | ≈ 7,300 | Powerful (8,000) |
| Two `m3.large` for 6 months | 2 × 0.228 × 4,380 | ≈ 2,000 | Standard |
| One `m3.xxlarge` for 3 months of heavy work, then an `m3.medium` for 9 months | 0.913 × 2,190 + 0.114 × 6,570 | ≈ 2,000 + 750 = 2,750 | Standard |

Leave some headroom (say 20%): reaching 100% of your SU expires the allocation
(see the expiry table in [02-your-allocation.md](02-your-allocation.md)). Also
check the bundle's other limits: Standard caps you at 64 vCPU and 128 GB RAM
across all instances at once
([bundle contents](https://support.ehelp.edu.au/support/solutions/articles/6000272093)).

### Shut off is not off

A **shut-off** instance still uses SU at the full rate. To stop the meter,
**shelve** it (the instance is saved and can be unshelved later, keeping its
disk) or delete it. Unused SU don't carry over to the next year, but SU
burned by an idle machine are gone for good. See
[08-looking-after-it.md](08-looking-after-it.md).
