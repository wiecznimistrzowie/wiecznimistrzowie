---
name: read-slice
description: Read slice responsible for read action, ie action that handles a request to display data
---
Read slice building blocks are:

* query - a data structure named after the query it represents, eg. `ShowPerson::ByPersonId`, inherits from `Infra::Query` that uses `Literal` syntax for structs with types
* read model - a decider view pattern that handles projection logic from events to state
* endpoint - a roda endpoint to handle the action
* view - html in Phlex to display the data
* setup - register query in the query bus and specify which events needs to be loaded to build a state
* entites and value objects - if more complex data structure is needed to represent state built from the events, we can have multiple entities and or value objects classes; prefer simple `Data` over more complex solutions

For short streams that do not need complex queries (eg. sorting, or filtering) we can build projections in memory `Infra::EventSourcedQueryHandler`. Otherwise use materialized projection with catchup subscription and data stored in database in a format needed for a view. That would require separate migration first to prepare db table.