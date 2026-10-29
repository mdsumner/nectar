# 2. Your allocation

> **Status:** draft

How to get your own Nectar resources: the Project Trial you get at first login, then
applying for a bigger allocation when you need one.

If your group already runs a Nectar project, its manager can add you as a member
instead; ask them how they do it.

## Logging in

- Go to the [dashboard](https://dashboard.rc.nectar.org.au) and choose
  **Login via AAF** (Australia) or **Login via Tuakiri** (New Zealand), then use
  your university credentials
  ([logging in](https://support.ehelp.edu.au/support/solutions/articles/6000055377)).
- Not sure you're eligible? Use the
  [eligibility checker](https://eligibility.rc.nectar.org.au/)
  ([about](https://support.ehelp.edu.au/support/solutions/articles/6000274921)).
  If your organisation isn't in AAF, a collaborator's institution or an
  AAF Virtual Home account may work
  ([no AAF](https://support.ehelp.edu.au/support/solutions/articles/6000225027)).
- Your account goes inactive after 6 months without a login; logging in again
  reactivates it.

## Your Project Trial

Your first login creates a Project Trial (`pt-NNNN`): up to 4 vCPU, expiring
after 6 months, and not shareable
([Project Trial](https://support.ehelp.edu.au/support/solutions/articles/6000068044),
[tutorial](https://tutorials.rc.nectar.org.au/allocation-management/03-account-and-trial)).
The tutorial describes the budget as "4 vCPU for up to 6 vCPU-months". A
shut-off instance still counts; only **shelving** or **deleting** stops it.
A trial is fine for learning how to launch a VM ([04-launch-a-vm.md](04-launch-a-vm.md)),
but it has no DNS name and is too small for most real work.

## Applying

1. **Link your ORCID** first; the form won't go through without it
   ([ORCID](https://support.ehelp.edu.au/support/solutions/articles/6000272526)).
2. In the dashboard, **Allocations > New Request**. You can convert your
   Project Trial into the new project (it keeps whatever you've built, and you
   get a fresh empty trial) or start a new project
   ([converting](https://support.ehelp.edu.au/support/solutions/articles/6000257171)).
3. Choose a **Resource Bundle**
   ([bundles](https://support.ehelp.edu.au/support/solutions/articles/6000271206)):

   | Bundle | Service Units per year |
   |---|---|
   | Standard | 4,000 |
   | Powerful | 8,000 |
   | Extreme | 16,000 |
   | Custom | what you justify |

   Standard also includes up to 40 instances, 64 vCPU, 128 GB RAM, 500 GB of
   object storage, 4 routers and 8 floating IPs
   ([bundle contents](https://support.ehelp.edu.au/support/solutions/articles/6000272093)).
   SU are spent per hour by each running (or shut-off) instance and don't
   carry over ([Service Units](https://support.ehelp.edu.au/support/solutions/articles/6000257023)).
   [03-sizing.md](03-sizing.md) shows how to turn "the machine I need" into SU.
4. **Volumes are requested separately**, as "Location Specific Resources", per
   availability zone (e.g. 500 GB in `tasmania`). Ask for them in the zone
   where you'll run your instance; see [05-storage.md](05-storage.md).
5. Describe the research, funding and why you need these resources. Track the
   request under **Allocations > My Requests**.

Review is done by the local node or the national Allocation Committee and "can
take up to four weeks"; bigger requests need more justification
([Project Trial and allocations](https://support.ehelp.edu.au/support/solutions/articles/6000068044)).

## National or local?

([national vs local](https://support.ehelp.edu.au/support/solutions/articles/6000226889))

- **National**: approved by the Allocation Committee, and you can run in any
  availability zone. You need national or international competitive grant
  funding, NCRIS/ARDC funding, or government/industry funding
  ([policy](https://support.ehelp.edu.au/support/solutions/articles/6000191233)).
- **Local**: at a node's discretion, for researchers at that node's member
  institutions, and resources are at that node only.

Current nodes
([node list](https://support.ehelp.edu.au/support/solutions/articles/6000193442), Aug 2026):
Intersect, Queensland (UQ), Adelaide University, Tasmania (UTAS), Melbourne
Research Cloud, Monash, Swinburne, Pawsey, and National (ARDC-AARNet). Auckland
is a private node for the University of Auckland only. ANU, Deakin, USyd, RMIT and
Macquarie are listed as unaffiliated. Pawsey's old Nimbus cloud closed on 31 March
2025; its Nectar node [went live in December 2025](https://pawsey.org.au/systems/ardc-nectar-cloud-node/). A
[second member list](https://support.ehelp.edu.au/support/solutions/articles/6000264341)
disagrees in places (e.g. Deakin): TODO(verify) which institutions belong to
which node.

## Renewing and amending

Allocations last up to 12 months
([allocations](https://support.ehelp.edu.au/support/solutions/articles/6000055380)).
To renew, or to ask for more, use **Allocations > My Requests > Amend/Extend
allocation**
([tutorial](https://tutorials.rc.nectar.org.au/allocation-management/05-amending-extending)).
Submitting an amendment pauses the expiry process below.

## What happens at expiry

An allocation expires at its end date, or when it has used 100% of its SU
([expiry](https://support.ehelp.edu.au/support/solutions/articles/6000171494)):

| When | What happens |
|---|---|
| 4 weeks before, or at 80% of SU | Warning email |
| Expiry | Quota drops to zero; running instances keep running |
| + 2 weeks | Instances stopped and locked |
| + 30 days | Instances snapshotted, then terminated |
| + 3 months | Everything deleted (except public objects and shared snapshots) |

Don't rely on this as a safety net: copy your data off before the end.

## What to put in your request

You'll be asked how much compute and storage you need. Work it out before you
start the form:

- which flavour (cores and RAM), how many instances, and for how many months,
  which together give your Service Units;
- how much volume storage, and in which availability zone;
- how much object storage, if any.

[03-sizing.md](03-sizing.md) has the commands to measure what you use now, and
worked examples of the SU arithmetic.
