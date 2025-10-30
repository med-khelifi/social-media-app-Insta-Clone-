import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/routes.dart';

class StoriesSections extends StatelessWidget {
  const StoriesSections({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Navigator.pushNamed(context, RoutesNames.storyView),
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.pink, width: 3.w),
              ),
            ),
          );
        },
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return HorizontalSpace(8.w);
        },
      ),
    );
  }
}
