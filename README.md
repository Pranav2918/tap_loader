# tap_loader

A professional, production-ready Flutter package providing a customizable button that automatically handles loading states for asynchronous operations with smooth transitions and haptic feedback.

[![pub package](https://img.shields.io/pub/v/tap_loader.svg)](https://pub.dev/packages/tap_loader)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Automatic Loading State**: Handles `FutureOr` callbacks and shows a loader automatically during async execution.
- **Sync & Async Support**: Works seamlessly with both synchronous and asynchronous tap handlers.
- **Haptic Feedback**: Built-in support for light impact haptics to improve user experience.
- **Micro-Animations**: Smooth `AnimatedSwitcher` transitions between button content and the loader.
- **Highly Customizable**: Customize colors, text styles, border radius, loader type, and more.
- **External Control**: Support for external `isLoading` state management.
- **Double-Tap Prevention**: Automatically disables interactions while loading to prevent re-entrancy.
- **Accessibility**: Includes proper semantic labels for state changes.

## Demo

<p align="center">
  <img src="assets/demo.gif" width="800" alt="Tap Loader Demo" />
</p>

## Getting Started

Add `tap_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  tap_loader: ^1.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Simple Usage
The simplest way to use `tap_loader` is by providing a `text` and an `onTap` callback. It handles both `async` and `sync` functions.

```dart
TapLoaderButton(
  text: "Login",
  onTap: () async {
    // Perform async task like login API call
    await Future.delayed(Duration(seconds: 2));
  },
)
```

### Custom Styling
`TapLoaderButton` follows modern design standards (Material 3) by default.

```dart
TapLoaderButton(
  text: "Delete Account",
  backgroundColor: Colors.red,
  loadingBackgroundColor: Colors.red.shade900,
  textColor: Colors.white,
  borderRadius: 30,
  onTap: () async {
    await Future.delayed(Duration(seconds: 2));
  },
)
```

### External Control
You can control the loading state from your view model or parent widget.

```dart
TapLoaderButton(
  text: "Start Upload",
  isLoading: _isUploading, // Controlled externally
  onTap: () {
    setState(() => _isUploading = true);
    _manualUpload();
  },
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onTap` | `FutureOr<void> Function()?` | `null` | Callback triggered when tapped. Button loads during execution. |
| `onLongPress` | `VoidCallback?` | `null` | Optional callback for long-press gesture. |
| `text` | `String?` | `null` | Text to display (required if `child` is null). |
| `child` | `Widget?` | `null` | Custom widget for button content. |
| `backgroundColor` | `Color?` | `Theme.primaryColor` | Background color of the button. |
| `indicatorColor` | `Color?` | `Colors.white/black` | Color of the progress indicator. |
| `textColor` | `Color?` | `Colors.white/black` | Color of the text (ignored if `child` is used). |
| `borderRadius` | `double` | `10.0` | Radius of the button corners. |
| `elevation` | `double` | `0.0` | Shadow elevation. |
| `height` | `double?` | `50.0` | Button height. |
| `width` | `double?` | `null` | Button width. |
| `indicatorWidget`| `Widget?` | `CupertinoActivityIndicator` | Custom loader widget. |
| `indicatorSize` | `double` | `20.0` | Size of the loader indicator. |
| `isLoading` | `bool?` | `null` | Optional external loading control. |
| `enabled` | `bool` | `true` | Whether the button is interactable. |
| `hapticFeedback`| `bool` | `true` | Whether to trigger haptics on tap. |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
