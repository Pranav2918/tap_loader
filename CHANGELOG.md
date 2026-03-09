## 1.1.0

* **Haptic Feedback**: Added support for light impact haptic feedback on tap.
* **External Loading Control**: Added `isLoading` property to allow parent widgets to control the loading state.
* **Long Press Support**: Added `onLongPress` callback.
* **Customization Enhancements**: 
    * Added `loadingBackgroundColor` for specific loading state styling.
    * Added `enabled` flag to programmatically disable the button.
    * Improved text styling and color estimation logic.
* **Accessibility**: Added `Semantics` support for better screen reader compatibility.
* **Bug Fixes**: Resolved issues where the button would stay in a loading state if the tap callback failed.

## 1.0.1

* Fixed repository & homepage links

## 1.0.0

* Initial release of `tap_loader`.
* Implemented `TapLoaderButton` with automatic async loading state.
* Added support for custom colors, loaders, and transitions.
* Provided comprehensive example app.
* Support for Android, iOS, Web, and Desktop.
