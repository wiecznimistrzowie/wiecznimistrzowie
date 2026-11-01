---
name: command-slice
description: Create slice responsible for command action, ie action that handles a request to change state
---
Command slice building blocks are:

* command - a data structure named after the action it represents, eg. `AddPerson`, inherits from `Infra::Command` that uses `Literal` syntax for structs with types
* decider - a decider pattern that handles the command and builds local state from events that is needed to make a decision
* endpoint - a roda endpoint to handle the action; if form is needed it also provides a get endpoint to render the form
* view - html form if needed build with Phlex
* setup - register command in the command bus and specify which events needs to be loaded to make a decision in the decider
* entites and value objects - if more complex data structure is needed to represent state built from the events, we can have multiple entities and or value objects classes; prefer simple `Data` over more complex solutions

