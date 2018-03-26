#!/usr/bin/env bash

rm -rf .build
vapor clean --verbose -y
rm Package.resolved
vapor xcode --verbose -y
