import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/search_controller.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  final SearchController searchController = SearchController.instance;

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AnimatedBuilder(
        animation: Listenable.merge([
          searchController,
        ]),
        builder: (context, child) {
          searchController.getProvince();
          return Scaffold(
            appBar: appBar(context),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                styleConfig.defaultPadding,
                styleConfig.defaultPadding,
                styleConfig.defaultPadding,
                styleConfig.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  propertyTypeWidget(context),
                  SizedBox(height: styleConfig.largePadding),
                  propertyInformationWidget(context),
                  // SizedBox(height: styleConfig.largePadding),
                  // propertyTitleWidget(context),
                  SizedBox(height: styleConfig.largePadding),
                  propertyAddressWidget(context),
                  // SizedBox(height: styleConfig.largePadding),
                  // propertyUtilitiesWidget(context),
                  SizedBox(height: 6 * styleConfig.defaultPadding),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: styleConfig.primaryColor,
              onPressed: () {
                searchController.onSearchButtonPressed(context);
              },
              label: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: styleConfig.defaultIconSize,
                  ),
                  SizedBox(width: styleConfig.mediumPadding),
                  Text(
                    al.search,
                    style: textStyle.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        });
  }

  PreferredSizeWidget appBar(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        al.search,
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

  Widget customOutlineButton({
    required bool isChoose,
    required String text,
    required void Function() onTap,
    double? width,
    double? height,
    TextStyle? style,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 36,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: styleConfig.defaultPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isChoose ? styleConfig.secondaryColor : styleConfig.greyColor,
          ),
          color: isChoose ? styleConfig.secondaryColor : styleConfig.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: style ??
                  textStyle.body.apply(
                    color: isChoose
                        ? styleConfig.whiteColor
                        : styleConfig.blackColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyTypeWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          al.type,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Wrap(
          spacing: styleConfig.mediumPadding,
          runSpacing: styleConfig.mediumPadding,
          children: [
            for (final element
                in searchController.getPropertyType(context).keys)
              customOutlineButton(
                isChoose: searchController.currentPropertyType == element,
                text: searchController.getPropertyType(context)[element]!,
                onTap: () {
                  searchController.currentPropertyType = element;
                },
              ),
          ],
        ),
      ],
    );
  }

  Widget textBox({
    required GlobalKey key,
    required String text,
    required String textValidate,
    int? maxLength,
    int? minLine,
    TextInputType? keyBoardType,
    bool showCounterText = false,
  }) {
    return TextFormField(
      key: key,
      keyboardType: keyBoardType,
      maxLength: maxLength,
      minLines: minLine,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          styleConfig.mediumPadding,
          styleConfig.mediumPadding,
          styleConfig.mediumPadding,
          styleConfig.mediumPadding,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0,
            ),
          ),
        ),
        hintText: text,
        hintStyle: textStyle.body,
        counterText: showCounterText == true ? null : '',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return textValidate;
        }
        return null;
      },
    );
  }

  Widget propertyTitleWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          al.byTitle,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        textBox(
          key: searchController.titleKey,
          maxLength: 150,
          text: al.title,
          textValidate: al.enterTitle,
          showCounterText: true,
        ),
      ],
    );
  }

  Widget propertyInformationWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              al.price,
              style: textStyle.bodyLargeBold.apply(
                color: styleConfig.blackColor,
              ),
            ),
            Text(
              '${styleConfig.numberFormat.format(searchController.selectedPriceRange.start)} - ${styleConfig.numberFormat.format(searchController.selectedPriceRange.end)}',
              style: textStyle.bodyMediumBold.apply(
                color: styleConfig.secondaryColor,
              ),
            )
          ],
        ),
        SizedBox(height: styleConfig.mediumPadding),
        RangeSlider(
          values: searchController.selectedPriceRange,
          onChanged: (RangeValues newRange) {
            searchController.selectedPriceRange = newRange;
          },
          min: 0,
          max: 10000000,
          divisions: 100,
        ),
        SizedBox(height: styleConfig.largePadding),
        Text(
          al.numberOfBed,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Wrap(
          spacing: styleConfig.mediumPadding,
          runSpacing: styleConfig.mediumPadding,
          children: [
            for (final element
                in searchController.getNumberOfRoom(context).keys)
              customOutlineButton(
                isChoose: searchController.currentNumberOfBed == element,
                text: searchController.getNumberOfRoom(context)[element]!,
                width: 48,
                onTap: () {
                  if (searchController.currentNumberOfBed == element) {
                    searchController.currentNumberOfBed = null;
                  } else {
                    searchController.currentNumberOfBed = element;
                  }
                },
              ),
          ],
        ),
        SizedBox(height: styleConfig.largePadding),
        Text(
          al.numberOfBath,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Wrap(
          spacing: styleConfig.mediumPadding,
          runSpacing: styleConfig.mediumPadding,
          children: [
            for (final element
                in searchController.getNumberOfRoom(context).keys)
              customOutlineButton(
                isChoose: searchController.currentNumberOfBath == element,
                text: searchController.getNumberOfRoom(context)[element]!,
                width: 48,
                onTap: () {
                  if (searchController.currentNumberOfBath == element) {
                    searchController.currentNumberOfBath = null;
                  } else {
                    searchController.currentNumberOfBath = element;
                  }
                },
              ),
          ],
        ),
      ],
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
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
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                styleConfig.mediumPadding,
                styleConfig.mediumPadding,
                styleConfig.mediumPadding,
                styleConfig.mediumPadding,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    8.0,
                  ),
                ),
              ),
              hintStyle: textStyle.body,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget propertyAddressWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          al.address,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Column(
          children: [
            dropDownButton(
              context,
              text: al.province,
              items: searchController.provinces,
              value: searchController.currentProvinceCode,
              onChanged: (value) {
                searchController.currentProvinceCode = value!;
                searchController.getDistrictOfProvince();
              },
            ),
            SizedBox(height: styleConfig.mediumPadding),
            dropDownButton(
              context,
              text: al.district,
              items: searchController.districts,
              value: searchController.currentDistrictCode,
              onChanged: (value) {
                searchController.currentDistrictCode = value!;
                searchController.getWardOfDistrict();
              },
            ),
            SizedBox(height: styleConfig.mediumPadding),
            dropDownButton(
              context,
              text: al.ward,
              value: searchController.currentWardCode,
              items: searchController.wards,
              onChanged: (value) {
                searchController.currentWardCode = value!;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget propertyUtilityItem(
    BuildContext context, {
    required bool isChoose,
    required String text,
    required void Function() onTap,
    required bool isFullWidth,
  }) {
    final size = MediaQuery.of(context).size;
    final width = size.width -
        (2 * styleConfig.defaultPadding) -
        (2 * styleConfig.mediumPadding);
    final maxWidth = size.width - (2 * styleConfig.defaultPadding);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: isFullWidth ? maxWidth : width / 3,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isChoose ? styleConfig.secondaryColor : styleConfig.greyColor,
          ),
          color: isChoose ? styleConfig.secondaryColor : styleConfig.whiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textStyle.body.apply(
                color:
                    isChoose ? styleConfig.whiteColor : styleConfig.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyUtilitiesWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          al.utilities,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Wrap(
          spacing: styleConfig.mediumPadding,
          runSpacing: styleConfig.mediumPadding,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                propertyUtilityItem(
                  context,
                  isChoose: searchController.currentPropertyUtilities.length ==
                      searchController.getPropertyUtilities(context).length,
                  text: al.all,
                  isFullWidth: true,
                  onTap: () {
                    if (searchController.currentPropertyUtilities.length ==
                        searchController.getPropertyUtilities(context).length) {
                      searchController.currentPropertyUtilities = [];
                    } else {
                      searchController.currentPropertyUtilities =
                          searchController
                              .getPropertyUtilities(context)
                              .keys
                              .toList();
                    }
                  },
                ),
              ],
            ),
            for (final utilityKey
                in searchController.getPropertyUtilities(context).keys)
              propertyUtilityItem(
                context,
                isChoose: searchController.currentPropertyUtilities
                    .contains(utilityKey),
                text:
                    searchController.getPropertyUtilities(context)[utilityKey]!,
                isFullWidth: false,
                onTap: () {
                  if (searchController.currentPropertyUtilities
                      .contains(utilityKey)) {
                    searchController
                        .removeItemCurrentPropertyUtilities(utilityKey);
                  } else {
                    searchController
                        .addItemCurrentPropertyUtilities(utilityKey);
                  }
                },
              ),
          ],
        ),
      ],
    );
  }
}
