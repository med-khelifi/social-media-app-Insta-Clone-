// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';
import 'package:insta/core/constants/routes.dart';
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
// ... (الـ imports كما هي)

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
    final isOwnProfile = widget.userId == null;

    final buttonText = isOwnProfile
        ? Strings.editProfile
        : (user.isFollowing ? "unfollow" : "follow");

    final buttonColor = isOwnProfile
        ? Colors.grey
        : (user.isFollowing ? ColorsManager.grey : ColorsManager.red);

    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Text(
                user.username,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (isOwnProfile)
                IconButton(
                  icon: Icon(Icons.logout, size: 24.sp),
                  onPressed: () => _controller.onSignOutPressed(context),
                ),
            ],
          ),
          VerticalSpace(10.h),

          // PROFILE INFO
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Story Avatar
                Stack(
                  children: [
                    FutureBuilder(
                      future: _controller.getUserStories(uid: widget.userId),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }
                        final stories = asyncSnapshot.data ?? [];
                        return InkWell(
                          onTap: stories.isEmpty
                              ? null
                              : () => _controller.goToStoryViewScreen(
                                  context,
                                  stories,
                                ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: stories.isEmpty
                                  ? null
                                  : Border.all(
                                      width: 3.w,
                                      color: ColorsManager.pink,
                                    ),
                            ),
                            child: CircleAvatar(
                              radius: 45.r,
                              backgroundImage:
                                  (user.profileImageUrl == null ||
                                      user.profileImageUrl!.isEmpty)
                                  ? const AssetImage(ImagesPaths.placeholder)
                                  : NetworkImage(user.profileImageUrl!)
                                        as ImageProvider,
                            ),
                          ),
                        );
                      },
                    ),
                    if (isOwnProfile)
                      Positioned(
                        bottom: -15,
                        right: -15,
                        child: IconButton(
                          onPressed: () =>
                              _controller.goToAddNewScreen(context),
                          icon: const Icon(Icons.add),
                        ),
                      ),
                  ],
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
                          // عدد المنشورات من الـ user مباشرة
                          StatsInfo(
                            number: user.postsCount.toString(),
                            label: Strings.posts,
                          ),
                          StatsInfo(
                            number: user.followers.length.toString(),
                            label: Strings.followers,
                          ),
                          StatsInfo(
                            number: user.following.length.toString(),
                            label: Strings.following,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalSpace(6.h),
          Text(user.bio, style: TextStyle(fontSize: 14.sp)),
          VerticalSpace(8.h),

          // زر Follow / Edit
          if (isOwnProfile)
            CustomButton(
              onPressed:
                  () {}, //Navigator.pushNamed(context, RoutesNames.editProfile)},
              color: Colors.grey,
              child: const Text(Strings.editProfile),
            )
          else
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () async {
                      try {
                        final newState = await _controller.handleFollowing(
                          widget.userId!,
                        );
                        userProvider.updateFollowingState(
                          widget.userId!,
                          newState,
                        );
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
                    color: buttonColor,
                    child: Text(buttonText),
                  ),
                ),
                HorizontalSpace(3.w),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoutesNames.messages,
                        arguments: {
                          'receiverId': user.uid,
                          'receiverName': user.name,
                          'receiverImage': user.profileImageUrl,
                        },
                      );
                    },
                    color: Colors.grey,
                    child: const Text(Strings.sendMessage),
                  ),
                ),
              ],
            ),
          const Divider(thickness: 1),

          // Posts Grid
          Expanded(
            child: FutureBuilder(
              future: _controller.getUserPost(userId: widget.userId),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                } else if (!asyncSnapshot.hasData ||
                    asyncSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No posts yet'));
                } else {
                  final data = asyncSnapshot.data!;
                  return GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.w,
                      mainAxisSpacing: 2.h,
                      childAspectRatio: 4 / 5,
                    ),
                    itemBuilder: (context, index) {
                      return Image.network(
                        data[index].imageUrl,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
