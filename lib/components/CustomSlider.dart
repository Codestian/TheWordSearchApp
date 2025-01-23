import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  final double min;
  final double max;
  final int? divisions;
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.min,
    required this.max,
    this.divisions,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: SquareSliderThumbShape(),
      ),
      child: Slider(
        value: _currentValue,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        onChanged: (value) {
          setState(() {
            _currentValue = value;
          });
          widget.onChanged(value);
        },
      ),
    );
  }
}

class SquareSliderThumbShape extends SliderComponentShape {
  final double thumbSize;

  SquareSliderThumbShape({this.thumbSize = 16.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbSize, thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    final Rect square = Rect.fromCenter(
      center: center,
      width: thumbSize,
      height: thumbSize,
    );

    canvas.drawRect(square, paint);
  }
}
