---
title: "Brain-Computer Interface Authenticator Prototype"
date: 2019-01-23
draft: true
---

#### by Joshua Carr

This post describes a software prototype that I built as a part of my HCI
Master's thesis at Carleton University. I describe a novel idea for
brain-computer interface (BCI) authentication based on mental command
sequences, as well as a prototype based on this design which I used to conduct
usability testing.  This project was originally published as Chapter 3 of my
Master's thesis, available [here](/docs/thesis_FINAL.pdf). The code repository
for this prototype is available [on
Github](https://github.com/jcarr132/BrainGridAuthenticator), but an Emotiv BCI
is needed in order to use the application.

## Organization

* Carleton University - Human-Oriented Technology Software Research Lab
  [(HotSoft)](https://hotsoft.carleton.ca/hotsoft/)
* Supervised by [Dr. Robert Biddle](https://carleton.ca/scs/people/robert-biddle/)

## Project Summary

The goal of this project was to assess the feasibility of a novel method of
BCI-based authentication based on mental command sequences. To that end, I
designed and build a prototype authenticator to use with
[Emotiv](https://emotiv.com) BCI devices in order to conduct
usability/feasibility testing. The authentication involves training a series of
*mental commands*--specific mental states that are associated with a desired
action--and then using those commands in a sequence as a sort of password by
drawing a pattern through a grid of points.

I recruited some of my lab colleagues to test the application and give
feedback, but at this stage we began running into significant problems with the
reliability and usability of the Emotiv BCI headset. We were unable to get
Emotiv's mental command classifier to reliably distinguish between the four
commands that were required for the two-dimensional grid drawing task. In fact,
I found that it was nearly impossible for the Emotiv system to reliably
distinguish between two trained commands, even after several hours of training.

{{< figure
  src="/img/thesis/epoc_insight_comparison.png"
  link="https://emotiv.com"
  alt="A side by side comparison of the Emotiv Insight and Epoc devices, on their own and worn by a model."
  caption="A side by side comparison of the Emotiv Insight (left) and Epoc (right) devices, worn by a model (top) as well as on their own (bottom). Images from [emotiv.com](https://emotiv.com)"
>}}

I started working on some modifications to the prototype in order to have it
work with fewer (*i.e.* 2 or 3) commands instead of four, but it was at this
time that Carleton University closed and suspended in-person research
activities due to the emerging COVID-19 pandemic. I was unfortunately forced
to shelve this project and focus on other research projects that didn't require
direct participant interaction in order to complete my thesis on time.

## Project Timeline

Development of the authenticator prototype began in mid-October of 2019, and
the final code commit was on April 16, 2020.  I began testing with lab
volunteers and iterating the design based on feedback in December of 2019 and
this continued into March of 2020.  Development of this prototype was
indefinitely halted in April 2020 due to the emerging COVID-19 global health
crisis and suspension of in-person research activities at Carleton University.

## My Role

I was the lead researcher on this project, in collaboration with my thesis
supervisor Dr. Biddle who provided advice and guidance throughout the process.
I designed and built the software prototype, prepared the Research Ethics Board
(REB) proposal, recruited volunteers to test the application and give feedback,
and made iterative changes to the application based on user performance and
comments.


## Context

The text-based passwords that most of us are familiar with exhibit a number of
usability problems which lead to user behaviours that compromise security, such
as reusing the same passwords multiple times or writing them down. This is
compounded by the fact that people are maintaining a greater number of online
accounts than ever before. Researchers have been proposing new types of
authentication mechanisms for years, but so far nothing has really stuck and
passwords stubbornly remain as the *de facto* standard for authentication
across nearly all domains.

The idea of using BCIs for authentication is not new, and was first suggested
in 2005 by another Carleton graduate student, Dr. Julie Thorpe (now of Ontario
Tech University). Since then, a rather significant body of work has been built
up around the topic of *"passthoughts"*, with some studies reporting
authentication accuracies well above 90%.  Passthoughts demonstrate some
desirable characteristics for strong security (in theory); however, the
critical question of their usability has been mostly overlooked. At the same
time, a new generation of direct-to-consumer BCI devices have emerged in recent
years which has brought renewed interest in potential applications for BCIs,
including passthoughts. With this research project, I aimed to test the
feasibility of authentication using commercial-grade BCIs using a software
prototype that I built myself.

---

## The Prototype
### Design

I knew going in that I wanted to base the authentication interaction on
mental commands. The basic idea is that a machine learning classifier
learns to associate a specific pattern of neurological activity from the
headset with a discrete output command. Mental commands are an
interesting approach because they are a generalizable control scheme
that are not specific to authentication. Emotiv's software toolkit comes
with built-in support for training a mental command classifier and
integrating them into a third-party application.

{{< figure
  src="/img/thesis/emotivbci_merged.png"
  link="https://emotiv.com"
  alt="Screenshots of the EmotivBCI application which is used to train mental commands with an Emotiv device."
  caption="Screenshots of the EmotivBCI application which is used to train mental commands with an Emotiv device. Images from [emotiv.com](https://emotiv.com)"
>}}

The first major consideration in the design process was how to construct a
*"password"* from mental commands. A sequence of mental commands has advantages
over other BCI-based authentication methods because it does not require storing
any of the user's neurological data. The neurological data can be processed
locally, and only the output commands would need to be stored for comparison.
The initial design process is reflected in some of my notes, shown below.

{{< figure
  src="/img/thesis/design_merged1.png"
  link="https://emotiv.com"
  alt=""
  caption=""
>}}

A simple and generalizable solutions that occurred to me was to model the
interaction after the *pattern unlock* paradigm that is common on mobile phones
using directional (i.e., up, down, left, right) commands. The first sketches of
this design are shown in the figure below. This design is somewhat more
constrained than the mobile phone version, because the user is limited to
moving only one grid space at a time and only in four cardinal directions (no
diagonals!).

{{< figure
  src="/img/thesis/design_merged2.png"
  link="https://emotiv.com"
  alt=""
  caption=""
>}}

---

### Implementation

The app itself is implemented as a single-page web app running on a
NodeJS express server on the local machine. The server connects to a
MondoDB database instance, used to store user credentials, and the
Emotiv Cortex API which is used to read data from the Emotiv headset.

I built a simple wrapper around the Cortex API to handle
sending/receiving requests and processing data. Cortex handles requests
in the form of JSON-RPC calls over a websocket, so I create a websocket
connection and store that in the Cortex object.

```javascript
const CORTEX_URL = 'wss://localhost:6868';
const WebSocket = require('ws');

class Cortex {
  constructor(auth) { // auth = object containing Cortex API key
    this.ws = new WebSocket(CORTEX_URL)

    // listen for close
    this.ws.addEventListener('close', () => {
      log('Socket closed');
    });

    // wait for connection
    this.ready = new Promise((resolve) => {
      log('initialized Cortex object');
      this.ws.addEventListener('open', resolve);
    }).then(() => log('Socket opened'));
  }
}
```



```javascript
call(method, params = {}) {
  return new Promise((resolve) => {

    // construct the JSON-RPC request
    const request = {
      jsonrpc: '2.0',
      method,
      params,
      id: messageId,
    };

    // serialize and send the request
    const message = JSON.stringify(request);
    this.ws.send(message);

    // messageHandler callback doesn't correctly interpret `this`, so
    // store an unambiguous reference
    const ctx = this;

    // create the messageHandler
    function messageHandler(data) {
      const response = JSON.parse(data);
      if (response.id === messageId) {
        ctx.ws.removeEventListener('message', messageHandler);
        resolve(response.result);
      }
    }

    // attach the messageHandler to the websocket
    this.ws.on('message', messageHandler);
  });
}
```


## Results
## Reflection












### Objective



<!--
### BCI Authentication Prototype

The first step in this investigation was to design and build a BCI-based
authentication system that I could use to conduct user testing. For this
project I had access to two BCI devices, the Insight and Epoc from
[Emotiv](https://emotiv.com) (shown below), so the application would be based
around their API called **Cortex**.

{{< figure
  src="/img/thesis/epoc_insight_comparison.png"
  link="https://emotiv.com"
  alt="A side by side comparison of the Emotiv Insight and Epoc devices, on their own and worn by a model."
  caption="A side by side comparison of the Emotiv Insight (left) and Epoc (right) devices, worn by a model (top) as well as on their own (bottom). Images from [emotiv.com](https://emotiv.com)"
>}}

One of the functions that the Emotiv Cortex API provides is the use of mental
commands: translating specific patterns of brain activity into discrete
*commands* which can be used to interact with a computer system.  To my
knowledge, nobody else has written in the research literature about passthought
systems based on mental-commands--generally they are based on some sort of
similarity analysis of some subset features extracted from the EEG signal--so
this seemed like it might be a promising approach. The idea was to use a
specific sequence of mental commands as a sort of *password*. There are a few
advantages to this, but one of the main ones is that it avoids having to store
any representation of the user's actual neurological data on a server.

I built out a simple web application around the Emotiv mental command API. My
goal for the initial prototype was to create the simplest form of
authentication based on mental commands possible in order to establish whether
the basic idea was feasible. I used NodeJS with `express` to set up a server
which would use websockets to handle communication with the Cortex API as well
as a MongoDB instance which was used to store authentication credentials and
metadata.  The server provides a single page, `index.html`, which contains the
JavaScript code used to render the graphical UI (using the `snap.svg`
JavaScript library).

{{< figure
  src="/img/thesis/app_schematic.png"
  alt="A schematic showing the structure of the BCI authenticator prototype."
  caption="A schematic showing the structure of the BCI authenticator prototype."
  width="90%"
>}}

For the interface, I wanted to have a task that could be done using a series of
discrete commands to provide visual feedback during the authentication process,
so I based the design on the *pattern unlock* authentication paradigm common on
mobile devices. Basically, given a grid of points and a starting position, a
user *draws* a pattern through the grid using a series of directional mental
commands (*i.e.,* up, down, left, right); the sequence of commands comprises
their password.

I want to mention an important point here: the application itself is not
intended to actually be *secure* in any real way. The goal is only to conduct
usability testing, so it is more accurate to describe it as a *simulation* of
BCI mental command authentication.  Therefore, security features that would not
affect the user experience such as password hashing and encryption were
ignored. That said, I did try to design the overall interaction in such a way
that a properly secure version could be built based on the same idea.

{{< figure
  src="/img/thesis/auth_interface.png"
  alt="The front-end menu and grid interface."
  caption="The front-end menu and grid interface."
  width="90%"
>}}

My intent was to use an iterative design approach, starting from the simplest
possible implementation and repeatedly refining prototypes based on the results
and feedback from pilot sessions until the application was ready for full-scale
user testing.  Once the basic interaction had been implemented, I started some
pilot testing with some of my lab colleagues who agreed to help out.

Several issues quickly became apparent with the first iteration of the
prototype. Specifically, most of the difficulty came from the usability and
reliability of the Emotiv system, especially the mental command functionality.
I found that it was nearly impossible to train the Emotiv mental command
classifier well enough to reliably discriminate between the four mental
commands necessary to use the authenticator. While volunteers could get the
system to work with one or two commands relatively easily, adding a third
seemed to completely confuse the classifier such that it no longer recognized
any of the previously trained commands.

Based on these preliminary experiments, I got a sense of how the system would
need to be changed. I began the process of refining the prototype to cope with
fewer commands as well as making several modifications to improve usability of
the mental command training process. However, before I had an opportunity to
test this new iteration with volunteers, Carleton suspended in-person
activities at the University campus due to the emerging COVID-19 pandemic. This
meant that it would be impossible to continue work on the BCI authenticator
project, as I had no indication of when I would be able to resume testing with
volunteers. However, I was still on a timeline to complete my Master's degree
within two years. After consulting with Dr. Biddle, we decided to write-up the
BCI authenticator study as it was, and conduct a pair of additional studies
using remote user research methods in order for the final thesis to have a
reasonable amount of content.

{{< figure
  src="/img/thesis/app_schematic.png"
  alt="The structure of the application back-end."
  caption="The structure of the application back-end."
  width="90%"
>}}
-->
