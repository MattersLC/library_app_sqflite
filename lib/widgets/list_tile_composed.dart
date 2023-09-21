import 'package:flutter/material.dart';

class MyListTileComposed extends StatelessWidget {
  final double width;
  final double iconSize;
  final IconData icon;
  final double secondIconSize;
  final IconData secondIcon;
  final double fontSize;
  final String title;
  final void Function()? onTap;
  const MyListTileComposed(
      {super.key,
      required this.width,
      required this.iconSize,
      required this.icon,
      required this.secondIconSize,
      required this.secondIcon,
      required this.fontSize,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: width,
        child: Row(
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 4.0),
            Icon(secondIcon, size: secondIconSize),
          ],
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize),
      ),
      onTap: onTap,
    );
  }
}
