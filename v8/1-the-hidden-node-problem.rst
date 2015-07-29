Scenario 1: The Hidden Node Problem
===================================

Setup and description
---------------------

You create a wireless network station **(A1)** with one hidden node **(N1)** like this:

<first image here>

To avoid collision issues when communicating on a shared medium a media access control
method called **CSMA/CA RTS/CTS** is used.

The hidden node problem occurs when collision avoidance is unable to cover all nodes in
the respective area. For example, N2 is able to detect whether A1 or N3 are transmitting
but it will not know of N1. Therefore **A1** is potentially receiving corrupted data when
both N1 and N2 are going to transmit their data at the same time.

Test plan
---------

You will figure out the optimal configuration of RTS/CTS thresholds in order to gain
maximum performance in OpenWRT. After that compare your results with Ubiquiti’s
proprietary airMAX polling technology that implements **TDMA** in AirOS.

**Requirements:**

- 4x TL-WDR4300 with OpenWRT (including iperf)
- 4x Ubiquiti Picostation M2-HP

Results and interpretation
--------------------------

... TODO ...
