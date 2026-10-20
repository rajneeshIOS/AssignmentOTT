# OTT Streaming App

## Overview
An OTT application built using Swift and UIKit that displays featured, trending, and recommended content and supports video playback.

## Requirements
- Xcode
- Swift
- iOS 26.5 or later

## Architecture
The project follows MVVM and uses three layers:

- **Presentation:** ViewControllers, ViewModels, and UI components
- **Domain:** Models, repository protocols, and use cases
- **Data:** Repository implementation and local JSON data source

## Features
- Home screen with hero banner and horizontal content rails
- Content detail screen
- Video playback using AVPlayer
- Play, pause, mute, and seek controls
- Player event logging
- Local JSON data using `home_content.json`

## Player Events
The `PlayerEvent` enum defines Ready, Started, Paused, Seeked, Completed, and Error events. `PlayerEventHandler` logs these events to the console.

## How to Run
1. Open `Assignment.xcodeproj` in Xcode.
2. Select an iOS Simulator or compatible device.
3. Build and run the app.

## Frameworks
UIKit, Foundation, AVKit, and AVFoundation.

## Limitations
Content is loaded from local mock JSON, and video playback depends on the configured video URLs.

