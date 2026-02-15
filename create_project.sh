#!/bin/bash

# Create a new Xcode project programmatically
PROJECT_DIR="$PWD"
PROJECT_NAME="Aisland"

# Use swift package init for a macOS app
swift package init --type executable --name "$PROJECT_NAME"

# Clean up default files
rm -rf Sources Tests Package.swift

# Create proper Xcode project using xcodegen or manually
# Since xcodegen might not be installed, we'll use a different approach

