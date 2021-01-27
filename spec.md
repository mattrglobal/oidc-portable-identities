%%%
title = "OpenID Connect Portable Identities"
abbrev = "OpenID Connect Portable Identities"
ipr = "none"
workgroup = "none"
keyword = ["SSI", "OpenID Connect"]
#date = 2020-04-028T00:00:00Z

[seriesInfo]
name = "Individual-Draft"
value = "openid-portable-identities-01"
status = "standard"

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
[author.address]
    email = "torsten@lodderstedt.net"

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

This specification defines how an OpenID provider and client can be extended to support cryptographically verifiable subject identifiers that enable an End-User to easily transfer an identity from one provider to another.

{mainmatter}

# Introduction {#Introduction}

In the current deployments of OpenID Connect today the identity of the End-User obtained by a Relying Party (RP) during an OpenID transaction is bound to the OpenID Provider (OP). In technical terms this means, the RP needs to scope any subject value (the `sub` claim) with the issuer URL of the respective OP.

This scoping ensures uniqueness of user identities across all OPs and, furthermore, is a security mechanism against account takeover as it prevents OPs from asserting identities of other OP's user accounts. As a consequence, the End-Users identity with a RP is dependent on the OP continued existance and co-operation. This phenomena is what can be described as OP bound identity which makes porting an End-User's identity from one OP to another a complex task (see [@!OpenIDPorting] for a possible approach).

This specification takes a completely different angle by defining how an OpenID provider and client can be extended to support cryptographically verifiable subject identifiers that put the End-User in full control of the identity lifecycle. It especially enables an End-User to easily transfer an identity from one provider to another.

## Requirements Notation and Conventions

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 [@!RFC2119].

In the .txt version of this document, values are quoted to indicate that they are to be taken literally. When using these values in protocol messages, the quotes MUST NOT be used as part of the value. In the HTML version of this document, values to be taken literally are indicated by the use of this fixed-width font.

All uses of JSON Web Signature (JWS) [@RFC7515] and JSON Web Encryption (JWE) [@RFC7516] data structures in this specification utilize the JWS Compact Serialization or the JWE Compact Serialization; the JWS JSON Serialization and the JWE JSON Serialization are not used.

## Terminology {#Terminology}

This specification uses the terms defined in OpenID Connect Core 1.0; in addition, the following terms are also defined:

TODO

## Overview

Diagrams for review

TODO insert diagrams

# Provider Discovery Extension

The following section outlines how an OpenID provider can use the following meta-data elements in its openid-configuration as defined in [@!OpenID-Discovery] to advertise the identifier types it supports, which especially includes metadata about portable subject identifiers.

subject\_id\_types\_supported
: OPTIONAL. A JSON array of strings. This metadata element describes the subject identifier types supported by the respective OP. This specification defines the following values:
* `jwkthumb`: the identifier constitutes the thumbprint of a JWK 
* `did`: the identifier constitutes a decentralized identifier as defined in [@!decentralized_identifiers]
* `op-bound`: the "classical" OpenID Connect identifier. The identifier is built by concatinating the `sub` value, created and maintained by the OP, and the OP's issuer URL.  
    
did\_methods\_supported
: OPTIONAL. A JSON array of strings used in conjunction with the identifier type `did`. This metadata element describes whether the client supports the resolution of [@!decentralized_identifiers] and further more which decentralized identifier methods. A full enumeration of DID methods can be found in the "decentralized identifier method registry" (see [@!did_specs_registry]). 

[TBD] is this element required if the did subject identifier type is supported?

A non-normative extract from the OP Metadata depicting these elements

```json
{
    "subject_id_types": [
        "jwkthumb",
        "did",
        "op-bound"
    ],
    "did_methods_supported": [
        "elem",
        "ion",
        "sov",
        "v1"
    ]
}
```

# Client Metadata Extension

The following section outlines the additional metadata elements required for a client to express support for specific identifier types.

subject\_id\_types\_supported
: OPTIONAL. An array of strings. This metadata element describes the subject identifier types supported by the registering client. Valid values MUST be a subset of those that the OP the client is registering with supports, which can be found in respective `subject_id_types_supported` metadata element.
    
did\_methods\_supported
: OPTIONAL. An array of strings. This metadata element describes whether the client supports the resolution (point to a definition of did resolution) of [@!decentralized_identifiers] and further more which decentralized identifier methods (a full enumeration can be found in the "decentralized identifier method registry" (see [@!did_specs_registry]) the client supports. 

[TBD] is this element required if the did subject identifier type is supported?

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

{backmatter}

<reference anchor="OpenIDPorting" target="https://openid.net/specs/openid-connect-account-porting-1_0.html">
  <front>
    <title>OpenID Connect Account Porting</title>
    <author initials="J." surname="Manger" fullname="James Manger">
      <organization>Telstra</organization>
    </author>
    <author initials="T." surname="Lodderstedt" fullname="Torsten Lodderstedt">
      <organization>yes.com</organization>
    </author>
    <author initials="A." surname="Gleditsch" fullname="Arne Georg Gleditsch">
      <organization>Telenor</organization>
    </author>
   <date day="6" month="Mar" year="2017"/>
  </front>
</reference>

<reference anchor="OpenID-Discovery" target="https://openid.net/specs/openid-connect-discovery-1_0.html">
  <front>
    <title>OpenID Connect Discovery 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="E." surname="Jay" fullname="Edmund Jay">
      <organization> Illumila </organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

<reference anchor="decentralized_identifiers" target="https://w3c.github.io/did-core/">
  <front>
    <title>Decentralized Identifiers (DIDs) v1.0</title>
    <author>
      <organization>W3C</organization>
    </author>
    <date year="2021" month="01" day="26" />
  </front>
</reference>

<reference anchor="did_specs_registry" target="https://w3c.github.io/did-spec-registries/#did-methods">
  <front>
    <title>DID Specification Registries</title>
    <author>
      <organization>W3C</organization>
    </author>
    <date year="2021" month="01" day="25"/>
  </front>
</reference>