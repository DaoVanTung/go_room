// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/setting_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/loading/loading_widget.dart';

class LoginView extends StatelessWidget with LoadingWidget {
  LoginView({Key? key}) : super(key: key);

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final settingController = SettingController.instance;
  final authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);
    return AnimatedBuilder(
        animation: Listenable.merge(
          [
            settingController,
            authController,
          ],
        ),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: styleConfig.backgroundColor,
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_rounded,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  settingController.switchLanguage();
                                },
                                child: Text(
                                  settingController.supportLanguage[
                                      settingController.languageCode]!,
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Image.asset(
                              'assets/images/login.webp',
                              height: 200,
                              width: 200,
                            ),
                          ),
                          Text(
                            al!.login,
                            style: textStyle.headline,
                          ),
                          SizedBox(height: styleConfig.defaultPadding),
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
                                  keyboardType: TextInputType.emailAddress,
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
                                      authController.isShowPasswordSignIn,
                                  decoration: InputDecoration(
                                    label: Text(al.password),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        authController.isShowPasswordSignIn =
                                            !authController
                                                .isShowPasswordSignIn;
                                      },
                                      icon: authController.isShowPasswordSignIn
                                          ? const Icon(
                                              Icons.visibility_outlined)
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/forgotPassword');
                                },
                                child: Text(
                                  al.forgotPassword,
                                  style: textStyle.bodyMedium.apply(
                                    color: styleConfig.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: styleConfig.smallPadding),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onContinueLoginPressed(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: styleConfig.primaryColor,
                                    ),
                                    child: Text(
                                      al.login,
                                      style: textStyle.bodyMediumBold.apply(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(al.or),
                              ),
                              const Expanded(
                                  child: Divider(
                                thickness: 1.0,
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onGoogleLoginPressed(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: styleConfig.whiteColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/google.webp',
                                          width: 32,
                                          height: 32,
                                        ),
                                        const SizedBox(width: 24),
                                        Text(
                                          al.loginWithGoogle,
                                          style: textStyle.bodyMediumBold.apply(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 56),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: styleConfig.defaultPadding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(al.dontHaveAnAccount),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signUp');
                                },
                                child: Text(
                                  al.registerNow,
                                  style: textStyle.bodyMedium.apply(
                                    color: styleConfig.primaryColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: authController.isBusy,
                    child: stackLoading(
                      context,
                      content: al.signingIn,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void onContinueLoginPressed(BuildContext context) {
    if (_emailKey.currentState!.validate()) {
      if (_passwordKey.currentState!.validate()) {
        authController.signInWithEmailAndPassword(
          context,
          email: _emailKey.currentState!.value,
          password: _passwordKey.currentState!.value,
        );
      }
    }
  }

  void onGoogleLoginPressed(BuildContext context) {
    authController.signInWithGoogle(context);
  }
}
