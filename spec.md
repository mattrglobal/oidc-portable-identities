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
organization = "ConsenSys"
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

[TBD] I think we need to first describe the fundamental idea. The following bullets are intended to be a starting point.

* client sets up relationsship
* client sends standard OpenID COnnect authentication request
* OP authenticates end-user
* OP determines identifier types (and did methods) the client supports
* OP offers suitable identifiers to the end-user
* end-user picks identifier
* OP and end-user create proof of possession (Subject Identifier Assertion)
* OP creates id token and embedds subject identifier assertion
* OP responds to RP with id token
* RP validates id token
* RP validates subject identifier assertion
* RP uses portable identifier

// Diagrams for review

// TODO insert diagrams

# OP Metadata Extension {#op_metadata}

The following section outlines how an OpenID provider can use the following meta-data elements in its openid-configuration as defined in [@!OpenID-Discovery] to advertise the identifier types it supports, which especially includes metadata about portable subject identifiers.

sub\_id\_types\_supported
: OPTIONAL. A JSON array of strings. This metadata element describes the subject identifier types supported by the respective OP. This specification defines the following values:
* `jwkthumb`: the identifier constitutes the thumbprint of a JWK 
* `did`: the identifier constitutes a decentralized identifier as defined in [@!decentralized_identifiers]
* `op-bound`: the "classical" OpenID Connect identifier. The identifier is built by concatinating the `sub` value, created and maintained by the OP, and the OP's issuer URL.  
    
did\_methods\_supported
: OPTIONAL. A JSON array of strings used in conjunction with the identifier type `did`. This metadata element describes whether the client supports the resolution of [@!decentralized_identifiers] and further more which decentralized identifier methods. Each array value contains the DID method name as per [@!decentralized_identifiers]. A full enumeration of DID methods can be found in the "decentralized identifier method registry" (see [@!did_specs_registry]). 

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

sub\_id\_types\_supported
: OPTIONAL. An array of strings. This metadata element describes the subject identifier types supported by the registering client. Valid values MUST be a subset of those that the OP the client is registering with supports, which can be found in respective `sub_id_types_supported` metadata element.
    
did\_methods\_supported
: OPTIONAL. An array of strings. This metadata element describes whether the client supports the resolution (point to a definition of did resolution) of [@!decentralized_identifiers] and further more which decentralized identifier methods. Each array element contains the DID method name as per [@!decentralized_identifiers]. A full enumeration can be found in the "decentralized identifier method registry" (see [@!did_specs_registry]) the client supports. 

[TBD] is this element required if the did subject identifier type is supported?

# Subject Identifier Assertion {#subject_identifier_assertion}

The Subject Identifier Assertion represents to End-user's proof of possession of the key material corresponding to a cryptographically verifiable identifier. This assertion is embedded by the OP into the ID token provided to the RP in response for an OpenID Connect authentication request. 

This assertion MUST be of the form of a compact JWT.

The JWT contains the following claims:

iss
: issuer of the subject identifier assertion represented by the DID of the End-user.

[TBD] could this also be the identifier of an agent acting on behalf of the end-user?

sub
: the subject of the subject identifier assertion

[TBD] shouldn't this be the end user as well?

aud
: REQUIRED. the audience of the JWT represented by the client_id of the respective RP

nonce
: REQUIRED. the nonce as provided by the RP in the OpenID Connect request. This claims binds the subject identifier assertion to a particular transaction in orrder to prevent replay in a different transaction. 

iat
: iat. identifies the time when the subject identifier assertion was issued.

// TODO What claims need to be in this and what constraints should be applied

A non-normative example of the claims in a subject identifier assertion is shown in the following.

```json
{
    "iss": "did:example:12345",
    "sub": "https://issuer.com/",
    "aud": "s6BhdRkqt3",
    "nonce": "n-0S6_WzA2Mj",
    "iat": 1311280970
}
```

// Carefully consider what claims in the JWT for this assertion and their associated constraints i.e in reference to the id_token in which it will appear. 

// We should include a JWT header in the protected header that informs the consumer about the nature of the JWT? One option is to use the "typ" claim.
// Needs to be defined and registered. Doing this prevents the assertion from being used out of its intended designation i.e id_token being used as an access_token.

// Should the only required claims just be iss and nonce?

// We need a more systematic threat analysis there are multiple adversaries
// 1. A rouge OP
// 2. Man in the middle

// TODO define the validation logic

// signature algorthms including discovery (client needs to support alg)

# Cryptographic Subject Identifier ID Token Extension

This following section defines the additional (JWT) claims required to express the End-User as the subject of an id token through the use of a portable subject identifier.
    
sub\_id\_type
: OPTIONAL. Subject identifier type, this claim has a value which reports the type of subject identifier reported in the `sub` claim of the id token and therefore how to validate the `sub_ast` claim. For allowed values see (#op_metadata). 
    
sub\_ast
: REQUIRED. IF sub_id_type is not `op-bound`. Subject identifier assertion, this claim has a value that is of the form of a compact JWT (see (#subject_identifier_assertion)) which when validated prooves control of the subject identifier reported in the `sub` claim of the `id_token`. 

// TODO link to the subject identifier assertion section and validation logic

[TBD] check back with Mike re traditional OIDC identifiers

sub
: REQUIRED. Subject identifier - in case of portable identifiers (e.g. `sub_id_type` is `did`) a globally unique identifier who's type is defined by the `sub_id_type` claim in the id token and proof of control of the identifier can be established through validating the `sub_ast` claim in the same id token.
   
A non-normative example of the contents of an id token.

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
[TBD] add real sub ast example

## Additional ID Token Validation Steps

The RP first performs the Authentication Response Validation as defined in steps as defined [@!OpenID]. This ensures backward compabtibility and security since any OIDC RPs that will use the `sub` value without performing the additional steps defined below will use the `sub` value in conjuction with the OP's issuer URL only. 

In the next step, a portable identifier aware RP will perform the following checks:

A Relying Party processing an `id_token` that is making use of a portable subject identifier MUST employ the following additional validation steps beyond those defined in [Section 3.1.3.7](https://openid.net/specs/openid-connect-core-1_0.html#IDTokenValidation) of [@!OpenID].

// TODO validating the sub\_\st and its relationship to the sub value when sub\_id\_type is not the default ...?

# Subject Identifier Types

## JWK Thumbprint

TODO

## Decentralized Identifier

TODO

## Usecases

## Planned Provider Death

_An Identity Provider Going out of business_

Alice as a user of the web has been leveraging the standard technology of OpenID Connect to login to various websites (Relying Parties) using the federated login services provided by her chosen provider https://logmein.example. She becomes aware via communication from logmein.example that as a service provider they intend to stop offering the federated login services she has become reliant upon. Not wanting to loose the identity she has established with numerous websites (Relying Parties), Alice logs into https://logmein.example and clicks the "export identities" option available, resulting in her downloading a file to her local device. After careful research, Alice establishes that https://loginsareus.example is a suitable provider for her federated login services going forward, so she establishes a relationship with the provider and clicks the "import identities" option the provider has available, during this process she uploads the file she previously downloaded from her old login provider. Once the process is complete Alice is now able to use https://loginsareus.example to login to the same websites as before with no further interruption.

## Account Consolidation

_Consolidating accounts across multiple providers into one_

Bob as a user of the web has been leveraging the standard technology of OpenID Connect to login to various websites (Relying Parties), however due to a variety of different factors like differing sign up journey's across the different websites, Bob is using numerous providers across the different websites to "login". Bob feeling overwhelmed with the different login options he is greeted with every time he sees a login page, struggling to remember which provider he uses where, does some research to see whether he can simplify things. His research informs him of the capability to consolidate his accounts/identities back into a single provider, finding this option appealing he embarks on the process. Bob starts by logging into the providers he wishes to no longer use selecting the "export identities" option available, resulting in him downloading a file to his local device per provider. Once complete with the export process, Bob logs into the provider he has selected to be his only provider and clicks the "import identities" option the provider has available, during this process he uploads the file he previously downloaded from his old login providers. Once the process is complete Bob is now able to login to all the websites he was able to previously but instead having only to remember one provider.

## Implementation Considerations

### DID Methods

If a provider or relying party wishes to offer support for [@!decentralized_identifiers] as a valid form of portable subject identifier then one aspect of consideration is which DID methods to support. A DID method is the primary way in which different types of DID's are classified, the did method governs several key properties about the identifier including how the identifier is resolved and how changes to to the information associated to the identifier is controlled if applicable.

# Security Considerations

In traditional OpenID Connect the End-User that is authenticated by the provider during an OpenID Connect flow is referred to as the subject in the resulting `id_token` that is produced. Importantly the `sub` value that denotes an identifier for End-User MUST be processed in conjunction with the `iss` value as the End-Users identity is strictly tied to the providers domain. This limitation is what makes transferring an End-Users identity between providers difficult to achieve.

With portable subject identifiers the relationship between the End-User and the provider changes. 

{backmatter}

<reference anchor="OpenID" target="http://openid.net/specs/openid-connect-core-1_0.html">
  <front>
    <title>OpenID Connect Core 1.0 incorporating errata set 1</title>
    <author initials="N." surname="Sakimura" fullname="Nat Sakimura">
      <organization>NRI</organization>
    </author>
    <author initials="J." surname="Bradley" fullname="John Bradley">
      <organization>Ping Identity</organization>
    </author>
    <author initials="M." surname="Jones" fullname="Mike Jones">
      <organization>Microsoft</organization>
    </author>
    <author initials="B." surname="de Medeiros" fullname="Breno de Medeiros">
      <organization>Google</organization>
    </author>
    <author initials="C." surname="Mortimore" fullname="Chuck Mortimore">
      <organization>Salesforce</organization>
    </author>
   <date day="8" month="Nov" year="2014"/>
  </front>
</reference>

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