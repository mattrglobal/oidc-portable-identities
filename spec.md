%%%
title = "OpenID Connect Portable Identities"
abbrev = "OpenID Connect Portable Identities"
ipr = "none"
workgroup = "none"
keyword = [""]
#date = 2020-04-028T00:00:00Z

[seriesInfo]
name = "Individual-Draft"
value = "openid-portable-identities-01"
status = "informational"

[[author]]
initials = "T."
surname = "Looker"
fullname = "Tobias Looker"
#role = "editor"
organization = "MATTR"

[[author]]
initials = "T."
surname = "Lodderstedt"
fullname = "Torsten Lodderstedt"
#role = "editor"
organization = "yes.com"

[[author]]
initials = "K."
surname = "Yasuda"
fullname = "Kristina Yasuda"
#role = "editor"
organization = "Microsoft"

[[author]]
initials = "O."
surname = "Terbu"
fullname = "Oliver Terbu"
#role = "editor"
organization = "Consensys"
%%%

.# Abstract

OpenID Connect is a simple identity layer on top of the OAuth 2.0 protocol. It enables relying parties to verify the identity of the End-User based on the authentication performed by an Authorization Server, as well as to obtain basic profile information about the End-User.

In the current deployments of OpenID Connect today the identity of the End-User obtained by a relying party during an OpenID transaction is bound to the provider, meaning the End-Users identity with a relying party is dependent on the provider continued existance and co-operation. This phenomena is what can be described as provider bound identity which prevents an End-User from easily porting their identity from one provider to another.

{mainmatter}

# Introduction {#Introduction}

OpenID Connect is a simple identity layer on top of the OAuth 2.0 protocol. It enables relying parties to verify the identity of the End-User based on the authentication performed by an Authorization Server, as well as to obtain basic profile information about the End-User.

In the current deployments of OpenID Connect today the identity of the End-User obtained by a relying party during an OpenID transaction is bound to the provider, meaning the End-Users identity with a relying party is dependent on the provider continued existance and co-operation. This phenomena is what can be described as provider bound identity which prevents an End-User from easily porting their identity from one provider to another.

This specification defines how an OpenID provider and client can be extended to support cryptographically verifiable subject identifiers that enable an End-User to easily transfer an identity from one provider to another.

This specification defines how an OpenID provider can be extened to support portable identities that leverage asymmetric cryptography to allow an End-User to transfer an identity from one provider to another.

## Requirements Notation and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 `@!RFC2119`.

In the .txt version of this document, values are quoted to indicate that they are to be taken literally. When using these values in protocol messages, the quotes MUST NOT be used as part of the value. In the HTML version of this document, values to be taken literally are indicated by the use of this fixed-width font.

All uses of JSON Web Signature (JWS) [JWS](https://tools.ietf.org/html/rfc7515) and JSON Web Encryption (JWE) [JWE](https://tools.ietf.org/html/rfc7516) data structures in this specification utilize the JWS Compact Serialization or the JWE Compact Serialization; the JWS JSON Serialization and the JWE JSON Serialization are not used.

## Terminology {#Terminology}

This specification uses the terms defined in OpenID Connect Core 1.0; in addition, the following terms are also defined:

TODO

## Overview

Diagrams for review

TODO insert diagrams

# Client Metadata Extension

The following section outlines the additional metadata elements required for a client to express support to a provider for portable subject identifiers.

subject\_id\_types\_supported
: OPTIONAL. An array of strings. This metadata element describes the subject identifier types supported by the registering client. Valid values SHOULD be a subset of those that the provider the client is registering supports which can be found via the subject_id_types_supported discovery element.
    
did\_methods\_supported
: OPTIONAL. An array of strings. This metadata element describes whether the client supports the resolution (point to a definition of did resolution) of [decentralized identifiers](https://w3c.github.io/did-core/) and further more which decentralized identifier methods (a full enumeration can be found in the [decentralized identifier method registry](https://w3c.github.io/did-spec-registries/#did-methods)) the client supports. Providers SHOULD interpret omission of this element from the clients registered metadata as the client not supporting decentralized identifiers.

# Provider Discovery Extension

The following section outlines how an OpenID provider can use the following meta-data elements to advertise its support for portable subject identifiers in its openid-configuration defined by [OpenID-Discovery](https://openid.net/specs/openid-connect-discovery-1_0.html).

subject\_id\_types\_supported
: OPTIONAL. A JSON array of strings. This metadata element describes the subject identifier types supported by the registering client. Valid values SHOULD be a subset of those that the provider the client is registering supports which can be found via the subject_id_types_supported discovery element.
    
did\_methods\_supported
: OPTIONAL. A JSON array of strings. This metadata element describes whether the client supports the resolution of [decentralized identifiers]() and further more which decentralized identifier methods (a full enumeration can be found in the decentralized identifier method registry) the client supports. Providers SHOULD interpret omission of this element from the clients registered metadata as the client not supporting decentralized identifiers.

A non-normative extract from the Client Metadata depicting these elements

```json
{
    "subject_id_types": [
        "jwkthumb",
        "did"
    ],
    "did_methods_supported": [
        "elem",
        "ion",
        "sov",
        "v1"
    ]
}
```

Torsten 
1. Do we need existing identifier values for the existing subject identifier type?

# Subject Identifier Assertion

This assertion MUST be of the form of a compact JWT

// TODO What claims need to be in this and what constraints should be applied

A non-normative example of the request.

```json
{
    "iss": "did:example:12345",
    "sub": "https://issuer.com/",
    "aud": "https://client.example.org/cb",
    "nonce": "n-0S6_WzA2Mj",
    "iat": 1311280970
}
```

Carefully consider what claims in the JWT for this assertion and their associated constraints i.e in reference to the id_token in which it will appear. 

We should include a JWT header in the protected header that informs the consumer about the nature of the JWT? One option is to use the "typ" claim.
Needs to be defined and registered. Doing this prevents the assertion from being used out of its intended designation i.e id_token being used as an access_token.

Should the only required claims just be iss and nonce?

We need a more systematic threat analysis there are multiple adversaries
1. A rouge OP
2. Man in the middle

// TODO define the validation logic

# Cryptographic Subject Identifier ID Token Extension

This following section defines the additional (JWT) claims required to express the End-User as the subject of an `id_token` through the use of a portable subject identifier.
    
sub\_id\_type
: OPTIONAL. Subject identifier type, this claim has a value which reports the type of subject identifier reported in the `sub` claim of the `id_token` and therefore how to validate the `sub_ast` claim. 
    
sub\_ast
: REQUIRED. IF sub_id_type is not ...??? (Ask mike) Subject identifier assertion, this claim has a value that is of the form of a compact JWT which when validated prooves control of the subject identifier reported in the `sub` claim of the `id_token`. // TODO link to the subject identifier assertion section and validation logic

sub
: REQUIRED. Subject identifier a globally unique identifier who's type is defined by the `sub_id_type` claim in the `id_token` and proof of control of the identifier can be established through validating the `sub_ast` claim in the `id_token`.
   
A non-normative example of the request.

```json
{
    "iss": "https://issuer.com/",
    "sub": "did:example:12345",
    "sub_id_type": "did",
    "sub_ast": "<jwt-prooving-control-of-sub>",
    "aud": "https://client.example.org/cb",
    "nonce": "n-0S6_WzA2Mj",
    "exp": 1311281970,
    "iat": 1311280970
}
```

## Additional ID Token Validation Steps

Start with what happens for a conventional RP that doesn't not support portable identifiers ..?

A Relying Party processing an `id_token` that is making use of a portable subject identifier MUST employ the following additional validation steps beyond those defined in [Section 3.1.3.7](https://openid.net/specs/openid-connect-core-1_0.html#IDTokenValidation) of OpenID Connect Core.

// TODO validating the sub\_\st and its relationship to the sub value when sub\_id\_type is not the default ...?

# Subject Identifier Types

## JWK Thumbprint

TODO

## Decentralized Identifier

TODO

# Security Considerations

In traditional OpenID Connect the End-User that is authenticated by the provider during an OpenID Connect flow is referred to as the subject in the resulting `id_token` that is produced. Importantly the `sub` value that denotes an identifier for End-User MUST be processed in conjunction with the `iss` value as the End-Users identity is strictly tied to the providers domain. This limitation is what makes transferring an End-Users identity between providers difficult to achieve.

With portable subject identifiers the relationship between the End-User and the provider changes. 

