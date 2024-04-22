import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_app/common/common.dart';

class FutureHelper {
  static Future<T?> buildShowDialog<T>({
    required BuildContext context,
    String? textTitle,
    String? textContent,
    required String textOnFalse,
    required String textOnTrue,
    void Function()? onFalsePressed,
    void Function()? onTruePressed,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: textTitle != null
              ? Text(textTitle, textAlign: TextAlign.center)
              : null,
          content: textContent != null
              ? Text(textContent, textAlign: TextAlign.center)
              : null,
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
      },
    );
  }

  static Future<T?> buildShowCupertinoDialog<T>({
    required BuildContext context,
    String? textTitle,
    String? textContent,
    required String textOnFalse,
    required String textOnTrue,
    void Function()? onFalsePressed,
    void Function()? onTruePressed,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: textTitle != null ? Text(textTitle) : null,
          content: textContent != null ? Text(textContent) : null,
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
      },
    );
  }

  static Future<T?> buildShowDialog1<T>({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowDialog<T>(
      context: context,
      textTitle: appLocalizations!.exitThisPageTitle,
      textContent: appLocalizations.exitThisPageContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitThisPageOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }

  static Future<T?> buildShowCupertinoDialog1<T>({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowCupertinoDialog<T>(
      context: context,
      textTitle: appLocalizations!.exitThisPageTitle,
      textContent: appLocalizations.exitThisPageContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitThisPageOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }

  static Future<T?> buildShowDialog1Auto<T>({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    const isWeb = kIsWeb;

    late final Future<T?> result;

    if (isAndroid) {
      result = buildShowDialog1<T>(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else if (isIos) {
      result = buildShowCupertinoDialog1<T>(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else if (isWeb) {
      result = buildShowDialog1<T>(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else {
      result = buildShowDialog1<T>(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    }

    return result;
  }
}
