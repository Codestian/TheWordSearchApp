import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_search/components/puzzle/DragHighlight.dart';
import 'package:word_search/components/puzzle/Highlight.dart';
import 'package:word_search/enums/Angle.dart';

class PuzzleGrid extends StatefulWidget {
  final List<List<String>> wordGrid;
  final List<List<List<int>>> solvedWords;
  final List<Color> listOfColors;
  final void Function(String word) onDrag;
  final void Function(List<List<int>> coordinates, String word) onDragEnd;
  final bool isPaused;
  final TransformationController transformationController;

  const PuzzleGrid({
    super.key,
    required this.wordGrid,
    required this.solvedWords,
    required this.listOfColors,
    required this.onDrag,
    required this.onDragEnd,
    required this.isPaused,
    required this.transformationController,
  });

  @override
  _PuzzleGridState createState() => _PuzzleGridState();
}

class _PuzzleGridState extends State<PuzzleGrid> {
  int drawHighlightOriginCol = 0;
  int drawHighlightOriginRow = 0;

  double gridWidth = 0;
  double gridHeight = 0;
  double length = 0;
  double size = 28;
  double dragWidth = 0.0;

  Angle drawHighlightAngle = Angle.right;
  List<int> drawEndPoint = <int>[];

  Timer? _movementTimer;
  Offset _offscreenDirection = Offset.zero;

  List<List<int>> bresenhamLine(int x0, int y0, int x1, int y1) {
    List<List<int>> points = [];

    int dx = (x1 - x0).abs();
    int dy = (y1 - y0).abs();
    int sx = x0 < x1 ? 1 : -1;
    int sy = y0 < y1 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      points.add([x0, y0]);

      if (x0 == x1 && y0 == y1) break;
      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x0 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y0 += sy;
      }
    }

    return points;
  }

  void _handleDrag(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size viewportSize = renderBox.size;

    // Convert global position to local coordinates
    Offset localPosition = renderBox.globalToLocal(globalPosition);

    // Determine offscreen direction
    double dx = 0, dy = 0;

    if (localPosition.dx < 32) {
      dx = -1; // Offscreen left
    } else if (localPosition.dx > viewportSize.width - 32) {
      dx = 1; // Offscreen right
    }

    if (localPosition.dy < 32) {
      dy = -1; // Offscreen top
    } else if (localPosition.dy > viewportSize.height - 32) {
      dy = 1; // Offscreen bottom
    }

    _offscreenDirection = Offset(dx, dy);

    // Start continuous movement if offscreen
    if (_offscreenDirection != Offset.zero && _movementTimer == null) {
      _startContinuousMovement();
    }

    // Stop movement if back on screen
    if (_offscreenDirection == Offset.zero) {
      _stopContinuousMovement();
    }
  }

  void _startContinuousMovement() {
    _movementTimer = Timer.periodic(Duration(milliseconds: 16), (_) {
      if (_offscreenDirection == Offset.zero) return;

      final matrix = widget.transformationController.value;
      Matrix4 updatedMatrix = matrix.clone()
        ..translate(-_offscreenDirection.dx * 2, -_offscreenDirection.dy * 2);

      setState(() {
        widget.transformationController.value = updatedMatrix;
        dragWidth += _offscreenDirection.dx * 2;
      });
    });
  }

  void _stopContinuousMovement() {
    _movementTimer?.cancel();
    _movementTimer = null;
    _offscreenDirection = Offset.zero;
  }

  double calculateDistance(double x1, double y1, double x2, double y2) {
    double dx = x2 - x1;
    double dy = y2 - y1;
    return sqrt(dx * dx + dy * dy);
  }

  void centerPuzzle() {
    double viewerWidth = MediaQuery.of(context).size.width;
    double viewerHeight = MediaQuery.of(context).size.width;

    double containerWidth = length;
    double containerHeight = length;

    double offsetX = (viewerWidth - containerWidth) / 2.0;
    double offsetY = (viewerHeight - containerHeight) / 2.0;

    widget.transformationController.value = Matrix4.identity()
      ..translate(offsetX, offsetY);
  }

  void zoom() {
    final x = Offset(MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.width / 2);
    final offset1 = widget.transformationController.toScene(x);
    widget.transformationController.value.scale(1.1);
    final offset2 = widget.transformationController.toScene(x);
    final dx = offset1.dx - offset2.dx;
    final dy = offset1.dy - offset2.dy;
    widget.transformationController.value.translate(-dx, -dy);
  }

  int findLargestSublistLength(List<List<String>> listOfLists) {
    int maxSize = 0;

    for (var sublist in listOfLists) {
      if (sublist.length > maxSize) {
        maxSize = sublist.length;
      }
    }

    return maxSize;
  }

  Angle getNearestAngle(double radian) {
    // Convert radians to degrees
    double degrees = radian * (180 / pi);

    // Normalize degrees to the range [0, 360)
    degrees = degrees % 360;
    if (degrees < 0) degrees += 360;

    // Round to the nearest multiple of 45
    int roundedDegrees = (degrees / 45).round() * 45;

    // Handle the case where 360 wraps back to 0
    if (roundedDegrees == 360) roundedDegrees = 0;

    // Map rounded degrees to enum values
    switch (roundedDegrees) {
      case 0:
        return Angle.right;
      case 45:
        return Angle.bottomRight;
      case 90:
        return Angle.bottom;
      case 135:
        return Angle.bottomLeft;
      case 180:
        return Angle.left;
      case 225:
        return Angle.topLeft;
      case 270:
        return Angle.top;
      case 315:
        return Angle.topRight;
      default:
        throw ArgumentError("Unexpected degree value: $roundedDegrees");
    }
  }

  Map<String, double> calculateEndPoint(
      int startX, int startY, double length, double angle) {
    // Convert angle to radians because Dart's trigonometric functions use radians
    double angleInRadians = angle * (pi / 180);

    // Calculate change in x and y
    double deltaX = length * cos(angleInRadians);
    double deltaY = length * sin(angleInRadians);

    // Calculate end point
    double x2 = startX + deltaX;
    double y2 = startY + deltaY;

    return {'x': x2, 'y': y2};
  }

  @override
  void initState() {
    super.initState();
    gridWidth = findLargestSublistLength(widget.wordGrid) * size;
    gridHeight = widget.wordGrid.length * size;
    length = max(gridWidth, gridHeight);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      centerPuzzle();
    });
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.2),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: InteractiveViewer(
          transformationController: widget.transformationController,
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          boundaryMargin: const EdgeInsets.all(30),
          constrained: false,
          child: Opacity(
            opacity: widget.isPaused ? 0.2 : 1.0,
            child: SizedBox(
              width: length,
              height: length,
              child: Center(
                child: SizedBox(
                  width: gridWidth,
                  height: gridHeight,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: widget.wordGrid.map((List<String> row) {
                          return Row(
                            children: row.map((String character) {
                              return GridCell(character, size,
                                  Theme.of(context).colorScheme.secondary);
                            }).toList(),
                          );
                        }).toList(),
                      ),
                      for (var i = 0; i < widget.solvedWords.length; i++)
                        Highlight(
                          size,
                          [
                            widget.solvedWords[i][0][0].toDouble(),
                            widget.solvedWords[i][0][1].toDouble()
                          ],
                          [
                            widget.solvedWords[i][1][0].toDouble(),
                            widget.solvedWords[i][1][1].toDouble()
                          ],
                          widget.listOfColors[i],
                        ),
                      DragHighlight(
                          size,
                          [drawHighlightOriginCol, drawHighlightOriginRow],
                          drawHighlightAngle,
                          dragWidth,
                          Theme.of(context).colorScheme.primary),
                      GestureDetector(
                        onLongPressStart: (LongPressStartDetails details) {
                          setState(() {
                            drawHighlightOriginCol =
                                (details.localPosition.dy / size).floor();
                            drawHighlightOriginRow =
                                (details.localPosition.dx / size).floor();
                          });
                        },
                        onLongPressEnd: (LongPressEndDetails details) {
                          _stopContinuousMovement();

                          if (drawEndPoint.isNotEmpty) {
                            List<List<int>> linePoints = bresenhamLine(
                                drawHighlightOriginCol,
                                drawHighlightOriginRow,
                                drawEndPoint[0],
                                drawEndPoint[1]);

                            String word = '';

                            for (var point in linePoints) {
                              int row = point[1];
                              int col = point[0];
                              word += widget.wordGrid[col][row];
                            }

                            widget.onDrag('');
                            widget.onDragEnd(linePoints, word);
                            setState(() {
                              drawHighlightOriginCol = 0;
                              drawHighlightOriginRow = 0;
                              drawHighlightAngle = Angle.right;
                              dragWidth = 0;
                              drawEndPoint = [];
                            });
                          }
                        },
                        onLongPressMoveUpdate:
                            (LongPressMoveUpdateDetails details) {
                          _handleDrag(details.globalPosition);

                          double col = (details.localPosition.dy / size);
                          double row = (details.localPosition.dx / size);

                          Map<String, double> test = calculateLineProperties([
                            drawHighlightOriginCol.toDouble() + 0.5,
                            drawHighlightOriginRow.toDouble() + 0.5,
                          ], [
                            col,
                            row
                          ]);

                          Angle roundedAngle = getNearestAngle(test['angle']!);

                          List<int> finalEndPoint = [col.floor(), row.floor()];

                          switch (roundedAngle) {
                            case Angle.right:
                              finalEndPoint[0] = drawHighlightOriginCol;
                              break;
                            case Angle.left:
                              finalEndPoint[0] = drawHighlightOriginCol;
                              break;
                            case Angle.top:
                              finalEndPoint[1] = drawHighlightOriginRow;
                              break;
                            case Angle.bottom:
                              finalEndPoint[1] = drawHighlightOriginRow;
                              break;
                            case Angle.topRight:
                              finalEndPoint[0] = drawHighlightOriginCol -
                                  (test['length']! / sqrt(2)).toInt();
                              finalEndPoint[1] = drawHighlightOriginRow +
                                  (test['length']! / sqrt(2)).toInt();
                              break;
                            case Angle.topLeft:
                              finalEndPoint[0] = drawHighlightOriginCol -
                                  (test['length']! / sqrt(2)).toInt();
                              finalEndPoint[1] = drawHighlightOriginRow -
                                  (test['length']! / sqrt(2)).toInt();
                              break;
                            case Angle.bottomRight:
                              finalEndPoint[0] = drawHighlightOriginCol +
                                  (test['length']! / sqrt(2)).toInt();
                              finalEndPoint[1] = drawHighlightOriginRow +
                                  (test['length']! / sqrt(2)).toInt();
                              break;
                            case Angle.bottomLeft:
                              finalEndPoint[0] = drawHighlightOriginCol +
                                  (test['length']! / sqrt(2)).toInt();
                              finalEndPoint[1] = drawHighlightOriginRow -
                                  (test['length']! / sqrt(2)).toInt();
                              break;
                          }

                          List<List<int>> linePoints = bresenhamLine(
                              drawHighlightOriginCol,
                              drawHighlightOriginRow,
                              finalEndPoint[0],
                              finalEndPoint[1]);

                          String word = '';

                          for (var point in linePoints) {
                            int row = point[1];
                            int col = point[0];
                            word += widget.wordGrid[col][row];
                          }

                          widget.onDrag(word);

                          setState(() {
                            dragWidth =
                                ((test['length']! <= 1 ? 1 : test['length']!) *
                                    size);

                            drawHighlightAngle = roundedAngle;

                            drawEndPoint = finalEndPoint;
                          });
                        },
                        child: Container(
                          width: gridWidth,
                          height: gridHeight,
                          color: Colors.transparent,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
            ),

    );
  }
}

Widget GridCell(String character, double size, Color color) => Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: const Color.fromARGB(59, 0, 0, 0)),
      // ),
      width: size,
      height: size,
      child: Center(
          child: Text(
        character.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      )),
    );
