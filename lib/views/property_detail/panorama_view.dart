// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class PanoramaView extends StatelessWidget {
  final String imageUrl;

  const PanoramaView({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: Panorama(
            animSpeed: 0.5,
            sensorControl: SensorControl.Orientation,
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
