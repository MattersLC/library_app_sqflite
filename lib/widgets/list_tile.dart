import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final double width;
  final double iconSize;
  final IconData icon;
  final double fontSize;
  final String title;
  final void Function()? onTap;
  const MyListTile(
      {super.key,
      required this.width,
      required this.iconSize,
      required this.icon,
      required this.fontSize,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            icon,
            size: iconSize,
          ),
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
