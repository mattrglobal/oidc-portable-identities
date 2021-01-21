# OpenID Connect Portable Identities

[Latest Draft](https://mattrglobal.github.io/oidc-portable-identities/)

This repository is the home to a draft specification to extend an OpenID Connect Provider to support the notion of portable identities which
is essentially the capability for an end-user to maintain a consistent identity with a relying party whilst changing the underlying IDP.

## Contributing

The main specification is written in the markdown, however to preview the changes you have made in the final format, the following steps can be followed.

The tool `markdown2rfc` is used to convert the raw markdown representation to both an HTML and XML format. In order to run this tool you must have [docker](https://www.docker.com/) installed.

### Updating Docs

Update `spec.md` file with your desired changes.

Run the following to compile the new txt into the output HTML and XML.

```./scripts/build-html.sh```
