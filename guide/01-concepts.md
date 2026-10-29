# 1. Concepts

> **Status:** draft

The few words you need before anything else makes sense. You don't need to
memorise them; come back here when a later page uses one.

## The words

| Word | What it means |
|---|---|
| **Cloud** | Computers that aren't on your desk, and that you create for yourself when you need them. They run the same kind of software as your laptop, but you reach them over the network. On Nectar the cloud software is called OpenStack. |
| **Project** | The shared account that owns resources in Nectar. People are *members* of projects. (Older pages call it a "tenant".) |
| **Allocation** | Your request for resources, and its approval. It gives a project a quota for a period of up to 12 months, and can be renewed. |
| **Project Trial** | A small personal project (named like `pt-12345`) created the first time you log in. Up to 4 vCPU, expires after 6 months, and can't be shared with anyone else. Good for trying things out. |
| **Resource Bundle** | The pre-set sizes you choose from when you apply: Standard, Powerful, Extreme or Custom. Each comes with a yearly budget of Service Units plus limits on cores, RAM, and so on. |
| **Service Units (SU)** | The "currency" of an allocation. Every machine size costs a fixed number of SU per hour while it exists. When your SU run out, the allocation expires. |
| **Quota** | The limits that come with an allocation: how many cores (vCPU), how much RAM, how many instances, how much volume and object storage. |
| **Flavour** | A machine size: cores, RAM and root disk, e.g. `m3.large` (8 cores, 16 GB RAM). See [03-sizing.md](03-sizing.md). |
| **Image** | The operating system you start from, usually an official Nectar Ubuntu image such as `NeCTAR Ubuntu 24.04 LTS (Noble) amd64`. |
| **Instance** (VM) | A running machine, built from an image at a flavour, inside a project. "VM" means virtual machine; it behaves like a real computer that you have to yourself. |
| **Volume** | An extra, persistent disk you attach to one instance at a time. It survives when the instance is deleted, which the instance's own root disk does not. |
| **Object storage** | A place to keep files (as "objects" in "containers") that you reach over the web rather than as a disk, a bit like Dropbox. Good for sharing and for big read-mostly data. Not backed up. |
| **Snapshot** | A saved copy of an instance's root disk, or of a volume. You can launch new instances from an instance snapshot. |
| **Availability zone** / **node** | Nectar is run by several partner organisations ("nodes"), each with its own data centre(s), called availability zones (e.g. `tasmania`, `melbourne-qh2`). A volume and the instance it attaches to must be in the same availability zone. |

Sources:
[project](https://support.ehelp.edu.au/support/solutions/articles/6000175280),
[allocations](https://support.ehelp.edu.au/support/solutions/articles/6000055380),
[Project Trial](https://support.ehelp.edu.au/support/solutions/articles/6000068044),
[Resource Bundles](https://support.ehelp.edu.au/support/solutions/articles/6000271206),
[Service Units](https://support.ehelp.edu.au/support/solutions/articles/6000257023),
[flavours](https://support.ehelp.edu.au/support/solutions/articles/6000205341),
[object storage](https://tutorials.rc.nectar.org.au/object-storage/01-overview).

## Two ways to get a working machine

From `legacy/README-2014.md`, and still true:

- **Snapshot**: set a machine up once, save it, and launch copies of it.
- **Recipe**: a script (or container) that turns a clean machine into a working one.

They aren't mutually exclusive. Recipes age better: a snapshot freezes an
old operating system and old software, while a recipe can be re-run on next
year's image. Keep a recipe even if you also keep snapshots.

## If you know AWS EC2

Nectar runs [OpenStack](https://www.openstack.org/), which does much the same job as
EC2. Most of what you know carries across:

| AWS | Nectar (OpenStack) |
|---|---|
| Account, billed by card | Project, with an allocation of Service Units (free to eligible researchers) |
| Instance type (`t3.large`) | Flavour (`m3.large`) |
| AMI | Image |
| EBS volume | Volume (Cinder) |
| S3 | Object storage (Swift), with an [S3-compatible API](https://tutorials.rc.nectar.org.au/object-storage/06-object-storage-s3) |
| Security group, key pair | Same names, same idea |
| Elastic IP | Floating IP (only with Advanced networking; most VMs get a public IP directly) |
| Region / availability zone | Node / availability zone (e.g. `tasmania`, `melbourne-qh2`) |
| Route 53 | DNS (Designate): a `<project>.cloud.edu.au` zone for allocated projects |
| `aws` CLI | `openstack` CLI |
| User data, instance metadata | Same: cloud-init reads user data, and `169.254.169.254` serves EC2-style metadata |

What Nectar doesn't have: managed databases, queues, serverless, autoscaling, or a
marketplace beyond a handful of ready-made applications. You get VMs, storage, and
networking, and you build the rest. Nor is there a bill that grows with use: when the
Service Units run out, the allocation expires.

## Cloud, desktop, or HPC?

| | Your desktop/laptop | Nectar cloud VM | HPC (NCI Gadi, Pawsey Setonix, university cluster) |
|---|---|---|---|
| **How you work** | Interactive | Interactive (RStudio, Jupyter, a terminal), or long jobs left running | Batch: you submit jobs to a queue and wait |
| **Always on?** | Only while it's on and awake | Yes, until you shelve or delete it | Jobs run when the scheduler lets them; there's a time limit |
| **Root/admin access** | Usually | Yes: it's your machine, you install what you like | No; software via modules or containers |
| **Who maintains it** | You or your IT | **You** (updates, users, security) | The HPC centre |
| **How you get access** | Buy it | Join a project or apply for an allocation (free to Australian researchers) | Apply for a compute allocation through your institution or a national scheme |
| **Typical size** | 4–16 cores, 8–64 GB RAM | 1–32 cores (64 on `c3`), up to 128 GB RAM; bigger by special request | Thousands of cores, many nodes per job |

In short: HPC is for massive or highly parallel jobs; the cloud is for
on-demand, interactive, always-on work that you control
([ARDC: cloud computing](https://ardc.edu.au/services/cloud-computing-with-ardc/),
[support: cloud vs HPC](https://support.ehelp.edu.au/support/solutions/articles/6000284556)).
The Nectar tutorial ["What is cloud?"](https://tutorials.rc.nectar.org.au/prereading/02-what-is-cloud)
has a "do I need it?" checklist: more compute, sharing with collaborators,
hosting a service, a different operating system, or work that runs for a long time.

### Small or short jobs: no allocation needed

If you only need a bit more than your laptop for a few days or weeks, these
managed services work with just a Nectar login
([eligibility and services](https://support.ehelp.edu.au/support/solutions/articles/6000274921)):

- **[Virtual Desktop Service](https://desktop.rc.nectar.org.au/)**: a Linux
  desktop in your browser, 8 cores / 16 GB RAM (boost to 16 / 32), for 14 days
  at a time, extendable
  ([details](https://support.ehelp.edu.au/support/solutions/articles/6000253856)).
  How long it stays shelved before deletion differs between pages (30 days,
  1 month or 3 months): TODO(verify).
- **Jupyter Notebook Service**: notebooks in the browser, nothing to install.
- **BinderHub**: run a notebook straight from a Git repository.

For GPU and AI work, look at the National GPU Service rather than a general VM.
