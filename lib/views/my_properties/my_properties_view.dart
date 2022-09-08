import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/my_properties_controller.dart';
import '../../controllers/property_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/property/property_widget.dart';
import '../edit_property/edit_property_view.dart';

class MyPropertiesView extends StatefulWidget {
  const MyPropertiesView({super.key});

  @override
  State<MyPropertiesView> createState() => _MyPropertiesViewState();
}

class _MyPropertiesViewState extends State<MyPropertiesView> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;

  final MyTextStyle textStyle = MyTextStyle.instance;

  final PropertyController propertyController = PropertyController.instance;
  final MyPropertiesController myPropertiesController =
      MyPropertiesController.instance;
  @override
  void initState() {
    myPropertiesController.loadMyProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        myPropertiesController,
      ]),
      builder: (context, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: appBar(context),
            body: body(context),
          ),
        );
      },
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        al.myPosts,
        style: textStyle.headline1.apply(
          color: styleConfig.blackColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: styleConfig.blackColor,
      ),
      centerTitle: true,
      backgroundColor: styleConfig.backgroundColor,
      bottom: TabBar(
        tabs: [
          Text(al.waitingApproval),
          Text(al.showing),
          Text(al.hidden),
        ],
        labelPadding: EdgeInsets.all(styleConfig.defaultPadding),
        labelColor: styleConfig.primaryColor,
        labelStyle: textStyle.bodyMedium,
        unselectedLabelColor: styleConfig.blackColor,
        indicatorColor: styleConfig.primaryColor,
      ),
    );
  }

  Widget body(BuildContext context) {
    return TabBarView(
      children: [
        waitingForApprovalTab(context),
        showingTab(context),
        hiddenTab(context),
      ],
    );
  }

  Widget waitingForApprovalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(styleConfig.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final item in myPropertiesController.waitingProperties)
            PropertyWidget(
              property: item,
              isShowOptionButton: true,
              optionButton: optionButton(
                context,
                options: [0, 3],
                property: item,
              ),
            ),
        ],
      ),
    );
  }

  Widget showingTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(styleConfig.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final item in myPropertiesController.showingProperties)
            PropertyWidget(
              property: item,
              isShowOptionButton: true,
              optionButton: optionButton(
                context,
                options: [0, 2, 3],
                property: item,
              ),
            ),
        ],
      ),
    );
  }

  Widget hiddenTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(styleConfig.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final item in myPropertiesController.hiddenProperties)
            PropertyWidget(
              property: item,
              isShowOptionButton: true,
              optionButton: optionButton(
                context,
                options: [0, 1, 3],
                property: item,
              ),
            ),
        ],
      ),
    );
  }

  /// Options
  /// 0: edit
  /// 1: show
  /// 2: hide
  /// 3: delete
  Widget optionButton(
    BuildContext context, {
    required List<int> options,
    required Property property,
  }) {
    final al = AppLocalizations.of(context)!;
    final totalOptions = {
      0: al.edit,
      1: al.show,
      2: al.hide,
      3: al.delete,
    };

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: styleConfig.whiteBlurColor,
      ),
      child: PopupMenuButton<int>(
        onSelected: (value) async {
          if (value == 0) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditPropertyView(
                  property: property,
                ),
              ),
            );
          }

          if (value == 1) {
            myPropertiesController.showProperty(property);
          }

          if (value == 2) {
            myPropertiesController.hideProperty(property);
          }

          if (value == 3) {
            myPropertiesController.deleteProperty(property.propertyId);
          }

          myPropertiesController.loadMyProperties();
        },
        padding: EdgeInsets.zero,
        iconSize: styleConfig.mediumIconSize,
        itemBuilder: (BuildContext context) {
          return options.map((int choice) {
            return PopupMenuItem<int>(
              value: choice,
              child: Text(totalOptions[choice]!),
            );
          }).toList();
        },
      ),
    );
  }
}
