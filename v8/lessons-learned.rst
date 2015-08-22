Lessons learned
===============

Lessons learned during the battlemesh v8.

Firmware
--------

**Problems**:

Choosing to compile the firmware using openwrt trunk in the first days of the
event was a mistake which delayed the testing phase.

Not stating clearly which protocols were going to participate in the battle
caused misunderstandings and discussions which could have been avoided with
more preparation.

**Possible solutions**:

* use a stable OpenWRT release
* choose a specific revision at least one month in advance
* prepare the firmware before the event
* the protocols that want to participate in the battle have to state it clearly
  in advance and have to take part during the test process

Configuration
-------------

**Problems**:

Planning the address scheme, configuring all the protocols to work together was
quite a big deal of work.

We assumed the configurations from the previous years could be reused, but they
had to be reworked from scratch.

**Possible solutions**:

* prepare a working configuration before the event
* ask all the routing protocol developers to contribute to the proposed configuration

Communication
-------------

**Problems**:

During the entire process communication between teams was uneffective and
disorganized, a second testbed was set up manually, there were rumors
circulating and this caused distress and loss of motivation of some people.

**Possible solutions**:

* have short meetings each day to debrief on the status of the test process and
  talk about eventual problems and proposed solutions
* take notes of the meetings and make them available to all the participants (eg: etherpad)
* use a projector and a microphone to keep attention levels high

Volunteers
----------

**Problems**:

There were quite some people that wanted to help out but it was not clear
how they could help because the tasks list contained only **firmware preparation**
and **test management**, which were not enough to describe the entire test process
to new comers so they were not able to understand how they could contribute.

**Possible solutions**:

* encourage people to participate to one or more of these following teams:
    * **planning team**: plans realistic test scenarios, that is, according to the
      situation of each event (number volunteers, location and so on)
    * **firmware team**: prepares the firmware with all the required agreed packages
    * **flashing team**: flashes devices in mass
    * **configuration team**: reviews config of the past year, checks if they can be reused
      as is or need to be modified, if modified gets them approved by the routing devs
    * **deployment team**: deploys the testbed and works until everything works
      correctly, updating configs if necessary
    * **test team**: writes and tests the scripts to execute tests and passes the
      raw data to the graph generation
    * **graph generation team**: writes (or reuses an already written set of) scripts to
      generate graphs from raw data extracted from the test scripts
    * **documentation team**: prepares drawing of topology, takes photos of the testbed for
      the presentation, writes an outline of the test plan, stores all the configs
      and scripts used during the process for later publication
    * **routing team**: developers of all the routing protocol involved oversee the
      whole process, with particular attention to the test plan phase,
      configuration and test scripts
* have people work in parallel on different indipendent tasks to speed up the process 
