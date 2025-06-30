# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter audio recording proof-of-concept application built with Riverpod state management. The app provides audio recording and playback functionality with a clean, modular architecture.

## Development Commands

### Essential Commands
- **Run the app**: `flutter run`
- **Build for release**: `flutter build apk` (Android) or `flutter build ios` (iOS)
- **Install dependencies**: `flutter pub get`
- **Generate code** (for Freezed models): `flutter packages pub run build_runner build --delete-conflicting-outputs`
- **Run tests**: `flutter test`
- **Check for issues**: `flutter analyze`
- **Format code**: `flutter format .`

### Additional Development Tools  
- **Clean build**: `flutter clean && flutter pub get`
- **Dependency updates**: `flutter pub upgrade`
- **Profile performance**: `flutter run --profile`
- **Hot reload**: Press `r` in terminal while running
- **Hot restart**: Press `R` in terminal while running

### Code Generation
The project uses Freezed for immutable state classes. After modifying any `@freezed` classes in `lib/state/`, run:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Architecture

### State Management
- **Framework**: Flutter Riverpod (v2.6.1) with AutoDisposeNotifierProvider
- **Pattern**: Controller-based architecture with immutable state
- **State Classes**: Located in `lib/state/` using Freezed for code generation

### Service Layer Architecture
- **AudioRecorderServiceImpl** (`lib/applications/`): Abstract interface defining audio operations contract
- **AudioRecorderService** (`lib/applications/`): Concrete implementation of recording/playback logic
- **Dependency Injection**: Uses `audioRecorderServiceProvider` for service layer access
- **Separation of Concerns**: Controllers handle state, Services handle audio operations

### Key Components
- **AudioRecordController** (`lib/controllers/`): Core business logic managing recording/playback state
- **AudioRecordState** (`lib/state/`): Immutable state model with `isRecording`, `isPlaying`, `isLoading`, `completedAudioFilePath`
- **Widget Composition**: Separate widgets for recording controls and playback UI

### Audio Architecture
- **Recording**: Uses `record` package with platform-specific configurations
- **Playback**: Uses `just_audio` with reactive stream-based state updates
- **File Management**: Saves WAV files to application documents directory

## Key Dependencies
- `flutter_riverpod` (^2.6.1) - State management
- `record` (^6.0.0) - Audio recording
- `just_audio` (^0.10.4) - Audio playback
- `freezed` (^2.4.5) - Immutable class generation
- `path_provider` (^2.1.5) - File system access
- `build_runner` (^2.4.6) - Code generation tool
- `json_serializable` (^6.7.1) - Serialization support

## Development Patterns

### Widget Architecture
- Extend `ConsumerWidget` for Riverpod integration
- Use `ref.watch().select()` for selective rebuilds
- Isolate UI logic in specialized widgets (`RecordingButtonWidget`, `PlayAudioWidget`)

### State Updates
- All state changes through `copyWith()` methods
- Use try-catch blocks with state rollback on errors
- Stream listeners for reactive audio player state updates

### File Structure
```
lib/
├── applications/       # Service layer with abstractions
│   ├── audio_recorder_service.dart         # Concrete implementation
│   └── audio_recorder_service_impl.dart    # Abstract interface
├── controllers/        # Business logic & state management
├── pages/              # Screen-level components  
├── state/              # State models & generated code
├── widgets/            # Reusable UI components
└── main.dart           # App entry point
```

## Platform Support
Configured for Android, iOS, macOS, Linux, Windows, and Web with microphone permissions setup for audio recording functionality.

### Platform Permissions
#### Android (`android/app/src/main/AndroidManifest.xml`)
- `RECORD_AUDIO` - Required for microphone access
- `MODIFY_AUDIO_SETTINGS` - Optional for Bluetooth audio device support  
- `WRITE_EXTERNAL_STORAGE` - Optional for external storage access

#### iOS (`ios/Runner/Info.plist`)
- `NSMicrophoneUsageDescription` - Required microphone usage description

## Testing Strategy
⚠️ **Current Status**: No test files found in codebase

### Recommended Test Structure
```
test/
├── unit/
│   ├── controllers/
│   ├── services/
│   └── state/
├── widget/
└── integration/
```

## Known Technical Debt
Based on code comments in `AudioRecordController`:
- [ ] Separate PlaybackService and FileService from Controller
- [ ] Add proper resource disposal (dispose method)  
- [ ] Enhanced error handling with error state
- [ ] Unique filename generation with timestamps
- [ ] Extended state model (playback progress, recording duration)
- [ ] Interface abstractions for better testability