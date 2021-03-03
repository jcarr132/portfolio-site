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
intended to be *secure* in any way. The goal is only to conduct usability
testing, so it is more accurate to describe it as a *simulation* of BCI mental
command authentication.  Therefore, security features that would not affect the
user experience such as password hashing and encryption were ignored. That
said, I did try to design the overall interaction in such a way that a properly
secure version could be built based on the same idea.

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

### BCI Expert Interview Study

The goal of this and the subsequent questionnaire study was to examine the
possibility of mass adoption of BCIs among the general public and to identify
the main barriers to this outcome by soliciting opinions with a specific
emphasis on privacy and cybersecurity-related concerns.

A major difficulty in studying people's attitudes toward BCI devices stems from
the fact that very few people know much about them, and the general public tend
to be uninformed or misinformed about BCIs, how they work, and the extent of
their capabilities.  I reasoned that it would be informative to understand the
perspective of experienced BCI users because this would help in parsing whether
issues I identified were real limitations of the BCI system or arising out of
misconceptions about the technology. To this end, I recruited 7 BCI expert
users by submitting recruitment posts on various BCI-related forums and social
media groups and conducted remote semi-structured interviews with them using
videoconferencing software.

In a semi-structured interview, I have a set of *guide questions* and potential
followups that I've planned out, but the goal of the interview is to allow the
conversation to unfold organically. Therefore, in some cases I may completely
disregard my interview guide in order to pursue an interesting conversational
thread that emerges. This type of interview produces a rich qualitative dataset
that can be analyzed in a number of ways. I recorded the audio of each
interview and also took notes. Afterward I relistened to each interview several
times and transcribed meaningful sections or quotations into text for easier
analysis.

I analyzed the interview data using a qualitative research approach called
*Reflexive Thematic Analysis*, which is a relatively loose, bottom-up approach
for deriving general themes from a text dataset. In the first step, every
non-trivial statement is assigned one or more *codes*--labels which capture a
particular sentiment or idea from the text. Coding and code generation are an
iterative process in which new codes are added as needed and frequently
replaced or combined with other codes. This process is repeated until some
predetermined stopping condition is met. In my case, I continued iterating over
the dataset and generating codes until I did a full pass without adding any new
codes, at which point I stopped and moved onto the next stage.

After code generation, the next step is to start to assemble the codes into
coherent themes that capture some general aspect of the interviewee responses.

### BCI Questionnaire Study
### Conclusion and Reflection
