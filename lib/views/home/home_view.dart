import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/home_controller.dart';
import '../../models/property.dart';
import '../../widgets/loading/loading_widget.dart';
import '../../widgets/property/property_short_widget.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../search/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin, LoadingWidget {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;
  final homeController = HomeController.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedBuilder(
        animation: homeController,
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xffF8F8F8),
              body: Padding(
                padding: EdgeInsets.all(styleConfig.defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchButton(context),
                    SizedBox(height: styleConfig.smallPadding),
                    chooseProvinceWidget(context),
                    Expanded(child: newPropertiesWidget(context)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget searchButton(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => SearchView())),
        );
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(
          horizontal: styleConfig.defaultPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xffc2c2c2),
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_outlined),
            SizedBox(width: styleConfig.mediumPadding),
            Text(al.search),
          ],
        ),
      ),
    );
  }

  Widget dropDownButton(
    BuildContext context, {
    required String text,
    required Map<int, dynamic> items,
    required int? value,
    required void Function(int? value) onChanged,
  }) {
    final size = MediaQuery.of(context).size;
    return DropdownButton<int>(
      value: value,
      items: [
        for (final key in items.keys)
          DropdownMenuItem<int>(
            value: key,
            child: Text(items[key].name!),
          ),
      ],
      menuMaxHeight: size.height / 2,
      hint: Text(text),
      style: textStyle.body.apply(color: Colors.black),
      elevation: 0,
      onChanged: onChanged,
    );
  }

  Widget chooseProvinceWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return dropDownButton(
      context,
      text: al.province,
      items: homeController.provinces,
      value: homeController.currentProvinceCode,
      onChanged: (value) {
        homeController.currentProvinceCode = value!;
      },
    );
  }

  Widget newPropertiesWidget(BuildContext context) {
    if (homeController.isBusy) {
      return Center(child: loadingWidget(context));
    }

    final al = AppLocalizations.of(context)!;

    if (homeController.motelProperties.isEmpty &&
        homeController.apartmentProperties.isEmpty &&
        homeController.houseProperties.isEmpty &&
        homeController.dormProperties.isEmpty) {
      return Center(child: Text(al.noPropertyThisArea));
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newPropertiesList(
            context,
            title: al.motel,
            items: homeController.motelProperties,
            onSeeMorePressed: () {
              homeController.onSeeMoreMotelPressed(context);
            },
          ),
          newPropertiesList(
            context,
            title: al.apartment,
            items: homeController.apartmentProperties,
            onSeeMorePressed: () {
              homeController.onSeeMoreApartmentPressed(context);
            },
          ),
          newPropertiesList(
            context,
            title: al.house,
            items: homeController.houseProperties,
            onSeeMorePressed: () {
              homeController.onSeeMoreHousePressed(context);
            },
          ),
          newPropertiesList(
            context,
            title: al.dorm,
            items: homeController.dormProperties,
            onSeeMorePressed: () {
              homeController.onSeeMoreDormPressed(context);
            },
          ),
        ],
      ),
    );
  }

  Widget newPropertiesList(
    BuildContext context, {
    required String title,
    required List<Property> items,
    required void Function() onSeeMorePressed,
  }) {
    if (items.isEmpty) return Container();

    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textStyle.headline1,
            ),
            TextButton(
              onPressed: onSeeMorePressed,
              child: Text(
                al.seeMore,
                style: textStyle.bodyBold.apply(
                  color: styleConfig.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final e in items)
                PropertyShortWidget(
                  property: e,
                ),
            ],
          ),
        ),
        SizedBox(height: styleConfig.defaultPadding),
      ],
    );
  }
}
