import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/loading/loading_widget.dart';

class SignUpView extends StatelessWidget with LoadingWidget {
  SignUpView({Key? key}) : super(key: key);

  final _displayNameKey = GlobalKey<FormFieldState>();
  final _phoneNumberKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  final authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([authController]),
      builder: (context, child) {
        return Stack(
          children: [
            SafeArea(
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
                            'assets/images/register.webp',
                            height: 200,
                            width: 200,
                          ),
                        ),
                        Text(
                          al!.register,
                          style: textStyle.headline,
                        ),
                        SizedBox(height: styleConfig.smallPadding),
                        Row(
                          children: [
                            const Icon(Icons.person_outline_sharp),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                key: _displayNameKey,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  label: Text(al.fullName),
                                ),
                                style: textStyle.body,
                                validator: (value) {
                                  return authController.validateFullName(
                                    context,
                                    fullName: value,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: styleConfig.smallPadding),
                        Row(
                          children: [
                            const Icon(Icons.phone_android_outlined),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                key: _phoneNumberKey,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  label: Text(al.phoneNumber),
                                ),
                                style: textStyle.body,
                                validator: (value) {
                                  return authController.validatePhoneNumber(
                                    context,
                                    phoneNumber: value,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: styleConfig.smallPadding),
                        Row(
                          children: [
                            const Icon(Icons.alternate_email_rounded),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                key: _emailKey,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  label: Text(al.email),
                                ),
                                style: textStyle.body,
                                validator: (value) {
                                  return authController.validateEmail(
                                    context,
                                    email: value,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: styleConfig.smallPadding),
                        Row(
                          children: [
                            const Icon(Icons.lock_outline_rounded),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                key: _passwordKey,
                                obscureText:
                                    authController.isShowPasswordSignUp,
                                decoration: InputDecoration(
                                  label: Text(al.password),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      authController.isShowPasswordSignUp =
                                          !authController.isShowPasswordSignUp;
                                    },
                                    icon: authController.isShowPasswordSignUp
                                        ? const Icon(Icons.visibility_outlined)
                                        : const Icon(
                                            Icons.visibility_off_outlined),
                                    splashRadius: 24,
                                  ),
                                ),
                                style: textStyle.body,
                                validator: (value) {
                                  return authController.validatePassword(
                                    context,
                                    password: value,
                                  );
                                },
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
                                  onPressed: () {
                                    onSignUpPressed(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: styleConfig.primaryColor,
                                  ),
                                  child: Text(
                                    al.register,
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
            ),
            Visibility(
              visible: authController.isBusy,
              child: stackLoading(
                context,
                content: al.processing,
              ),
            ),
          ],
        );
      },
    );
  }

  void onSignUpPressed(BuildContext context) {
    if (_displayNameKey.currentState!.validate()) {
      if (_phoneNumberKey.currentState!.validate()) {
        if (_emailKey.currentState!.validate()) {
          if (_passwordKey.currentState!.validate()) {
            authController.signUpWithEmailAndPassword(
              context,
              email: _emailKey.currentState!.value,
              password: _passwordKey.currentState!.value,
              displayName: _displayNameKey.currentState!.value,
              phoneNumber: _phoneNumberKey.currentState!.value,
            );
          }
        }
      }
    }
  }
}
