#!/usr/bin/env bash

echo "Building app..."

flutter build apk
cp ./build/app/outputs/flutter-apk/app-release.apk ./chartr-app.apk

echo "Done."