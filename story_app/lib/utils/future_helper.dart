import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/common/common.dart';

class FutureHelper {
  static Future<dynamic> buildShowDialog({
    required BuildContext context,
    String? textTitle,
    String? textContent,
    required String textOnFalse,
    required String textOnTrue,
    void Function()? onFalsePressed,
    void Function()? onTruePressed,
  }) {
    return showDialog(
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

  static Future<dynamic> buildShowCupertinoDialog({
    required BuildContext context,
    String? textTitle,
    String? textContent,
    required String textOnFalse,
    required String textOnTrue,
    void Function()? onFalsePressed,
    void Function()? onTruePressed,
  }) {
    return showCupertinoDialog(
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

  static Future<dynamic> buildShowDialog1({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowDialog(
      context: context,
      textTitle: appLocalizations!.exitThisPageTitle,
      textContent: appLocalizations.exitThisPageContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitThisPageOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }

  static Future<dynamic> buildShowCupertinoDialog1({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    return buildShowCupertinoDialog(
      context: context,
      textTitle: appLocalizations!.exitThisPageTitle,
      textContent: appLocalizations.exitThisPageContent,
      textOnFalse: appLocalizations.no,
      textOnTrue: appLocalizations.exitThisPageOnTrue,
      onFalsePressed: onFalsePressed,
      onTruePressed: onTruePressed,
    );
  }

  static Future<dynamic> buildShowDialog1Auto({
    required BuildContext context,
    required void Function() onFalsePressed,
    required void Function() onTruePressed,
  }) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    const isWeb = kIsWeb;

    late final Future<dynamic> result;

    if (isAndroid) {
      result = buildShowDialog1(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else if (isIos) {
      result = buildShowCupertinoDialog1(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else if (isWeb) {
      result = buildShowDialog1(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    } else {
      result = buildShowDialog1(
        context: context,
        onFalsePressed: onFalsePressed,
        onTruePressed: onTruePressed,
      );
    }

    return result;
  }
}