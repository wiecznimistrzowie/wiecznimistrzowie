# Wieczni Mistrzowie

This project follows fractal architecture, where we start from bounded context and each layer deep represents a smaller concept wrapped into a module. On a basic level we should expect two layers - bounded context (eg. `cms`) and feature (eg. `adding_person`) in `slices` directory. Unit that covers a single read or command action is called slice.

This projects base on event-sourcing with Dynamic Conistency Boundary (DCB), so instead of pushing or reading a specific stream of events, we define indices (called here tags) based on which we load events or check against race condidition when appending new events.

All events definition should be in the `events` directory under the bounded context directory. Single bounded context should not read/append directly events from another bounded context.

Tests are part of the slice. Decider test are unit tests that does not need db. Integration tests handles full request cycle and talks to db.

Each slice should be as independent from other slices as possible. It should be possible to remove whole slice directory without breaking other work. That impacts how we test - eg. we shouldn't check what is displayed after redirect that is handled by another slice. Just verify that redirect happens.

All terminal operations should be wrapped with mise, eg.:

* to run tests: `mise run test`
* to run db migrations: `mise run migrate:all`
* to run server: `mise run server`