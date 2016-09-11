# TimeTrackerBackend

A backend for a pretty basic (for now) Elm/Phoenix Single-Page-App.

## Development

To run it, this will maybe work?

```sh
mix deps.get
mix ecto.create
mix ecto.migrate
mix phoenix.server
```

## Security

NOTE: There is an `ec-secp521r1.pem` file in this repository.  This is the
keyfile for the JWT token signing.  If you use this as an example,
please-oh-please don't store this in your repo ok?
