import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/controllers/posts_tab_controller.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/screens/home/widgets/post_tab_header.dart';
import 'package:insta/screens/home/widgets/post_widget.dart';

class PostsTab extends StatefulWidget {
  const PostsTab({super.key});

  @override
  State<PostsTab> createState() => _PostsTabState();
}

class _PostsTabState extends State<PostsTab> {
  late PostsTabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PostsTabController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PostTabHeader(),
          VerticalSpace(10.h),
          ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: PostWidget(
                  onCommentIconPressed: () =>
                      _controller.onCommentIconPressed(context),
                ),
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
          ),
          // StoriesSection(),
        ],
      ),
    );
  }
}
