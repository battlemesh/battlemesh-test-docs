Scenario 2: The PowerLAN Conundrum
==================================

Setup and description
---------------------

You create a PowerLAN setup with 3 adapters lined up like this:

<first image here>

PowerLAN technology is mostly working peer-to-peer based and should also support mesh
network protocols. Since many end-users benefit from PowerLAN when connecting their homes
it would be good to know how well supported it is when it comes to dynamic mesh routing.

Test plan
---------

You will set up a basic PowerLAN network running **OLSR(2)**, **BMX6** and
**B.A.T.M.A.N.** to proof all protocols support PowerLAN connectivity (don’t do
simultaneously). After that generate some traffic load between N2 and N3 (e.g. using
iperf) and see how route selection changes in all the different protocols.

When done, create an AdHoc wireless network on N2 and N3 and analyze which path will be
preferred by the respective routing protocol.

**Requirements:**

- 3x TL-WDR4300 with OpenWRT (including iperf, olsr, olsr2, bmx6 and batman-adv)
- 3x TL-PA4010P Powerline adapter

Results and interpretation
--------------------------

... TODO ...
