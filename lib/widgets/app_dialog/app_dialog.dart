import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

mixin AppDialogWidget {
  final MyStyleConfig _styleConfig = MyStyleConfig.instance;
  final MyTextStyle _textStyle = MyTextStyle.instance;

  Future<dynamic> showConfirmDialog(
    BuildContext context, {
    Widget? title,
    Widget? content,
    Color? titleTextColor,
    Color? contentTextColor,
    String? textCancelButton,
    String? textContinueButton,
    void Function()? onCancelButtonPressed,
    void Function()? onContinueButtonPressed,
  }) {
    final al = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          titlePadding: EdgeInsets.fromLTRB(
            _styleConfig.largePadding,
            _styleConfig.largePadding,
            _styleConfig.largePadding,
            _styleConfig.tinyPadding,
          ),
          contentPadding: EdgeInsets.fromLTRB(
            _styleConfig.largePadding,
            _styleConfig.largePadding,
            _styleConfig.largePadding,
            _styleConfig.tinyPadding,
          ),
          title: title,
          content: content,
          actions: [
            TextButton(
              onPressed: onCancelButtonPressed,
              child: Text(
                textCancelButton ?? al!.cancel,
                style: _textStyle.bodyMedium.apply(
                  color: _styleConfig.blackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: onContinueButtonPressed,
              child: Text(
                textContinueButton ?? al!.continueStep,
                style: _textStyle.bodyMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showErrorDialog(
    BuildContext context, {
    required String title,
    required String content,
    List<Widget>? actions,
  }) {
    final al = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          actionsPadding: const EdgeInsets.all(8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: Column(
            children: [
              Image.asset(
                'assets/images/cross.webp',
                width: 52,
                height: 52,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: _textStyle.headline1,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                textAlign: TextAlign.center,
                style: _textStyle.bodyMedium,
              ),
            ],
          ),
          actions: actions ??
              [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _styleConfig.primaryColor,
                        ),
                        child: Text(al!.close),
                      ),
                    ),
                  ],
                ),
              ],
        );
      },
    );
  }

  Future<dynamic> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String content,
    List<Widget>? actions,
  }) {
    final al = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 16),
          actionsPadding: const EdgeInsets.all(8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: Column(
            children: [
              Image.asset(
                'assets/images/check.webp',
                width: 52,
                height: 52,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: _textStyle.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                style: _textStyle.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: actions ??
              [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        child: Text(al!.close),
                      ),
                    ),
                  ],
                ),
              ],
        );
      },
    );
  }
}
