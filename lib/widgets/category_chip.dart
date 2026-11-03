import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6
      ),
      decoration:  BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.4)
        ),
      ),
      child: Text(
        category,
        style: TextStyle(
            color: Colors.red[300],
            fontSize: 12,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
