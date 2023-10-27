import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gagagonew/constants/color_constants.dart';
import 'package:image_network/image_network.dart';

class AppCustomNetworkImage extends StatelessWidget {
  AppCustomNetworkImage(
      {Key? key,
        required this.height,
        required this.width,
        required this.imageUrl,
        required this.boxFit,
        this.loaderThickness = 2.0,
        this.loaderColor = AppColors.splashGradColor1,
        this.maxHeight= 1200,
        this.maxWidth =1200
      })
      : super(key: key);

  double height;
  double width;
  double loaderThickness;
  String imageUrl;
  Color loaderColor;
  BoxFit boxFit;
  int? maxHeight;
  int? maxWidth;

  @override
  Widget build(BuildContext context) {


    return ImageNetwork(
      image: imageUrl,
      height: height,
      width: width,
      duration: 200,
      curve: Curves.easeIn,
      onPointer: true,
      debugPrint: false,
      fullScreen: false,
      fitAndroidIos: BoxFit.cover,
      fitWeb: BoxFitWeb.cover,
      onLoading: const CircularProgressIndicator(
        color: Colors.indigoAccent,
      ),
      onError: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      onTap: () {
        debugPrint("©gabriel_patrick_souza");
      },
    );
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      fit: boxFit,
      maxHeightDiskCache: maxHeight,
      maxWidthDiskCache: maxWidth,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation<Color>(AppColors.splashGradColor1),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Image.asset(
          "assets/images/png/placeholder.png",
          fit: boxFit,
          height: height,
          width: width,
        );
      },
    );
  }
}
