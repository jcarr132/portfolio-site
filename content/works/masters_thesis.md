---
title: "HCI Masters Thesis"
date: 2020-09-23
draft: true
---


### Introduction

I earned my Master's in Human-Computer Interaction from Carleton University in
September 2020.  My thesis, titled *"Evaluating the Usability of Passthought
Authentication"*, was about the application of brain-computer interfaces (BCIs)
to the problem of authentication (sometimes called *passthought
authentication*). The project began as an effort to develop a BCI
authentication prototype in order to conduct user testing, but grew into a
broader investigation of the role of BCIs in society and the major barriers to
their acceptance including privacy, security, applicability, and general
uneasiness and uncertainty associated with neurotechnologies. The course of the
project was also largely defined by the global COVID-19 pandemic which required
a move away from in-person user testing to alternative remote methods.

This was a huge project and I'm hoping for this summary to be as concise as
possible, so I will omit a lot of the specific details. If you want to really
get into the specifics, [the full-text PDF of my thesis can be downloaded
here.](/docs/thesis_FINAL.pdf)


### Objective

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
desirable characteristics for strong security; however, the critical question
of their usability has been mostly overlooked. At the same time, a new
generation of direct-to-consumer BCI devices have emerged in recent years which
has brought renewed interest in potential applications for BCIs, including
passthoughts. With my thesis project, I aimed to comprehensively evaluate the
usability of BCI-based authentication systems using a variety of methods, and
to identify the main barriers to their acceptance and adoption.


### BCI Authentication Prototype

The first step in this investigation was to design and build a BCI-based
authentication system that I could use to conduct user testing. For this
project I had access to two BCI devices, the Insight and Epoc from
[Emotiv](https://emotiv.com) (shown below), so the application would be based
around their API called Cortex.

{{< figure
  src="/img/thesis/epoc_insight_comparison.png"
  link="https://emotiv.com"
  alt="A side by side comparison of the Emotiv Insight and Epoc devices, on their own and worn by a model."
  caption="A side by side comparison of the Emotiv Insight (left) and Epoc (right) devices, worn by a model (top) as well as on their own (bottom)."
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

{{< figure
  src="/img/thesis/auth_interface.png"
  alt="The front end menu and grid interface."
  caption="The front-end menu and grid interface."
  width="90%"
>}}

### BCI Expert Interview Study
### BCI Questionnaire Study
### Conclusion and Reflection
