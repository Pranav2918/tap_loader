import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A production-ready Flutter button that automatically shows a loading 
/// indicator during asynchronous tasks.
class TapLoaderButton extends StatefulWidget {
  /// The callback that is called when the button is tapped.
  /// If this callback returns a [Future], the button will show a loading 
  /// indicator until the future completes.
  final Future<void> Function()? onTap;

  /// The text to display on the button. Used if [child] is null.
  final String? text;

  /// A custom widget to display as the button's content.
  final Widget? child;

  /// The color of the button.
  final Color? buttonColor;

  /// The color of the loader.
  final Color? loaderColor;

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

  /// The padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The size of the loader.
  final double loaderSize;

  /// A custom loader widget to display instead of the default 
  /// [CupertinoActivityIndicator].
  final Widget? loaderWidget;

  /// The duration of the transition animation.
  final Duration animationDuration;

  /// The color of the button when it is disabled or loading.
  final Color? disabledColor;

  /// Creates a [TapLoaderButton].
  const TapLoaderButton({
    super.key,
    this.onTap,
    this.text,
    this.child,
    this.buttonColor,
    this.loaderColor,
    this.textColor,
    this.textStyle,
    this.height,
    this.width,
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.padding,
    this.loaderSize = 20.0,
    this.loaderWidget,
    this.animationDuration = const Duration(milliseconds: 300),
    this.disabledColor,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  @override
  State<TapLoaderButton> createState() => _TapLoaderButtonState();
}

class _TapLoaderButtonState extends State<TapLoaderButton> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading || widget.onTap == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onTap!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final bool isActuallyEnabled = widget.onTap != null;
    final bool isCurrentlyInteractable = isActuallyEnabled && !_isLoading;
    
    final Color effectiveButtonColor = isActuallyEnabled 
        ? (widget.buttonColor ?? theme.primaryColor)
        : (widget.disabledColor ?? theme.disabledColor);

    final Color effectiveTextColor = widget.textColor ?? 
        (ThemeData.estimateBrightnessForColor(effectiveButtonColor) == Brightness.dark 
            ? Colors.white 
            : Colors.black);

    final widgetChild = widget.child ?? Text(
      widget.text ?? '',
      style: widget.textStyle ?? TextStyle(
        color: effectiveTextColor,
        fontWeight: FontWeight.bold,
      ),
    );

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: isCurrentlyInteractable ? _handleTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveButtonColor,
          disabledBackgroundColor: _isLoading 
              ? effectiveButtonColor 
              : (widget.disabledColor ?? theme.disabledColor),
          elevation: isCurrentlyInteractable ? widget.elevation : 0,
          padding: widget.padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Always keep the primary content to maintain the button's size,
            // but fade it out when the loader is active.
            AnimatedOpacity(
              duration: widget.animationDuration,
              opacity: _isLoading ? 0.0 : 1.0,
              curve: Curves.easeInOut,
              child: widgetChild,
            ),
            
            // Show the loader on top of the invisible content.
            AnimatedSwitcher(
              duration: widget.animationDuration,
              child: _isLoading
                  ? SizedBox(
                      key: const ValueKey('loader'),
                      height: widget.loaderSize,
                      width: widget.loaderSize,
                      child: widget.loaderWidget ?? CupertinoActivityIndicator(
                        color: widget.loaderColor ?? effectiveTextColor,
                        radius: widget.loaderSize / 2,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    );
  }
}
