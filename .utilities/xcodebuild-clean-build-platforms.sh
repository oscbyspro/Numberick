#!/bin/bash
#=-----------------------------------------------------------------------------=
# This source file is part of the Numberick open source project.
#
# Copyright (c) 2023 Oscar Byström Ericsson
# Licensed under Apache License, Version 2.0
#
# See http://www.apache.org/licenses/LICENSE-2.0 for license information.
#=-----------------------------------------------------------------------------=
# This script requires the following structure:
#
# PROJECT/
# │
# ├─── DIRECTORY/
# │    │
# │    └─── SCRIPT.sh
# │
# └─── .swiftpm/xcode/xcshareddata/PROJECT.xcscheme
#=-----------------------------------------------------------------------------=

set -eu

# Variables

PROJECT_NAME="Numberick"
PROJECT_PATH=$(dirname $(dirname $(realpath $0)))
XCODE_SCHEME_NAME=$PROJECT_NAME

# Actions

cd $PROJECT_PATH

xcodebuild clean build \
-scheme $XCODE_SCHEME_NAME \
-destination "generic/platform=iOS" \
-destination "generic/platform=macOS" \
-destination "generic/platform=tvOS" \
-destination "generic/platform=watchOS"
