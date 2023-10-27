import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_crop/image_crop.dart';

class CropImage extends StatefulWidget {
  String? path;

  CropImage({Key? key, this.path}) : super(key: key);

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  // final cropKey = GlobalKey<CropState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: _buildCroppingImage(),
      ),
    );
  }

  Widget _buildCroppingImage() {
    File file = File(widget.path.toString());

    debugPrint("widget.path ${widget.path.toString()} file --> ${file.path}");

    return Column(
      children: <Widget>[
        // Expanded(
        //   child: Crop.file(file, key: cropKey),
        // ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  'Crop Image',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cropImage() async {
    // final scale = cropKey.currentState!.scale;
    // final area = cropKey.currentState!.area;
    // if (area == null) {
    //   // cannot crop, widget is not setup
    //   return;
    // }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    // final sample = await ImageCrop.sampleImage(
    //   file: File(widget.path.toString()),
    //   preferredSize: (2000 / scale).round(),
    // );
    //
    // final file = await ImageCrop.cropImage(
    //   file: sample,
    //   area: area,
    // );
    // sample.delete();

    // var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    // print("width --> ${decodedImage.width}");
    // print("height -- > ${decodedImage.height}");

    // Navigator.pop(context, file.path);
  }
}
