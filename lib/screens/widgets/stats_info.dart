import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';

class StatsInfo extends StatelessWidget {
  const StatsInfo({super.key, required this.number, required this.label});
  final String number;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: ColorsManager.grey),
        ),
      ],
    );
  }
}
