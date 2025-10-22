import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/profile_tab_controller.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/provider/user_provider.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/stats_info.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileTabController();

    // تحميل بيانات المستخدم بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // إذا البيانات مازالت تتحمل
    if (userProvider.getUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = userProvider.getUser!;

    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                user.username ?? "Profile",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.logout, size: 24.sp),
                onPressed: () => _controller.onSignOutPressed(context),
              ),
            ],
          ),
          VerticalSpace(10.h),

          /// Profile Info Row
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage: (user.profileImageUrl == null ||
                          user.profileImageUrl!.isEmpty)
                      ? AssetImage(ImagesPaths.placeholder)
                          as ImageProvider
                      : NetworkImage(user.profileImageUrl!),
                ),
                HorizontalSpace(16.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.name ?? "????",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      VerticalSpace(12.h),
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
            user.bio ?? "This is my bio",
            style: TextStyle(fontSize: 14.sp),
          ),
          CustomButton(
            onPressed: () {},
            color: Colors.grey,
            child: Text(Strings.editProfile),
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
