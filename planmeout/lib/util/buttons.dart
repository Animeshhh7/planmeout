import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Button({
    super.key, // specify key parameter
    required this.text,
    required this.onPressed,
  }); // Specify key parameter in super constructor

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      
      onPressed: onPressed,
      color: Colors.yellow[500],
      child: Text(text),
    );
  }
}
