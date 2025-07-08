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

For development with auto-rebuild:
```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

## Architecture

### State Management
- **Framework**: Flutter Riverpod (v2.6.1) with AutoDisposeNotifierProvider
- **Pattern**: Controller-based architecture with immutable state
- **State Classes**: Located in `lib/state/` using Freezed for code generation

### Three-Layer Architecture with Riverpod
- **Controller Layer** (`lib/controllers/`): State management with `AutoDisposeNotifierProvider`
- **Service Layer** (`lib/applications/`): Business logic coordination with `AutoDisposeProvider`
- **Repository Layer** (`lib/data/repository/`): Data access and platform interactions with `AutoDisposeProvider`

#### Riverpod Dependency Chain
```dart
Controller (ref.watch) → Service (ref.watch) → Repository → Platform Resources
```

#### Provider Usage Patterns
- **ref.watch**: Used in build() methods to establish dependencies and ensure reactive updates
- **ref.read**: Used in event handlers for one-time value access without creating dependencies
- **AutoDisposeProvider**: Automatically releases resources when no longer needed
- **ref.onDispose**: Ensures proper cleanup of native resources (AudioPlayer, AudioRecorder, StreamSubscriptions)

### Key Components
- **AudioRecordController** (`lib/controllers/`): Core business logic managing recording/playback state
- **AudioRecordState** (`lib/state/`): Immutable state model with `isRecording`, `isPlaying`, `isLoading`, `completedAudioFilePath`
- **Widget Composition**: Separate widgets for recording controls and playback UI

### Audio Architecture
- **Recording**: Uses `record` package with platform-specific configurations and dynamic permission checking
- **Playback**: Uses `just_audio` with reactive stream-based state updates via `PlayerStateCallback`
- **File Management**: Saves WAV files with timestamp naming: `recording_${timestamp}.wav`
- **File Location**: Application documents directory via `path_provider`
- **Resource Management**: Automatic cleanup of `AudioPlayer`, `AudioRecorder`, and `StreamSubscription` instances

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
- Stream listeners for reactive audio player state updates via `PlayerStateCallback`
- Controller uses `ref.watch` in build() to establish service dependencies
- Event handlers use `ref.read` for one-time service access

### File Structure
```
lib/
├── applications/       # Service layer
│   ├── audio_recorder_service.dart         # Abstract interface
│   └── audio_recorder_service_impl.dart    # Concrete implementation
├── controllers/        # Business logic & state management
│   └── audio_record_controller.dart
├── data/               # Repository layer
│   └── repository/     # Audio recording/playbook repositories
│       ├── audio_player_repository.dart          # Abstract interface
│       ├── audio_player_repository_impl.dart     # Concrete implementation
│       ├── audio_recorder_repository.dart        # Abstract interface
│       └── audio_recorder_repository_impl.dart   # Concrete implementation
├── pages/              # Screen-level components  
│   └── audio_record_page.dart
├── state/              # State models & generated code
│   ├── audio_record_state.dart
│   └── audio_record_state.freezed.dart
├── widgets/            # Reusable UI components
│   ├── play_audio_widget.dart
│   └── recording_button_widget.dart
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

### TDD Development Workflow
1. **Red**: Write failing tests that enforce new desired behavior
2. **Green**: Write minimal code to pass tests
3. **Refactor**: Improve code while maintaining passing tests
4. **Commit**: Only when all tests pass

### Test Structure
```
test/
├── unit/
│   ├── controllers/     # Test state management and business logic
│   ├── services/        # Test service coordination
│   ├── repositories/    # Test data access and platform interactions
│   └── state/          # Test state models
├── widget/             # Test UI components
└── integration/        # Test complete user workflows
```

### Testing Principles
- Test user behavior, not implementation details
- Focus on component inputs/outputs and user-visible results
- Use semantic queries (role, text) rather than CSS selectors
- Test complete workflows including proper parameter passing
- Verify side effects and state changes
- Files should not exceed 300 lines
- If code is difficult to test, refactor to improve testability

## Known Technical Debt
Based on code comments in `AudioRecordController`:
- [ ] Separate PlaybackService and FileService from Controller
- [ ] Enhanced error handling with error state in AudioRecordState
- [ ] Extended state model (playback progress, recording duration)
- [ ] Add comprehensive test coverage following TDD principles

## Resource Management
### AutoDisposeProvider Cleanup Chain
1. **User leaves page** → AutoDisposeProvider detects no usage
2. **ref.onDispose triggered** → Calls repository.dispose()
3. **Repository cleanup** → Cancels StreamSubscriptions, clears callbacks
4. **Native resource disposal** → AudioPlayer.dispose(), AudioRecorder.dispose()
5. **Memory fully released** → No resource leaks

### Critical Resource Management
- **StreamSubscription**: Must be stored and cancelled in dispose() to prevent memory leaks
- **AudioPlayer**: Holds native audio resources, requires explicit disposal
- **AudioRecorder**: Locks microphone access, must be disposed to release for other apps
- **PlayerStateCallback**: Cleared in dispose() to prevent null reference exceptions