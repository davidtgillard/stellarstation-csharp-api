#!/bin/bash

# This script generates 

# the versions of grpc tools and protobuf tools
GRPC_TOOLS_VERSION=2.32.0
PROTOBUF_TOOLS_VERSION=3.13.0

# names of executable files
PROTOC_EXEC_NAME=protoc
GRPC_CSHARP_PLUGIN_EXEC_NAME=grpc_csharp_plugin

# the nuget package root location
NUGET_PKG_ROOT=~/.nuget/packages

# echo to stderr 
function echo_err {
	1>&2 echo $1
}

function print_usage_and_exit {
	echo_err "Error: $1"
	echo_err "Usage: `basename $0` INPUT-PROTOBUF-PATH OUTPUT-PATH"
 	exit 1
}

# Set the platform. We assume x64.
if [[ "$OSTYPE" == "darwin"* ]]; then
	PLATFORM_DIR=macosx_x64
elif [[ "$OSTYPE" == "msys"* ]]; then
	PLATFORM_DIR=windows_x64
	# add .exe extension for windows
	PROTOC_EXEC_NAME=${PROTOC_EXEC_NAME}.exe
	GRPC_CSHARP_PLUGIN_EXEC_NAME=${GRPC_CSHARP_PLUGIN_EXEC_NAME}.exe
elif [[ "$OSTYPE" == "linux"* ]]; then
	PLATFORM_DIR=linux_x64
else
	echo_err "Unrecognized platform '$OSTYPE'" 
	exit 1
fi

# check that input and output paths are specified
if [[ -z $1 || -z $2 ]]; then
	print_usage_and_exit "input and output paths must be specified"
fi

# check that input path is a directory
if [[ ! -d $1 ]]; then
	print_usage_and_exit "The input path '$1' is not a directory"
fi

# check that output path is a directory
if [[ ! -d $2 ]]; then
	print_usage_and_exit "The input path '$2' is not a directory"
fi

# set up paths
GRPC_TOOLS_PATH=${NUGET_PKG_ROOT}/grpc.tools/${GRPC_TOOLS_VERSION}/tools/${PLATFORM_DIR}/
PROTO_PATH=${NUGET_PKG_ROOT}/google.protobuf.tools/${PROTOBUF_TOOLS_VERSION}/tools
# executables
PROTOC=${GRPC_TOOLS_PATH}/${PROTOC_EXEC_NAME}
GRPC_CSHARP_PLUGIN=${GRPC_TOOLS_PATH}/${GRPC_CSHARP_PLUGIN_EXEC_NAME}

$PROTOC \
	--proto_path=${PROTO_PATH} \
  --plugin=protoc-gen-grpc=${GRPC_CSHARP_PLUGIN} \
  -I${1} \
	--csharp_out $2 --grpc_out $2 \
	`find $1 \( ! -regex '.*/\..*' \) -type f -name *.proto`
