import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/screens/home/widgets/post_tab_header.dart';
import 'package:insta/screens/home/widgets/post_widget.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PostTabHeader(),
          VerticalSpace( 10.h),
          ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: const PostWidget(),
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
