// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../controllers/property_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';
import '../../views/property_detail/property_detail_view.dart';

class PropertyShortWidget extends StatefulWidget {
  final Property property;
  const PropertyShortWidget({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyShortWidget> createState() => _PropertyShortWidgetState();
}

class _PropertyShortWidgetState extends State<PropertyShortWidget> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;
  final PropertyController propertyController = PropertyController.instance;

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
          width: 200,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        property.imageUrls.first,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
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
                              text: styleConfig.numberFormat
                                  .format(property.price),
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
                ),
              )
            ],
          ),
        ),
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
}
