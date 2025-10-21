import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/stats_info.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "username",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          VerticalSpace(10.h),

          /// Profile Info Row
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Profile Image
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage: AssetImage(ImagesPaths.placeholder),
                ),
                HorizontalSpace(16.w),

                /// Name and Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Mohamed Ahmed",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      VerticalSpace(12.h),

                      /// Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          StatsInfo(number: "100", label: Strings.posts),
                          StatsInfo(number: "200", label: Strings.followers),
                          StatsInfo(number: "120", label: Strings.following),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalSpace(6.h),
          Text(
            "This is the bio section where the user can write something about themselves.",
            style: TextStyle(fontSize: 14.sp),
          ),
          CustomButton(
            text: Strings.editProfile,
            onPressed: () {},
            color: Colors.grey,
          ),
          Divider(thickness: 1.h),
          Expanded(
            child: GridView.builder(
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 4 / 5,
              ),
              itemBuilder: (context, index) {
                return Image.asset(ImagesPaths.placeholder, fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }
}
