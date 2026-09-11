# Wieczni Mistrzowie

## Setup

App is using four db users:

* `postgres` - superuser to create dbs and schemas
* `wm` - main app user
* `rodauth` - user for rodauth actions in rodauth schema
* `rodauth_password` - user to maintain passwords table and function allowing to verify passwords in rodauth_password schema

### Create db users

```bash
$ createuser -U postgres wm
$ createuser -U postgres rodauth
$ createuser -U postgres rodauth_password
```

### Create dbs

```bash
$ createdb -U postgres -O wm wm-dev
$ createdb -U postgres -O wm wm-test
```

### Run migration for superuser

```bash
$ sequel -m db/migrations/superuser/ postgres://postgres.../wm-dev?sslmode=disable
$ sequel -m db/migrations/superuser/ postgres://postgres.../wm-test?sslmode=disable
```

## Stack

* [Decider](https://github.com/jandudulski/decider) - decider DSL
* [En57](https://github.com/mostlyobvious/en57) - Event Store
* [Falcon](https://socketry.github.io/falcon/) - web server
* [Minitest](https://docs.seattlerb.org/minitest/) - testing framework
* [Mise](https://mise.jdx.dev/) - env setup
* [Phlex](https://www.phlex.fun/) - views framework
* [Postgres](https://postgresql.org/) - database
* [Roda](https://roda.jeremyevans.net/) - web routing
* [Rodauth](https://rodauth.jeremyevans.net/) - authentication framework
* [Sequel](https://sequel.jeremyevans.net/) - DSL and ORM for database
