import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String buttonText;
  final VoidCallback buttonTapped;

  MyButton({
    required this.color,
    required this.textColor,
    required this.buttonText,
    required this.buttonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade200,
                offset: Offset(4.0, 4.0),
                blurRadius: 14.0,
                spreadRadius: 1.0,
              ),
              BoxShadow(
                color: Color.fromARGB(255, 150, 71, 181),
                offset: Offset(-4.0, -4.0),
                blurRadius: 4.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
