import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/app_user_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/update_profile_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/app_dialog/app_dialog.dart';
import '../../widgets/loading/loading_widget.dart';

class UpdateProfileView extends StatelessWidget
    with LoadingWidget, AppDialogWidget {
  UpdateProfileView({super.key});

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  final AppUserController appUserController = AppUserController.instance;
  final UpdateProfileController updateProfileController =
      UpdateProfileController.instance;

  final authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AnimatedBuilder(
        animation: Listenable.merge([
          authController,
          appUserController,
          updateProfileController,
        ]),
        builder: (context, child) {
          return Scaffold(
            appBar: appBar(context),
            body: Stack(
              children: [
                body(context),
                Visibility(
                  visible: updateProfileController.isBusy,
                  child: stackLoading(
                    context,
                    content: al.processing,
                  ),
                ),
              ],
            ),
          );
        });
  }

  PreferredSizeWidget appBar(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        al.updateProfile,
        style: textStyle.headline1.apply(
          color: styleConfig.blackColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: styleConfig.blackColor,
      ),
      centerTitle: true,
      backgroundColor: styleConfig.backgroundColor,
    );
  }

  Widget body(BuildContext context) {
    final currentAppUser = appUserController.currentAppUser;
    String? photoUrl = currentAppUser?.photoURL;

    return Padding(
      padding: EdgeInsets.all(styleConfig.defaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 2 * styleConfig.largePadding),
                GestureDetector(
                  onTap: onAvatarPressed,
                  child: avatarWidget(context, photoUrl),
                ),
                SizedBox(height: 2 * styleConfig.largePadding),
                infoWidget(context),
              ],
            ),
            saveButton(context),
          ],
        ),
      ),
    );
  }

  Widget avatarWidget(BuildContext context, String? photoUrl) {
    final size = MediaQuery.of(context).size;
    if (photoUrl == null) {
      return CircleAvatar(
        radius: size.width / 5,
        backgroundImage: const AssetImage('assets/images/avatar.webp'),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: size.width / 5,
        backgroundImage: NetworkImage(photoUrl),
        backgroundColor: Colors.transparent,
      );
    }
  }

  Widget infoWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final currentAppUser = appUserController.currentAppUser;
    String displayName = currentAppUser?.displayName ?? 'GoRomm User';
    String email = currentAppUser?.email ?? '';
    String phoneNumber = currentAppUser?.phoneNumber ?? '';

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline_sharp),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                key: updateProfileController.displayNameKey,
                keyboardType: TextInputType.name,
                initialValue: displayName,
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
                key: updateProfileController.phoneNumberKey,
                keyboardType: TextInputType.phone,
                initialValue: phoneNumber,
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
                key: updateProfileController.emailKey,
                keyboardType: TextInputType.emailAddress,
                initialValue: email,
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
      ],
    );
  }

  Widget saveButton(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                onSaveButtonPressed(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: styleConfig.primaryColor,
              ),
              child: Text(
                al.update,
                style: textStyle.bodyMediumBold.apply(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onAvatarPressed() {
    updateProfileController.onAvatarPressed();
  }

  void onSaveButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await updateProfileController.onSaveButtonPressed(context).then((value) {
      final al = AppLocalizations.of(context)!;

      showSuccessDialog(
        context,
        title: 'Yay!',
        content: al.updateProfileSuccess,
      );
    });
  }
}
