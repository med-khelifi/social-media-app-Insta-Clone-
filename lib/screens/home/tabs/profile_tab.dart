// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:insta/controllers/profile_tab_controller.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';
import 'package:insta/core/constants/strings.dart';
import 'package:insta/core/provider/user_provider.dart';
import 'package:insta/screens/widgets/custom_button.dart';
import 'package:insta/screens/widgets/stats_info.dart';

class ProfileTab extends StatefulWidget {
  final String? userId;
  const ProfileTab({super.key, this.userId});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ProfileTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileTabController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).getUserData(uid: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.getUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = userProvider.getUser!;

    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== HEADER =====
          Row(
            children: [
              Text(
                user.username,
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

          /// ===== PROFILE INFO =====
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45.r,
                  backgroundImage:
                      (user.profileImageUrl == null ||
                          user.profileImageUrl!.isEmpty)
                      ? AssetImage(ImagesPaths.placeholder) as ImageProvider
                      : NetworkImage(user.profileImageUrl!),
                ),
                HorizontalSpace(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.name,
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

          /// ===== BIO =====
          Text(user.bio ?? "", style: TextStyle(fontSize: 14.sp)),
          VerticalSpace(8.h),

          /// ===== EDIT BUTTON =====
          CustomButton(
            onPressed: () {},
            color: Colors.grey,
            child: Text(Strings.editProfile),
          ),

          Divider(thickness: 1.h),

          /// ===== POSTS GRID =====
          Expanded(
            child: FutureBuilder(
              future: _controller.getUserPost(userId: widget.userId),
              builder: (context, asyncSnapshot) {
                return GridView.builder(
                  itemCount: asyncSnapshot.data?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 4 / 5,
                  ),
                  itemBuilder: (context, index) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${asyncSnapshot.error}'),
                      );
                    } else if (!asyncSnapshot.hasData ||
                        asyncSnapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      var data = asyncSnapshot.data!;
                      return Image.network(data[index].imageUrl,fit: BoxFit.fill,);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
