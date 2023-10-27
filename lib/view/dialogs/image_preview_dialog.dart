import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewDialog extends StatelessWidget {
  const ImagePreviewDialog({Key? key, this.imagePath, this.file}) : super(key: key);
  final String? imagePath;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(15),

      backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Stack(
        children: [
          Container(
              // height: Get.height * 0.57,
              // width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: file != null
                  ? ClipRRect(borderRadius: BorderRadius.all(Radius.circular(5.0)), child: Image.file(file!))
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        width: Get.width,
                        imageUrl: imagePath!,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                            height: Get.height * 0.57, color: Colors.white, width: double.infinity, child: Center(child: CircularProgressIndicator(value: downloadProgress.progress))),
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Icon(Icons.error),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/png/galleryicon.png',
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.06,
                                ),
                              ),
                              /*Text(
                                                              "Error! to Load Image"),*/
                            ],
                          ),
                        ),
                      ))),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 28,
                width: 28,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: const Icon(
                  Icons.cancel_rounded,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
