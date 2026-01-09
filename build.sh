#!/bin/bash
mkdir -p dist

TARGET=${1:-all}
SOURCE_FILE=${2:-main.go}
APP_NAME="atlassian-confluence-dc-go-mcp"

echo "Using source: $SOURCE_FILE"

build_linux_amd64() {
    echo "Building for Linux AMD64..."
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-linux-amd64 $SOURCE_FILE
}

build_linux_arm64() {
    echo "Building for Linux ARM64..."
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-linux-arm64 $SOURCE_FILE
}

build_windows_amd64() {
    echo "Building for Windows AMD64..."
    CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-windows-amd64.exe $SOURCE_FILE
}

build_windows_arm64() {
    echo "Building for Windows ARM64..."
    CGO_ENABLED=0 GOOS=windows GOARCH=arm64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-windows-arm64.exe $SOURCE_FILE
}

build_macos_arm64() {
    echo "Building for macOS Apple Silicon (ARM64)..."
    CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-macos-arm64 $SOURCE_FILE
}

build_macos_amd64() {
    echo "Building for macOS Intel (AMD64)..."
    CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -trimpath -ldflags "-s -w" -o dist/${APP_NAME}-macos-amd64 $SOURCE_FILE
}

case $TARGET in
    linux-amd64) build_linux_amd64 ;;
    linux-arm64) build_linux_arm64 ;;
    windows-amd64) build_windows_amd64 ;;
    windows-arm64) build_windows_arm64 ;;
    macos-arm64) build_macos_arm64 ;;
    macos-amd64) build_macos_amd64 ;;
    all)
        build_linux_amd64
        build_linux_arm64
        build_windows_amd64
        build_windows_arm64
        build_macos_arm64
        build_macos_amd64
        ;;
    *)
        echo "Unknown target: $TARGET"
        echo "Available targets: linux-amd64, linux-arm64, windows-amd64, windows-arm64, macos-arm64, macos-amd64, all"
        exit 1
        ;;
esac

echo "Build complete! Files are in the 'dist' folder."
