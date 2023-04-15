# Shared Library

This library contains all code that is relevant for both, client and server.

## Content

- `Protocol`: Includes types related to the communication protocol between the server and clients, such as messages, actions, updates, and errors.
- `Utilities`: Contains helper functions and extensions used throughout the game, such as vector operations, calculations, and other utility methods.

### Protocol

Here we got different files to sepearte logical concerns:

- `protocol.swift`: Holds the basic protocol types, such as `ProtocolMsg` and `ProtoMessageTyp`
- `client-server.swift`: Contains all types that are used by the client to communicate with the server. (`ProtoDirection`, ...)
- `server-client.swift`: Includes all types that are used by the server to send data to the client. (`ProtoGameState`, ...)
- `error.swift`: Holds all types that are used for error handling.
