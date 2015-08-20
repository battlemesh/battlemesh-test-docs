Scenario 1: The Mesh of Death Adversity
=======================================

.. image:: ./images/1-the-mesh-of-death-adversity.svg

Scenario
--------

This scenario contains two aspects which come into play when wifi nodes are placed in
close proximity.

First of all, as described in
`The Hidden Node Problem <https://en.wikipedia.org/wiki/Hidden_node_problem>`__, a Wi-Fi
adapter is either transmitting or receiving.
To properly function, this requires some form of medium access control, which defines who
can transmit and when.
Having a lot of different transmitters nearby should cause more difficult medium access
control.

Secondly, the routing protocols require information about the network topology to
calculate the best path to send packets.
In order to obtain this information protocols may send special packets to probe which node
is connected to whom and how well.
When the MAC protocol gets strained from the data being sent by all nodes, timeouts might
be caused for such probes.

Problems
--------

First of all, the interference from the different Wi-Fi radios should make transmissions a
bit more troublesome, causing issues even without any routing protocol.

Adding the strain from all the topology probes, can break badly configured protocols.

Requirements
------------

- 10x Tp Link WDR4300 with OpenWRT
- 2x laptops with real ethernet ports (no adapters)
- 2x ethernet cables

Topology
--------

.. image:: ./images/1-the-mesh-of-death-adversity.svg

Our test network consists of 10 nodes which are almost fully connected.

In this type of topology there are different ways the protocols can route the packets,
yet it's compact enough to properly notice the wi-fi interference.

.. note::
   To avoid *node A* linking to *node K* we put *A* and *K* in different rooms
   and we diminished their trasmission power.

   Router from B to J were all put in a large hall.

Configuration
-------------

.. note::
    All the configuration files for each router are
    `available on github
    <https://github.com/battlemesh/battlemesh-test-docs/tree/master/v8/testbed/config>`__.

Each node is a dual radio wireless router (TP-Link WDR4300), the most important facts
related to the configuration are:

* multi channel mesh (2 GHz and 5 GHz)
* dual stack (IPv4 and IPv6)
* protocols installed: **Babel**, **Batman-adv**, **BMX7**, **OLSRv1** and **OLSRv2**
* laptops were connected to the mesh with static routes on nodes *A* and *K*

.. warning::
   By the end of the eight edition we came to the conclusion that having to set up static
   routes to plug laptops into the mesh was a mistake.

   We also haven't been able to run batman-adv with the same network configuration
   of the other routing protocols.

   For these reasons Henning Rogge proposed `a better configuration plan for the next
   edition (Battlemesh v9)
   <http://ml.ninux.org/pipermail/battlemesh/2015-August/003839.html>`__.

Test
----

.. note::
    The test script is `available on github
    <https://github.com/battlemesh/battlemesh-test-docs/tree/master/v8/testbed/scripts/run_test_1-4.sh>`__,
    the relevant sections are test 1, 2 and 3.

The tests mainly consist in generating traffic from a client connected to
**A** to a server connected **K**. The measurements where collected from **A**.

3 different tests were performed:

* **reboot**: ping RTT measurement while the mesh is rebooted; measure time until connectivity
* **ping**: ping RTT measurement
* **ping + iperf**: ping RTT with simultaneous 10 Mbit/s UDP Iperf stream

.. note::
   **RTT** stands for `Round Trip Time <https://en.wikipedia.org/wiki/Round-trip_delay_time>`__

Results
-------

Graphs and raw data are provided for each test.

reboot
^^^^^^

Raw data

ping
^^^^

Raw data

ping + iperf
^^^^^^^^^^^^

Raw data

.. note::
   The graphs were generated with the following command (requires the R programming language)::

       R --vanilla --slave --args --separate-output --maxtime 300 --maxrtt 500 --width 12.8 --height 8 --palette "#FF0000 #005500 #0000FF #000000" --out-type svg results/ < generic.R

   the script `generic.R
   <https://github.com/battlemesh/battlemesh-test-docs/tree/master/v8/data/generic.R>`__ is available on github.
