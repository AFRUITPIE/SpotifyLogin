#!/bin/bash

# **** Update me when new Xcode versions are released! ****
PLATFORM="platform=iOS Simulator,OS=12.0,name=iPhone 7"
SDK="iphonesimulator"


# It is pitch black.
set -e
function trap_handler() {
    echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
    echo "**** You have died ****"
    exit 255
}
trap trap_handler INT TERM EXIT


MODE="$1"

if [ "$MODE" = "framework" ]; then
    echo "Building and testing SpotifyLogin.framework."
    xcodebuild \
        -project SpotifyLogin.xcodeproj \
        -scheme SpotifyLogin \
        -sdk "$SDK" \
        -destination "$PLATFORM" \
        build test
    trap - EXIT
    exit 0
fi

if [ "$MODE" = "examples" ]; then
    echo "Building and testing all SpotifyLogin examples."

    for example in examples/*/; do
        echo "Building $example."
        pod install --project-directory=$example
        xcodebuild \
            -workspace "${example}Sample.xcworkspace" \
            -scheme Sample \
            -sdk "$SDK" \
            -destination "$PLATFORM" \
            build test
    done
    trap - EXIT
    exit 0
fi

echo "Unrecognised mode '$MODE'."
