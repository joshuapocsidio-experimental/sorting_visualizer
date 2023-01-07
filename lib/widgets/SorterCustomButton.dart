import 'package:flutter/material.dart';

class SorterCustomButton extends StatelessWidget {
  final bool enable;
  final String label;
  final Function callback;
  final Color buttonColor;

  SorterCustomButton({required this.enable, required this.buttonColor, required this.label, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
      ),
      onPressed: !enable ? null : () {
        callback();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
