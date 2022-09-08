import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/loading/loading_widget.dart';
import '../../widgets/property/property_widget.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> with LoadingWidget {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  final FavoriteController favoriteController = FavoriteController.instance;
  final AuthController authController = AuthController.instance;

  @override
  void initState() {
    favoriteController.loadSavedProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: Listenable.merge([
        authController,
        favoriteController,
      ]),
      builder: (context, child) {
        if (authController.isLogin == false) {
          return Scaffold(
            appBar: appBar(context),
            body: Center(
              child: Text(al.needLoginToUse),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xffF8F8F8),
          appBar: appBar(context),
          body: body(context),
        );
      },
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        al.saved,
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
    final al = AppLocalizations.of(context)!;

    if (favoriteController.isBusy) {
      return Center(child: loadingWidget(context));
    }

    if (favoriteController.savedProperties.isEmpty) {
      return Center(
        child: Text(al.haveNotProperty),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(styleConfig.defaultPadding),
        itemCount: favoriteController.savedProperties.length,
        itemBuilder: (context, index) => PropertyWidget(
          property: favoriteController.savedProperties.elementAt(index),
          onSavedPressed: () {
            favoriteController.removeSavedItem(
              favoriteController.savedProperties.elementAt(
                index,
              ),
            );
          },
        ),
      );
    }
  }
}
