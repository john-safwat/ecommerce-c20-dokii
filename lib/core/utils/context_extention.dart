import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'dialog_utils.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;

  void showLoadingDialog({
    String message = 'Loading ...',
    bool barrierDismissible = false,
  }) {
    final dialogUtils = DialogUtils();
    dialogUtils.showLoadingDialog(
      this,
      message: message,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> showActionDialog({
    String? message,
    String? title,
    String? postActionTitle,
    Future<void> Function()? postAction,
    String? negativeActionTitle,
    Future<void> Function()? negativeAction,
    bool barrierDismissible = false,
  }) async {
    final dialogUtils = DialogUtils();
    await dialogUtils.showActionDialog(
      this,
      message: message,
      title: title,
      postActionTitle: postActionTitle,
      postAction: postAction,
      negativeActionTitle: negativeActionTitle,
      negativeAction: negativeAction,
      barrierDismissible: barrierDismissible,
    );
  }
}
