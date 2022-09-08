// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/edit_property_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class EditPropertyView extends StatefulWidget {
  final Property property;
  const EditPropertyView({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<EditPropertyView> createState() => _EditPropertyViewState();
}

class _EditPropertyViewState extends State<EditPropertyView>
    with AutomaticKeepAliveClientMixin {
  final EditPropertyController editPropertyController =
      EditPropertyController.instance;
  final AuthController authController = AuthController.instance;

  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;

  @override
  void initState() {
    editPropertyController.setCurrentProperty(widget.property);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        editPropertyController,
        authController,
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
        al.createProperty,
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

    if (authController.isLogin == false) {
      return Center(
        child: Text(al.needLoginToUse),
      );
    } else {
      return SingleChildScrollView(
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
            SizedBox(height: styleConfig.largePadding),
            propertyAddressWidget(context),
            SizedBox(height: styleConfig.largePadding),
            propertyUtilitiesWidget(context),
            SizedBox(height: styleConfig.largePadding),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        editPropertyController.savePropertyPressed(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: styleConfig.primaryColor,
                      ),
                      child: Text(
                        al.update,
                        style: textStyle.bodyMediumBold.apply(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2 * styleConfig.defaultPadding),
          ],
        ),
      );
    }
  }

  Widget propertyTypeItem({
    required bool isChoose,
    required String text,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
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
                in editPropertyController.getPropertyType(context).keys)
              propertyTypeItem(
                isChoose: editPropertyController.currentPropertyType == element,
                text: editPropertyController.getPropertyType(context)[element]!,
                onTap: () {
                  editPropertyController.currentPropertyType = element;
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
    required String initText,
  }) {
    return TextFormField(
      key: key,
      keyboardType: keyBoardType,
      maxLength: maxLength,
      minLines: minLine,
      maxLines: null,
      initialValue: initText,
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

  Widget propertyInformationWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final property = widget.property;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          al.info,
          style: textStyle.bodyLargeBold.apply(
            color: styleConfig.blackColor,
          ),
        ),
        SizedBox(height: styleConfig.mediumPadding),
        Wrap(
          spacing: styleConfig.mediumPadding,
          runSpacing: styleConfig.mediumPadding,
          children: [
            textBox(
              key: editPropertyController.titleKey,
              maxLength: 150,
              text: al.title,
              textValidate: al.enterTitle,
              initText: property.title,
            ),
            textBox(
              key: editPropertyController.descKey,
              text: al.desc,
              minLine: 4,
              maxLength: 1500,
              showCounterText: true,
              textValidate: al.enterDesc,
              initText: property.description,
            ),
            Row(
              children: [
                Expanded(
                  child: textBox(
                    key: editPropertyController.priceKey,
                    text: '${al.price} (VND/${al.month})',
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterPrice,
                    initText: property.price.toString(),
                  ),
                ),
                SizedBox(width: styleConfig.mediumPadding),
                Expanded(
                  child: textBox(
                    key: editPropertyController.areaKey,
                    text: '${al.area} (m²)',
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterArea,
                    initText: property.area.toString(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: textBox(
                    key: editPropertyController.electricPriceKey,
                    text: '${al.electricPrice} (VND/KW)',
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterElectricPrice,
                    initText: property.electricPrice.toString(),
                  ),
                ),
                SizedBox(width: styleConfig.mediumPadding),
                Expanded(
                  child: textBox(
                    key: editPropertyController.waterPriceKey,
                    text: '${al.waterPrice} (m³)',
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterWaterPrice,
                    initText: property.waterPrice.toString(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: textBox(
                    key: editPropertyController.numberOfBedKey,
                    text: al.numberOfBed,
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterNumberOfBed,
                    initText: property.numberOfBed.toString(),
                  ),
                ),
                SizedBox(width: styleConfig.mediumPadding),
                Expanded(
                  child: textBox(
                    key: editPropertyController.numberOfBathKey,
                    text: al.numberOfBath,
                    keyBoardType: TextInputType.number,
                    textValidate: al.enterNumberOfBath,
                    initText: property.numberOfBath.toString(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 128,
              child: editPropertyController.currentImages.isEmpty
                  ? GestureDetector(
                      onTap: editPropertyController.onChooseImagePressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: styleConfig.greyBlurColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: styleConfig.largeIconSize,
                            color: styleConfig.greyColor,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        direction: Axis.vertical,
                        runSpacing: 8.0,
                        children: [
                          Container(
                            height: 128,
                            width: 128,
                            decoration: BoxDecoration(
                              color: styleConfig.greyBlurColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed:
                                    editPropertyController.onChooseImagePressed,
                                icon: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: styleConfig.largeIconSize,
                                  color: styleConfig.greyColor,
                                ),
                              ),
                            ),
                          ),
                          for (var element
                              in editPropertyController.currentImages)
                            Stack(
                              children: [
                                Container(
                                  height: 128,
                                  width: 128,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: element.contains('http')
                                        ? DecorationImage(
                                            image: Image.network(element).image,
                                            fit: BoxFit.fitHeight,
                                          )
                                        : DecorationImage(
                                            image:
                                                Image.file(File(element)).image,
                                            fit: BoxFit.fitHeight,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  right: 4.0,
                                  top: 4.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: styleConfig.whiteColor
                                          .withOpacity(0.5),
                                    ),
                                    height: 36,
                                    width: 36,
                                    child: IconButton(
                                      onPressed: () {
                                        editPropertyController
                                            .removeItemOfCurrentImages(
                                          element,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                      ),
                                      iconSize: styleConfig.mediumIconSize,
                                      splashRadius: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              height: 128,
              child: videoWidget(context),
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

  Widget videoWidget(BuildContext context) {
    if (editPropertyController.currentVideos.isEmpty ||
        editPropertyController.currentImageOfVideo == null) {
      return GestureDetector(
        onTap: editPropertyController.onChooseVideoPressed,
        child: Container(
          decoration: BoxDecoration(
            color: styleConfig.greyBlurColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Icon(
              Icons.video_library_rounded,
              size: styleConfig.largeIconSize,
              color: styleConfig.greyColor,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 128,
          width: 128,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: Image.file(
                editPropertyController.currentImageOfVideo!,
              ).image,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned(
          right: 4.0,
          top: 4.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: styleConfig.whiteColor.withOpacity(0.5),
            ),
            height: 36,
            child: IconButton(
              onPressed: () {
                editPropertyController.removeItemOfCurrentVideo();
              },
              icon: const Icon(
                Icons.close,
              ),
              iconSize: styleConfig.mediumIconSize,
              splashRadius: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget propertyAddressWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final property = widget.property;

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
              items: editPropertyController.provinces,
              value: editPropertyController.currentProvinceCode,
              onChanged: (value) {
                editPropertyController.currentProvinceCode = value!;
                editPropertyController.getDistrictOfProvince();
              },
            ),
            SizedBox(height: styleConfig.mediumPadding),
            dropDownButton(
              context,
              text: al.district,
              items: editPropertyController.districts,
              value: editPropertyController.currentDistrictCode,
              onChanged: (value) {
                editPropertyController.currentDistrictCode = value!;
                editPropertyController.getWardOfDistrict();
              },
            ),
            SizedBox(height: styleConfig.mediumPadding),
            dropDownButton(
              context,
              text: al.ward,
              value: editPropertyController.currentWardCode,
              items: editPropertyController.wards,
              onChanged: (value) {
                editPropertyController.currentWardCode = value!;
              },
            ),
            SizedBox(height: styleConfig.mediumPadding),
            textBox(
              key: editPropertyController.addressKey,
              text: al.address,
              keyBoardType: TextInputType.streetAddress,
              textValidate: al.enterAddress,
              initText: property.address,
            ),
            SizedBox(height: styleConfig.mediumPadding),
            textBox(
                key: editPropertyController.phoneNumberKey,
                text: al.phoneNumber,
                keyBoardType: TextInputType.phone,
                textValidate: al.enterPhoneNumber,
                initText: property.phoneNumber),
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
                  isChoose:
                      editPropertyController.currentPropertyUtilities.length ==
                          editPropertyController
                              .getPropertyUtilities(context)
                              .length,
                  text: al.all,
                  isFullWidth: true,
                  onTap: () {
                    if (editPropertyController
                            .currentPropertyUtilities.length ==
                        editPropertyController
                            .getPropertyUtilities(context)
                            .length) {
                      editPropertyController.currentPropertyUtilities = [];
                    } else {
                      editPropertyController.currentPropertyUtilities =
                          editPropertyController
                              .getPropertyUtilities(context)
                              .keys
                              .toList();
                    }
                  },
                ),
              ],
            ),
            for (final utilityKey
                in editPropertyController.getPropertyUtilities(context).keys)
              propertyUtilityItem(
                context,
                isChoose: editPropertyController.currentPropertyUtilities
                    .contains(utilityKey),
                text: editPropertyController
                    .getPropertyUtilities(context)[utilityKey]!,
                isFullWidth: false,
                onTap: () {
                  if (editPropertyController.currentPropertyUtilities
                      .contains(utilityKey)) {
                    editPropertyController
                        .removeItemCurrentPropertyUtilities(utilityKey);
                  } else {
                    editPropertyController
                        .addItemCurrentPropertyUtilities(utilityKey);
                  }
                },
              ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
