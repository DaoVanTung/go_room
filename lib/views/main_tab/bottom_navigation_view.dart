import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/setting_controller.dart';
import '../../widgets/curved_navigation_bar/curved_navigation_bar.dart';
import '../../widgets/loading/loading_widget.dart';
import '../add_property/add_property_view.dart';
import '../favorite/favorite_view.dart';
import '../home/home_view.dart';
import '../setting/setting_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({Key? key}) : super(key: key);

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView>
    with SingleTickerProviderStateMixin, LoadingWidget {
  int _index = 3;
  final int _tabNumber = 4;
  final List<IconData> _tabIcons = const [
    Icons.home_outlined,
    Icons.favorite_outline_rounded,
    Icons.post_add_rounded,
    Icons.settings_outlined,
  ];

  final List<IconData> _chooseTabIcons = const [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.post_add,
    Icons.settings_rounded,
  ];
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(
      length: _tabNumber,
      vsync: this,
      initialIndex: _index,
    );

    super.initState();
  }

  final physics = const NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        SettingController.instance,
        AuthController.instance,
        AppController.instance,
      ]),
      builder: (context, child) {
        final List<Widget> tabView = [
          const HomeView(),
          const FavoriteView(),
          const AddPropertyView(),
          SettingView(),
        ];
        return Scaffold(
          bottomNavigationBar: CurvedNavigationBar(
            index: _index,
            backgroundColor: Colors.transparent,
            items: <Widget>[
              for (int i = 0; i < _tabNumber; i++)
                Icon(
                  i == _index ? _chooseTabIcons[i] : _tabIcons[i],
                  size: 30,
                  color: i == _index ? Colors.white : Colors.grey,
                ),
            ],
            buttonBackgroundColor: Colors.blue,
            onTap: (index) {
              //Handle button tap
              _index = index;

              tabController?.animateTo(
                index,
                duration: const Duration(microseconds: 600),
                curve: Curves.bounceIn,
              );

              setState(() {});
            },
          ),
          body: Stack(
            children: [
              TabBarView(
                physics: physics,
                controller: tabController,
                children: tabView,
              ),
              Visibility(
                visible: AppController.instance.isAppBusy,
                child: stackLoading(
                  context,
                  content: al!.processing,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
