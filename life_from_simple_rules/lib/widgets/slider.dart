import 'package:flutter/material.dart';

class TitleSlider extends StatelessWidget {
  const TitleSlider(
      {super.key,
      required this.title,
      required this.slider,
      required this.sliderValue});
  final String title;
  final Slider slider;
  final double sliderValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Expanded(
          child: slider,
        ),
        Text(sliderValue.toStringAsFixed(1)),
      ],
    );
  }
}
