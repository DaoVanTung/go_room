import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/role_assignment_controller.dart';
import '../../models/app_user.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class RoleAssignmentView extends StatefulWidget {
  const RoleAssignmentView({super.key});

  @override
  State<RoleAssignmentView> createState() => _RoleAssignmentViewState();
}

class _RoleAssignmentViewState extends State<RoleAssignmentView> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;

  final MyTextStyle textStyle = MyTextStyle.instance;

  final RoleAssignmentController roleAssignmentController =
      RoleAssignmentController.instance;

  @override
  void initState() {
    roleAssignmentController.loadAllAppUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([roleAssignmentController]),
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
        al.roleAssignment,
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
    final items = roleAssignmentController.appUserList;

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final role = item.role == 1
            ? 'Censor'
            : item.role == 2
                ? 'Admin'
                : 'User';
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(item.displayName ?? 'GoRoom User'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.email}',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(role),
              ],
            ),
            trailing: optionButton(
              context,
              options: [0, 1],
              appUser: item,
              index: index,
            ),
          ),
        );
      },
    );
  }

  /// Options
  /// 0: Set as default user
  /// 1: Set as censor
  Widget optionButton(
    BuildContext context, {
    required List<int> options,
    required AppUser appUser,
    required int index,
  }) {
    final al = AppLocalizations.of(context)!;
    final totalOptions = {
      0: al.setAsDefaultUser,
      1: al.setAsCensor,
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
            roleAssignmentController.setAppUserAsDefaultUser(index, appUser);
          }

          if (value == 1) {
            roleAssignmentController.setAppUserAsCensor(index, appUser);
          }
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
