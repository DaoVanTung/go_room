// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';

class Video360PropertyView extends StatefulWidget {
  final String url;
  const Video360PropertyView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Video360PropertyViewState();
}

class _Video360PropertyViewState extends State<Video360PropertyView> {
  Video360Controller? controller;
  _onVideo360ViewCreated(Video360Controller? controller) {
    this.controller = controller;
  }

  String durationText = '';
  String totalText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Video360View(
        key: UniqueKey(),
        onVideo360ViewCreated: _onVideo360ViewCreated,
        url: widget.url,
      ),
    );
  }
}
