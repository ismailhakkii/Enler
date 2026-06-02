import 'package:flutter/material.dart';

/// Convenience extensions on [BuildContext] for quick access to
/// theme data, media query, and (later) localizations.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  // TODO(l10n): Uncomment after running `flutter gen-l10n`
  // AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Shows a themed snack bar with the given [message].
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

/// Convenience extensions on [String] for common validations.
extension StringX on String {
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidUsername => RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(this);
}
