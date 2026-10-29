# Need a bigger computer?

The [ARDC Nectar Research Cloud](https://ardc.edu.au/services/ardc-nectar-research-cloud/)
lets Australian researchers create their own virtual machines (VMs): computers in
a data centre that you start, log in to, install what you like on, and delete when
you're done. It's free for researchers, and it sits between your laptop and a
supercomputer.

This page is a short way in, and a list of places to go next.

> **Status:** early draft. The old notes this grew out of are in [`legacy/`](legacy/).

## Is this for me?

Probably, if:

- your laptop is too slow, too small, or you need something running overnight or for weeks;
- you want a machine you control: your own software, your own users, always on;
- you want to serve something on the web (RStudio Server, Jupyter, marimo, Shiny, a website,
  a data service), or to work on a remote machine from [Positron](https://positron.posit.co/)
  or VS Code over SSH;
- you use HPC but want something interactive alongside it.

**If you have a university email address (`.edu.au`), try logging in now:** go to the
[Nectar dashboard](https://dashboard.rc.nectar.org.au) and choose **Login via AAF**.
If it works, you already have a small personal allocation (a Project Trial) and can
launch a VM today. Not sure you're eligible? Use the
[eligibility checker](https://eligibility.rc.nectar.org.au/).

The trial is small (up to 4 cores, for 6 months). When you need more, you apply for
your own allocation. How to think about that, and how big a machine you need:

- [Your allocation](guide/02-your-allocation.md): the trial, applying, renewing, what happens at expiry
- [Sizing](guide/03-sizing.md): how big a machine is, and turning that into Service Units
- [The words](guide/01-concepts.md): project, allocation, flavour, image, instance, volume

## What do I actually do?

Six steps. Each one has a "more" link if you get stuck; otherwise just do it.
Nothing here is precious. If something goes wrong, delete the VM and start again.

1. **Log in** to the [dashboard](https://dashboard.rc.nectar.org.au) with AAF.
   [More](guide/04-launch-a-vm.md#1-log-in-to-the-dashboard)
2. **Check your allocation.** Your Project Trial (`pt-NNNN`) is selected at the top left.
   [More](guide/04-launch-a-vm.md#2-check-your-allocation)
3. **Create a keypair, and save the private key.** This is how you'll log in; there
   are no passwords. [More](guide/04-launch-a-vm.md#3-create-a-keypair)
4. **Allow SSH in.** A security group is a firewall rule. Without one that allows SSH
   you can see your VM but not reach it.
   [More](guide/04-launch-a-vm.md#4-allow-ssh-in-security-groups)
5. **Launch an instance.** Pick an image (Ubuntu), a flavour (size), your security
   group, and **your key**. A VM launched without a key can't be logged in to; delete
   it and launch another. [More](guide/04-launch-a-vm.md#5-launch-the-instance)
6. **Connect with SSH**: `ssh ubuntu@<ip>`.
   [More](guide/04-launch-a-vm.md#6-connect-with-ssh)

That's it: you have a computer.

**Next:** put something on the web. [RStudio Server](guide/06-rstudio-server.md)
behind HTTPS with a proper name, or the dashboard's one-click "Quick Deploy" for RStudio.

Once you're using it:

- [Storage](guide/05-storage.md): volumes, object storage, network mounts
- [Software](guide/07-software.md): R and geospatial stacks, containers, Python
- [Looking after it](guide/08-looking-after-it.md): users, updates, snapshots, shelving, handing it back

## How Nectar fits

### Compared with AWS EC2

Same idea, different deal. Nectar runs [OpenStack](https://www.openstack.org/), and most
EC2 words have a direct match: instance type → flavour, AMI → image, EBS → volume,
S3 → object storage (Nectar's has an S3-compatible API), and security groups and
keypairs are the same. The differences are that Nectar is free to eligible researchers,
paid for with an allocation of Service Units instead of a credit card, and it has
no managed databases, queues or serverless: you get VMs, storage and DNS.
[More](guide/01-concepts.md#if-you-know-aws-ec2)

### Compared with HPC

HPC (supercomputers and university clusters) is for big batch jobs: you submit work
to a queue, it runs across many cores, and the centre looks after the software. A
Nectar VM is yours. It's interactive, always on, you have root, and you maintain it
([ARDC: cloud vs HPC](https://support.ehelp.edu.au/support/solutions/articles/6000284556)).
Many people use both. If you have an HPC project, interactive work is possible there too:
NCI's [ARE](https://are.nci.org.au/) runs RStudio and Jupyter in the browser, and both NCI
and Pawsey document running them inside a job.
[More](guide/01-concepts.md#cloud-desktop-or-hpc)

- [NCI](https://nci.org.au/): Gadi, the national supercomputer
- [Pawsey](https://pawsey.org.au/): Setonix, and since December 2025 also a
  [Nectar node](https://pawsey.org.au/systems/ardc-nectar-cloud-node/)
- [Monash](https://www.monash.edu/researchinfrastructure/eresearch): a Nectar node and <!-- TODO(verify): link returns 403 to scripts; check in a browser -->
  university HPC
- [QCIF](https://www.qcif.edu.au/): runs the Queensland Nectar node (QRIScloud)
  for UQ, QUT and other Queensland members, and brokers HPC access
- Your own university's research computing team, who often run a cluster and can
  help with a Nectar allocation

### The node network

Nectar is run by partner organisations ("nodes"), each with its own data centre. Your
institution's node can approve *local* allocations; *national* allocations are approved
centrally and can run anywhere. The nodes are Intersect (NSW), Queensland, Adelaide,
Tasmania, Melbourne Research Cloud, Monash, Swinburne, Pawsey, National (ARDC-AARNet),
and Auckland (NZ)
([current list and members](https://support.ehelp.edu.au/support/solutions/articles/6000193442)).

## Official docs and help

- [Nectar tutorials](https://tutorials.rc.nectar.org.au/): step-by-step, with screenshots
- [ARDC Nectar Support Centre](https://support.ehelp.edu.au/support/home): the knowledge base
- Help: support@nectar.org.au, or your node's local support
- [ARDC Nectar Research Cloud](https://ardc.edu.au/services/ardc-nectar-research-cloud/): what it is and who funds it

## About this guide

Written by Michael Sumner, a researcher at the University of Tasmania (home of the
Tasmania node), from about a decade of using Nectar. It's meant to be generic: none of
it depends on which node or institution you're at. Groups that run their own Nectar
projects or services will link their own pages from here. Corrections are welcome as
issues or pull requests.
