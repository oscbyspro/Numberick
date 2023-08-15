#!/bin/bash
#=-----------------------------------------------------------------------------=
# This source file is part of the Numberick open source project.
#
# Copyright (c) 2023 Oscar Byström Ericsson
# Licensed under Apache License, Version 2.0
#
# See http://www.apache.org/licenses/LICENSE-2.0 for license information.
#=-----------------------------------------------------------------------------=
# This script requires an orphaned gh-pages branch and the following structure:
#
# PROJECT/
# │
# ├─── .../
# │    │
# │    └─── SCRIPT.sh
# │
# └─── .../
#      │
#      └─── PROJECT.xcodescheme
#=-----------------------------------------------------------------------------=

set -eu

# Variables

PROJECT_NAME="Numberick"
XCODE_SCHEME_NAME=$PROJECT_NAME

PROJECT_PATH=$(dirname $(dirname $(realpath $0)))
CURRENT_COMMIT_HASH=$(git rev-parse --short HEAD)

# Variables x Environment

export DOCC_JSON_PRETTYPRINT="YES" # nondeterministic :(

# Actions

cd $PROJECT_PATH

xcodebuild docbuild \
-scheme $XCODE_SCHEME_NAME \
-derivedDataPath "docc" \
-destination 'generic/platform=iOS'

DOCC_ARCHIVE_PATH=$(find "docc" -name "$XCODE_SCHEME_NAME.doccarchive" | head -n 1)

git worktree add --checkout "gh-pages"

$(xcrun --find docc) process-archive transform-for-static-hosting $DOCC_ARCHIVE_PATH \
--output-path "gh-pages/docs" \
--hosting-base-path $PROJECT_NAME

rm -rf  docc
cd  gh-pages
git add docs
git commit -m "GitHub Pages. DocC. $CURRENT_COMMIT_HASH."
cd  ..
git worktree remove gh-pages
