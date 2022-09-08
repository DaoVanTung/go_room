import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/approval_property_controller.dart';
import '../../controllers/property_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../widgets/property/property_widget.dart';

class ApprovalPropertyView extends StatefulWidget {
  const ApprovalPropertyView({super.key});

  @override
  State<ApprovalPropertyView> createState() => _ApprovalPropertyViewState();
}

class _ApprovalPropertyViewState extends State<ApprovalPropertyView> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;

  final MyTextStyle textStyle = MyTextStyle.instance;

  final PropertyController propertyController = PropertyController.instance;
  final ApprovalPropertiesController approvalPropertiesController =
      ApprovalPropertiesController.instance;
  @override
  void initState() {
    approvalPropertiesController.loadProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        approvalPropertiesController,
      ]),
      builder: (context, child) {
        return Scaffold(
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
        al.approval,
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
    return waitingForApprovalTab(context);
  }

  Widget waitingForApprovalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(styleConfig.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final item in approvalPropertiesController.waitingProperties)
            PropertyWidget(
              property: item,
              isShowOptionButton: true,
              optionButton: optionButton(
                context,
                options: [0, 1],
                property: item,
              ),
            ),
        ],
      ),
    );
  }

  /// Options
  /// 0: Accept
  /// 1: Deny
  Widget optionButton(
    BuildContext context, {
    required List<int> options,
    required Property property,
  }) {
    final al = AppLocalizations.of(context)!;
    final totalOptions = {
      0: al.accept,
      1: al.deny,
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
            approvalPropertiesController.showProperty(property);
          }

          if (value == 1) {
            approvalPropertiesController.deleteProperty(property.propertyId);
          }

          approvalPropertiesController.loadProperties();
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
