import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: value ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        width: 20.0,
        height: 20.0,
        child: value
            ? const Icon(Icons.check, size: 16.0, color: Colors.blue)
            : null,
      ),
    );
  }
}
