# CLAUDE.md

"Wieczni Mistrzowie" (Eternal Champions) is a tribute to sports people who passed away. It's basically a database of them with location of the grave for anyone who wants to visit them and show respect.

It's a side project to test, practice and develop some techniques, especially:

* building UI with Phlex and HTMX
* building custom Event Sourcing on top of Postgres with DCB support
* Decider pattern for business logic
* Sequel for handling database
* minitest library for testing
* Vertical Slices Architecture with feature directories
* Roda for HTTP routing
* Falcon for Web server 
* Literal for data structures and types

All on top of event modeling that happens in external tool and should be reflected in the project.

## Commands

```bash
# Run all tests and linter
bundle exec rake

# Run tests only
bundle exec rake test

# Run a single test file
bundle exec ruby -Itest path/to/test_file.rb

# Lint
bundle exec rake standard

# Start the server
bundle exec falcon serve
```

## Architecture

### Layers

- `infra/` — shared kernel: event store, buses, base classes, test helpers. All under the `Infra` namespace.
- `cms/` — domain. All under the `CMS` namespace. Features live in `cms/features/<feature_name>/`.

Both layers use Zeitwerk for autoloading via their respective `loader.rb` files.

### Feature structure

Each feature is self-contained and typically contains:

| File | Purpose |
|------|---------|
| `<command>.rb` | Command (inherits `Infra::Command` via `Literal::Data`) |
| `<event>.rb` | Domain event (inherits `Infra::DomainEvent`) |
| `decider.rb` | Business logic using `Decider.define` DSL |
| `setup.rb` | Wires the command/query handler into `Infra::Config` buses |
| `view.rb` | Phlex view component |
| `read_model.rb` | Event-sourced read model using `Decider::View.define` |
| `test_*.rb` | Tests (decider unit tests or integration tests) |

### Request flow (command)

1. Roda route calls `command_bus.call(SomeCommand.new(...))`
2. `CommandBus` dispatches to the registered `Infra::CommandHandler`
3. `CommandHandler` builds an `EventStore::Query` (filtered by event types + tag values, e.g. `person_id`), reads matching events, folds them through the decider's `evolve` to rebuild state, calls `decider.decide(command, state)` to get new events
4. New events are appended with an `AppendCondition` that enforces optimistic concurrency (fails if new events appeared after the read)

### Request flow (query)

1. Roda route calls `query_bus.call(SomeQuery.new(...))`
2. `QueryBus` dispatches to a registered handler — typically `Infra::EventSourcedQueryHandler`
3. `EventSourcedQueryHandler` reads matching events from the store and folds them through a `Decider::View` (read model) to produce the result

### Event store

Custom Postgres-backed implementation in `infra/event_store/`. Events are stored in a single `:events` table with columns: `sequence`, `event_id`, `event_type`, `data` (jsonb), `metadata` (jsonb). The `AppendCondition` provides DCB-style optimistic concurrency.

### Config

`Infra::Config` is a frozen `Data.define` singleton holding `command_bus`, `query_bus`, `event_store`, `db`, and `logger`. Feature `setup.rb` files register handlers against it at load time. Never instantiate a new config — always use `Infra::Config` directly.

### Testing

- **Decider unit tests** — inherit `Minitest::Test`, include `Infra::DeciderTestHelpers`, use `given([events]).when(command).then([expected_events])` DSL. No database required.
- **Integration tests** — inherit `Infra::IntegrationTest`, use Capybara against the full Roda app. Each test runs inside a database transaction that is always rolled back, so no cleanup is needed.

Test files follow the naming convention `test_*.rb` and are co-located with the feature code.
