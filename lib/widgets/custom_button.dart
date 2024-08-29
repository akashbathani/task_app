import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Colors.black,
          ),
        ),
        minimumSize: Size(double.infinity, height),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
