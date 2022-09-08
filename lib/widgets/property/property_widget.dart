// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/app_user_controller.dart';
import '../../controllers/property_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../views/property_detail/property_detail_view.dart';

class PropertyWidget extends StatefulWidget {
  final Property property;
  final void Function()? onSavedPressed;
  final bool? isShowOptionButton;
  final Widget? optionButton;
  const PropertyWidget({
    Key? key,
    required this.property,
    this.onSavedPressed,
    this.isShowOptionButton,
    this.optionButton,
  }) : super(key: key);

  @override
  State<PropertyWidget> createState() => _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;
  final PropertyController propertyController = PropertyController.instance;
  final AppUserController appUserController = AppUserController.instance;

  String wardName = '';
  String districtName = '';
  String provinceName = '';
  @override
  void initState() {
    loadAddress();
    super.initState();
  }

  void loadAddress() async {
    wardName = await propertyController.getWardNameByCode(
      widget.property.wardCode,
    );
    districtName = await propertyController.getDistrictNameByCode(
      widget.property.districtCode,
    );
    provinceName = await propertyController.getProvinceNameByCode(
      widget.property.provinceCode,
    );

    if (wardName != '') {
      wardName = ', $wardName';
    }

    if (districtName != '') {
      districtName = ', $districtName';
    }

    if (provinceName != '') {
      provinceName = ', $provinceName';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context);
    final property = widget.property;

    Widget favoriteIconButton() {
      return GestureDetector(
        onTap: () {
          appUserController.addOrRemovePropertyToFavorite(
            context,
            propertyId: property.propertyId,
          );
          widget.onSavedPressed!();
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(styleConfig.smallPadding),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: styleConfig.whiteBlurColor,
          ),
          child: appUserController.isSavedProperty(property.propertyId)
              ? Icon(
                  Icons.favorite_sharp,
                  color: styleConfig.redColor,
                )
              : const Icon(Icons.favorite_border_sharp),
        ),
      );
    }

    Widget iconWithTextWidget(
        {required IconData iconData, required String text}) {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(styleConfig.smallPadding - 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: styleConfig.greyColor,
            ),
            child: Icon(
              iconData,
              size: styleConfig.smallIconSize,
            ),
          ),
          SizedBox(width: styleConfig.smallPadding),
          Text(
            text,
            style: textStyle.subTitle,
          ),
        ],
      );
    }

    Widget infomationProperty() {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          styleConfig.mediumPadding,
          styleConfig.mediumPadding,
          styleConfig.mediumPadding,
          styleConfig.smallPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: textStyle.body.apply(
                  color: styleConfig.blackColor,
                ),
                children: [
                  TextSpan(
                    text: styleConfig.numberFormat.format(property.price),
                    style: textStyle.bodyBold.apply(
                      color: styleConfig.secondaryColor,
                    ),
                  ),
                  TextSpan(text: '/${al!.month}'),
                ],
              ),
            ),
            SizedBox(height: styleConfig.mediumPadding),
            Text(
              '${property.address}$wardName$districtName$provinceName',
              style: textStyle.subTitle,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: styleConfig.mediumPadding),
            Row(
              children: [
                iconWithTextWidget(
                  iconData: Icons.king_bed_rounded,
                  text: '${property.numberOfBed}',
                ),
                SizedBox(width: styleConfig.largePadding),
                iconWithTextWidget(
                  iconData: Icons.bathtub_sharp,
                  text: '${property.numberOfBath}',
                ),
                SizedBox(width: styleConfig.largePadding),
                iconWithTextWidget(
                  iconData: Icons.area_chart_outlined,
                  text: '${property.area} m²',
                )
              ],
            ),
          ],
        ),
      );
    }

    Stack imageProperty() {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  property.imageUrls.first,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: styleConfig.defaultPadding,
            right: styleConfig.defaultPadding,
            child: widget.isShowOptionButton == true
                ? widget.optionButton!
                : favoriteIconButton(),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyDetailView(
              property: property,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: imageProperty(),
              ),
              Expanded(
                flex: 2,
                child: infomationProperty(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
