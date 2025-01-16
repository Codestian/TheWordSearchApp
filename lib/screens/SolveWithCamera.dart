import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';

import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:word_search/screens/pages/solvewithcamera/CropPage.dart';

class SolveWithCameraScreen extends StatefulWidget {
  const SolveWithCameraScreen({super.key});

  @override
  _SolveWithCameraScreenState createState() => _SolveWithCameraScreenState();
}

class _SolveWithCameraScreenState extends State<SolveWithCameraScreen> {
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        title: Row(
          children: <Widget>[
            ActionButton(
              onTap: () {
                Navigator.pop(context);
              },
              iconData: Icons.arrow_back,
            ),
            const Spacer(),
            const AppBarTitle(title: 'SOLVE PUZZLE'),
            const Spacer(),
            ActionButton(
              onTap: () {},
              iconData: Icons.abc,
              isVisible: false,
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLandscape = constraints.maxWidth > constraints.maxHeight;

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      isLandscape
                          ? SizedBox(
                              height: 200,
                              child: ImageButton(
                                context,
                                () => processImage(ImageSource.gallery),
                                Icons.photo,
                                'Select from Gallery',
                              ),
                            )
                          : ImageButton(
                              context,
                              () => processImage(ImageSource.gallery),
                              Icons.photo,
                              'Select from Gallery',
                            ),
                      isLandscape
                          ? SizedBox(
                              height: 200,
                              child: ImageButton(
                                context,
                                () => processImage(ImageSource.camera),
                                Icons.camera_alt,
                                'Take a picture',
                              ),
                            )
                          : ImageButton(
                              context,
                              () => processImage(ImageSource.camera),
                              Icons.camera_alt,
                              'Take a picture',
                            ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  void processImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      Uint8List fileBytes = await pickedFile.readAsBytes();

      cv.Mat warpedImage = cv.imdecode(fileBytes, cv.IMREAD_COLOR);

      int imageWidth = warpedImage.cols;
      int imageHeight = warpedImage.rows;

      double aspectRatio = imageWidth / imageHeight;

      // Calculate scaled height and width based on desired height (720 pixels)
      int scaledHeight = 1080;
      int scaledWidth = (scaledHeight * aspectRatio).round();

      // // Compress and resize the image while maintaining aspect ratio
      Uint8List compressedImage = await FlutterImageCompress.compressWithList(
        fileBytes,
        minHeight: scaledHeight,
        minWidth: scaledWidth,
      );

      cv.Mat warpedImage2 = cv.imdecode(compressedImage, cv.IMREAD_COLOR);

      int imageWidth1 = warpedImage2.cols;
      int imageHeight1 = warpedImage2.rows;

      print(imageWidth1);
      print(imageHeight1);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CropPage(imageByte: compressedImage),
      ));
    }
  }
}

Widget ImageButton(
        BuildContext context, Function() onTap, IconData icon, String text) =>
    Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: (0.1)),
              ),
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: (0.6)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    text,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
