import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A professional, production-ready button that handles asynchronous operations
/// with an integrated loading state and customizable styling.
class TapLoaderButton extends StatefulWidget {
  /// The callback that is executed when the button is tapped.
  /// If this returns a [Future], the button automatically shows a loading
  /// indicator until the future completes.
  final FutureOr<void> Function()? onTap;

  /// Optional callback for when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// The text to display on the button.
  /// Used only if [child] is not provided.
  final String? text;

  /// A custom widget to display as the button's content.
  /// If provided, this overrides the [text] property.
  final Widget? child;

  /// The background color of the button.
  final Color? backgroundColor;

  /// The color of the loading indicator.
  /// Defaults to the text color if not provided.
  final Color? indicatorColor;

  /// The color of the text.
  final Color? textColor;

  /// The style of the text.
  final TextStyle? textStyle;

  /// The height of the button.
  final double? height;

  /// The width of the button.
  final double? width;

  /// The border radius of the button.
  final double borderRadius;

  /// The elevation of the button.
  final double elevation;

  /// The internal padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The size of the loading indicator.
  final double indicatorSize;

  /// A custom widget to display as the loading indicator.
  /// If not provided, a [CupertinoActivityIndicator] is used.
  final Widget? indicatorWidget;

  /// The duration of the transition animation between normal and loading states.
  final Duration animationDuration;

  /// The background color when the button is disabled.
  final Color? disabledBackgroundColor;

  /// The background color while the button is in the loading state.
  /// If null, it will use the [backgroundColor] or the theme's primary color.
  final Color? loadingBackgroundColor;

  /// Controls whether the button is enabled.
  /// If false, the button will be disabled regardless of the [onTap] value.
  final bool enabled;

  /// External control for the loading state.
  /// If provided, this value determines if the button stays in the loading state.
  final bool? isLoading;

  /// Whether to trigger haptic feedback when the button is tapped.
  final bool hapticFeedback;

  /// Creates a [TapLoaderButton].
  const TapLoaderButton({
    super.key,
    this.onTap,
    this.onLongPress,
    this.text,
    this.child,
    this.backgroundColor,
    this.indicatorColor,
    this.textColor,
    this.textStyle,
    this.height,
    this.width,
    this.borderRadius = 10.0,
    this.elevation = 0.0,
    this.padding,
    this.indicatorSize = 20.0,
    this.indicatorWidget,
    this.animationDuration = const Duration(milliseconds: 200),
    this.disabledBackgroundColor,
    this.loadingBackgroundColor,
    this.enabled = true,
    this.isLoading,
    this.hapticFeedback = true,
  }) : assert(text != null || child != null,
            'Either text or child must be provided');

  @override
  State<TapLoaderButton> createState() => _TapLoaderButtonState();
}

class _TapLoaderButtonState extends State<TapLoaderButton> {
  bool _internalIsLoading = false;

  bool get _isLoading => widget.isLoading ?? _internalIsLoading;

  Future<void> _handleTap() async {
    if (_isLoading || !widget.enabled || widget.onTap == null) return;

    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (widget.isLoading == null) {
      setState(() {
        _internalIsLoading = true;
      });
    }

    try {
      await widget.onTap!();
    } catch (e) {
      // Re-throw the error so it can be handled by the caller or global error handler,
      // but ensure we've stopped the loader if it was internal.
      rethrow;
    } finally {
      if (mounted && widget.isLoading == null) {
        setState(() {
          _internalIsLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActuallyEnabled = widget.enabled && widget.onTap != null;
    final isInteractable = isActuallyEnabled && !_isLoading;

    final Color effectiveBackgroundColor = _isLoading
        ? (widget.loadingBackgroundColor ??
            widget.backgroundColor ??
            theme.primaryColor)
        : (isActuallyEnabled
            ? (widget.backgroundColor ?? theme.primaryColor)
            : (widget.disabledBackgroundColor ?? theme.disabledColor));

    final Color effectiveTextColor = widget.textColor ??
        (ThemeData.estimateBrightnessForColor(effectiveBackgroundColor) ==
                Brightness.dark
            ? Colors.white
            : Colors.black);

    final widgetChild = widget.child ??
        Text(
          widget.text ?? '',
          style: widget.textStyle ??
              TextStyle(
                color: effectiveTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        );

    final indicator = widget.indicatorWidget ??
        CupertinoActivityIndicator(
          color: widget.indicatorColor ?? effectiveTextColor,
          radius: widget.indicatorSize / 2,
        );

    return Semantics(
      button: true,
      enabled: isInteractable,
      child: Container(
        height: widget.height ?? 50,
        width: widget.width,
        constraints: const BoxConstraints(minWidth: 88),
        child: ElevatedButton(
          onPressed: isInteractable ? _handleTap : null,
          onLongPress:
              isInteractable ? widget.onLongPress : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            disabledBackgroundColor: _isLoading
                ? effectiveBackgroundColor
                : (widget.disabledBackgroundColor ?? theme.disabledColor),
            foregroundColor: effectiveTextColor,
            disabledForegroundColor: effectiveTextColor.withValues(alpha: 0.6),
            elevation: isInteractable ? widget.elevation : 0,
            padding: widget.padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            splashFactory: NoSplash.splashFactory,
            animationDuration: widget.animationDuration,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.black.withValues(alpha: 0.05);
              }
              return null;
            }),
          ),
          child: AnimatedSwitcher(
            duration: widget.animationDuration,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _isLoading
                ? SizedBox(
                    key: const ValueKey('loader'),
                    height: widget.indicatorSize,
                    width: widget.indicatorSize,
                    child: indicator,
                  )
                : KeyedSubtree(
                    key: const ValueKey('content'),
                    child: widgetChild,
                  ),
          ),
        ),
      ),
    );
  }
}
