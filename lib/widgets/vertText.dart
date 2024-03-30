import 'package:flutter/material.dart';

class VertText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const VertText(this.text, this.style);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 21,
        child: Wrap(
          runSpacing: 30,
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: text
              .split("")
              .map((string) => Text(string, style: style))
              .toList(),
        ));
  }
}
