import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/app_user_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/app_dialog/app_dialog.dart';
import '../approval_property/approval_property_view.dart';
import '../my_properties/my_properties_view.dart';
import '../role_assignment/role_assignment_view.dart';
import 'language_view.dart';
import 'update_password_view.dart';
import 'update_profile_view.dart';

class SettingView extends StatelessWidget with AppDialogWidget {
  SettingView({Key? key}) : super(key: key);
  final MyTextStyle textStyle = MyTextStyle.instance;
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final authController = AuthController.instance;
  final appUserController = AppUserController.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        authController,
        appUserController,
      ]),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(
              al!.setting,
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
            child: Column(
              children: [
                profileCard(context),
                listButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget profileCard(BuildContext context) {
    final al = AppLocalizations.of(context);
    final currentAppUser = appUserController.currentAppUser;
    String? imageUrl = currentAppUser?.photoURL;
    String displayName = currentAppUser?.displayName ?? 'GoRomm User';
    String email = currentAppUser?.email ?? '';
    String phoneNumber = currentAppUser?.phoneNumber ?? '';

    String createdTime = currentAppUser?.creationTime?.toString() ?? '';
    int numberOfProperty = currentAppUser?.properties?.length ?? 0;
    int numberOfFavorite = currentAppUser?.savedProperties?.length ?? 0;

    return Visibility(
      visible: authController.isLogin,
      child: Padding(
        padding: EdgeInsets.all(styleConfig.defaultPadding),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateProfileView(),
              ),
            );
          },
          child: Card(
            elevation: 4.0,
            child: Container(
              padding: EdgeInsets.all(styleConfig.largePadding),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      imageUrl != null
                          ? CircleAvatar(
                              radius: 32,
                              backgroundImage: NetworkImage(imageUrl),
                              backgroundColor: Colors.transparent,
                            )
                          : const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.webp'),
                              backgroundColor: Colors.transparent,
                            ),
                      SizedBox(width: styleConfig.defaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: textStyle.bodyMediumBold,
                            ),
                            Text(
                              email,
                              style: textStyle.body,
                            ),
                            Text(
                              phoneNumber,
                              style: textStyle.body,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: styleConfig.defaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${al!.createdTime}: $createdTime',
                        style: textStyle.body,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.post_add_outlined,
                          ),
                          Text(
                            numberOfProperty.toString(),
                            style: textStyle.body,
                          ),
                          SizedBox(width: styleConfig.defaultPadding),
                          const Icon(
                            Icons.favorite_outline,
                          ),
                          Text(
                            numberOfFavorite.toString(),
                            style: textStyle.body,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listButton(BuildContext context) {
    final al = AppLocalizations.of(context);

    Widget itemButton({
      required IconData leadingIcon,
      required String text,
      required Function() onTap,
    }) {
      return ListTile(
        onTap: onTap,
        minLeadingWidth: 0,
        leading: Icon(leadingIcon),
        title: Text(
          text,
          style: textStyle.bodyMedium,
        ),
        trailing: const Icon(Icons.navigate_next_rounded),
        tileColor: styleConfig.whiteColor,
      );
    }

    return Column(
      children: [
        itemButton(
          leadingIcon: Icons.language_rounded,
          text: al!.language,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LanguageView(),
              ),
            );
          },
        ),
        Visibility(
          visible: !authController.isLogin,
          child: Column(
            children: [
              itemButton(
                leadingIcon: Icons.login,
                text: al.login,
                onTap: () {
                  Navigator.of(context).pushNamed('/signIn');
                },
              ),
            ],
          ),
        ),
        Visibility(
          visible: authController.isLogin,
          child: Column(
            children: [
              itemButton(
                leadingIcon: Icons.folder_shared_outlined,
                text: al.myPosts,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyPropertiesView(),
                    ),
                  );
                },
              ),
              Visibility(
                visible: appUserController.currentAppUser?.role == 1 ||
                    appUserController.currentAppUser?.role == 2,
                child: itemButton(
                  leadingIcon: Icons.approval,
                  text: al.approval,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ApprovalPropertyView(),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: appUserController.currentAppUser?.role == 2,
                child: itemButton(
                  leadingIcon: Icons.rule_outlined,
                  text: al.roleAssignment,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RoleAssignmentView(),
                      ),
                    );
                  },
                ),
              ),
              itemButton(
                leadingIcon: Icons.password_rounded,
                text: al.changePassword,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdatePasswordView(),
                    ),
                  );
                },
              ),
              itemButton(
                leadingIcon: Icons.logout_rounded,
                text: al.logout,
                onTap: () {
                  authController.signOut();
                },
              ),
            ],
          ),
        ),
        itemButton(
          leadingIcon: Icons.close,
          text: al.exit,
          onTap: () {
            showConfirmDialog(
              context,
              content: Text(al.askExit),
              textCancelButton: al.close,
              textContinueButton: al.exit,
              onCancelButtonPressed: () {
                Navigator.of(context).pop();
              },
              onContinueButtonPressed: () {
                exit(0);
              },
            );
          },
        ),
      ],
    );
  }
}
