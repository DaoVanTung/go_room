// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_360/video_360.dart';

import 'panorama_view.dart';
import 'video_360_view.dart';
import '../../controllers/app_user_controller.dart';
import '../../controllers/property_controller.dart';
import '../../controllers/property_detail_controller.dart';
import '../../models/property.dart';
import '../../style/my_style_config.dart';
import '../../style/my_text_style.dart';

class PropertyDetailView extends StatefulWidget {
  final Property property;
  const PropertyDetailView({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<PropertyDetailView> createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> {
  final MyStyleConfig styleConfig = MyStyleConfig.instance;
  final MyTextStyle textStyle = MyTextStyle.instance;
  final AppUserController appUserController = AppUserController.instance;

  final PropertyController propertyController = PropertyController.instance;
  final PropertyDetailController propertyDetailController =
      PropertyDetailController.instance;

  String wardName = '';
  String districtName = '';
  String provinceName = '';

  @override
  void initState() {
    if (widget.property.videoUrls.isNotEmpty) {
      widget.property.imageUrls.add(widget.property.videoUrls.first);
    }

    loadAddress();
    propertyDetailController.loadPropertyAppUserByUid(widget.property.uid);
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
    return AnimatedBuilder(
      animation: Listenable.merge(
        [
          appUserController,
          propertyController,
          propertyDetailController,
        ],
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: styleConfig.backgroundColor,
          appBar: appBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                propertyImage(context),
                infomationProperty(context),
                const Divider(
                  thickness: 1,
                ),
                profileCard(context),
                const Divider(
                  thickness: 1,
                ),
                descWidget(context),
                const Divider(
                  thickness: 1,
                ),
                utilitiesWidget(context),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final propertyId = widget.property.propertyId;
    return AppBar(
      title: Text(
        al.detail,
        style: textStyle.headline1.apply(
          color: styleConfig.blackColor,
        ),
      ),
      iconTheme: IconThemeData(
        color: styleConfig.blackColor,
      ),
      centerTitle: true,
      backgroundColor: styleConfig.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            appUserController.addOrRemovePropertyToFavorite(
              context,
              propertyId: propertyId,
            );
          },
          icon: appUserController.isSavedProperty(propertyId)
              ? Icon(
                  Icons.favorite_sharp,
                  color: styleConfig.redColor,
                )
              : const Icon(Icons.favorite_border_sharp),
          splashRadius: 24,
        ),
      ],
    );
  }

  int currentImageIndex = 0;
  Video360Controller? controller;
  _onVideo360ViewCreated(Video360Controller? controller) {
    this.controller = controller;
  }

  Widget propertyImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = 0.75 * size.width;
    bool isShowPlayButton = false;
    Widget image = Container();
    if (widget.property.videoUrls.isNotEmpty &&
        currentImageIndex == widget.property.imageUrls.length - 1) {
      image = Video360View(
        key: UniqueKey(),
        onVideo360ViewCreated: _onVideo360ViewCreated,
        url: widget.property.videoUrls.first,
      );
      isShowPlayButton = true;
    } else {
      image = Image.network(
        widget.property.imageUrls.elementAt(currentImageIndex),
        fit: BoxFit.cover,
        cacheWidth: 1920,
        cacheHeight: 1080,
      );
    }

    return SizedBox(
      width: size.width,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: image,
          ),
          Positioned(
            top: (height / 2) - 20,
            left: 12.0,
            child: GestureDetector(
              onTap: () {
                if (currentImageIndex == 0) {
                  currentImageIndex = widget.property.imageUrls.length - 1;
                } else {
                  currentImageIndex = currentImageIndex - 1;
                }

                setState(() {});
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(styleConfig.smallPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: styleConfig.whiteColor.withOpacity(0.6),
                ),
                child: Icon(
                  Icons.navigate_before,
                  size: styleConfig.defaultIconSize,
                ),
              ),
            ),
          ),
          Positioned(
            top: (height / 2) - 20,
            right: 12.0,
            child: GestureDetector(
              onTap: () {
                if (currentImageIndex == widget.property.imageUrls.length - 1) {
                  currentImageIndex = 0;
                } else {
                  currentImageIndex = currentImageIndex + 1;
                }

                setState(() {});
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(styleConfig.smallPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: styleConfig.whiteColor.withOpacity(0.6),
                ),
                child: Icon(
                  Icons.navigate_next,
                  size: styleConfig.defaultIconSize,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12.0,
            right: 12.0,
            child: GestureDetector(
              onTap: () {
                if (isShowPlayButton) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Video360PropertyView(
                        url: widget.property.imageUrls
                            .elementAt(currentImageIndex),
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PanoramaView(
                        imageUrl: widget.property.imageUrls
                            .elementAt(currentImageIndex),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(styleConfig.smallPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: styleConfig.whiteColor.withOpacity(0.6),
                ),
                child: Icon(
                  Icons.open_with,
                  size: styleConfig.mediumIconSize,
                ),
              ),
            ),
          ),
          Visibility(
            visible: isShowPlayButton,
            child: Positioned(
              top: (height / 2) - 20,
              right: (size.width / 2) - 20,
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(styleConfig.smallPadding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: styleConfig.whiteColor.withOpacity(0.6),
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: styleConfig.mediumIconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconWithTextWidget({
    required IconData iconData,
    required String text,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(styleConfig.smallPadding),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: styleConfig.greyColor,
          ),
          child: Icon(
            iconData,
            size: styleConfig.defaultIconSize,
          ),
        ),
        SizedBox(width: styleConfig.smallPadding),
        Text(
          text,
          style: textStyle.body,
        ),
      ],
    );
  }

  Widget infomationProperty(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        styleConfig.defaultPadding,
        styleConfig.defaultPadding,
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.property.title,
            style: textStyle.headline1,
          ),
          SizedBox(height: styleConfig.mediumPadding),
          RichText(
            text: TextSpan(
              style: textStyle.body.apply(
                color: styleConfig.blackColor,
              ),
              children: [
                TextSpan(
                  text: styleConfig.numberFormat.format(widget.property.price),
                  style: textStyle.bodyMedium.apply(
                    color: styleConfig.secondaryColor,
                  ),
                ),
                TextSpan(text: '/${al.month}'),
              ],
            ),
          ),
          SizedBox(height: styleConfig.mediumPadding),
          Text(
            '${widget.property.address}$wardName$districtName$provinceName',
            style: textStyle.body,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: styleConfig.mediumPadding),
          Row(
            children: [
              iconWithTextWidget(
                iconData: Icons.king_bed_rounded,
                text: widget.property.numberOfBed.toString(),
              ),
              SizedBox(width: styleConfig.largePadding),
              iconWithTextWidget(
                iconData: Icons.bathtub_sharp,
                text: widget.property.numberOfBath.toString(),
              ),
              SizedBox(width: styleConfig.largePadding),
              iconWithTextWidget(
                iconData: Icons.area_chart_outlined,
                text: '${widget.property.area} m²',
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget profileCard(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final userProperty = propertyDetailController.propertyAppUser;

    String displayName = userProperty?.displayName ?? 'GoRomm User';
    String createdTime = userProperty?.creationTime?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.fromLTRB(
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
      ),
      child: Row(
        children: [
          userProperty?.photoURL == null
              ? const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/avatar.webp'),
                  backgroundColor: Colors.transparent,
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(userProperty!.photoURL!),
                  backgroundColor: Colors.transparent,
                ),
          SizedBox(width: styleConfig.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: textStyle.bodyMediumBold,
                ),
                Text(
                  '${al.createdTime}: $createdTime',
                  style: textStyle.body,
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final Uri smsLaunchUri = Uri(
                    scheme: 'sms',
                    path: widget.property.phoneNumber,
                  );
                  launchUrl(smsLaunchUri);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(styleConfig.smallPadding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: styleConfig.whiteColor,
                  ),
                  child: Icon(
                    Icons.forum,
                    size: styleConfig.mediumIconSize,
                    color: styleConfig.secondaryColor,
                  ),
                ),
              ),
              SizedBox(width: styleConfig.mediumPadding),
              GestureDetector(
                onTap: () {
                  final Uri telLaunchUri = Uri(
                    scheme: 'tel',
                    path: widget.property.phoneNumber,
                  );
                  launchUrl(telLaunchUri);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(styleConfig.smallPadding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: styleConfig.whiteColor,
                  ),
                  child: Icon(
                    Icons.phone_in_talk_rounded,
                    size: styleConfig.mediumIconSize,
                    color: styleConfig.lightGreenColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget descWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    final desc = widget.property.description;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            al.desc,
            style: textStyle.bodyLargeBold,
          ),
          Text(
            desc,
            style: textStyle.body,
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: styleConfig.mediumPadding),
          Row(
            children: [
              Icon(
                Icons.electric_bolt_rounded,
                size: styleConfig.mediumIconSize,
                color: styleConfig.yellowColor,
              ),
              SizedBox(width: styleConfig.mediumPadding),
              Text(
                '${styleConfig.numberFormat.format(widget.property.electricPrice)}/kWh',
                style: textStyle.body,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
          SizedBox(height: styleConfig.smallPadding),
          Row(
            children: [
              Icon(
                Icons.water_drop_sharp,
                size: styleConfig.mediumIconSize,
                color: styleConfig.secondaryColor,
              ),
              SizedBox(width: styleConfig.mediumPadding),
              Text(
                '${styleConfig.numberFormat.format(widget.property.waterPrice)}/m³',
                style: textStyle.body,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget propertyUtilityItem(
    BuildContext context, {
    required String text,
  }) {
    final size = MediaQuery.of(context).size;
    final width = size.width -
        (2 * styleConfig.defaultPadding) -
        (2 * styleConfig.mediumPadding);
    return Container(
      height: 36,
      width: width / 3,
      decoration: BoxDecoration(
        border: Border.all(
          color: styleConfig.greyColor,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: textStyle.body.apply(
              color: styleConfig.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget utilitiesWidget(BuildContext context) {
    final al = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
        styleConfig.defaultPadding,
        styleConfig.mediumPadding,
      ),
      child: Column(
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
              for (final utilityKey in widget.property.utilities)
                propertyUtilityItem(
                  context,
                  text: propertyDetailController
                      .getPropertyUtilities(context)[utilityKey]!,
                ),
            ],
          ),
        ],
      ),
    );
  }

  final Uri telLaunchUri = Uri(
    scheme: 'tel',
    path: '0118 999 881 999 119 7253',
    queryParameters: <String, String>{
      'body': Uri.encodeComponent('Example Subject & Symbols are allowed!'),
    },
  );
}
