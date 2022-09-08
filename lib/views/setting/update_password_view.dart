import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/loading/loading_widget.dart';

class UpdatePasswordView extends StatelessWidget with LoadingWidget {
  UpdatePasswordView({Key? key}) : super(key: key);

  final MyTextStyle textStyle = MyTextStyle.instance;
  final MyStyleConfig styleConfig = MyStyleConfig.instance;

  final _newPasswordKey = GlobalKey<FormFieldState>();
  final _confirmNewPasswordKey = GlobalKey<FormFieldState>();

  final authController = AuthController.instance;
  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: authController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: styleConfig.blackColor,
            ),
            title: Text(
              al.changePassword,
              style: textStyle.headline1.apply(color: styleConfig.blackColor),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                color: styleConfig.greyColor,
                height: 1.0,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              styleConfig.defaultPadding,
              styleConfig.defaultPadding,
              styleConfig.defaultPadding,
              styleConfig.defaultPadding,
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            key: _newPasswordKey,
                            obscureText: authController.isShowPasswordChange,
                            decoration: InputDecoration(
                              label: Text(al.newPassword),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authController.isShowPasswordChange =
                                      !authController.isShowPasswordChange;
                                },
                                icon: authController.isShowPasswordChange
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(Icons.visibility_off_outlined),
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
                    SizedBox(height: styleConfig.defaultPadding),
                    Row(
                      children: [
                        const Icon(Icons.lock_outline_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            key: _confirmNewPasswordKey,
                            obscureText: authController.isShowPasswordConfirm,
                            decoration: InputDecoration(
                              label: Text(al.confirmPassword),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authController.isShowPasswordConfirm =
                                      !authController.isShowPasswordConfirm;
                                },
                                icon: authController.isShowPasswordConfirm
                                    ? const Icon(Icons.visibility_outlined)
                                    : const Icon(Icons.visibility_off_outlined),
                                splashRadius: 24,
                              ),
                            ),
                            style: textStyle.body,
                            validator: (value) {
                              if (value !=
                                  _newPasswordKey.currentState?.value) {
                                return al.confirmationPasswordIncorrect;
                              }
                              return authController.validatePassword(
                                context,
                                password: value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: styleConfig.defaultPadding),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                onChangePasswordPressed(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: styleConfig.secondaryColor,
                              ),
                              child: Text(
                                al.changePassword,
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
                Visibility(
                  visible: authController.isBusy,
                  child: stackLoading(
                    context,
                    content: al.processing,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onChangePasswordPressed(BuildContext context) {
    if (_newPasswordKey.currentState!.validate()) {
      if (_confirmNewPasswordKey.currentState!.validate()) {
        authController.updatePassword(
          context,
          newPassword: _newPasswordKey.currentState?.value,
        );
      }
    }
  }
}
