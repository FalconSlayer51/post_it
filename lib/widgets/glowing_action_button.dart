import 'package:flutter/material.dart';

class GlowingActionButton extends StatelessWidget {
  const GlowingActionButton({
    Key? key,
    required this.color,
    required this.iconData,
    this.size = 54,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final double size;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 10,
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipOval(
          child: Material(
        color: color,
        child: InkWell(
          splashColor: Colors.white,
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              iconData,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      )),
    );
  }
}
