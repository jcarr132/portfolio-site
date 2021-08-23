---
title: "Brain-Computer Interface Authenticator Prototype"
date: 2019-01-23
author: "Joshua Carr"
draft: true
---

## Context

The text-based passwords that we are all familiar with exhibit a number
of usability problems which lead to user behaviours that compromise
security, such as reusing the same passwords multiple times or writing
them down. This is compounded by the fact that people are maintaining a
greater number of online accounts than ever before.  Researchers have
been proposing new types of authentication mechanisms for years, but so
far nothing has really stuck and passwords stubbornly remain as the *de
facto* standard for authentication across nearly all domains.

The goal of this project was to assess the feasibility of a novel method
of BCI-based authentication based on mental command sequences. To that
end, I designed and build a prototype authenticator to use with
[Emotiv](https://emotiv.com) BCI devices in order to conduct
usability/feasibility testing. The authentication involves training a
series of *mental commands*--specific mental states that are associated
with a desired action--and then using those commands in a sequence as a
sort of password by drawing a pattern through a grid of points.

{{< figure
  src="/img/thesis/epoc_insight_comparison.png"
  link="https://emotiv.com"
  alt="A side by side comparison of the Emotiv Insight and Epoc devices, on their own and worn by a model."
  caption="A side by side comparison of the Emotiv Insight (left) and Epoc (right) devices, worn by a model (top) as well as on their own (bottom). Images from [emotiv.com](https://emotiv.com)"
>}}

The idea of using BCIs for authentication is not new, and was first
suggested in 2005 by another Carleton graduate student, Dr. Julie Thorpe
(now of Ontario Tech University). Since then, a rather significant body
of work has been built up around the topic of *"passthoughts"*, with
some studies reporting authentication accuracies well above 90%.
Passthoughts demonstrate some desirable characteristics for strong
security (in theory); however, the critical question of their usability
has been mostly overlooked. At the same time, a new generation of
direct-to-consumer BCI devices have emerged in recent years which has
brought renewed interest in potential applications for BCIs, including
passthoughts. With this research project, I aimed to test the
feasibility of authentication using commercial-grade BCIs using a
software prototype that I built myself.

---

## Design

I knew going in that I wanted to base the authentication interaction on
mental commands. The basic idea of mental commands is that a machine
learning classifier learns to associate a specific pattern of
neurological activity from the headset with a discrete output command.
Mental commands have potential to be an interesting approach to BCI
authentication because they are a generalizable control scheme that can
be extended to a variety of BCI activities other than authentication.
Emotiv's software toolkit and API provide built-in support for training
a mental command classifier and integrating them into a third-party
application.

{{< figure
  src="/img/thesis/emotivbci_merged.png"
  link="https://emotiv.com"
  alt="Screenshots of the EmotivBCI application which is used to train mental commands with an Emotiv device."
  caption="Screenshots of the EmotivBCI application which is used to train mental commands with an Emotiv device. Images from [emotiv.com](https://emotiv.com)"
>}}

The first major consideration in the design process was how to construct
a *"password"* from mental commands. A sequence of mental commands has
advantages over other BCI-based authentication methods because it does
not require storing any of the user's neurological data. The
neurological data can be processed locally, and only the output commands
would need to be stored for comparison.

{{< figure
  src="/img/thesis/design_merged1.png"
  link="https://emotiv.com"
  alt=""
  caption=""
>}}

The basic idea is that the user trains several (i.e., at least 4)
directional mental commands and then issues them in a particular
sequence as a sort of *password* (e.g., *up, right, up, left, left,
down, left*). Because Emotiv's devices produce a nearly-constant stream
of mental command outputs, I needed to develop a way to discretize the
commands into individual steps. I decided to do this by collecting
mental commands over some predefined period of time, which I call a
"Command Block", and then processing the data to determine an overall
output command. The *password* then is basically a series of these
Command Blocks with the correct outputs.

A simple and generalizable solution that occurred to me was to model the
interaction after the *pattern unlock* paradigm that is common on mobile
phones using directional (i.e., up, down, left, right) commands.  The
first sketches of this design are shown in the figure below. This design
is somewhat more constrained than the mobile phone version, because the
user is limited to moving only one grid space at a time and only in four
cardinal directions (no diagonals!).

{{< figure
  src="/img/thesis/design3_grid.jpg"
  link="https://emotiv.com"
  width="70%"
  alt=""
  caption=""
>}}

---

## Implementation

The app itself is implemented as a single-page web app running on a
NodeJS express server on the local machine. The server connects to a
MondoDB database instance, used to store user credentials, and the
Emotiv Cortex API which is used to read data from the Emotiv headset.

{{< figure
  src="/img/thesis/app_schematic.png"
>}}

Something to keep in mind is that I didn't design this application to be
an actually *secure* authentication system; rather it is meant to be a
prototype of this specific type of BCI-authentication interaction.
Therefore I didn't spend time implementing security features that would
not affect the direct user experience (like password hashing).

### Cortex API Wrapper

I built a simple wrapper class around the Cortex API to handle
sending/receiving requests and processing data. The `Cortex` class
handles requests in the form of JSON-RPC calls over a websocket, so I
create a websocket connection and store that in the Cortex object:

```javascript
const WebSocket = require('ws');

// local port used by cortex
const CORTEX_URL = 'wss://localhost:6868';

class Cortex {
  constructor(auth) { // auth = struct containing Cortex API key
    this.ws = new WebSocket(CORTEX_URL);
    this.auth = auth  // API credentials needed to authorize

    // wait for connection
    this.ready = new Promise((resolve) => {
      this.ws.addEventListener('open', resolve);
    }).then(() => console.log('Socket opened'));

    // listen for close
    this.ws.addEventListener('close', () => {
      console.log('Socket closed');
    });
  }
}
```

A JSON-RPC request is essentially a JavaScript object with a few special
fields, shown here:

```javascript
{
    "id": 1,
    "jsonrpc": "2.0",
    "method": "area",
    "params": {
        "width": 6,
        "length": 7
    }
}
```

Where `"method"` is the name of an API method  and `"params"` is an
optional array of parameters that the method expects.  `"id"` is just an
integer value that can be incremented for each message to keep track of
which responses correspond to which requests, and `"jsonrpc"` is a
mandatory field that must be set as "2.0". I added a value in the
`Cortex` constructor to keep track of the `messageId` as it's
incremented with each API call:

```javascript
//-------SNIP--------//
  constructor(auth) { // auth = struct containing Cortex API key
    this.ws = new WebSocket(CORTEX_URL);

    this.messageId = 0;

    // wait for connection
    this.ready = new Promise((resolve) => {

//-------SNIP--------//
```

I then implemented a `call` method that handles building, sending, and
receiving JSON-RPC data over the websocket. `call` is implemented as a
`Promise` to deal with the asynchronicity of the Cortex API (it is not
possible to know when or in what order responses will arrive). The
`Promise` in this case is a guarantee that the instructions within the
Promise will eventually `resolve` into a value, which can then be
consumed with `Promise.then()`.

(Promises are a pretty complicated topic. You can read more about their
use [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Using_promises).)

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

    this.messageId++;

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

So the `call` method takes the name of a method and a set of parameters
and, as a Promise, constructs a `request` object, serializes it, and
passes it to the API over the websocket connection. A `messageHandler`
is defined and attached to the websocket which will listen for the
response to this specific request (each request gets its own
`messageHandler`) and `resolve` the Promise with the response data
before deleting itself.

Now specific Cortex API methods can be wrapped as special cases of
`call`. For example, the `authorize` API method which takes the API
credentials (`client.id` and `client.secret`) and provides an
authentication token:

```javascript
authorize(auth = this.auth) {
  return new Promise((resolve) => {
    const params = {
      clientId: auth.client_id,
      clientSecret: auth.client_secret,
    };

    this.call('authorize', params)
      .then((result) => {
        this.authToken = result.cortexToken; // store authToken in Cortex object
        console.log(`assigning authToken: ${result.cortexToken.slice(0, 20)}...`);
        resolve(result.cortexToken);
      });
  });
}
```


---

Here is a more advanced example. The usual workflow to read data from
the Emotiv headset is to start a "session" (`createSession` API method)
and then subscribe to a "stream" (`subscribe`). There are several
streams available for different types of data, but I am interested in
the mental commands (or `com`) stream. One issue with the mental command
stream is that it sends events at a rate of several per second, and for
the authenticator app I want commands to be entered in more discrete
steps.  When mental command events come through the websocket, they look
like this:

```javascript
{
    "id":7,
    "jsonrpc":"2.0",
    "result":{
        "failure":[],
        "success":[{
            "cols":["act","pow"],
            "sid":"...",
            "streamName":"com"
        }]
    }
}
```

Where `"act"` is the name of the command that the mental command
classifier has predicted, and `"pow"` is the confidence of the
prediction. I developed the idea of a "command block" in which I keep
track of the cumulative power of each command over some fixed amount of
time, and then determine a final output based on which command had the
greatest overall power during the block. Here is what that looks like:

```javascript
commandBlock(blockTime = 8000) {
  // `blockTime` = duration of the `commandBlock` in milliseconds
  return new Promise((resolve) => {
    // define a structure to hold the data from the block
    const blockData = {
      output: {},
      commands: {},
    };

    this.createSession({ auth: this.auth, status: 'open' })
      .then(() => {
        // subscribe to the `com` stream to get mental command events
        this.subscribe(['com']).then(() => {
          // attach a handler function for mental command events coming
          // over the websocket
          this.ws.on('message', (msg) => {
            // for each command event:
            // parse the json into struct.
            msg = JSON.parse(msg);
            if (msg.com) {
              // record which command, and how powerful.
              const act = msg.com[0];
              const pow = msg.com[1];

              // add or update entry in `blockData.commands` struct.
              // keep a running total of cumulative power for each
              // command.
              if (!blockData.commands.hasOwnProperty(act)) {
                blockData.commands[act] = { count: 1, power: pow };
              } else {
                blockData.commands[act].count++;
                blockData.commands[act].power += pow;
              }
            }
          });

          // end the block after `blockTime` milliseconds (default 8s)
          setTimeout(() => {
            // iterate over each command in `blockData`, determine which
            // has the greatest cumulative power and set that command as
            // `blockData.output`
            Object.keys(blockData.commands).forEach((key) => {
              const command = blockData.commands[key];
              if (!blockData.output) {
                blockData.output = { key, command };
              } else if (command.power > blockData.output.command.power) {
                blockData.output = { key, command };
              }
            });

            // clean up and `resolve` the promise with the data from the
            // block
            this.closeSession();
            this.ws.removeEventListener('message', commandHandler);
            resolve(blockData);
          }, blockTime);
        });
      });
  });
}
```

When `commandBlock` is called, a session is created via Cortex
(`createSession`) which begins a period of data acquisition from the
Emotiv BCI device. Then, `subscribe` is called to subscribe to the
mental command stream, which causes mental command events to begin
streaming over the websocket. Each of these events is processed and a
running total is kept for the cumulative power of each command. After a
predetermined amount of time (`blockTime`), the accumulated data is
processed to determine the final output command for the entire block,
which is passed back to the calling function by `resolve`-ing the
promise.

### Grid UI with [snap.svg](http://snapsvg.io/)

{{<figure
  src="/img/thesis/auth_interface.png"
>}}

``` javascript
createRandomPath(pathLength, xpoints, ypoints) {
  /* generate a random path of desired length with random start location.
     uses a 2d 'random walk' algorithm with the constraint that the path
     cannot go backward or overlap itself.  `xpoints` and `ypoints`
     determine the dimensions of the grid. */

  const moveOptions = {
    up   : [0, -1],
    down : [0, 1],
    left : [-1, 0],
    right: [1, 0],
  };

  const start = [Math.floor(Math.random() * this.xpoints),
                Math.floor(Math.random() * this.ypoints)];


  // keep track of moves made, visited and deadend nodes
  const moves = [];
  const visited  = [];
  const deadEnds = [];

  let currentNode = [...start];
  visited.push(currentNode);

  let steps = 0; // track the number of steps made
  while (steps < pathLength) {
    // check all `moveOptions`, filter only valid options
    const validOptions = [];
    for (const opt of Object.keys(moveOptions)) {
      // check each candidate move, add to `validOptions` if it is valid
      const option = moveOptions[opt];
      const candidateX = currentNode[0] + option[0];
      const candidateY = currentNode[1] + option[1];

      if (this.isValidNode(candidateX, candidateY, xpoints,
                           ypoints, visited, deadEnds))
      {
        validOptions.push([moveOptions[opt], opt]);
      }
    }

    if (validOptions.length > 0) {
      // if there are valid options, choose one at random
      const choice = Math.floor(Math.random() * validOptions.length);
      const move = validOptions[choice][0];
      // make the move
      currentNode = [currentNode[0] + move[0], currentNode[1] + move[1]];
      visited.push(currentNode);
      moves.push(validOptions[choice][1]);
      // now one step closer to the desired `pathLength`, so increment
      // `steps`
      steps++;
    } else {
      // if there are no valid options, it's a deadend. backtrack 1 step.
      // note the deadend so we don't end up here again.
      deadEnds.push(currentNode);
      visited.pop();
      output.moves.pop();
      currentNode = visited[visited.length - 1];
      // now one step further from desired `pathLength`, decrement `steps`
      steps--;
    }
  }

  const output = {start, moves}
  return output
}

isValidNode(x, y, xpoints, ypoints, visitedList, deadEnds) {
  /* Returns true if the node coordinates `x` and `y` do not lie outside
  the bounds of the grid and are not contained in `visitedList` or
  `deadEnds`.*/
  if (x < 0 || x > xpoints - 1) { return false; }
  if (y < 0 || y > ypoints - 1) { return false; }

  if (visitedList.some(node => (node[0] === x && node[1] === y))) {
    return false;
  }

  if (deadEnds && deadEnds.some(node => (node[0] === x && node[1] === y))) {
    return false;
  }

  return true;
}
```

## Results
## Reflection
