#!/bin/bash
set -e

APP=VanityCamera.app
BUNDLE=$APP/Contents

swift build -c release

rm -rf "$APP"
mkdir -p "$BUNDLE/MacOS"

cp .build/release/VanityCamera "$BUNDLE/MacOS/VanityCamera"
cp Info.plist "$BUNDLE/Info.plist"

echo "Built: $APP"
echo "Run:   open $APP"
