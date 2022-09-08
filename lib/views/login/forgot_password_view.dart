import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  final _emailKey = GlobalKey<FormFieldState>();

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: styleConfig.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/images/forgot_password.webp',
                    height: 200,
                    width: 200,
                  ),
                ),
                Text(
                  al!.forgot_password,
                  style: textStyle.headline,
                ),
                SizedBox(height: styleConfig.smallPadding),
                Text(
                  al.dontWorryForgotPassword,
                  style: textStyle.body,
                ),
                SizedBox(height: styleConfig.smallPadding),
                Row(
                  children: [
                    const Icon(Icons.alternate_email_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: _emailKey,
                        decoration: InputDecoration(
                          label: Text(al.email),
                        ),
                        style: textStyle.body,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2 * styleConfig.defaultPadding),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onContinueLoginPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: styleConfig.primaryColor,
                          ),
                          child: Text(
                            al.send,
                            style: textStyle.bodyMediumBold.apply(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onContinueLoginPressed() {}

  void onGoogleLoginPressed() {}
}
