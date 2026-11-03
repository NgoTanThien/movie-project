import 'package:flutter/material.dart';

class MovieInfoChip extends StatelessWidget {
  final String text;
  MovieInfoChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6
      ),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500
        ) ,
      ),
    );
  }
}
