import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:word_search/components/ActionButton.dart';
import 'package:word_search/components/AppBarTitle.dart';
import 'package:word_search/components/BottomButton.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:word_search/models/min_max_values_model.dart';
import 'package:word_search/screens/pages/solvewithcamera/ExtractGridPage.dart';

class CropPage extends StatefulWidget {
  final Uint8List imageByte;

  const CropPage({super.key, required this.imageByte});

  @override
  _CropAreaState createState() => _CropAreaState();
}

class _CropAreaState extends State<CropPage> {
  final GlobalKey _imageKey = GlobalKey();
  double width = 0;
  double height = 0;

  List<Offset> sourcePoints = [
    const Offset(0, 0),
    const Offset(0, 0),
    const Offset(0, 0),
    const Offset(0, 0),
  ];

  int? selectedPointIndex;

  void transformImage() {
    final mat = cv.imdecode(widget.imageByte, cv.IMREAD_COLOR);

    MinMaxValues minMaxValues = findMinMaxDxDy(scaleOffset(
        minusPadding(sourcePoints), width / mat.width, height / mat.height));

    var scaledTarget = convertOffsetToPoint(scaleOffset(
        minusPadding(sourcePoints), width / mat.width, height / mat.height));

    cv.Mat matrix = cv.getPerspectiveTransform(
        cv.VecPoint.fromList(scaledTarget),
        cv.VecPoint.fromList([
          cv.Point(0, 0),
          cv.Point(minMaxValues.maxDx.toInt(), 0),
          cv.Point(minMaxValues.maxDx.toInt(), minMaxValues.maxDy.toInt()),
          cv.Point(0, minMaxValues.maxDy.toInt()),
        ]));

    cv.Mat warpedImage = cv.warpPerspective(
        mat, matrix, (minMaxValues.maxDx.toInt(), minMaxValues.maxDy.toInt()));

    (bool,Uint8List) warpedImageScaledBytes = cv.imencode('.png', warpedImage);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExtractGridPage(imageByte: warpedImageScaledBytes.$2),
    ));
  }

  MinMaxValues findMinMaxDxDy(List<Offset> offsets) {
    if (offsets.isEmpty) {
      return MinMaxValues(minDx: 0, maxDx: 0, minDy: 0, maxDy: 0);
    }

    double minDx = offsets.first.dx;
    double maxDx = offsets.first.dx;
    double minDy = offsets.first.dy;
    double maxDy = offsets.first.dy;

    for (var offset in offsets) {
      if (offset.dx < minDx) minDx = offset.dx;
      if (offset.dx > maxDx) maxDx = offset.dx;
      if (offset.dy < minDy) minDy = offset.dy;
      if (offset.dy > maxDy) maxDy = offset.dy;
    }

    return MinMaxValues(minDx: minDx, maxDx: maxDx, minDy: minDy, maxDy: maxDy);
  }

  List<Offset> minusPadding(List<Offset> list) {
    List<Offset> listOfOffsets = <Offset>[];
    for (var offset in list) {
      listOfOffsets.add(Offset(offset.dx - 12, offset.dy - 12));
    }
    return listOfOffsets;
  }

  List<Offset> scaleOffset(List<Offset> list, double scaleX, double scaleY) {
    List<Offset> listOfPoints = <Offset>[];
    for (var offset in list) {
      listOfPoints.add(Offset(offset.dx / scaleX, offset.dy / scaleY));
    }
    return listOfPoints;
  }

  List<cv.Point> convertOffsetToPoint(List<Offset> list) {
    List<cv.Point> listOfPoints = <cv.Point>[];
    for (var offset in list) {
      listOfPoints.add(cv.Point(offset.dx.toInt(), offset.dy.toInt()));
    }
    return listOfPoints;
  }

  void getSize() {
    RenderBox renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox;

    setState(() {
      width = renderBox.size.width;
      height = renderBox.size.height;

      sourcePoints = [
        const Offset(12, 12),
        Offset(width + 12, 12),
        Offset(width + 12, height + 12),
        Offset(12, height + 12),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      getSize();
    });
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
                title: 'CROP IMAGE',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Ensure no other elements are\nvisible except the word grid',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(32),
                      child: Container(
                        key: _imageKey,
                        child: Image.memory(
                          widget.imageByte,
                          fit: BoxFit.contain,
                        ),
                      )),
                  SizedBox(
                    width: width + 24,
                    height: height + 24,
                    child: GestureDetector(
                      onPanStart: (details) {
                        for (int i = 0; i < sourcePoints.length; i++) {
                          if ((details.localPosition - sourcePoints[i])
                                  .distance <
                              20) {
                            selectedPointIndex = i;
                            break;
                          }
                        }
                      },
                      onPanUpdate: (details) {
                        if (selectedPointIndex != null) {
                          setState(() {
                            double dx =
                                details.localPosition.dx.clamp(12, width + 12);
                            double dy =
                                details.localPosition.dy.clamp(12, height + 12);
                            sourcePoints[selectedPointIndex!] = Offset(dx, dy);
                          });
                        }
                      },
                      onPanEnd: (details) {
                        selectedPointIndex = null;
                      },
                      child: CustomPaint(
                        painter: MyCanvasPainter(
                            width: width,
                            height: height,
                            points: sourcePoints,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomButton(context, 'NEXT', false, () {
              transformImage();
            }, showBackground: false)
          ],
        ));
  }
}

class MyCanvasPainter extends CustomPainter {
  final double width;
  final double height;
  final List<Offset> points;
  final Color color;

  MyCanvasPainter(
      {required this.width,
      required this.height,
      required this.points,
      required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the polygon path
    Paint pathPaint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Paint for the circles
    Paint circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Paint for the circle outline
    Paint circleOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Paint for the darkened area
    Paint darkPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Create a Path for the polygon and move to the first point
    Path polygonPath = Path();
    polygonPath.moveTo(points[0].dx, points[0].dy);

    // Draw lines to the remaining points
    for (int i = 1; i < points.length; i++) {
      polygonPath.lineTo(points[i].dx, points[i].dy);
    }

    // Close the path to form a closed polygon
    polygonPath.close();

    // Create a Path that covers the entire canvas
    Path canvasPath = Path();
    canvasPath.addRect(Rect.fromLTWH(12, 12, width + 12, height + 12));

    // Combine the paths to create the darkened area outside the polygon
    Path darkAreaPath =
        Path.combine(PathOperation.difference, canvasPath, polygonPath);

    // Draw the darkened area
    canvas.drawPath(darkAreaPath, darkPaint);

    // Draw the polygon outline
    canvas.drawPath(polygonPath, pathPaint);

    // Draw circles at each point
    for (Offset point in points) {
      canvas.drawCircle(point, 12.0, circlePaint);
      canvas.drawCircle(point, 16.0, circlePaint);
      canvas.drawCircle(point, 12.0, circleOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
