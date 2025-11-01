// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/colors.dart';
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

  String text = "";
  Color? color = Colors.grey;

  /// ===== FETCH BUTTON COLOR =====
  Future<void> getColor() async {
    if (widget.userId == null) return;
    final newColor = await _controller.handelColor(widget.userId!);
    if (!mounted) return;
    setState(() {
      color = newColor;
    });
  }

  /// ===== FETCH BUTTON TEXT =====
  Future<void> getText() async {
    if (widget.userId == null) return;
    final newText = await _controller.handelTextFollowUnfollow(widget.userId!);
    if (!mounted) return;
    setState(() {
      text = newText;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ProfileTabController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).getUserData(uid: widget.userId);

      // Load initial follow/unfollow state (only if viewing another user)
      if (widget.userId != null) {
        await getColor();
        await getText();
      } else {
        // current user: show Edit profile text and grey button (or hide it)
        if (!mounted) return;
        setState(() {
          text = Strings.editProfile; // أو "Edit profile"
          color = Colors.grey;
        });
      }
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
              if (widget.userId == null)
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
                Stack(
                  children: [
                    FutureBuilder(
                      future: _controller.getUserStories(uid: widget.userId),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        } else if (!asyncSnapshot.hasData ||
                            asyncSnapshot.data == null) {
                          return SizedBox();
                        } else {
                          final stories = asyncSnapshot.data!;
                          return InkWell(
                            onTap: () {
                              if (stories.isEmpty) {
                                return;
                              }
                              _controller.goToStoryViewScreen(context, stories);
                            },
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
                                    ? AssetImage(ImagesPaths.placeholder)
                                    : NetworkImage(user.profileImageUrl!)
                                          as ImageProvider,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // show add-story button only if current user
                    if (widget.userId == null)
                      Positioned(
                        bottom: -15,
                        right: -15,
                        child: IconButton(
                          onPressed: () =>
                              _controller.goToAddNewScreen(context),
                          icon: Icon(Icons.add),
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
                          FutureBuilder(
                            future: _controller.getUserPostsCount(
                              uid: widget.userId,
                            ),
                            builder: (context, asyncSnapshot) {
                              if (asyncSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              return StatsInfo(
                                number: asyncSnapshot.hasData
                                    ? asyncSnapshot.data!.toString()
                                    : "",
                                label: Strings.posts,
                              );
                            },
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

          /// ===== BIO =====
          Text(user.bio, style: TextStyle(fontSize: 14.sp)),
          VerticalSpace(8.h),

          /// ===== EDIT / FOLLOW BUTTON =====
          if (widget.userId == null)
            CustomButton(
              onPressed: () {
                // navigate to edit profile screen or whatever
              },
              color: Colors.grey,
              child: Text(Strings.editProfile),
            )
          else
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () async {
                      try {
                        // wait for follow/unfollow to finish
                        await _controller.handleFollowing(widget.userId!);

                        // refresh local UI (color, text and provider data)
                        await getColor();
                        await getText();

                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).getUserData(uid: widget.userId);

                        if (mounted) setState(() {});
                      } catch (e) {
                        // show error
                        if (mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
                    color: color ?? Colors.grey,
                    child: Text(text),
                  ),
                ),
                HorizontalSpace(3.w),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      // navigate to edit profile screen or whatever
                    },
                    color: Colors.grey,
                    child: Text(Strings.sendMessage),
                  ),
                ),
              ],
            ),

          Divider(thickness: 1.h),

          /// ===== POSTS GRID =====
          Expanded(
            child: FutureBuilder(
              future: _controller.getUserPost(userId: widget.userId),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                } else if (!asyncSnapshot.hasData ||
                    asyncSnapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
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
                        fit: BoxFit.fill,
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
