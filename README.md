# stellarstation-csharp-api

Example project of how to create C# bindings from gRPC protobuf spec for the [stellarstation API](https://github.com/infostellarinc/stellarstation-api).

Simply run the provided `build_proto.sh` script, with the path to the protobuf spec provided in API as the first argument, and the path to the folder to which the resulting C# source code will be written as the second argument. E.g.

```
./build_proto.sh  SOME-PATH/stellarstation-api.git/api/src/main/proto/ stellarstation-csharp-api
```
