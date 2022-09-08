// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_room/models/property.dart';

import '../../controllers/result_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/property/property_widget.dart';

class ResultView extends StatelessWidget {
  final String title;
  final List<Property> items;
  ResultView({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;
  final ResultController resultController = ResultController.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(styleConfig.defaultPadding),
        child: Column(
          children: [
            for (final item in items)
              PropertyWidget(
                property: item,
                onSavedPressed: () {},
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(
        title,
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
}
