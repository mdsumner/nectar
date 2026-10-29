# Research notes: current Nectar facts (checked 2026-10-29)

Working notes for writing the guide, not part of it. Gathered by reading
support and tutorial pages directly. "mod" = the page's "Modified on" date.

Prefixes:
- **SA/** = `https://support.ehelp.edu.au/support/solutions/articles/` (e.g. SA/6000205341)
- **T/** = `https://tutorials.rc.nectar.org.au/`

## Naming and sites
- Official name: "ARDC Nectar Research Cloud" (https://ardc.edu.au/services/ardc-nectar-research-cloud/). Support site: "ARDC Nectar Support Centre".
- support.ehelp.edu.au is live; **support.ardc.edu.au does not resolve**. Support email support@nectar.org.au (SA/6000055378).
- Free to Australian researchers since 2012; 10 partner nodes.

## 1. Logging in
- Dashboard https://dashboard.rc.nectar.org.au (SA/6000076111).
- "Login VIA AAF (Australia)" or "Login VIA Tuakiri (NZ)" with institutional credentials (SA/6000055377, mod 2026-05). No AAF: credentials through a collaborator, or an AAF Virtual Home account (SA/6000225027).
- Eligibility self-check: https://eligibility.rc.nectar.org.au/ (SA/6000274921).
- Account goes inactive after 6 months without a login; logging in reactivates it (SA/6000055377).
- Project Trial (`pt-NNNN`): created at first login; 4 vCPU, expires at 6 months (SA/6000068044, mod 2026-08). Tutorial: "4 vCPU for up to 6 vCPU-months"; shut-off servers still count; only delete or shelve stops it (T/allocation-management/03-account-and-trial). Can't be shared. Pre-made SSH/HTTP/ICMP security groups (SA/6000055387). No DNS zone (T/dns/03-inspect-records).
- Without an allocation: Virtual Desktop, Jupyter Notebook Service, BinderHub (SA/6000274921).

## 2. Projects and allocations
- Project = group of users sharing an allocation ("tenant" is the old term) (SA/6000175280, mod 2017; T/allocation-management/04-allocation-and-projects).
- Allocations last up to 12 months and can be renewed (SA/6000055380).
- Apply: Dashboard > Allocations > New Request; track it in My Requests. **ORCID must be linked first** (SA/6000272526). Choose to convert your PT or start a new project (SA/6000257171).
- Resource Bundles (since March 2024): Standard 4,000 SU/yr, Powerful 8,000, Extreme 16,000, Custom (SA/6000271206). Standard = 40 instances, 64 vCPU, 128 GB RAM, 500 GB object storage, 4 routers, 8 floating IPs... Volumes and Manila are requested separately as "Location Specific Resources" (SA/6000272093).
- Service Units: each flavour costs SU/hour. **Shut-off instances still use SU; only shelve or delete stops it.** No carry-over. 100% SU triggers expiry (SA/6000257023). Usage graphs: SA/6000257054.
- Review by the local node or the Allocation Committee, "can take up to four weeks"; bigger requests need more justification (SA/6000068044).
- Amend or extend: My Requests > Amend/Extend allocation (T/allocation-management/05-amending-extending).
- Expiry (SA/6000171494, mod 2026-07): warning at -4 weeks or 80% SU → at expiry quota goes to 0, instances keep running → +2 weeks stopped and locked → +30 days snapshotted and terminated → +3 months all deleted (except public objects and shared snapshots). Submitting an amendment pauses expiry.
- National vs local (SA/6000226889): national = Committee-approved, runs in any availability zone, needs national/international grant, NCRIS/ARDC, or government/industry funding (RC-NAS policy SA/6000191233); local = at the node's discretion, that node only.
- Nodes (SA/6000193442, mod 2026-08): Intersect, Queensland (UQ), Adelaide University, Tasmania (UTAS), Melbourne Research Cloud, Monash, Swinburne, Pawsey, National (ARDC-AARNet), Auckland (private, University of Auckland only). ANU, USyd, RMIT, Macquarie listed as unaffiliated. A second member list (SA/6000264341) disagrees (e.g. Deakin). Pawsey Nimbus closed 2025-03-31.
- Add a member: Identity > Project Members > Add, using their Nectar username (their email); they must have logged in once. A new project manager needs a support ticket from a manager or the CI (T/allocation-management/07-delegating-project-manager-role).
- Roles are now lowercase: `member`, `tenantmanager` (SA/6000278188).

## 3. Flavours (SA/6000205341, mod 2026-08)
- t3 (tiny, 1 GB/vCPU, 10 GB root); m3 (2 GB/vCPU, 30 GB root, m3.xsmall 1/2 → m3.xxlarge 32/64; m3.small = 0.057 SU/hr ≈ 500 SU/yr); r3 (4 GB/vCPU, up to 32/128); c3 (CPU priority, up to 64/128); p3 (preemptible, 1/4 the SU, killed within 24 h).
- Reserved GPU: g1 A40, g2 A100, g3 L40S; h4 huge RAM. Restricted h3. Node-private flavours (e.g. `tas.*`) are node-specific, via ticket; their naming isn't documented. m1/m2 deprecated.
- Standard flavours have **no ephemeral disk** (only g and h4 list one).
- Quota: Project > Compute > Overview (pie charts). SU: Usage menu (SA/6000257054).

## 4. Images and apps
- Official images are named like `NeCTAR Ubuntu 24.04 LTS (Noble) amd64`. Login users: ubuntu, debian, fedora, rocky, almalinux, ec2-user (SA/6000106269 — its example list is from 2018).
- Build repo https://github.com/NeCTAR-RC/nectar-images/tree/master/vars (active Oct 2026): Ubuntu 22.04, 24.04, **26.04**, Debian 12/13, Rocky 9/10, Alma 9/10, Fedora 44, Windows 2022, AI-Ready. The launch tutorial still shows 20.04.
- Virtual Desktop Service https://desktop.rc.nectar.org.au/: 8 vCPU/16 GB, boost 16/32, 14 days extendable (SA/6000253856). Shelve period conflicts: 3 months / 1 month / 30 days across support, tutorial and ARDC pages. Bumblebee = the software behind it.
- **Applications tab → "Quick Deploy" R-Studio**: RStudio Server + Shiny + browser desktop + X2Go; pick a DNS zone and you get automatic HTTPS at `https://<host>.<project>.cloud.edu.au`; optional volume in the same availability zone (SA/6000164849, mod 2025-09; T/applications/03-configuring). Each deploy creates a security group, so clean them up (SA/6000168298). JupyterLab and AI-Ready apps too (SA/6000196124, SA/6000279725).
- Murano is retired upstream, but Nectar's Applications catalogue (Murano UI) is still documented as current (T/applications/04-deploy). No retirement notice found.
- Other services: Jupyter Notebook Service, BinderHub, National GPU Service, AI Ready.

## 5. Storage
- Root disk 30 GB (10 for t3). Boot from Image, Instance Snapshot, Volume or Volume Snapshot; only a volume-backed root survives deleting the instance (SA/6000222487).
- Volumes (Cinder): requested per availability zone as Location Specific Resources, standard or encrypted. One instance at a time, same availability zone. Steps (T/volume-storage/03-create-attach, /04-format-mount): create in the instance's availability zone → attach → `lsblk` (e.g. /dev/vdc) → `sudo mkfs -t ext4 /dev/vdc` → mkdir → fstab `/dev/vdc /pvol auto defaults,nofail 0 2` → `sudo mount --all` → chown. Unmount, then detach, then delete (/07-unmount-detach). Resize: detach, Extend, `e2fsck -f`, `resize2fs` (/08-increasing-size). Volume backup service at all nodes (SA/6000185788).
- Object storage (Swift): in bundles; replicated across 3 availability zones; **not backed up** (T/object-storage/01-overview); dashboard, `swift`, Cyberduck, rclone. S3: `openstack ec2 credentials create`, endpoint `https://object-store.rc.nectar.org.au`; no aws-chunked uploads (T/object-storage/06-object-storage-s3). No server-side encryption (SA/6000061932).
- Manila shared filesystems: Monash (CephFS, availability zone monash-02-cephfs) and Auckland (NFS) only; same availability zone; own quota (SA/6000183607, mod 2023).

## 6. Networking and security
- `default` security group is empty for inbound; rules are additive; outbound is open. Allocated projects start with only `default`, which is shared by all members (SA/6000055387). Project > Network > Security Groups (T/sec-groups-101/03-create).
- Keypair: `ssh-keygen`, then Compute > Key Pairs > Import Public Key (T/keypairs/03-ssh-keygen). No default passwords.
- Classic Provider = public IPv4 directly on the instance (the default in the launch tutorial). Advanced = private network + router + floating IP, which need quota via an amendment; floating IP in the same availability zone (T/advanced-networking/03-classic-vs-advanced-networking, /02-availability-and-quota).
- DNS: new or renewed allocations get the zone `<project>.cloud.edu.au.` automatically; PTs don't; older projects ask support (T/dns/03-inspect-records; SA/6000201311). Dashboard Project > DNS > Zones, or `openstack recordset create <project>.cloud.edu.au. <name> --type A --record <ip>` with python-designateclient (T/dns/05-create-recordset). Own domain: nameservers ns1/ns2.rc.nectar.org.au.

## 7. Command line
- `pip install python-openstackclient` (or apt `python3-openstackclient`); Windows → WSL (T/openstack-cli/02-openstack-client, stale: easy_install). No venv/uv advice from Nectar.
- RC file: click your email (top right) > OpenStack RC File; Settings > Reset Password gives a separate OpenStack password, shown once (T/openstack-cli/04-credentials). Robot accounts for unattended services (SA/6000145832).
- Application credentials (T/application-credentials/02-..., /03-...): Identity > Application Credentials; download the openrc or clouds.yaml; `export OS_CLOUD=openstack`; one project each; unset other OS_* first. Preferred over passwords in scripts. Auth URL: identity.rc.nectar.org.au/v3 vs keystone.rc.nectar.org.au:5000/v3 in older pages; use whatever the downloaded file says.

## 8. Snapshots and lifecycle
- Instance snapshot = root disk only (T/snapshots/02-instance-snapshots). A volume snapshot uses quota equal to the volume's size and blocks deleting the volume (T/snapshots/06-volume-storage-snapshots). Share with another project: `glance member-create`; the recipient accepts (SA/6000106269).
- Resize = resize then confirm; rebuild wipes the disk but keeps the IP; delete is irreversible and the IP is lost (T/changing-instances/03-05).
- Only shelve or delete stops SU use (SA/6000257023).
- Converting a PT: the PT becomes the new project and keeps its resources; a new empty PT is created (SA/6000257171).

## 9. Cloud vs HPC
- HPC (NCI, Pawsey) is for massive or parallel jobs; the ARDC cloud is for scalable, on-demand, interactive work (SA/6000284556; https://ardc.edu.au/services/cloud-computing-with-ardc/). GPU/AI work → National GPU Service or preemptible.
- "Do I need it?" checklist: more compute, sharing, hosting, a different OS, long-running work (T/prereading/02-what-is-cloud).

## Staleness and conflicts
support.ardc.edu.au is dead; VDS shelve period disagrees across pages; tutorials still show Ubuntu 20.04; image catalogue examples from 2018; CLI install pages dated; auth URL varies; two node member lists disagree; Murano retired upstream but Nectar Applications still current; several pages dated 2017–2022; `tas.*` flavour naming undocumented.
