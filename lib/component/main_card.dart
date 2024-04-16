import 'package:dusty_dust/const/colors.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget child; // 외부에서 child 받을 때
  const MainCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      color: lightColor,
      child: child,
    );
  }
}
