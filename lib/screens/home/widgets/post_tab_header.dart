import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';

class PostTabHeader extends StatelessWidget {
  const PostTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            "Instagram",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.favorite_border),
          HorizontalSpace(6.w),
          const Icon(Icons.send),
        ],
      ),
    );
  }
}
