import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_app/common/common.dart';

class FutureHelper {
  static Future<T?> buildShowAlertDialogText<T>({
    required BuildContext context,
    required String textTitle,
    required String textContent,
    required String textOnFalse,
    required String textOnTrue,
    void Function()? onFalsePressed,
    void Function()? onTruePressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        Widget alertDialog() {
          return AlertDialog(
            title: Text(textTitle, textAlign: TextAlign.center),
            content: Text(textContent, textAlign: TextAlign.center),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: onFalsePressed,
                child: Text(textOnFalse),
              ),
              TextButton(
                onPressed: onTruePressed,
                child: Text(textOnTrue),
              ),
            ],
          );
        }

        Widget cupertinoDialog() {
          return CupertinoAlertDialog(
            title: Text(textTitle),
            content: Text(textContent),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: onFalsePressed,
                child: Text(textOnFalse),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: onTruePressed,
                child: Text(textOnTrue),
              ),
            ],
          );
        }

        final isAndroid = Theme.of(context).platform == TargetPlatform.android;
        final isIos = Theme.of(context).platform == TargetPlatform.iOS;
        const isWeb = kIsWeb;

        late final Widget result;

        if (isAndroid) {
          result = alertDialog();
        } else if (isIos) {
          result = cupertinoDialog();
        } else if (isWeb) {
          result = alertDialog();
        } else {
          result = alertDialog();
        }

        return result;
      },
    );
  }

  static Future<T?> buildShowAlertDialogTextForExitPage<T>({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowAlertDialogText<T>(
      context: context,
      textTitle: appLocalizations!.exitThisPageTitle,
      textContent: appLocalizations.exitThisPageContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitThisPageOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }

  static Future<T?> buildShowAlertDialogTextForExitApp<T>({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowAlertDialogText<T>(
      context: context,
      textTitle: appLocalizations!.exitAppTitle,
      textContent: appLocalizations.exitAppContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitAppOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }
}
