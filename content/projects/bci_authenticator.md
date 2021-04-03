---
title: "BCI Authenticator Prototype"
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
commands that were required for the two-dimensional grid drawing task.

{{< figure
  src="/img/thesis/epoc_insight_comparison.png"
  link="https://emotiv.com"
  alt="A side by side comparison of the Emotiv Insight and Epoc devices, on their own and worn by a model."
  caption="A side by side comparison of the Emotiv Insight (left) and Epoc (right) devices, worn by a model (top) as well as on their own (bottom). Images from [emotiv.com](https://emotiv.com)"
>}}

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
## The Study
## Results
## Reflection













### Introduction

I earned my Master's in Human-Computer Interaction from Carleton University in
September 2020.  My thesis, titled *"Evaluating the Usability of Passthought
Authentication"*, was about the application of brain-computer interfaces (BCIs)
to the problem of authentication (sometimes called *passthought
authentication*). This project was conducted under the supervision of Dr.
Robert Biddle, whose guidance and mentorship were instrumental in it's
completion. The project began as an effort to develop a BCI authentication
prototype in order to conduct user testing, but grew into a broader
investigation of the role of BCIs in society and the major barriers to their
acceptance including privacy, security, applicability, and general uneasiness
and uncertainty associated with neurotechnologies. The course of the project
was also largely influenced by the global COVID-19 pandemic which required a
move away from in-person user testing to alternative remote methods.

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
desirable characteristics for strong security (in theory); however, the
critical question of their usability has been mostly overlooked. At the same
time, a new generation of direct-to-consumer BCI devices have emerged in recent
years which has brought renewed interest in potential applications for BCIs,
including passthoughts. With my thesis project, I aimed to comprehensively
evaluate the usability of BCI-based authentication systems using a variety of
methods, and to identify the main barriers to their acceptance and adoption.


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

<!--
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
-->

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
