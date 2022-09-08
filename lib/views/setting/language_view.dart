import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/setting_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class LanguageView extends StatelessWidget {
  LanguageView({Key? key}) : super(key: key);

  final MyTextStyle textStyle = MyTextStyle.instance;
  final MyStyleConfig styleConfig = MyStyleConfig.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final settingController = SettingController.instance;

    return AnimatedBuilder(
      animation: settingController,
      builder: (context, child) {
        String currentLanguage = settingController.languageCode;
        final supportLanguage = settingController.supportLanguage;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: styleConfig.blackColor,
            ),
            title: Text(
              al.language,
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
                for (final e in supportLanguage.keys)
                  ListTile(
                    onTap: () {
                      settingController.changeLocaleByLanguageCode(e);
                    },
                    title: Text(supportLanguage[e]!),
                    trailing: currentLanguage == e
                        ? Icon(
                            Icons.done_rounded,
                            color: styleConfig.secondaryColor,
                          )
                        : null,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
