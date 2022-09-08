import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

mixin LoadingWidget {
  final MyStyleConfig _styleConfig = MyStyleConfig.instance;
  final MyTextStyle _textStyle = MyTextStyle.instance;
  Widget stackLoading(
    BuildContext context, {
    String? content,
  }) {
    final al = AppLocalizations.of(context);

    return Container(
      color: _styleConfig.whiteColor.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/loading.gif',
              filterQuality: FilterQuality.high,
              width: 120,
              height: 120,
            ),
            Text(
              content ?? al!.loading,
              style: _textStyle.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingWidget(
    BuildContext context, {
    String? content,
  }) {
    final al = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/loading.gif',
          filterQuality: FilterQuality.high,
          width: 120,
          height: 120,
        ),
        Text(
          content ?? al!.loading,
          style: _textStyle.body,
        ),
      ],
    );
  }
}
