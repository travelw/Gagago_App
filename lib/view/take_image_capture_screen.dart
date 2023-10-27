// A screen that allows users to take a picture using a given camera.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'package:image/image.dart' as img;

// import 'package:exif/exif.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.callBack,
  });

  final Function(XFile? capturedImage) callBack;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? capturedImage;
  CameraDescription? _camera;
  FlashMode? flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // To display the current  from the Camera,
    // create a CameraController.
    _camera = camerasAvailable.first;
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        _camera!,
        // Define the resolution to use.
        ResolutionPreset.medium,
        enableAudio: false);

    // Next, initialize the controller. This returns a Future.

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        body: capturedImage != null
            ? DisplayPictureScreen(
                imagePath: capturedImage!.path,
                callbackCancel: () {
                  setState(() {
                    capturedImage = null;
                  });
                },
                callbackDone: () async {
                  print("under callback");
                  // Get.back();

/*
                  final img.Image? rawImage = img.decodeImage(
                      await File(capturedImage!.path).readAsBytes());
                  final img.Image orientedImage =
                      img.bakeOrientation(rawImage!);
                  await File(capturedImage!.path)
                      .writeAsBytes(img.encodeJpg(orientedImage));
*/

                  // File file = await fixExifRotation(capturedImage!.path);

                  _rotateImage(capturedImage!.path, callBack: (f) {
                    widget.callBack(XFile(f.path));
                  });

                  // widget.callBack(XFile(file.path));
                  // setState(() {
                  //   capturedImage = null;
                  // });
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        if (flashMode == FlashMode.off) {
                          _controller.setFlashMode(FlashMode.torch);
                          flashMode = FlashMode.torch;
                        } else {
                          _controller.setFlashMode(FlashMode.off);
                          flashMode = FlashMode.off;
                        }
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5),
                        child: Icon(
                          flashMode == FlashMode.off
                              ? Icons.flash_off
                              : Icons.flash_on,
                          color: Colors.white,
                        ),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.

                          return Align(
                              alignment: Alignment.center,
                              child: CameraPreview(_controller));
                        } else {
                          // Otherwise, display a loading indicator.
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, bottom: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ),
                        if (capturedImage == null)
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            // Provide an onPressed callback.
                            onPressed: () async {
                              // Take the Picture in a try / catch block. If anything goes wrong,
                              // catch the error.

                              try {
                                // Ensure that the camera is initialized.
                                await _initializeControllerFuture;

                                // Attempt to take a picture and get the file `image`
                                // where it was saved.
                                capturedImage = await _controller.takePicture();

                                _controller.setFlashMode(FlashMode.off);

                                setState(() {});
                                // if (!mounted) return;

                                // If the picture was taken, display it on a new screen.
                                // await Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => DisplayPictureScreen(
                                //       // Pass the automatically generated path to
                                //       // the DisplayPictureScreen widget.
                                //       imagePath: image.path,
                                //     ),
                                //   ),
                                // );
                              } catch (e) {
                                // If an error occurs, log the error to the console.
                                print(e);
                              }
                            },
                            // child: const Icon(Icons.camera_alt),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                              onPressed: () {
                                if (camerasAvailable.length > 1) {
                                  if (_camera!.lensDirection ==
                                      CameraLensDirection.back) {
                                    for (var element in camerasAvailable) {
                                      if (element.lensDirection ==
                                          CameraLensDirection.front) {
                                        _camera = element;
                                      }
                                    }
                                  } else if (_camera!.lensDirection ==
                                      CameraLensDirection.front) {
                                    for (var element in camerasAvailable) {
                                      if (element.lensDirection ==
                                          CameraLensDirection.back) {
                                        _camera = element;
                                      }
                                    }
                                  }

                                  _controller = CameraController(
                                      // Get a specific camera from the list of available cameras.
                                      _camera!,
                                      // Define the resolution to use.
                                      ResolutionPreset.medium,
                                      enableAudio: false);
                                  _initializeControllerFuture =
                                      _controller.initialize();

                                  setState(() {});
                                }
                                print(
                                    "camerasAvailable.length ${camerasAvailable.length} 1 ${camerasAvailable[0].lensDirection} 2 ${camerasAvailable[1].lensDirection}");
                              },
                              icon: const Icon(
                                  Icons.flip_camera_android_rounded,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  // Future<File> fixExifRotation(String imagePath) async {
  //   final originalFile = File(imagePath);
  //   Uint8List imageBytes = await originalFile.readAsBytes();
  //
  //   final originalImage = img.decodeImage(imageBytes);
  //
  //   final height = originalImage!.height;
  //   final width = originalImage.width;
  //
  //   // Let's check for the image size
  //   // This will be true also for upside-down photos but it's ok for me
  //   if (height >= width) {
  //     // I'm interested in portrait photos so
  //     // I'll just return here
  //     return originalFile;
  //   }
  //
  //   // We'll use the exif package to read exif data
  //   // This is map of several exif properties
  //   // Let's check 'Image Orientation'
  //   final exifData = await readExifFromBytes(imageBytes);
  //
  //   img.Image? fixedImage;
  //
  //   if (height < width) {
  //     // rotate
  //     if (exifData['Image Orientation']!.printable.contains('Horizontal')) {
  //       fixedImage = img.copyRotate(originalImage, angle: 90);
  //     } else if (exifData['Image Orientation']!.printable.contains('180')) {
  //       fixedImage = img.copyRotate(originalImage, angle: -90);
  //     } else if (exifData['Image Orientation']!.printable.contains('CCW')) {
  //       fixedImage = img.copyRotate(originalImage, angle: 180);
  //     } else {
  //       fixedImage = img.copyRotate(originalImage, angle: 0);
  //     }
  //   }
  //
  //   // Here you can select whether you'd like to save it as png
  //   // or jpg with some compression
  //   // I choose jpg with 100% quality
  //   final fixedFile =
  //       await originalFile.writeAsBytes(img.encodeJpg(fixedImage!));
  //
  //   return fixedFile;
  // }

  _rotateImage(imagePath, {Function(File)? callBack}) {
    File contrastFile = File(imagePath);

    try {
      img.Image? contrast = img.decodeImage(contrastFile.readAsBytesSync());
      contrast = img.copyRotate(contrast!, angle: 0);
      contrastFile.writeAsBytesSync(img.encodeJpg(contrast));
      callBack!(contrastFile);

      imageCache.clear();
      imageCache.clearLiveImages();
    } catch (e) {
      callBack!(contrastFile);
      print(e);
    }
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Function callbackCancel;
  final Function callbackDone;

  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.callbackCancel,
      required this.callbackDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Align(
                  alignment: Alignment.center,
                  child: Image.file(File(imagePath)))),
          Padding(
            padding: const EdgeInsets.only(
                left: 30.0, right: 30.0, bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        callbackCancel();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        callbackDone();
                      },
                      icon: Icon(Icons.check, color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
