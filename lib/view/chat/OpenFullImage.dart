import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../../constants/string_constants.dart';

class OpenFullImage extends StatefulWidget {
  final String imagePath ;

  const OpenFullImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<OpenFullImage> createState() => _OpenFullImageState();
}

class _OpenFullImageState extends State<OpenFullImage> {
  @override
  void initState() {
    super.initState();

    debugPrint("OpenFullImage screen: ${widget.imagePath}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              backgroundDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
              filterQuality: FilterQuality.high,
              imageProvider: widget.imagePath.contains("https:")
                  ? NetworkImage(widget.imagePath)
                  : Image.file(File(widget.imagePath)).image,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Get.width * 0.05,
                  right: Get.width * 0.050,
                  left: Get.width * 0.050,
                  bottom: Get.height * 0.010),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  "${StringConstants.svgPath}backIcon.svg",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
