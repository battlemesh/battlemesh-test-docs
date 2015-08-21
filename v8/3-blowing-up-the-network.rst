3: Blowing up the network
=========================

.. image:: ./images/1-the-mesh-of-death-adversity.svg

.. warning::
    To perform this test we had to reuse the
    topology prepared for :doc:`The Mesh of Death Adversity Test
    <1-the-mesh-of-death-adversity>` because we were running out of time.

    Therefore this scenario inherits all the settings of the previous test
    but adds parallel streams of traffic from **A** to **K** in order to
    deliberately cause disruption in the network.

Test
----

.. note::
    The tests were performed with `Flent (FLExible Network Tester)
    <https://flent.org/>`__, the `shell script that launches the 5 different tests
    <https://github.com/battlemesh/battlemesh-test-docs/blob/master/v8/testbed/scripts/flent-tests.sh>`__
    is available on github.

The tests mainly consisted in generating a high amount of traffic from
**client** to **server** while measuring network performance.

We ran five different tests on the test setup:

* Realtime Response Under Load (RRUL) test
* Realtime Response Under Load Best Effort (RRUL_BE) test
* 8-stream download test, designed to mimic the dslreports speedtest
* TCP upload test
* TCP download test

Realtime Response Under Load (RRUL) tests
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The **RRUL** test consists of running four simultaneous bulk TCP streams in
both the upstream and downstream directions (so eight streams total),
while simultaneously running UDP and ICMP latency measurements. The test
runs for 60 seconds, to make sure the network is fully saturated.

Two variants of the test were performed:

* the straight **RRUL** test, which marks each of the four TCP streams with different
  diffserv markings matching the mapping into hardware queues in the WiFi stack
* best-effort only (called **RRUL_BE**) in which no diffserv marking is employed

8-stream download test
^^^^^^^^^^^^^^^^^^^^^^

The **8-stream** download test runs eight simultaneous download streams while also
measuring latency.

TCP traffic tests
^^^^^^^^^^^^^^^^^

The TCP traffic tests are just a single TCP stream with
simultaneous latency measurement.

Two different tests were performed:

* TCP upload
* TCP download

Results
-------

Graphs are provided for each test.

`Raw data <https://github.com/battlemesh/battlemesh-test-docs/tree/master/v8/data/results/002-20150808/5>`__
is available on github.

.. note::
   **TODO**: add notes on how to generate the graphs.

Realtime Response Under Load (RRUL)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ICMP latency in ECDF graph:

.. image:: ./data/results/002-20150808/5/rrul-cdf.svg
   :target: ../_images/rrul-cdf.svg

ICMP latency in box graph:

.. image:: ./data/results/002-20150808/5/rrul-box.svg
  :target: ../_images/rrul-box.svg

Realtime Response Under Load Best Effort (RRUL_BE)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ICMP latency in ECDF graph:

.. image:: ./data/results/002-20150808/5/rrul_be-cdf.svg
  :target: ../_images/rrul_be-cdf.svg

ICMP latency in box graph:

.. image:: ./data/results/002-20150808/5/rrul_be-box.svg
  :target: ../_images/rrul_be-box.svg

8-stream download test
^^^^^^^^^^^^^^^^^^^^^^

... **TODO** ...

TCP upload
^^^^^^^^^^

... **TODO** ...

TCP download
^^^^^^^^^^^^

... **TODO** ...
