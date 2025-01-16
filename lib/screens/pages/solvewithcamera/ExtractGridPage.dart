import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/BottomButton.dart';
import 'package:word_search/screens/pages/solvewithcamera/SolveGridPage.dart';
// import 'package:word_search/screens/pages/SolveGridPage.dart';

class ExtractGridPage extends StatefulWidget {
  final Uint8List imageByte;

  const ExtractGridPage({super.key, required this.imageByte});

  @override
  _ExtractGridPageState createState() => _ExtractGridPageState();
}

class _ExtractGridPageState extends State<ExtractGridPage> {
  Uint8List finalImage = Uint8List.fromList([]);
  double _currentSliderValue = 127;
  List<cv.Rect> boundingAreas = <cv.Rect>[];
  late OrtSession session;

  Future<((bool, Uint8List), int, List<cv.Rect>)> heavyTask(
      Uint8List buffer, double thresholdValue) async {
    cv.Mat mat = cv.imdecode(buffer, cv.IMREAD_COLOR);

    cv.Mat gray = cv.cvtColor(mat, cv.COLOR_BGR2GRAY);

    cv.Mat blurred = cv.blur(gray, (2, 2));

    cv.Mat inverted = await cv.bitwiseNOTAsync(blurred);

    (double, cv.Mat) threshold =
        cv.threshold(inverted, thresholdValue, 255, cv.THRESH_BINARY);

    (cv.Contours, cv.Mat) contour =
        cv.findContours(threshold.$2, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);

    List<cv.Rect> filteredBoxes = [];

    int imageWidth = mat.cols;
    int imageHeight = mat.rows;

    // Define acceptable aspect ratio range for letters
    double minAspectRatio = 0.1;
    double maxAspectRatio = 10.0;

    // Minimum and maximum area thresholds (adjust according to your needs)
    int imageArea = imageWidth * imageHeight;
    double minAreaThreshold = 0.0001 * imageArea;
    double maxAreaThreshold = 0.05 * imageArea;

    gray.dispose();
    inverted.dispose();
    blurred.dispose();
    threshold.$2.dispose();

    final test = contour.$1;

    try {
      for (final contour in contour.$1.toList()) {
        cv.Rect boundingBox = cv.boundingRect(contour);

        double aspectRatio = boundingBox.height / boundingBox.width;
        int area = boundingBox.width * boundingBox.height;

        if (minAspectRatio <= aspectRatio &&
            aspectRatio <= maxAspectRatio &&
            minAreaThreshold <= area &&
            area <= maxAreaThreshold) {
          filteredBoxes.add(boundingBox);
        }
      }
    } catch (e) {
      print(e);
    }

    List<cv.Rect> boundingAreas = <cv.Rect>[];

    for (cv.Rect rect in filteredBoxes) {
      cv.rectangle(mat, rect, cv.Scalar.green, thickness: cv.FILLED);
      boundingAreas.add(rect);
    }

    return (cv.imencode(".png", mat), test.length, boundingAreas);
  }

  void _onSliderChangeEnd(double value) async {
    final image = await heavyTask(widget.imageByte, _currentSliderValue);
    setState(() {
      finalImage = image.$1.$2;
      boundingAreas = image.$3;
    });
  }

  @override
  void initState() {
    super.initState();
    _onSliderChangeEnd(127);
    initONNX();
  }

  void initONNX() async {
    OrtEnv.instance.init();

    final sessionOptions = OrtSessionOptions();
    const assetFileName = 'assets/models/letter_recognition_model.onnx';
    final rawAssetFile = await rootBundle.load(assetFileName);
    final bytes = rawAssetFile.buffer.asUint8List();
    session = OrtSession.fromBuffer(bytes, sessionOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
                isDark: true,
              ),
              const Spacer(),
              const AppBarTitle(
                title: 'EXTRACT GRID',
                isDark: true,
              ),
              const Spacer(),
              ActionButton(
                onTap: () {},
                iconData: Icons.abc,
                isVisible: false,
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            const Center(
              child: Text(
                'Adjust the slider so all letters are fully\ncovered by the green boxes and spaced out',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    child: finalImage.isEmpty
                        ? Image.memory(
                            widget.imageByte,
                            fit: BoxFit.contain,
                          )
                        : Image.memory(
                            finalImage,
                            fit: BoxFit.contain,
                          ),
                  )),
            ),
            Slider(
              value: _currentSliderValue,
              min: 0,
              max: 255,
              // divisions: 10,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
              onChangeEnd: _onSliderChangeEnd,
            ),
            BottomButton(context, 'NEXT', false, () {
              boundingAreas.sort((cv.Rect r1, cv.Rect r2) {
                if (r1.y.compareTo(r2.y) != 0) {
                  return r1.y.compareTo(r2.y); // Compare by y (top)
                }
                return r1.x.compareTo(r2.x); // Compare by x (left)
              });

              List<List<cv.Rect>> gridRectList = [];

              int rowIndex = 0;

              boundingAreas.asMap().forEach((int idx, cv.Rect current) {
                if (idx > 0) {
                  cv.Rect previous = boundingAreas[idx - 1];
                  if (current.y + current.height / 2 >= previous.y &&
                      current.y + current.height / 2 <=
                          previous.y + previous.height) {
                    gridRectList[rowIndex].add(current);
                  } else {
                    gridRectList.add([current]);
                    rowIndex++;
                  }
                } else {
                  gridRectList.add([current]);
                }
              });

              gridRectList.forEach((test) {
                print(test);
              });

              cv.Mat originalImage =
                  cv.imdecode(widget.imageByte, cv.IMREAD_COLOR);

              List<List<String>> gridList = [];

              final shape = [1, 1, 28, 28];
              // Mapping from index to letter
              Map<int, String> indexToLetter = {
                for (int i = 0; i < 26; i++) i: String.fromCharCode(65 + i)
              };

              gridRectList.forEach((List<cv.Rect> rowRect) {
                List<String> row = [];
                rowRect.forEach((cv.Rect rect) {
                  cv.Mat roi = originalImage.region(rect);

                  double scale = 28 / max(rect.width, rect.height);
                  int resizedWidth = (rect.width * scale).toInt();
                  int resizedHeight = (rect.height * scale).toInt();

                  cv.Mat resizedRoi = cv.resize(
                      roi, (resizedWidth, resizedHeight),
                      interpolation: cv.INTER_AREA);

                  cv.Mat finalSmallImage = cv.Mat.create(
                      cols: 28,
                      rows: 28,
                      r: 255,
                      g: 255,
                      b: 255,
                      type: resizedRoi.type);
                  resizedRoi.copyTo(finalSmallImage.region(
                      cv.Rect((28 - resizedWidth) ~/ 2, 0, resizedWidth, 28)));

                  cv.Mat finalised =
                      cv.cvtColor(finalSmallImage, cv.COLOR_BGR2GRAY);

                  // (bool, Uint8List) roiBytes1 = cv.imencode('.png', finalised);

                  Float32List normalizedData = Float32List.fromList(
                      finalised.data.map((value) => value / 255.0).toList());

                  final inputOrt = OrtValueTensor.createTensorWithDataList(
                      normalizedData, shape);

                  final inputs = {'input': inputOrt};
                  final runOptions = OrtRunOptions();

                  List<OrtValue?> ortValueList =
                      session.run(runOptions, inputs);

                  if (ortValueList[0]?.value is List<List<double>>) {
                    List<List<double>> resultList =
                        ortValueList[0]!.value as List<List<double>>;
                    List<double> result = resultList[0];

                    int maxIndex =
                        0; // Start by assuming the first element is the maximum

                    for (int i = 1; i < result.length; i++) {
                      if (result[i] > result[maxIndex]) {
                        maxIndex = i;
                      }
                    }
                    if (indexToLetter[maxIndex] != null) {
                      row.add(indexToLetter[maxIndex]!);
                    }
                  }
                  inputOrt.release();
                  runOptions.release();
                });
                gridList.add(row);
              });

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SolveGridPage(gridList: gridList),
              ));
            }, showBackground: false)
          ],
        ));
  }
}
