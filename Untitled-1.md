
![](https://i.imgur.com/zzsrL3Q.png)

![](https://i.imgur.com/VKkRq2a.png)

Kristina
1. What is the recommended practises around key rotation which transfering subject identifiers between providers? Tobias - I can add some text around how I think key rotation will potentially occur.

![](https://i.imgur.com/2tPVe9I.png)

--------------------------------------------------

### Outstanding questions

1. Client Registration new metadata element of subject_id_types which is an array of subject identifier types that the client supports. <- Torsten to contribute

2. Kristina could we drop support for jwk thumbprint and instead just have support for dids for now? With an extension point for other identifier types in future?

Torsten two questions about request elements
- First question what are the semantics of the request is it the RP saying I want this or I support this.
- How is this expressed e.g in the request or as a part of registration?

Torsten Comments
- subject_id_types should be in client registration
- Undecided on whether subject_id_types semantic implies the RP saying I MUST get back a portable identities vs I support portable identities
- OP should also advertise its support portable identifiers.
- RP should do provider discovery before making a request to an OP requesting a portable identifier.

- Is there a reason for a relying party to ask for portable subject identifier vs expressing support for portable subject identifiers?


- What do the RP and OP need to negotiate on
    - Whether each party supports portable identities
    - What types of portable subject identifiers each party supports e.g jwk thumb vs did
    - For DIDs what did methods each party supports
    - What crypto algorithms each party supports for asserting control of the subject identifier