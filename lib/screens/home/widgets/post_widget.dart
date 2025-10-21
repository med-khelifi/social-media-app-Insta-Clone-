import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta/core/constants/constants_widgets.dart';
import 'package:insta/core/constants/images_paths.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.onCommentIconPressed});
   final VoidCallback onCommentIconPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            CircleAvatar(backgroundImage: AssetImage(ImagesPaths.placeholder)),
            HorizontalSpace(8.w),
            Text('username'),
            const Spacer(),
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
        VerticalSpace(8.h),
        Image.asset(
          ImagesPaths.placeholder,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        VerticalSpace(4.h),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.comment_outlined),
              onPressed: onCommentIconPressed,
            ),
            IconButton(icon: const Icon(Icons.send), onPressed: () {}),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
